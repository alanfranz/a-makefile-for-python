

# verify no tabs 
gfind SRC_ROOT -name '*.py' | xargs grep $'\t'

test: devenv Makefile
	source devenv/bin/activate && python devenv/bin/unit discover -v
	$(FIND) SRC_ROOT -type f -name '*.py' | { ! xargs grep -H $$'\t' ; } || { echo 'found tabs in some py file' ; exit 1 ; }

