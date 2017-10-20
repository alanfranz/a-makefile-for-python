

# verify no tabs 
gfind SRC_ROOT -name '*.py' | xargs grep $'\t'

