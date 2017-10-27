

# verify no tabs 
gfind SRC_ROOT -name '*.py' | xargs grep $'\t'

# OSX / Linux
FIND := $(shell which gfind || which find)

devenv: setup.py requirements.txt
	test -r devenv/bin/activate || $(VIRTUALENV) devenv || rm -rf devenv
	touch -t 197001011200 devenv
	source devenv/bin/activate && python devenv/bin/pip install -r requirements.txt && python devenv/bin/pip install --editable . --no-deps && python devenv/bin/pip check
	touch devenv

test: devenv Makefile
	source devenv/bin/activate && python devenv/bin/unit discover -v
	$(FIND) SRC_ROOT -type f -name '*.py' | { ! xargs grep -H $$'\t' ; } || { echo 'found tabs in some py file' ; exit 1 ; }

