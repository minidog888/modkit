# Core Library Documentation

## Overview

The `modules/core/lib/` directory contains reusable libraries that can be used by any module.

## Directory Structure

```
modules/core/lib/
├── core.lib       # Main loader, loads all libraries
├── colors.lib     # Color output and logging
├── yaml.lib       # YAML parsing utilities
├── config.lib     # Config file loader with priority
└── i18n.lib       # Internationalization (i18n) library
```

## Quick Start

### Option 1: Load All Libraries (Recommended)

```bash
source modules/core/lib/core.lib
```

### Option 2: Load Specific Libraries

```bash
# Load just colors and yaml
source modules/core/lib/core.lib "colors yaml"

# Or load individually
source modules/core/lib/colors.lib
source modules/core/lib/yaml.lib
```

## Library Reference

### colors.lib - Logging and Color Output

**Color Variables:**
- `COLOR_RED`, `COLOR_GREEN`, `COLOR_YELLOW`, `COLOR_BLUE`
- `COLOR_PURPLE`, `COLOR_CYAN`, `COLOR_BOLD`, `COLOR_RESET`
- Backward compatible: `RED`, `GREEN`, `YELLOW`, `BLUE`, `NC`

**Logging Functions:**
```bash
log_info "Information message"     # Blue
log_success "Success message"       # Green
log_warning "Warning message"       # Yellow
log_error "Error message"           # Red
log_debug "Debug message"           # Purple (only if LOG_DEBUG=true)
log_section "Section title"         # Bold cyan separator
```

### yaml.lib - YAML Parsing

**Functions:**

```bash
# Parse simple key-value pairs
parse_yaml_simple "config.yaml" "key_name"

# Parse list items
parse_yaml_list "config.yaml" "list_name"

# Parse dictionary (returns key=value pairs)
parse_yaml_dict "config.yaml" "dict_name"

# Parse nested value with dot notation
parse_yaml_nested "config.yaml" "parent.child.grandchild"
```

### config.lib - Config Loader with Priority

Priority: `$PROJECT_ROOT/config/<module>/` > `$PROJECT_ROOT/modules/<module>/config/`

**Functions:**

```bash
# Get the path to config file (checks priority)
CONFIG_PATH=$(load_config "core" "core.yaml")

# Source the config file
source_config "core" "core.yaml"

# Check if config exists
if config_exists "core" "core.yaml"; then
    echo "Config found!"
fi

# List all config files for a module
get_module_configs "core"
```

### i18n.lib - Internationalization (i18n)

**Functions:**

```bash
# Initialize i18n (loads language from config)
i18n_init

# Get translated string
echo "$(t 'HELLO_WORLD')"

# Quick translation functions are also available
echo "$(msg_installing)"
echo "$(msg_success)"
```

**Language Files:**
Language files are stored in `modules/core/i18n/` directory.

### core.lib - Library Loader

**Functions:**

```bash
# Check if library is loaded
if is_lib_loaded "colors"; then
    echo "Colors library loaded"
fi

# Load specific libraries
load_core_libs "colors yaml"
```

## Usage Examples

### Complete Example

```bash
#!/bin/bash

# Load all core libraries
source modules/core/lib/core.lib
i18n_init  # Initialize i18n

# Use colors and logging
log_info "Starting script..."

# Use YAML parser
VERSION=$(parse_yaml_simple "modules.yaml" "version")
log_success "Version: $VERSION"

# Load config
if source_config "core" "core.yaml"; then
    log_success "Config loaded"
fi

# Use i18n
echo "$(msg_installing)"
echo "$(t 'HELP_INSTALL')"
```

### Module Development

Any module can use these libraries:

```bash
#!/bin/bash
# modules/my-module/bin/my-script.sh

# Load core libraries
source "$(dirname "${BASH_SOURCE[0]}")/../../core/lib/core.lib"

# Use them
log_info "My module script"
CONFIG=$(load_config "my-module" "config.yaml")
```

### Migrating Existing Scripts

**Before:**
```bash
# Duplicate code
RED='\033[0;31m'
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

parse_yaml_simple() { ... }
```

**After:**
```bash
# Use shared library
source modules/core/lib/core.lib
log_error "Clean!"
```

## Best Practices

1. **Load Early**: Source `core.lib` at the beginning of your script
2. **Use core.lib**: Prefer loading through `core.lib` instead of individual files
3. **Error Handling**: Check if files exist before sourcing
4. **Log Levels**: Use `LOG_DEBUG=true` for debugging output
