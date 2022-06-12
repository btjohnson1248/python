.PHONY: all setup lint pytest test


all: test

test: setup lint pytest

setup:
	@echo Installing required tools for testing
	python3 -m pip install -U pip setuptools wheel tox cfn-lint

lint:
	@echo "------------------------------------------"
	@echo "--------------Linting Python--------------"
	@echo "------------------------------------------"
	tox -e flake8 -e black -e isort;

	@if [ $$? -ne 0 ]; \
    then \
        echo "" \
		echo "------------------------------------------" \
		echo "--------Linting failed for python---------" \
		echo "------------------------------------------" \
		exit $$?; \
    fi

	@echo "------------------------------------------"
	@echo "-----------Linting shell scripts----------"
	@echo "------------------------------------------"

	@echo "Linting shell scripts"
	# Add check to ensure it is installed
	shellcheck scripts/*.sh
	@if [ $$? -ne 0 ]; \
    then \
		echo "" \
        echo "------------------------------------------" \
		echo "-----Linting failed for shell scripts-----" \
		echo "------------------------------------------" \
        exit $$?; \
    fi

	# docker run --rm -v "$PWD:/mnt" koalaman/shellcheck:stable myscript
	@echo "------------------------------------------"
	@echo "----------Linting CloudFormation----------"
	@echo "------------------------------------------"

	@echo ""
	@echo "------------------------------------------"
	@echo "------------Succesfully Linted------------"
	@echo "------------------------------------------"

pytest:
	@echo ""
	@echo "------------------------------------------"
	@echo "------------Running pytest 3.9------------"
	@echo "------------------------------------------"
	@tox -e py39;
	@if [ $$? -ne 0 ]; \
    then \
        echo "" \
		echo "------------------------------------------" \
		echo "---------------Test failed----------------" \
		echo "------------------------------------------" \
        exit $$?; \
    fi
	@echo ""
	@echo "------------------------------------------"
	@echo "-------------All test passed--------------"
	@echo "------------------------------------------"
