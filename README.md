# Template

Template that show a basic python repo using AWS Tools

## Files

### setup.cfg
Used to run CI tools when python builds


```
[metadata]
name = project
version = 0.1.0
description = Project
author = Ben Johnson
author_email = ben@johnsontech.io
license = MIT
readme = "README.md"
python = ^3.6 # Supported python versions
homepage =
repository =
documentation =

keywords = # keywords that pip can search on

classifiers =
    Topic :: Software Development

[options]
# Tells setuptools where to find the modules to build. Searches in src
package_dir=
    =src
packages=find:

# Required packages at runtime, does not include for build time
install_requires =
    requests

[options.packages.find]
where=src


# CLI entry for application
[options.entry_points]
  console_scripts =
    contacts-api = contacts.app:main

[tox:tox]
isolated_build = True
# envlist = py27, py35, py36, py37, pypy, jython
envlist = py39

[testenv]
deps =
    pytest
    pytest-cov[all]
    black
    isort
    flake8
    flake8-builtins
    flake8-comprehensions
    flake8-fixme
    flake8-functions-names
    flake8-print
    flake8-eradicate
    flake8-bugbear
    flake8-unused-arguments
    flake8-sfs
    flake8-annotations

commands =
    flake8
    pytest --cov=app tests/
    black --check --diff src tests
    isort --check-only --diff src tests

[coverage:run]
branch = True
omit = src/db/env.py,src/db/versions/*  # define paths to omit

[coverage:report]
show_missing = True
exclude_lines = # regex to exclude lines
    def __repr__
    if __name__ == "__main__"

[flake8]
exclude = .venv,.git,.tox,docs,venv,bin,lib,deps,build
max-complexity = 25
doctests = True
# To work with Black
# E501: line too long
# W503: Line break occurred before a binary operator
# E203: Whitespace before ':'
# D202 No blank lines allowed after function docstring
# W504 line break after binary operator
ignore =
    E501,
    W503,
    E203,
    D202,
    W504
noqa-require-code = True
```

### pyproject.toml
Configures python build settings, successor to `setup.cfg`. CI tools can store
config settings here to centalize it.

```
[build-system]
requires = [
    "setuptools >= 42",
    "wheel",
    "tox"
]
build-backend = "setuptools.build_meta"

[tool.black]
line-length = 88
target-version = ['py39']
include = '\.pyi?$'
exclude = '''

(
  /(
      \.eggs         # exclude a few common directories in the
    | \.git          # root of the project
    | \.mypy_cache
    | \.tox
    | \.venv
  )/
  | foo.py           # also separately exclude a file named foo.py in
                     # the root of the project
)
'''

[tool.isort]
profile = "black"
```

### .editorconfig
Sets VSCode and other editors specifics for the workspace. Requries `EditorConfig.EditorConfig`

```
root = true

[*]
indent_style = space
indent_size = 4
insert_final_newline = true
trim_trailing_whitespace = true
end_of_line = lf
charset = utf-8
max_line_length = 120

# Docstrings and comments use max_line_length = 79
[*.py]
max_line_length = 88

[*.{yml,yaml,json,js,css,html}]
indent_size = 2

```

### .env
pytest will use these env variables on run

```
PYTHONPATH=./src

```

### .git/hooks/pre-commit
Per local repo, will run at each commit, is not controlled by git. Ensure to `chmod +x`

Runs tox before, committing, if any errors are returned, does not commit
```
#!/bin/sh

# Redirect output to stderr.
exec 1>&2


tox
result=$?

if [ $result -ne 0 ]; then
	cat <<\EOF
Error: Failed to commit, tox failed
EOF
	exit 1
fi

shellcheck scripts/*.sh
result=$?

if [ $result -ne 0 ]; then
	cat <<\EOF
Error: Failed to commit, shellcheck failed
EOF
	exit 1
fi
```

### .git/hooks/pre-push
Per local repo, will run at each push, is not controlled by git. Ensure to `chmod +x`

If commit message starts with WIP, will refuse
```
#!/bin/sh

# An example hook script to verify what is about to be pushed.  Called by "git
# push" after it has checked the remote status, but before anything has been
# pushed.  If this script exits with a non-zero status nothing will be pushed.
#
# This hook is called with the following parameters:
#
# $1 -- Name of the remote to which the push is being done
# $2 -- URL to which the push is being done
#
# If pushing without using a named remote those arguments will be equal.
#
# Information about the commits which are being pushed is supplied as lines to
# the standard input in the form:
#
#   <local ref> <local oid> <remote ref> <remote oid>
#
# This sample shows how to prevent push of commits where the log message starts
# with "WIP" (work in progress).

remote="$1"
url="$2"

zero=$(git hash-object --stdin </dev/null | tr '[0-9a-f]' '0')

while read local_ref local_oid remote_ref remote_oid
do
	if test "$local_oid" = "$zero"
	then
		# Handle delete
		:
	else
		if test "$remote_oid" = "$zero"
		then
			# New branch, examine all commits
			range="$local_oid"
		else
			# Update to existing branch, examine new commits
			range="$remote_oid..$local_oid"
		fi

		# Check for WIP commit
		commit=$(git rev-list -n 1 --grep '^WIP' "$range")
		if test -n "$commit"
		then
			echo >&2 "Found WIP commit in $local_ref, not pushing"
			exit 1
		fi
	fi
done

exit 0
```

### .vscode/extensions.json
In VSCode workspace, recommends these extensions if not installed

```
{
  // See https://go.microsoft.com/fwlink/?LinkId=827846
  // for the documentation about the extensions.json format
  "recommendations": [
      "EditorConfig.EditorConfig",
      "ms-python.python",
      "ms-python.vscode-pylance",
      "amazonwebservices.aws-toolkit-vscode",
      "vscode-cfn-lint"
  ]
}

```

### .vscode/launch.json
Sets up multiple debuggers in VSCode

```
{
  // Use IntelliSense to learn about possible attributes.
  // Hover to view descriptions of existing attributes.
  // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Python: Remote Attach",
      "type": "python",
      "request": "attach",
      "connect": {
        "host": "localhost",
        "port": 5678
      },
      "pathMappings": [
        {
          "localRoot": "${workspaceFolder}",
          "remoteRoot": "."
        }
      ],
      "justMyCode": true
    },
    {
      "name": "Python: Current File",
      "type": "python",
      "request": "launch",
      "program": "${file}",
      "console": "integratedTerminal",
      "justMyCode": true
    },
  ]
}
```

### .vscode/settings.json
Setups workspace specific setting for VSCode

```
// Place your settings in this file to overwrite default and user settings.
{
  "[python]": {
      "editor.formatOnSave": true,
      "editor.codeActionsOnSave": {
          "source.organizeImports": true
      }
  },
  "python.linting.enabled": true,
  "python.formatting.provider": "black",
  "python.sortImports.args": ["--profile", "black"],
  "python.languageServer": "Pylance",
  "python.linting.pylintEnabled": false,
  "python.linting.flake8Enabled": true,
  "python.linting.flake8Args": [
      // Match what black does.
      "--max-line-length=88"
  ],
  "python.testing.pytestEnabled": true,
  "python.testing.unittestEnabled": true,
  "python.testing.pytestArgs": ["--no-cov"],
}
```

## Tools
### Tox
Used as an entrypoint for all other python tools

Configured in setup.cfg. Multiple environments based on runtime are setup and ran isolated.

Deps are installed only for testing and not used during build.


### Flake8

Linter that ensures python follows pep standards

To ignore specifc lines add ` # noqa: $CODE` to end of line
$Code is identifies what standard to ignore

To work with Black
- E501: line too long
- W503: Line break occurred before a binary operator
- E203: Whitespace before ':'
- D202 No blank lines allowed after function docstring
- W504 line break after binary operator

### Black

Autoformats python files adhearing to pep standards

To prevent from formatting a specific line add ` # fmt: skip

To prevent from formatting a block of code
```
 # fmt: off
 Code to ignore by black
 # fmt: on
```

To add both flake8 and black to same line ` # fmt: skip # noqa: E501`

### iSort

Organizes import statements at the top of the file

Uses the same profile as black

### pytest

Can execute both regualar unittest and pytest tests with fixtures

In order to import module that is located in src, we add a `.env` file with contents `PYTHONPATH=./src`

To add code coverage we install `pytest-cov` plugin. This generates a report and what functions do not have test

To generate a coverage report `pytest --cov=app tests/`

To skip a function/clause add to `setup.cfg` or `  # pragma: no cover`
```
exclude_lines =
    pragma: no cover
    def __repr__
    if __name__ == .__main__.
```


### cfn-lint
Lints CloudFormation and SAM Template [cfn-lint](https://github.com/aws-cloudformation/cfn-lint)
```
cfn-lint path/**/*.yaml
```

### shellcheck
Lints Shell code

To run `shellcheck **/*.sh`

Add `# shellcheck disable=$CODE` above line to ignore it

## Dev Setup

- Install pyenv to use muliple py versions at once
- Install shellcheck `brew install shellcheck`
- Install VSCode extensions

```
pip install -U pip wheel setuptools flake8 flake8-builtins flake8-comprehensions flake8-fixme flake8-functions-names flake8-print flake8-eradicate flake8-bugbear flake8-unused-arguments flake8-sfs flake8-annotations pytest pytest-cov black tox isort cfn-lint
code --install-extension EditorConfig.EditorConfig
code --install-extension ms-python.python
code --install-extension ms-python.vscode-pylance
code --install-extension amazonwebservices.aws-toolkit-vscode
code --install-extension kddejong.vscode-cfn-lint
code --install-extension timonwong.shellcheck
```
