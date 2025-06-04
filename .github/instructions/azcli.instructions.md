---
applyTo: "**/*.azcli"
---
# Project coding standards for Azure CLI scripts

Apply the [general coding guidelines](./general-coding.instructions.md) to all code.

## Azure CLI guidelines

### Code Style

- Use POSIX syntax
- Follow [ShellCheck](https://www.shellcheck.net/) recommendations
- Use 2 spaces for indentation, instead of tabs
- Use `--output none` to suppress output from az commands
- Each parameter is represented on a separate line
- Maximum line length is 80 characters
- Pipelines should be split one per line if they don’t all fit on one line
- In order of precedence: Stay consistent with what you find; quote your variables; prefer "${var}" over "$var"
- Always quote strings containing variables, command substitutions, spaces or shell meta characters, unless careful unquoted expansion is required or it’s a shell-internal integer
- Use arrays for safe quoting of lists of elements, especially command-line flags
- Use $(command) instead of backticks.
- eval should be avoided.
- Use an explicit path when doing wildcard expansion of filenames.
