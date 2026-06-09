# ModKit

ModKit 是一个基于 Makefile 的模块化项目框架，支持模块化管理、配置发布和远程依赖安装。

## 快速开始

### 1. 安装依赖模块

```bash
modkit install
```

### 2. 配置模块

编辑 `modules.mk` 启用需要的模块：

```makefile
ENABLE_MODULES := demo-module
```

### 3. 发布模块配置

```bash
modkit mod@publish
```

## 项目结构

```
.
├── Makefile              # 主构建文件
├── mod.json              # 模块配置
├── modules.mk            # 启用的模块列表
├── modules/              # 模块目录
│   └── (your modules)
└── config/               # 配置目录（发布后）
```

## 常用命令

| 命令 | 说明 |
|------|------|
| `modkit help` | 显示帮助信息 |
| `modkit install` | 安装所有依赖模块 |
| `modkit publish` | 发布模块配置到 config/ |

## 文档

- [模块注册与安装](docs/REGISTRY_GUIDE.md) - 从远程 registry 安装模块
- [模块配置发布](docs/CONFIG_PUBLISH_GUIDE.md) - 配置文件的加载与发布
- [核心库参考](docs/LIBRARY_GUIDE.md) - colors.lib, yaml.lib, config.lib, i18n.lib

## mod.json 配置

```json
{
  "name": "my-project",
  "version": "1.0.0",
  "dependencies": {
    "core": "^1.0.0"
  },
  "registry": {
    "default": "http://localhost:8000/api/packages",
    "fallback": "./modules",
    "local": "./modules"
  }
}
```

## 环境变量

参考 `.env.example` 文件配置环境变量。
