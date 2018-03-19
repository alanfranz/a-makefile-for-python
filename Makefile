

# verify no tabs 
gfind SRC_ROOT -name '*.py' | xargs grep $'\t'

# OSX / Linux
FIND := $(shell which gfind || which find)


devenv: setup.py requirements.txt
	# if we're unable to create the devenv completely, remove it.
	test -r devenv/bin/activate || $(VIRTUALENV) devenv || rm -rf devenv
	# set the devenv to a very old date, so if the next step fails because requirements/setup has errors, re-executing makefile will re-execute this target.
	touch -t 197001011200 devenv

	source devenv/bin/activate && python devenv/bin/pip install -r requirements.txt && python devenv/bin/pip install --editable . --no-deps && python devenv/bin/pip check
	touch devenv

freeze: distclean devenv
	source devenv/bin/activate && python devenv/bin/pip freeze | grep -v "docker-rpm-builder" > requirements.txt

upgrade: devenv
       source devenv/bin/activate && python devenv/bin/pip install --editable . --upgrade

test: devenv
	source devenv/bin/activate && python devenv/bin/unit discover -v
	$(FIND) SRC_ROOT -type f -name '*.py' | { ! xargs grep -H $$'\t' ; } || { echo 'found tabs in some py file' ; exit 1 ; }


clean:
	rm -rf tmp build dist test-reports 
	$(FIND) -name *.pyo -o -name *.pyc -delete

distclean: clean
	rm -rf devenv *.egg-info

