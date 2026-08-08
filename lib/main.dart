// The default target remains mobile for compatibility with `flutter run` on
// Android/iOS. Desktop builds must use `-t lib/main_desktop.dart`.
import 'package:bears_video/main_mobile.dart' as mobile;

Future<void> main() => mobile.main();
