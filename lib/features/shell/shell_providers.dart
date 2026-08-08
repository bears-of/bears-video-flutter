import 'package:hooks_riverpod/hooks_riverpod.dart';

enum ShellTab { home, mine }

final shellTabProvider = StateProvider<ShellTab>((ref) => ShellTab.home);
