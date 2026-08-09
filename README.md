# Bears Video

Bears Video is a cross-platform video browsing and playback client built with Flutter and Rust. It supports content discovery, search, source and episode selection, full-screen playback, offline downloads, favorites, and watch history. Mobile and desktop platforms use dedicated application shells with responsive layouts.

## Features

- Home recommendations and category-based browsing
- Video search, search history, and category filters
- Multiple playback sources and episode selection
- Online and full-screen playback with speed controls
- Buffer progress, saved playback position, and resume support
- Danmaku, screen brightness, volume, and full-screen battery indicators
- Episode downloads, offline playback, and download management
- Favorites, watch history, and persistent playback state
- Adaptive interfaces for mobile and desktop devices

## Technology

- [Flutter](https://flutter.dev/) for the cross-platform interface and application logic
- [Riverpod](https://riverpod.dev/) and Flutter Hooks for state management
- [media_kit](https://github.com/media-kit/media-kit) for video playback
- [Rust](https://www.rust-lang.org/) for APIs, data models, and local database operations
- [flutter_rust_bridge](https://cjycode.com/flutter_rust_bridge/) for Flutter and Rust interoperability
- SQLite through `rusqlite` for local persistence

## Requirements

- Flutter SDK with Dart `>= 3.12.2 < 4.0.0`
- The stable Rust toolchain and Cargo
- The Flutter development environment for the target platform:
  - Android: Android SDK and NDK
  - iOS and macOS: Xcode and CocoaPods
  - Windows: Visual Studio with Desktop development with C++
  - Linux: Flutter Linux desktop dependencies

Verify the development environment before continuing:

```bash
flutter doctor
rustc --version
cargo --version
```

## Getting Started

Clone the repository and install the Flutter dependencies:

```bash
git clone https://github.com/bears-of/bears-video-flutter.git
cd bears-video-flutter
flutter pub get
```

### Mobile

`lib/main.dart` uses the mobile entry point by default. It can also be selected explicitly:

```bash
flutter run -t lib/main_mobile.dart
```

To run on a specific device:

```bash
flutter devices
flutter run -d <device-id> -t lib/main_mobile.dart
```

### Desktop

Desktop builds must use the dedicated desktop entry point:

```bash
flutter run -d windows -t lib/main_desktop.dart
```

Replace `windows` with the appropriate device name when running on macOS or Linux.

## Building

The repository includes Windows command scripts. Each script validates the platform import boundaries before starting a build:

```bat
tool\build_mobile.cmd
tool\build_desktop.cmd
```

The equivalent Flutter commands are:

```bash
flutter build apk -t lib/main_mobile.dart
flutter build windows -t lib/main_desktop.dart
```

## Checks and Tests

```bash
flutter analyze
flutter test
dart run tool/check_platform_imports.dart
```

An attached or running target device is required for the integration test:

```bash
flutter test integration_test/simple_test.dart
```

## Rust Bridge

Rust source code is located in `rust/`. Generated Dart bindings are written to `lib/src/rust/`. The bridge configuration is defined in `flutter_rust_bridge.yaml`:

```yaml
rust_input: crate::api
rust_root: rust/
dart_output: lib/src/rust
```

After changing a public Rust interface, regenerate the bindings with a `flutter_rust_bridge_codegen` version compatible with the project dependencies. Do not manually edit files in `lib/src/rust/` that are marked as generated.

## Project Structure

```text
lib/
  common/          Application bootstrap, shared platform APIs, and widgets
  core/            Configuration, theme, services, dependency injection, and UI rules
  desktop/         Desktop shell and platform controller
  features/        Home, search, player, downloads, history, and other features
  mobile/          Mobile shell and platform controller
  src/rust/        Generated flutter_rust_bridge Dart bindings
rust/              Rust APIs, data models, and database implementation
rust_builder/      Flutter build plugin for the native Rust library
assets/            MiSans font, icons, and empty-state images
test/              Flutter unit and widget tests
integration_test/  Integration tests
tool/              Build and architecture validation scripts
```

## Design Conventions

- The application interface is primarily written in Simplified Chinese.
- `MiSans-Regular.ttf` is the global typeface.
- Icons are maintained as individual SVG files under `assets/icons/lucide/`.
- Mobile and desktop share business capabilities while keeping platform-specific implementations in their respective directories.
