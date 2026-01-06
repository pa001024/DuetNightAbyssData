# DuetNightAbyssData - Agent Guidelines

This repository contains Python tools for converting, processing, and translating game data for Duet Night Abyss. This guide helps agentic coding agents work effectively in this codebase.

## Build, Lint, and Test Commands

### Running Tests

```bash
# Run all tests
python -m unittest discover -s . -p "test_*.py"

# Run a single test file
python test_char_processor.py
python test_mod_processor.py

# Run a specific test class
python -m unittest test_char_processor.TestCharProcessor

# Run a specific test method
python -m unittest test_char_processor.TestCharProcessor.test_process_char_1101

# Run tests with verbose output
python -m unittest test_char_processor.py -v
```

### Main Data Processing Pipeline

```bash
# Step 1: Convert Lua data files to JSON
python step1_convert.py

# Step 2: Translate data (optional)
python step2_translate.py

# Step 3: Output processed data
python step3_output.py
```

### Development

- No formal linting or type checking configured
- Follow Python conventions and existing code style

## Code Style Guidelines

### Imports

Order imports by type, with no blank lines between groups of the same type:

1. Standard library imports: `import os`, `import json`, `from collections import OrderedDict`
2. Third-party imports: `from lupa import LuaRuntime`
3. Local imports: `from processor.base_processor import BaseProcessor`, `from ast_parser import parse_ast`

### Formatting

- Use 4 spaces for indentation
- All files use UTF-8 encoding
- JSON files: indent=2, ensure_ascii=False
- Use `OrderedDict` for JSON data when order preservation matters

### Type Hints

- Use type hints when defining new classes and public methods
- Import from `typing`: `Union`, `List`, `Optional`, `Dict`
- Use `@dataclass` for simple data structures (see ast_parser.py)
- Example: `def process_item(self, item_data, language) -> Dict:`

### Naming Conventions

- Classes: PascalCase - `BaseProcessor`, `CharProcessor`, `DataLoader`
- Functions/Methods: snake_case - `process_item`, `load_json`, `get_translated_text`
- Variables: snake_case - `char_id`, `battle_char`, `skill_data`
- Private methods: prefix with underscore - `_process_skills`, `_get_table_data`
- File names: snake_case - `char_processor.py`, `test_char_processor.py`

### Error Handling

- Use try-except blocks with specific exceptions where possible
- Print errors with `flush=True` for immediate output: `print(f"Error: {e}", flush=True)`
- Provide graceful fallbacks: return `None`, `{}`, or `0.0` instead of raising
- Import rarely-used modules inside try-except blocks: `import math` in `_execute_function`
- Use `traceback.print_exc()` for debugging complex errors

### Code Organization

- Inherit from `BaseProcessor` for all data processors (char_processor.py, weapon_processor.py, etc.)
- Use `DataLoader` for all JSON file access (caching, i18n support)
- Each processor handles one data type (Char, Weapon, Mod, etc.)
- Processors follow pattern: `load_json()` → `process_item()` → `save_processed_items()`

### Documentation

- Add docstrings to public methods and classes
- Use Chinese for docstrings and comments (matching existing code)
- Example: `"""处理单个项目，子类必须实现"""`

### Testing

- Use standard `unittest.TestCase` for all tests
- Test files: `test_<module>_processor.py`
- Test classes: `Test<Module>Processor`
- Test methods: `test_<feature>_with_<condition>`
- Mock external dependencies using `unittest.mock.MagicMock`

### Special Patterns

- **I18n**: Always use `get_translated_text()` instead of hardcoded strings
- **AST Parsing**: Use `ast_parser.parse_ast()` for expression evaluation
- **Lua Conversion**: Files in `Datas/*.lua` → `out/*.json` via `step1_convert.py`
- **Expression Evaluation**: Use `_calculate_expr_value()` for game data expressions
- **Skill Growth**: Access via `skill_grow_data` using `table_type` and `table_id`

### File Paths

- Input data: `./Datas/*.lua` (Lua game data files)
- Converted data: `./out/*.json` (intermediate JSON)
- Processors: `./processor/*_processor.py`
- Tests: `./test_*_processor.py`

## Key Components

### Processor Classes

All processors inherit from `BaseProcessor` and implement:

- `process_item(item_data, language)` - Process single data item
- Optional: Override `_calc_attr_by_level()` for custom attribute calculation

### DataLoader

Centralized JSON data loading with:

- Caching to avoid repeated file reads
- i18n support (TextMap_I18n.json with cn, en, jp, kr, fr, es, tc fields)
- Language switching via `set_language(language)`

### AST Parser

Handles game data expression evaluation (e.g., "#SkillEffects[310313].Value")

- Supports: binary ops, member access, index access, function calls
- Math functions: math.abs, math.floor, math.ceil, math.max, math.min
