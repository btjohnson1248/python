.PHONY: setup lint test docs

test: setup lint test

VSCODE_INSTALLED := $(shell command -v code 2> /dev/null)
PYENV_ENV := $(shell grep '^PYTHONPATH' .env)
export PYTHONPATH=./src

setup:
	@echo Creating virtual env - .venv
	python3 -m venv .venv

	@echo Installing dev packages into virtual env
	.venv/bin/python -m pip install -U pip install -U -r dev-requirements.txt

	@echo Updating pre-commit hooks
	.venv/bin/python -m pre_commit install
	.venv/bin/python -m pre_commit autoupdate

ifdef VSCODE_INSTALLED
	echo VSCode is installed, installing extensions
	code --install-extension EditorConfig.EditorConfig
	code --install-extension ms-python.python
	code --install-extension ms-python.vscode-pylance
	code --install-extension amazonwebservices.aws-toolkit-vscode
	code --install-extension kddejong.vscode-cfn-lint
	code --install-extension timonwong.shellcheck
endif

# If .env contains PYTHONPATH entry skip, otherwise append it
ifeq ($(PYENV_ENV),)
	@echo Adding PYHTONPATH to .env
	@echo PYTHONPATH=./src >> .env
endif

	@echo Run "source .venv/bin/activate" to activate virtual environment


lint:
	@echo Linting all files
	pre-commit run --all

black:
	@echo Formatting code with black
	black --config=pyproject.toml src

isort:
	@echo Formatting imports
	isort src

test: lint
	@tox -e py38

docs:
	@echo generatic docs
	.venv/bin/python -m mkdocs build
