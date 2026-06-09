# 模块配置发布和加载指南

## 新增功能

### 1. make install 改进

现在 `make install` 会自动执行以下 3 个步骤：

1. **下载所有依赖模块** - 从 registry 下载所有依赖
2. **初始化目录结构** - 创建必要的目录
3. **启用依赖模块** - 自动启用所有依赖模块

### 2. mod@publish 命令

新增 `mod@publish` 命令，用于发布模块配置到项目根目录。

#### 用法

```bash
make mod@publish
```

#### 功能

1. 列出所有包含配置文件的模块
2. 让用户选择要发布的模块
3. 将模块 `config/` 目录下的所有文件复制到 `config/<module-name>/`
4. 配置文件优先从项目根目录的 `config/` 目录加载

#### 示例

```bash
$ make mod@publish
[INFO] 正在发布模块配置...

选择要发布的模块：

  1. core
  2. my-module

输入模块编号： 1
[INFO] Publishing configuration for: core
[INFO]   Copied: core.yaml

已发布的配置文件：
  /path/to/project/config/core (1 files)

[SUCCESS] Configuration published successfully!
```

## 配置文件加载优先级

系统支持两种配置加载方式：

### 方式 1：使用 config-loader 工具（推荐）

```bash
#!/bin/bash

# 加载 config-loader
source modules/core/bin/config-loader

# 加载配置文件（会自动查找优先级）
CONFIG_PATH=$(load_config "core" "core.yaml")

# 直接 source 配置文件
source_config "core" "core.yaml"

# 检查配置文件是否存在
if config_exists "core" "core.yaml"; then
    echo "Config exists!"
fi
```

### 方式 2：手动实现优先级逻辑

```bash
# 优先级 1: 项目根目录的 config 目录
PROJECT_CONFIG="$PROJECT_ROOT/config/core/core.yaml"

# 优先级 2: 模块目录下的 config 目录
MODULE_CONFIG="$PROJECT_ROOT/modules/core/config/core.yaml"

# 优先使用项目配置
if [ -f "$PROJECT_CONFIG" ]; then
    source "$PROJECT_CONFIG"
elif [ -f "$MODULE_CONFIG" ]; then
    source "$MODULE_CONFIG"
fi
```

## 配置目录结构

发布配置后，项目的配置目录结构如下：

```
project-root/
├── config/                      # 项目级配置（优先级高）
│   └── core/
│       └── core.yaml            # 从模块发布过来的配置
│
├── modules/                     # 模块目录
│   └── core/
│       ├── config/              # 模块默认配置（优先级低）
│       │   └── core.yaml
│       └── ...
│
└── modules.yaml                 # 项目配置
```

## 优势

1. **灵活的覆盖机制** - 可以通过发布配置来覆盖模块的默认配置
2. **集中管理** - 所有模块配置集中在 `config/` 目录
3. **易于维护** - 修改配置不需要改动模块代码
4. **版本控制友好** - 项目特定的配置可以独立版本控制

## 使用场景

### 场景 1：自定义模块配置

```bash
# 1. 创建自定义配置
vim config/my-module/custom.yaml

# 2. 在代码中加载配置
source_config "my-module" "custom.yaml"
```

### 场景 2：环境特定配置

```bash
# 生产环境
cp config/production/database.yaml config/my-module/database.yaml

# 开发环境
cp config/development/database.yaml config/my-module/database.yaml
```

### 场景 3：覆盖模块默认配置

```bash
# 1. 发布模块配置
make mod@publish

# 2. 修改已发布的配置
vim config/core/core.yaml

# 3. 配置会以项目目录中的为准
```
