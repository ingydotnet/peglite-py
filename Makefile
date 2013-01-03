#-----------------------------------------------------------------------------#
#
# Greetings!
#
# This Makefile was generated by `package`, the Python package package
# package. If you don't know what that means, that's OK. This Makefile is
# mostly for the "author" of this package. If you are not the author you can
# ignore this file, or you can use it to call the setup.py commands that you
# are used to:
#
# * make build
# * make test
# * sudo make install
#
# If you are the module author, you can run `make help` to see all the
# commands that are available to you.
#
# This Makefile currently assumes that, if you are the package author, you are
# on some kind of Unix based system.
#
# For more information on the Python package package package, `package`, visit
# the Python Package Index here:
#
#     http://pypi.python.org/pypi/package/
#
# Cheers!
#
#-----------------------------------------------------------------------------#

.PHONY: \
    help \
    setup \
    info \
    build \
    test \
    tests \
    devtest \
    install \
    register \
    sdist \
    clean \
    purge \
    upload \
 

# This variable is hardcoded into the Makefile by initial setup.
# If you move package-py, you need to change this.
PACKAGE_BASE = ../package-py

PYTHON = python


YOUR_PACKAGE = yourpackage/__init__.py

LAYOUT_FILES = \
	setup.py \
	README.rst \
	LICENSE \
	CHANGES.yaml \
	MANIFEST.in \

PACKAGE_FILES = \
	info.yaml \
	__init__.py \
	errors.py \
	unittest.py \

TESTS_FILES = \
	test_import.py \


SETUP_TARGETS = \
	Makefile \
	$(YOUR_PACKAGE) \
	$(LAYOUT_FILES) \
	$(PACKAGE_FILES) \
	$(TESTS_FILES) \

UPGRADE_TARGETS = \
	Makefile \
	setup.py \
	MANIFEST.in \
	__init__.py \
	errors.py \
	unittest.py \

ALL_TESTS = $(shell echo tests/*.py)
ALL_DEV_TESTS = $(shell echo dev-tests/*.py)

#-----------------------------------------------------------------------------#
# package-py targets
#-----------------------------------------------------------------------------#
help::
	@echo "This is the package (Python package package package) Makefile."
	@echo ""
	@echo "With this Makefile, you can use the following targets:"
	@echo ""
	@echo "* setup - Set up a new project with default (package-py) files"
	@echo "* info - Update package.info from package/info.yaml"
	@echo "* upgrade - Pull in updated files from package-py"
	@echo ""
	@echo "These targets are simply run by your setup.py:"
	@echo ""
	@echo "* build - Compile the Python modules"
	@echo "* test - Run the unittests"
	@echo "* devtest - Run the "developer only" tests"
	@echo "* register - Register this package to PyPi"
	@echo "* sdist - Create a dist bundle file"
	@echo "* upload - Create the dist bundle and upload it to PyPi"
	@echo "* clean - Remove the various generated files"

# This rule is disabled after initial setup.
setup:: _setup $(SETUP_TARGETS) _fixup _next

_setup::
	@if [ -e "package/base" ]; then echo "Don't `make setup` here!!!"; exit 1; fi
	@if [ -e "package" ]; then echo "Can't setup if 'package' directory exists."; exit 1; else mkdir package; fi
	@if [ ! -e "tests" ]; then mkdir tests; fi

info::
	$(PYTHON) $(PACKAGE_BASE)/bin/make_package_info.py

upgrade:: _upgrade $(UPGRADE_TARGETS) _fixup info

_upgrade::
	@if [ -e "Makefile.mk" ]; then \
	    echo "You can't `make upgrade` here!!!"; \
	    exit 1; \
	fi
	@if [ "$(MAKEFILE_LIST:%=%)" = "Makefile" ]; then \
	    echo 'Run this instead:'; \
	    echo; \
	    echo '    make -f $(PACKAGE_BASE)/Makefile.mk upgrade'; \
	    echo; \
	    exit 1; \
	fi

_fixup::
	$(PYTHON) $(PACKAGE_BASE)/bin/fix_makefile.py "$(PACKAGE_BASE)"

_next::
	@cat $(PACKAGE_BASE)/help/next.txt

Makefile::
	cp $(PACKAGE_BASE)/$@.mk $@

$(YOUR_PACKAGE)::
	mkdir yourpackage
	cp $(PACKAGE_BASE)/layout/$@ $@

$(PACKAGE_FILES)::
	cp $(PACKAGE_BASE)/layout/package/$@ package/$@

$(LAYOUT_FILES)::
	if [ ! -e $@ ]; then cp $(PACKAGE_BASE)/layout/$@ $@; fi

$(TESTS_FILES)::
	if [ ! -e tests/$@ ]; then cp $(PACKAGE_BASE)/layout/tests/$@ tests/$@; fi


#-----------------------------------------------------------------------------#
# setup.py targets
#-----------------------------------------------------------------------------#
register:: info

build test devtest install register sdist clean::
	$(PYTHON) setup.py $@

upload:: clean register
	$(PYTHON) setup.py sdist $@

tests:: $(ALL_TESTS)

$(ALL_TESTS) $(ALL_DEV_TESTS):
	@$(PYTHON) -c 'print " Running test: $@ ".center(70, "-") + "\n"'
	@PYTHONPATH=. $(PYTHON) $@

clean::
	find . -name '*.pyc' | xargs rm
	rm -fr build dist MANIFEST *.egg-info

purge:: clean
