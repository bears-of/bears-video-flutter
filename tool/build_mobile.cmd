@echo off
setlocal
dart run tool\check_platform_imports.dart || exit /b 1
flutter build apk -t lib\main_mobile.dart %*
