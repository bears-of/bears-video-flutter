---
name: Bears
description: 清爽轻盈的跨平台视频浏览与播放体验
colors:
  sky-blue: "#4388E8"
  indigo-blue: "#295FAF"
  indigo-pressed: "#204E91"
  cloud-blue: "#E1ECFC"
  focus-blue: "#72A9F2"
  daylight-canvas: "#F2F7FD"
  cloud-white: "#FBFDFF"
  cloud-muted: "#E6EEF8"
  cloud-pressed: "#D7E5F6"
  midnight-ink: "#1E3049"
  blue-gray-ink: "#586B83"
  cloud-line: "#C7D7EA"
  sunrise: "#F2A93B"
  danger: "#C64B51"
  danger-pressed: "#A63A40"
  overlay: "rgba(20, 36, 60, 0.478)"
typography:
  headline:
    fontFamily: "MiSans, sans-serif"
    fontSize: "28px"
    fontWeight: 400
    letterSpacing: "normal"
  title-large:
    fontFamily: "MiSans, sans-serif"
    fontSize: "22px"
    fontWeight: 400
    letterSpacing: "normal"
  title:
    fontFamily: "MiSans, sans-serif"
    fontSize: "16px"
    fontWeight: 400
    letterSpacing: "normal"
  body:
    fontFamily: "MiSans, sans-serif"
    fontSize: "14px"
    fontWeight: 400
    letterSpacing: "normal"
  label:
    fontFamily: "MiSans, sans-serif"
    fontSize: "12px"
    fontWeight: 400
    letterSpacing: "normal"
rounded:
  xs: "4px"
  sm: "6px"
  md: "8px"
  lg: "12px"
  capsule: "999px"
spacing:
  xs: "4px"
  sm: "8px"
  md: "12px"
  lg: "16px"
  xl: "20px"
  2xl: "24px"
  3xl: "32px"
components:
  button-primary:
    backgroundColor: "{colors.indigo-blue}"
    textColor: "#FFFFFF"
    typography: "{typography.body}"
    rounded: "{rounded.sm}"
    padding: "0 16px"
    height: "42px"
  button-primary-pressed:
    backgroundColor: "{colors.indigo-pressed}"
    textColor: "#FFFFFF"
    rounded: "{rounded.sm}"
  button-secondary:
    backgroundColor: "{colors.cloud-blue}"
    textColor: "{colors.indigo-blue}"
    rounded: "{rounded.sm}"
    padding: "0 16px"
    height: "42px"
  button-ghost:
    backgroundColor: "transparent"
    textColor: "{colors.indigo-blue}"
    rounded: "{rounded.sm}"
    padding: "0 10px"
    height: "34px"
  input:
    backgroundColor: "{colors.cloud-white}"
    textColor: "{colors.midnight-ink}"
    typography: "{typography.body}"
    rounded: "{rounded.md}"
    padding: "9px 12px"
  card:
    backgroundColor: "{colors.cloud-white}"
    textColor: "{colors.midnight-ink}"
    rounded: "{rounded.md}"
    padding: "12px"
---

# Design System: Bears

## Overview

**Creative North Star: "晴空云端影库"**

Bears 像一座悬在晴空中的随身影库：晴空蓝负责清晰操作，靛青蓝强化关键状态，云霭蓝承担柔和反馈。界面保持清爽、年轻和轻盈，让用户长时间浏览海报、剧集和播放信息时仍然舒适，不用厚重暗色制造所谓的影院感。

视觉表达坚持“轻巧而明确，灵动而年轻”。内容始终先于装饰；按钮、选择器和提示通过短促缩放、柔和换色及清楚的状态差异提供反馈。通透材质集中用于导航和浮层，不扩散到每一块内容区域。

**Key Characteristics:**

- 云霭浅色背景与清澈晴空蓝交互色
- 清晰提示、紧凑控件和内容优先的信息层级
- 细描边、浅表面和克制阴影构成的轻柔分层
- 优雅短动效，以及对系统“减少动态效果”设置的尊重
- 移动端与桌面端共享品牌语言，但保留各自的导航结构

## Colors

色彩以清澈蓝色为主轴，配合云白表面和深靛墨色文字；暖黄色只负责少量提示，红色只用于危险操作和错误状态。

### Primary

- **晴空蓝**：主要操作、进度、选中状态和活跃强调。
- **靛青蓝**：文字主按钮的默认底色、深色交互文字和需要更强对比的选中内容。
- **深靛按压蓝**：文字承载按钮的按压状态，保持白字对比度。
- **云霭蓝**：次要按钮、选中底色、悬停与轻提示背景。
- **天光焦点蓝**：键盘焦点环和输入框聚焦边界。

### Secondary

- **日出琥珀**：评分、提醒或少量需要温度的重点信息；不可作为大面积主题色。
- **珊瑚警示红**：删除、取消下载等破坏性操作及错误反馈。

### Neutral

- **晴昼云白**：页面画布，降低长时间浏览的视觉疲劳。
- **云端白**：卡片、输入框、弹窗等前景表面。
- **浅云蓝灰**：禁用轨道、占位和次级区域。
- **午夜靛墨**：标题和主要正文。
- **云影蓝灰**：说明文字、未选中图标和次级标签。
- **云线蓝灰**：边框、分隔线和静态轮廓。

**The Sky Signal Rule.** 晴空蓝表示可操作、已选中或正在进行；不要把它当作无意义的装饰填满页面。

**The Daylight Rule.** 常规浏览表面保持明亮清透，不用大面积黑色或深色渐变营造沉重影院氛围；深色只属于视频画面与必要遮罩。

## Typography

**Display Font:** MiSans（系统无衬线回退）  
**Body Font:** MiSans（系统无衬线回退）

**Character:** MiSans 的清晰中文骨架与略带现代感的笔画适合高密度影视信息。全局只使用 MiSans Regular，层级由字号、颜色、留白和状态标记建立，不使用合成粗体或 Material 默认文本字体。

### Hierarchy

- **Headline**（400，28px）：顶层页面身份或重点区块标题。
- **Title Large**（400，22px）：视频名称及重要内容标题。
- **Title**（400，16px）：应用栏、卡片组标题和弹窗标题。
- **Body**（400，14px）：正文、描述和常规控件文本。
- **Label**（400，12px）：标签、状态、导航文字和辅助信息。

**The Compact Hierarchy Rule.** 操作型页面只使用完成任务所需的字号层级；卡片和工具面板内不使用展示级大字。

**The Natural Tracking Rule.** 字距保持正常，不使用负字距压缩标题，也不以宽字距模拟品牌感。

## Layout

布局采用内容驱动的响应式网格。页面内容在桌面端居中并限制在 1180px，桌面画布提供 32px 横向内边距；1024px 起切换为桌面导航结构。海报网格根据宽度在 3、4、5、6、7 列之间变化，关键断点为 720px、1024px、1240px 和 1500px。

基础间距沿 4px 节奏扩展，常用值为 8、12、16、20、24 和 32px。移动端页面使用紧凑的 12–16px 内容边距，并为悬浮底部导航和安全区保留空间。桌面端使用固定 112px 侧栏；移动端使用底部双入口导航，两种结构不直接缩放复用。

**The Content Breath Rule.** 海报与信息列表保持紧凑扫描节奏，但区块之间必须有明确留白；不得通过叠加卡片边框代替空间层级。

**The Platform Shell Rule.** 移动端与桌面端共享内容组件，不共享同一套全局导航几何。

## Elevation & Depth

系统采用轻柔分层：大多数内容平铺在晴昼画布上，云端白表面通过云线细描边建立边界；阴影仅用于悬停海报、气泡弹窗和悬浮移动导航。导航的半透明与模糊是品牌签名，但不应扩散成全页面玻璃拟态。

### Shadow Vocabulary

- **海报悬停影**：蓝色环境阴影，16px 模糊并向下偏移 7px，只在桌面悬停时出现。
- **气泡浮层影**：深森林色低透明阴影，24px 模糊并向下偏移 12px，用于对话框与确认浮层。
- **导航环境影**：黑色低透明阴影，28px 模糊并向下偏移 14px，使移动导航与内容分离。
- **玻璃高光影**：白色内向高光与晴空蓝下方辉光组合，仅用于移动端选中胶囊。

**The Light-Layer Rule.** 表面默认无阴影；只有真实悬浮、悬停或模态层级才获得阴影。

## Shapes

基础形状克制而圆润：4px 用于微型标签，6px 用于按钮，8px 用于输入框、卡片和海报，12px 用于气泡表面。胶囊形状仅用于选择指示器、底部导航和确实需要连续选择语义的控件。

边框通常为 1px 云线蓝灰，焦点时变为 1.5px 天光焦点蓝。海报图片裁切遵循稳定纵横比和 8px 圆角，悬停、加载状态或角标不得改变卡片尺寸。

**The Radius Ladder Rule.** 优先使用 4/6/8/12px 半径阶梯；大圆角和胶囊必须对应导航、浮层或选择语义，不能成为所有容器的默认造型。

## Components

### Buttons

- **Shape:** 轻巧圆角矩形（6px），标准高度 42px，紧凑高度 34px。
- **Primary:** 靛青蓝底、白色文字；按压切换为深靛蓝并缩放至 0.97。晴空蓝保留给无需承载小号白字的品牌信号和进度状态。
- **Secondary:** 云霭蓝底、靛青蓝文字和云线描边。
- **Ghost:** 透明底、靛青蓝文字；按压时出现云霭蓝底。
- **Danger:** 珊瑚红底、白色文字，只用于破坏性命令。
- **Focus / Disabled:** 键盘焦点使用 1.5px 天光蓝；禁用态覆盖半透明云白表面并移除可点击光标。

### Chips

- **Style:** 紧凑标签使用 4–14px 圆角，未选中为浅表面或透明底，选中为晴空蓝或晴空蓝 10% 底色。
- **State:** 通过底色、边框、图标和短滑动/换色共同表达选择，不允许仅依赖颜色的细微差异。
- **Inline Playback Selectors:** 详情页内横向播放源与选集按钮使用 6px 圆角并统一保持白底。普通态使用云影蓝灰文字和 1px 云线蓝灰边框；选中态使用靛青蓝文字、1.5px 靛青蓝边框和状态图标，不使用实色填充、合成粗体或悬浮阴影。

### Episode Sheet Selectors

- **Playback Source / Episode:** `_EpisodeSheet` 中的播放源和剧集按钮统一使用白色底。普通态使用云影蓝灰文字与完整的 1px 云线蓝灰边框，保持边界清晰但弱化视觉权重；选中态切换为靛青蓝文字和 1.5px 靛青蓝边框。
- **Selected State:** 选中不能只靠边框颜色表达，必须同时使用播放图标或状态圆点，让播放源与当前剧集可以快速扫读。
- **Scope:** 这是播放详情选集面板的局部选择器规范，不替代全局 Primary Button 的靛青蓝实底与白字规范。

### Cards / Containers

- **Corner Style:** 常规内容和海报使用 8px，气泡浮层使用 12px。
- **Background:** 内容卡片使用云端白；页面区块通常直接位于晴昼画布，不额外套卡片。
- **Shadow Strategy:** 静止无影，桌面悬停时才出现海报悬停影。
- **Border:** 工具型卡片使用 1px 水线描边；纯内容海报可无边框。
- **Internal Padding:** 常用 12–16px，弹窗为 20–24px。

### Inputs / Fields

- **Style:** 云端白填充、8px 圆角、1px 云线描边，正文和提示保持 13–14px。
- **Focus:** 140ms 内将边框切换为 1.5px 焦点青，不添加发光或布局位移。
- **Icon Area:** 前后图标保持至少 34–36px 的稳定区域，避免文本和状态变化挤动布局。

### Navigation

- **Mobile:** 底部 76px 半透明胶囊，安全区外边距 24px；选中胶囊在 320ms 内滑动，按压缩放在 120ms 内完成，并响应系统减少动画设置。
- **Desktop:** 112px 左侧导航，72px 导航项；选中态使用淡云霭蓝底、靛青蓝图标与明确状态指示器。
- **Hierarchy:** 顶级目的地进入平台外壳；详情、搜索、下载和历史使用导航栈推进。

### Full-Screen Player Controls

- **Scope:** 全屏播放器顶部与底部控制区域全部使用 `Colors.transparent`，不添加渐变、背景面板、圆角或阴影，让视频画面保持完整连续。
- **Top Bar:** 顶部控件位于安全区内并保持 44px 触控尺寸；返回按钮位于左侧，可截断的标题与剧集副标题随可用空间收缩，时间固定在屏幕水平正中，实时电量状态位于右侧。电量同时显示系统百分比和按 0–100% 比例填充的电池图形，充电或连接电源时显示对应状态；无法读取电量时降级为 `--%`。窄于 600px 时压缩间距，但保留截断的剧集副标题和完整触控尺寸。
- **Bottom Bar:** 进度轨位于操作行上方：晴空蓝表示已播放区间、54% 白色表示已缓冲区间、24% 白色表示尚未缓冲区间。主播放按钮保持 48px，其余工具按钮保持 44px。选集使用纯文字且无图标，与退出全屏共同位于底栏最右侧。
- **Interaction:** 控制栏按钮默认完全透明，不使用 `Tooltip`、`InkWell`、hover、水波、按钮背景、圆角或阴影。交互由 `Semantics`、`GestureDetector` 与 `FocusableActionDetector` 承担，键盘保留 `ActivateIntent`；焦点只显示居中的 2px 短白色下划线，播放、暂停、静音等视觉状态必须与语义标签同步。
- **Motion:** 控制层显隐使用短促、克制的淡入淡出；系统启用减少动态效果时立即切换，不保留位移或缩放动画。
- **Episode Drawer:** 全屏选集抽屉使用近黑炭色表面、12px 左侧圆角和细白色分界线。标题区保持紧凑，不使用装饰性图标块；当前剧集以均衡器图标、剧集名称和播放源组成单行状态。播放源与剧集选择器使用 6px 圆角、弱白填充和清晰描边，选中态切换为 1.5px 晴空蓝边框，并通过状态圆点或播放图标共同表达。关闭按钮复用无 Tooltip、无 hover 的全屏控制按钮，选择剧集后立即关闭抽屉。

### Video Detail Player Controls

- **Persistent Back:** 视频详情页的返回按钮独立于播放器控制层，固定在页面左上安全区内，并保持 44px 触控区域。加载、缓冲、播放错误、控制层自动隐藏及页面滚动时均不得隐藏；按钮保持完全透明，仅通过白色图标和轻微暗色投影维持画面对比。
- **Control Layout:** 底部控制层使用上下两行结构：进度轨独占上行，并同时区分已播放、已缓冲和尚未缓冲区间；播放、合并时间读数和全屏操作位于下行。所有图标操作保持 44px 稳定区域，窄屏不得压缩触控尺寸。
- **Surface:** 控制层、返回按钮以及所有图标按钮均保持完全透明，不使用面板底色、渐变、描边或常驻按钮背景。白色图标与时间文字可使用轻微暗色投影维持复杂画面上的可读性。
- **Behavior:** 控制层可自动隐藏，返回按钮不可随之隐藏。播放、暂停和全屏操作分别使用 Bears 的 `playSVG`、`pauseSVG` 与 `fullScreenSVG` 白色图标；不存在实际行为的占位控件不得显示。按钮不显示 Tooltip、hover 或按压底色，无障碍语义标签必须与当前播放状态同步。

### Bubble Dialog

云端白气泡表面使用 12px 圆角、云线描边、底部小尾巴和柔和浮层影。进入时在 180ms 内从 0.94 缩放并淡入；确认操作用主按钮，危险确认用珊瑚红按钮。

### Poster Card

海报卡维持固定比例与 8px 裁切，底部可使用局部黑色透明渐变承载短备注。桌面悬停放大至 1.018 并显示环境影，按压收至 0.985；移动端不依赖悬停才能理解信息。

## Do's and Don'ts

### Do:

- **Do** 使用晴昼云白画布、云端白表面和晴空蓝状态建立清晰层级。
- **Do** 保持提示文字直接明确，并让加载、错误、空状态和下载进度可被快速识别。
- **Do** 使用 90–320ms 的短动效表达按压、选择和层级变化，并在系统禁用动画时降级为瞬时切换。
- **Do** 在移动端尊重安全区和系统返回，在桌面端提供悬停、键盘焦点与明确鼠标光标。
- **Do** 保持海报、按钮、导航项和输入框的稳定尺寸，避免动态内容造成布局跳动。

### Don't:

- **Don't** 使用大面积黑色、深蓝或浓重渐变把日常浏览页变成厚重影院界面。
- **Don't** 把玻璃拟态、模糊背景或漂浮阴影应用到每个卡片和区块。
- **Don't** 创建卡片内再套卡片的多层容器结构。
- **Don't** 用无语义的晴空蓝装饰争夺内容注意力，或用暖黄色替代主交互色。
- **Don't** 依赖悬停、动画或颜色作为状态的唯一线索。
