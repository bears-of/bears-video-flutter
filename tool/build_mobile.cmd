@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem Vendored OpenSSL requires an MSYS2 Perl when cross-compiling for Android.
rem Strawberry Perl emits Windows paths, while Git's bundled Perl lacks core
rem modules required by OpenSSL Configure.
set "DETECTED_MSYS2_ROOT="
if defined MSYS2_ROOT if exist "!MSYS2_ROOT!\usr\bin\perl.exe" if exist "!MSYS2_ROOT!\usr\bin\make.exe" set "DETECTED_MSYS2_ROOT=!MSYS2_ROOT!"
for %%I in ("C:\msys64" "D:\msys64" "D:\bearsof\Environment\msys64") do if not defined DETECTED_MSYS2_ROOT if exist "%%~I\usr\bin\perl.exe" if exist "%%~I\usr\bin\make.exe" set "DETECTED_MSYS2_ROOT=%%~I"

if not defined DETECTED_MSYS2_ROOT (
  echo MSYS2 with Perl and GNU Make is required to build OpenSSL for Android. 1>&2
  echo Install the MSYS2 perl and make packages, or set MSYS2_ROOT. 1>&2
  exit /b 1
)

set "OPENSSL_SRC_PERL=!DETECTED_MSYS2_ROOT!\usr\bin\perl.exe"
set "PATH=!DETECTED_MSYS2_ROOT!\usr\bin;!PATH!"

dart run tool\check_platform_imports.dart || exit /b 1
flutter build apk -t lib\main_mobile.dart %*
