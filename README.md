# BuildBox Python tools

A [BuildBox](https://github.com/TrustedObjects/BuildBox) tool that creates and manages a Python 3 virtual environment inside a target's build directory.

## Purpose

When listed as a tool in a BuildBox target, this tool initializes a Python virtual environment at `$BB_TARGET_BUILD_DIR` on load and tears it down cleanly on unload. Any package build script running within that target can then invoke `pip` and `python` against the target-local venv without ever sourcing an `activate` script.

## Installation

In your `.bbx/packages`, add a `buildbox_python_tools` package file with this content:

```bash
SRC_PROTO=git
SRC_URI=https://github.com/TrustedObjects/BuildBox-python-tools.git
SRC_REVISION="master"
SRC_BUILD=prebuilt
```

## Usage

Assuming you have in your BuildBox target file a `TOOLS=tools.<TARGET>` entry, you can list the tool in your target's tools file (`.bbx/tools.<TARGET>`):

```
buildbox_python_tools
```

or, to use a given release:

```
buildbox_python_tools-1.0.0
```

BuildBox will source `load.sh` when the tool is loaded and `unload.sh` when it is unloaded.

## Configuration

Set this variable in your target file (`.bbx/target.<NAME>`) before the tool is loaded:

| Variable | Default | Description |
|---|---|---|
| `BB_TARGET_VAR_PYVENV_ALLOW_SYS_SITE_PKG` | `0` | Set to `1` to create the venv with `--system-site-packages` |

## Behavior

On load, `load.sh`:

1. Creates `python3 -m venv [--system-site-packages] $BB_TARGET_BUILD_DIR` if the venv does not exist yet.
2. Recreates the venv if the system-site-packages setting has changed since the last load (tracked by the marker file `$BB_TARGET_BUILD_DIR/pyvenv_allow_sys_site_pkg`).
3. Exports `VIRTUAL_ENV=$BB_TARGET_BUILD_DIR` so that `pip` and `python` resolve to the venv without sourcing `activate`.

On unload, `unload.sh` unsets `VIRTUAL_ENV`.

## License

Copyright Trusted Objects.

GNU General Public License v2. See [LICENSE](LICENSE) for details.
