---
applyTo: "**/*.sh"
---
# Project coding standards for Shell scripts

Apply the [general coding guidelines](./general-coding.instructions.md) to all code.

## Shell guidelines

### Code Style

- Use POSIX compliant shell scripts
- Follow [ShellCheck](https://www.shellcheck.net/) recommendations
- Use 2 spaces for indentation, instead of tabs
- Maximum line length is 80 characters
- Pipelines should be split one per line if they don’t all fit on one line
- Put ; then and ; do on the same line as the if, for, or while.
- A one-line alternative needs a space after the close parenthesis of the pattern and before the ;;
- Long or multi-command alternatives should be split over multiple lines with the pattern, actions, and ;; on separate lines
- In order of precedence: Stay consistent with what you find; quote your variables; prefer "${var}" over "$var"
- Always quote strings containing variables, command substitutions, spaces or shell meta characters, unless careful unquoted expansion is required or it’s a shell-internal integer
- Use arrays for safe quoting of lists of elements, especially command-line flags
- Use $(command) instead of backticks.
- eval should be avoided.
- Use an explicit path when doing wildcard expansion of filenames.
