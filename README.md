# Bears Video

Bears Video 是一个使用 Flutter 与 Rust 构建的跨平台视频浏览和播放客户端。项目提供内容分类、搜索、播放源与剧集选择、全屏播放、离线下载、收藏及观看历史等功能，并针对移动端和桌面端使用不同的平台外壳与响应式布局。

## 主要功能

- 首页推荐与电影、电视剧、综艺、动漫、纪录片、少儿分类
- 视频搜索、搜索历史和分类筛选
- 多播放源与剧集选择
- 在线播放、全屏控制、倍速播放、缓冲进度与断点续播
- 弹幕、屏幕亮度、音量和全屏电量显示
- 剧集下载、离线播放和下载记录管理
- 收藏、观看历史和播放状态持久化
- 移动端与桌面端自适应界面

## 技术栈

- [Flutter](https://flutter.dev/)：跨平台界面与应用逻辑
- [Riverpod](https://riverpod.dev/) / Flutter Hooks：状态管理
- [media_kit](https://github.com/media-kit/media-kit)：视频播放
- [Rust](https://www.rust-lang.org/)：接口、数据模型和本地数据库能力
- [flutter_rust_bridge](https://cjycode.com/flutter_rust_bridge/)：Flutter 与 Rust 通信
- SQLite（`rusqlite`）：本地数据持久化

## 环境要求

- Flutter SDK，内含 Dart `>= 3.12.2 < 4.0.0`
- Rust stable 工具链及 Cargo
- 对应目标平台的 Flutter 开发环境
  - Android：Android SDK、NDK
  - iOS / macOS：Xcode、CocoaPods
  - Windows：Visual Studio C++ 桌面开发工具
  - Linux：Flutter Linux 桌面开发依赖

先确认环境可用：

```bash
flutter doctor
rustc --version
cargo --version
```

## 开始开发

克隆项目并安装 Flutter 依赖：

```bash
git clone https://github.com/bears-of/bears-video-flutter.git
cd bears-video-flutter
flutter pub get
```

### 移动端

`lib/main.dart` 默认指向移动端入口，也可以显式指定 `lib/main_mobile.dart`：

```bash
flutter run -t lib/main_mobile.dart
```

指定设备运行：

```bash
flutter devices
flutter run -d <device-id> -t lib/main_mobile.dart
```

### 桌面端

桌面端必须使用独立入口：

```bash
flutter run -d windows -t lib/main_desktop.dart
```

在 macOS 或 Linux 上，将 `windows` 替换为对应设备名称。

## 构建

仓库提供了 Windows 命令脚本。脚本会先检查移动端与桌面端之间的平台导入边界：

```bat
tool\build_mobile.cmd
tool\build_desktop.cmd
```

对应的 Flutter 命令为：

```bash
flutter build apk -t lib/main_mobile.dart
flutter build windows -t lib/main_desktop.dart
```

## 代码检查与测试

```bash
flutter analyze
flutter test
dart run tool/check_platform_imports.dart
```

运行集成测试时需要连接或启动目标设备：

```bash
flutter test integration_test/simple_test.dart
```

## Rust 桥接

Rust 源码位于 `rust/`，生成的 Dart 绑定位于 `lib/src/rust/`。桥接配置保存在 `flutter_rust_bridge.yaml`：

```yaml
rust_input: crate::api
rust_root: rust/
dart_output: lib/src/rust
```

修改 Rust 对外接口后，需要使用与项目依赖一致的 `flutter_rust_bridge_codegen` 重新生成绑定。`lib/src/rust/` 中标记为自动生成的文件不应手动编辑。

## 项目结构

```text
lib/
  common/          应用启动、公共平台接口与通用组件
  core/            配置、主题、服务、依赖注入和响应式规则
  desktop/         桌面端外壳与平台控制器
  features/        首页、搜索、播放器、下载、历史等业务功能
  mobile/          移动端外壳与平台控制器
  src/rust/        flutter_rust_bridge 生成的 Dart 绑定
rust/              Rust API、数据模型与数据库实现
rust_builder/      Rust 原生库的 Flutter 构建插件
assets/            MiSans 字体、图标与空状态图片
test/              Flutter 单元与组件测试
integration_test/  集成测试
tool/              构建及架构检查脚本
```

## 设计约定

- 应用界面以简体中文为主。
- 全局字体使用 `MiSans-Regular.ttf`。
- 图标使用 `assets/icons/lucide/` 中的独立 SVG 文件。
- 移动端和桌面端共享业务能力，但平台相关实现应保持在各自目录中。
