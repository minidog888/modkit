
# ============================================
# ModKit - 模块化构建系统
# ============================================
# 配置文件：
#   - mod.json: 模块配置
#   - modules.mk: 启用的模块列表
# ============================================

# Environment variables configuration
PROJECT_ROOT ?= $(shell pwd)
MODULES_DIR := $(PROJECT_ROOT)/modules

# Load system configuration
ifneq ("$(wildcard $(SYSTEM_CONFIG))","")
	include $(SYSTEM_CONFIG)
endif

# Load module configuration
ifneq ("$(wildcard $(MODULES_CONFIG))","")
	include $(MODULES_CONFIG)
endif

# Load core module (shared utilities)
include modules/core/module.mk

# Load optional modules (support submodules)
ifdef ENABLE_MODULES
	# Load top-level modules first
	-include $(patsubst %,modules/%/module.mk,$(ENABLE_MODULES))
	
	# Check and load submodules if any
	-include $(patsubst %,modules/%/modules/*/module.mk,$(ENABLE_MODULES))
endif
