import 'dart:io';

final _directivePattern = RegExp(
  r'''(?:import|export|part)\s+['"]([^'"]+)['"]''',
);

void main() {
  final root = Directory.current.absolute;
  final lib = Directory('${root.path}${Platform.pathSeparator}lib');
  if (!lib.existsSync()) {
    stderr.writeln('Run this script from the project root.');
    exitCode = 2;
    return;
  }

  final errors = <String>[];
  final desktopEntry = File(
    '${lib.path}${Platform.pathSeparator}main_desktop.dart',
  );
  final mobileEntry = File(
    '${lib.path}${Platform.pathSeparator}main_mobile.dart',
  );
  final desktopClosure = _dependencyClosure(desktopEntry, lib, errors);
  final mobileClosure = _dependencyClosure(mobileEntry, lib, errors);

  _rejectPlatformDirectory(
    closure: desktopClosure,
    forbiddenSegment:
        '${Platform.pathSeparator}mobile${Platform.pathSeparator}',
    label: 'desktop',
    errors: errors,
  );
  _rejectPlatformDirectory(
    closure: mobileClosure,
    forbiddenSegment:
        '${Platform.pathSeparator}desktop${Platform.pathSeparator}',
    label: 'mobile',
    errors: errors,
  );

  final sharedRoots = ['common', 'core', 'features', 'src'];
  for (final sharedRoot in sharedRoots) {
    final directory = Directory(
      '${lib.path}${Platform.pathSeparator}$sharedRoot',
    );
    if (!directory.existsSync()) continue;
    for (final entity in directory.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      for (final dependency in _directDependencies(entity, lib, errors)) {
        if (_isInside(dependency, Directory('${lib.path}/desktop')) ||
            _isInside(dependency, Directory('${lib.path}/mobile'))) {
          errors.add(
            'Shared file ${_relative(entity, root)} imports platform file '
            '${_relative(dependency, root)}.',
          );
        }
      }
    }
  }

  if (errors.isNotEmpty) {
    for (final error in errors.toSet()) {
      stderr.writeln('ERROR: $error');
    }
    exitCode = 1;
    return;
  }

  stdout.writeln(
    'Platform imports OK. Desktop graph: ${desktopClosure.length} Dart files. '
    'Mobile graph: ${mobileClosure.length} Dart files.',
  );
}

Set<File> _dependencyClosure(File entry, Directory lib, List<String> errors) {
  final visited = <String>{};
  final files = <File>{};
  final pending = <File>[_canonical(entry)];
  while (pending.isNotEmpty) {
    final file = _canonical(pending.removeLast());
    final normalized = file.path.toLowerCase();
    if (!visited.add(normalized)) continue;
    if (!file.existsSync()) {
      errors.add('Missing Dart file: ${file.path}');
      continue;
    }
    files.add(file);
    pending.addAll(_directDependencies(file, lib, errors));
  }
  return files;
}

Iterable<File> _directDependencies(
  File file,
  Directory lib,
  List<String> errors,
) sync* {
  final source = file.readAsStringSync();
  for (final match in _directivePattern.allMatches(source)) {
    final uri = match.group(1)!;
    File? dependency;
    if (uri.startsWith('package:bears_video/')) {
      dependency = File(
        '${lib.path}/${uri.substring('package:bears_video/'.length)}',
      );
    } else if (!uri.contains(':')) {
      dependency = File('${file.parent.path}/$uri');
    }
    if (dependency == null) continue;
    final resolved = _canonical(dependency);
    if (!resolved.existsSync()) {
      errors.add('Unresolved import in ${file.path}: $uri');
      continue;
    }
    yield resolved;
  }
}

File _canonical(File file) {
  if (file.existsSync()) {
    return File(file.resolveSymbolicLinksSync());
  }
  return file.absolute;
}

void _rejectPlatformDirectory({
  required Set<File> closure,
  required String forbiddenSegment,
  required String label,
  required List<String> errors,
}) {
  for (final file in closure) {
    if (file.path.toLowerCase().contains(forbiddenSegment.toLowerCase())) {
      errors.add('$label dependency graph includes ${file.path}.');
    }
  }
}

bool _isInside(File file, Directory directory) {
  final prefix = '${directory.absolute.path}${Platform.pathSeparator}'
      .toLowerCase();
  return file.absolute.path.toLowerCase().startsWith(prefix);
}

String _relative(File file, Directory root) {
  final rootPath = '${root.absolute.path}${Platform.pathSeparator}';
  return file.absolute.path.startsWith(rootPath)
      ? file.absolute.path.substring(rootPath.length)
      : file.path;
}
