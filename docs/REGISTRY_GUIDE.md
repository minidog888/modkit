# ModKit Registry 使用指南

## 概述

ModKit 支持从远程 registry 自动下载和安装模块。

## Registry 配置

在项目的 `mod.json` 中配置 registry：

```json
{
  "registry": {
    "default": "https://raw.githubusercontent.com/your-org/make-modules/main",
    "fallback": "./modules",
    "local": "./modules"
  },
  "dependencies": {
    "core": "^1.0.0",
    "demo-module": "^1.0.0"
  }
}
```

## 支持的下载方式

### 方式 1: tar.gz 压缩包（推荐）

URL 格式：`{registry}/{module-name}.tar.gz`

例如：
```
https://raw.githubusercontent.com/your-org/make-modules/main/demo-module.tar.gz
```

### 方式 2: Git 仓库

URL 格式：`{registry}/{module-name}.git`

例如：
```
https://github.com/your-org/demo-module.git
```

## 创建可分发的模块

### 标准模块结构

```
demo-module/
├── mod.json              # 模块元数据（必需）
├── module.mk            # Makefile 定义（必需）
├── bin/                 # 可执行脚本
│   ├── help
│   └── demo-command
├── lib/                 # 库文件
│   └── demo.lib
├── i18n/               # 国际化文件
│   ├── en
│   └── zh
├── config/             # 配置文件
│   └── demo.ini
├── resources/          # 资源文件
├── README.md
└── README_zh.md
```

### mod.json 示例

```json
{
  "name": "demo-module",
  "version": "1.0.0",
  "description": "A demo module for ModKit",
  "author": "Your Name",
  "maintainers": [
    "Your Name <your.email@example.com>"
  ],
  "keywords": ["demo", "example"],
  "depends": ["core"],
  "devDepends": [],
  "optionalDepends": [],
  "commands": {
    "demo-command": "Run demo command"
  },
  "files": [
    {
      "source": "config/demo.ini",
      "target": "config/demo.ini",
      "type": "copy",
      "description": "Demo module config"
    }
  ],
  "directories": [],
  "dataDirectories": [],
  "aliases": {
    "@demo-module": "./modules/demo-module"
  },
  "env": {
    "DEMO_MODULE_PATH": "./modules/demo-module"
  }
}
```

### module.mk 示例

```makefile
# ============================================
# Demo Module
# ============================================

MODULE_NAME := demo-module
MODULE_PATH := modules/demo-module

# Include core helper
include modules/core/lib/makefile-helpers.mk

.PHONY: demo-command help-demo-module

demo-command:
	@bash $(MODULE_PATH)/bin/demo-command

help-demo-module:
	@echo ""
	@echo "Demo Module Commands:"
	@echo "  demo-command    Run demo command"
	@echo ""

$(call generate_phony_auto)
```

## 打包模块为 tar.gz

```bash
# 进入模块目录
cd demo-module

# 打包（不包含目录本身）
tar -czf ../demo-module.tar.gz .
```

## 设置 GitHub Registry

### 步骤 1: 创建仓库

在 GitHub 上创建一个仓库，例如 `make-modules`

### 步骤 2: 上传模块

```
make-modules/
├── demo-module.tar.gz
├── another-module.tar.gz
└── README.md
```

### 步骤 3: 获取 raw URL

访问 GitHub 上的文件，点击 "Raw" 获取 URL，例如：
```
https://raw.githubusercontent.com/your-org/make-modules/main/demo-module.tar.gz
```

### 步骤 4: 配置 registry

在 `mod.json` 中：
```json
{
  "registry": {
    "default": "https://raw.githubusercontent.com/your-org/make-modules/main"
  }
}
```

## 自动安装流程

运行 `make install` 后，系统会：

1. **步骤 0/3**: 检测环境依赖（python3, git, curl, tar）
2. **步骤 1/3**: 从 registry 下载所有依赖的模块
3. **步骤 2/3**: 初始化目录结构
4. **步骤 3/3**: 启用所有依赖模块

## 手动安装模块

### 方式 1: 通过 mod 命令

```bash
bash modules/core/bin/mod install demo-module https://github.com/your-org/demo-module.git
```

### 方式 2: 通过 Makefile

```bash
make mod@add name=demo-module source=https://github.com/your-org/demo-module.git
```

### 方式 3: 通过 install-deps（推荐）

1. 先在 `mod.json` 中配置：
```json
{
  "dependencies": {
    "demo-module": "^1.0.0"
  }
}
```

2. 运行：
```bash
make mod@install-deps
```

## 本地开发测试

开发新模块时，可以在本地测试：

```bash
# 假设你的模块在 ~/dev/my-module
bash modules/core/bin/mod install my-module ~/dev/my-module
```

## 版本约束

支持的版本约束格式：

- `^1.0.0` - 兼容 1.x.x
- `1.0.0` - 精确版本
- `*` - 任意版本（默认）

当前实现中，版本约束主要用于记录，实际安装时会使用最新可用版本。

## 故障排除

### 问题: 下载失败

```
[ERROR] Failed to download: demo-module
```

**解决方案:**
1. 检查网络连接
2. 确认 registry URL 正确
3. 确认模块文件存在
4. 尝试手动访问 URL 测试

### 问题: 模块结构无效

```
[ERROR] No valid module found in downloaded content
```

**解决方案:**
1. 确认模块包含 `mod.json` 文件
2. 确认 `mod.json` 格式正确
3. 检查打包时是否包含了正确的文件

### 问题: 环境依赖缺失

```
[WARNING] Missing dependencies: python3
```

**解决方案:**
1. 选择自动安装（按 y）
2. 或手动安装：`sudo apt-get install python3`
