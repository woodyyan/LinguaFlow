# LinguaFlow

一款轻量的 macOS 原生翻译应用，专注于**英↔中翻译**和**简↔繁转换**两个核心场景。

![macOS 15+](https://img.shields.io/badge/macOS-15%2B-blue) ![Swift](https://img.shields.io/badge/Swift-5-orange) ![License](https://img.shields.io/badge/license-MIT-green)

## ✨ 功能

### 英↔中翻译
- 输入英文 → 自动翻译为简体中文
- 输入中文 → 自动翻译为英文
- 基于 Apple Translation Framework，完全离线、免费、隐私友好

### 简↔繁转换
- 输入简体中文 → 转换为繁体中文
- 输入繁体中文 → 转换为简体中文
- 基于 macOS 内置 ICU 引擎，瞬间完成

### 交互体验
- **自动语言检测**：NLLanguageRecognizer 实时识别输入语言，自动确定翻译方向
- **双模式切换**：顶栏 `[英↔中]` / `[简↔繁]` 一键切换
- **防抖输入**：停止输入 0.8 秒后自动翻译，避免频繁触发
- **一键复制**：翻译结果一键复制到剪贴板

### ⌨️ 快捷键

| 快捷键 | 功能 |
|--------|------|
| `⌘ Return` | 立即翻译 |
| `⌘ /` | 切换翻译模式（英↔中 ⇄ 简↔繁）|
| `⌘ ⇧ C` | 复制翻译结果 |

## 📦 技术栈

| 模块 | 技术 |
|------|------|
| 框架 | SwiftUI（macOS 15+）|
| 英↔中翻译 | Apple Translation Framework |
| 简↔繁转换 | CFStringTransform（ICU）|
| 语言检测 | NLLanguageRecognizer |
| 架构 | MVVM |

## 🚀 运行

### 环境要求
- macOS 15.0+
- Xcode 16+

### 构建运行

**Xcode（推荐）：**
1. 打开 `LinguaFlow.xcodeproj`
2. 选择 Scheme → LinguaFlow，Target → My Mac
3. `⌘ + R` 运行

**Swift Package Manager：**
```bash
swift build && swift run LinguaFlow
```

> 首次使用英↔中翻译时，系统可能提示下载语言模型，按提示下载即可。

## 📁 项目结构

```
LinguaFlow/
├── LinguaFlowApp.swift              # App 入口
├── Info.plist
├── Models/
│   ├── TranslationRoute.swift        # 翻译路由 + 模式枚举
│   └── TranslationRecord.swift       # 历史记录模型（预留）
├── Services/
│   ├── LanguageRouter.swift          # 语言检测 + 路由
│   ├── TranslationEngine.swift       # 翻译引擎协议
│   ├── AppleTranslationEngine.swift  # Apple Translation 引擎
│   └── ChineseVariantConverter.swift # 本地简繁转换
├── ViewModels/
│   └── TranslationViewModel.swift    # 核心 ViewModel
├── Views/
│   ├── MainTranslationView.swift     # 主翻译界面
│   └── Components/
│       ├── ModeToggle.swift          # 模式切换
│       ├── LanguageIndicator.swift   # 语言指示器
│       └── TextInputArea.swift       # 文本输入区域
└── Utilities/
    └── Debouncer.swift               # 输入防抖
```

## 📋 Roadmap

- [x] Phase 1：核心翻译 + 模式切换 + 语言检测 + 一键复制
- [ ] Phase 2：Menu Bar 常驻 + 全局快捷键 + 翻译历史
- [ ] Phase 3：LLM 翻译引擎（真正的粤语翻译）+ 剪贴板翻译

## 📄 License

MIT
