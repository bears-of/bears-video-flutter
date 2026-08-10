; Build the Windows release bundle before compiling this installer:
;   flutter build windows --release -t lib/main_desktop.dart
; Then run:
;   makensis installer\bears_video.nsi

Unicode True

!include "MUI2.nsh"

!define APP_NAME "Bears Video"
!ifndef APP_VERSION
  !define APP_VERSION "1.0.0"
!endif
!ifndef APP_VERSION_NUMERIC
  !define APP_VERSION_NUMERIC "1.0.0.0"
!endif
!define APP_PUBLISHER "Bears"
!define APP_EXE "bears_video.exe"
!define APP_REG_KEY "Software\BearsVideo"
!define UNINSTALL_REG_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\BearsVideo"
!define BUILD_DIR "${__FILEDIR__}\..\build\windows\x64\runner\Release"
!define APP_ICON "${__FILEDIR__}\..\windows\runner\resources\app_icon.ico"

Name "${APP_NAME}"
OutFile "${__FILEDIR__}\BearsVideo-${APP_VERSION}-windows-x64-setup.exe"
InstallDir "$LOCALAPPDATA\Programs\${APP_NAME}"
InstallDirRegKey HKCU "${APP_REG_KEY}" "InstallDir"
RequestExecutionLevel user

BrandingText "${APP_NAME}"
ShowInstDetails show
ShowUninstDetails show
SetCompressor /SOLID lzma
SetOverwrite on

Icon "${APP_ICON}"
UninstallIcon "${APP_ICON}"

VIProductVersion "${APP_VERSION_NUMERIC}"
VIAddVersionKey /LANG=1033 "ProductName" "${APP_NAME}"
VIAddVersionKey /LANG=1033 "ProductVersion" "${APP_VERSION}"
VIAddVersionKey /LANG=1033 "CompanyName" "${APP_PUBLISHER}"
VIAddVersionKey /LANG=1033 "FileDescription" "${APP_NAME} installer"
VIAddVersionKey /LANG=1033 "FileVersion" "${APP_VERSION}"
VIAddVersionKey /LANG=1033 "LegalCopyright" "Copyright (C) 2026 ${APP_PUBLISHER}"

!define MUI_ABORTWARNING
!define MUI_ICON "${APP_ICON}"
!define MUI_UNICON "${APP_ICON}"
!define MUI_FINISHPAGE_RUN "$INSTDIR\${APP_EXE}"
!define MUI_FINISHPAGE_RUN_TEXT "Launch ${APP_NAME}"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"

Section "${APP_NAME}" SecMain
  SectionIn RO
  SetShellVarContext current
  SetOutPath "$INSTDIR"

  File /r "${BUILD_DIR}\*"

  ; The marker prevents the uninstaller from recursively deleting an
  ; unrelated directory if the installation path is changed manually.
  FileOpen $0 "$INSTDIR\.bears-video-install" w
  FileWrite $0 "BearsVideoInstaller-v1"
  FileClose $0

  WriteUninstaller "$INSTDIR\Uninstall.exe"

  CreateDirectory "$SMPROGRAMS\${APP_NAME}"
  CreateShortcut "$SMPROGRAMS\${APP_NAME}\${APP_NAME}.lnk" "$INSTDIR\${APP_EXE}" "" "$INSTDIR\${APP_EXE}" 0
  CreateShortcut "$SMPROGRAMS\${APP_NAME}\Uninstall ${APP_NAME}.lnk" "$INSTDIR\Uninstall.exe"
  CreateShortcut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\${APP_EXE}" "" "$INSTDIR\${APP_EXE}" 0

  WriteRegStr HKCU "${APP_REG_KEY}" "InstallDir" "$INSTDIR"
  WriteRegStr HKCU "${UNINSTALL_REG_KEY}" "DisplayName" "${APP_NAME}"
  WriteRegStr HKCU "${UNINSTALL_REG_KEY}" "DisplayVersion" "${APP_VERSION}"
  WriteRegStr HKCU "${UNINSTALL_REG_KEY}" "Publisher" "${APP_PUBLISHER}"
  WriteRegStr HKCU "${UNINSTALL_REG_KEY}" "DisplayIcon" "$INSTDIR\${APP_EXE},0"
  WriteRegStr HKCU "${UNINSTALL_REG_KEY}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKCU "${UNINSTALL_REG_KEY}" "UninstallString" '$\"$INSTDIR\Uninstall.exe$\"'
  WriteRegStr HKCU "${UNINSTALL_REG_KEY}" "QuietUninstallString" '$\"$INSTDIR\Uninstall.exe$\" /S'
  WriteRegDWORD HKCU "${UNINSTALL_REG_KEY}" "NoModify" 1
  WriteRegDWORD HKCU "${UNINSTALL_REG_KEY}" "NoRepair" 1

  SectionGetSize ${SecMain} $0
  WriteRegDWORD HKCU "${UNINSTALL_REG_KEY}" "EstimatedSize" $0
SectionEnd

Section "Uninstall"
  SetShellVarContext current

  ClearErrors
  FileOpen $0 "$INSTDIR\.bears-video-install" r
  IfErrors invalidInstall
  FileRead $0 $1
  FileClose $0
  StrCmp $1 "BearsVideoInstaller-v1" markerValid invalidInstall

markerValid:
  Delete "$DESKTOP\${APP_NAME}.lnk"
  RMDir /r "$SMPROGRAMS\${APP_NAME}"
  DeleteRegKey HKCU "${UNINSTALL_REG_KEY}"
  DeleteRegKey HKCU "${APP_REG_KEY}"
  RMDir /r "$INSTDIR"
  Goto uninstallDone

invalidInstall:
  MessageBox MB_OK|MB_ICONSTOP "The ${APP_NAME} installation marker is missing or invalid. Uninstallation was stopped to protect other files."
  Abort

uninstallDone:
SectionEnd
