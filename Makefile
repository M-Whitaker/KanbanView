MAIN=things3_kanban.py
SERVER=things3_api.py
SERVER_PORT=8088
SRC_CORE=src
SRC_TEST=tests
DEST=$(SRC_CORE)/kanban-static.html
DEST_SRV=http://localhost:$(SERVER_PORT)/kanban.html
PYTHON=python3
PYDOC=pydoc3
PIP=pip3

help:
	@echo "CLI, API and Web Service for Things3."
	@echo ""
	@echo "Configuration:"
	@echo " * Static Kanban : $(DEST)"
	@echo " * Dynamic Kanban: $(DEST_SRV)"
	@echo ""
	@echo "Avaliable environment variables:"
	@echo " * THINGSDB    - Path to database"
	@echo " * TAG_WAITING - Tag for tasks you are waiting for"
	@echo " * TAG_MIT     - Tag for most important tassk"
	@echo ""
	@echo "Available commands:"
	@echo " * run          - Run code in static mode."
	@echo " * run-server   - Run code in server mode."
	@echo " * open         - Open GUI in static mode."
	@echo " * open-server  - Open GUI in server mode."
	@echo " * kill-server  - Kill a running server."
	@echo " * app          - Create KanbanView App."
	@echo " * test         - Run unit tests and test coverage."
	@echo " * doc          - Document code (pydoc)."
	@echo " * clean        - Cleanup (e.g. pyc files)."
	@echo " * auto-style   - Automatially style code (autopep8)."
	@echo " * code-style   - Check code style (pycodestyle)."
	@echo " * code-lint    - Check code lints (pyflakes, pyline, flake8)."
	@echo " * css-lint     - Check CSS styke lints (csslint)."
	@echo " * js-lint      - Check JS code lints (jslint)."
	@echo " * html-lint    - Check HTML file lints (tidy)."
	@echo " * code-count   - Count code lines (cloc)."
	@echo " * deps-install - Install dependencies (see requirements.txt)."
	@echo " * deps-update  - Update dependencies (pur)."
	@echo " * deps-create  - Create dependencies (pipreqs)."
	@echo " * feedback     - Create a GitHub issue."

run:
	@$(PYTHON) $(SRC_CORE)/$(MAIN)
	@open $(DEST)

run-server:
	@(sleep 3 ; open "$(DEST_SRV)") &
	@$(PYTHON) $(SRC_CORE)/$(SERVER)

kill-server:
	@lsof -nti:$(SERVER_PORT) | xargs kill

open-server:
	@open $(DEST_SRV)

test:
	@type coverage >/dev/null 2>&1 || (echo "Run 'pip install coverage' first." >&2 ; exit 1)
	@coverage run --source . -m $(SRC_TEST).test_things3 || true
	@coverage report

.PHONY: app
app: clean
	@$(PYTHON) setup.py py2app -s --iconfile 'resources/icon.icns'
	@xattr -cr dist/KanbanView.app || true
	@hdiutil create dist/tmp.dmg -ov -volname "KanbanView" -fs HFS+ -srcfolder "dist"
	@hdiutil convert dist/tmp.dmg -format UDZO -o dist/KanbanView.dmg
	@rm dist/tmp.dmg
	@open dist

.PHONY: doc
doc:
	@$(PYDOC) src.things3

.PHONY: open
open:
	@open $(DEST)

.PHONY: clean
clean:
	@rm -f $(DEST)
	@rm -f $(SRC_CORE)/*.pyc
	@rm -rf build dist *.egg-info

auto-style:
	@type autopep8 >/dev/null 2>&1 || (echo "Run '$(PIP) install autopep8' first." >&2 ; exit 1)
	@autopep8 -i -r $(SRC_CORE)

lint: code-style code-lint css-lint js-lint html-lint

code-style:
	@type pycodestyle >/dev/null 2>&1 || (echo "Run '$(PIP) install pycodestyle' first." >&2 ; exit 1)
	@pycodestyle --max-line-length=80 $(SRC_CORE)

code-lint:
	@type pyflakes >/dev/null 2>&1 || (echo "Run '$(PIP) install pyflakes' first." >&2 ; exit 1)
	@type pylint >/dev/null 2>&1 || (echo "Run '$(PIP) install pylint' first." >&2 ; exit 1)
	@type flake8 >/dev/null 2>&1 || (echo "Run '$(PIP) install flake8' first." >&2 ; exit 1)
	@echo "PyFlakes:" ; pyflakes $(SRC_CORE) || true
	@echo "Flake8:" ; flake8 --max-complexity 10 $(SRC_CORE) || true
	@echo "PyLint:" ; pylint $(SRC_CORE)/*.py || true

css-lint:
	@type csslint >/dev/null 2>&1 || (echo "Run 'npm install -g csslint' first." >&2 ; exit 1)
	@csslint --format=compact resources/*.css

js-lint:
	@type jslint >/dev/null 2>&1 || (echo "Run 'npm install -g jslint' first." >&2 ; exit 1)
	@jslint resources/*.js

html-lint:
	@type tidy >/dev/null 2>&1 || (echo "Run 'brew install tidy' first." >&2 ; exit 1)
	@tidy -qe resources/*.html

code-count:
	@type cloc >/dev/null 2>&1 || (echo "Run 'brew install cloc' first." >&2 ; exit 1)
	@cloc $(SRC_CORE)

deps-update:
	@type pur >/dev/null 2>&1 || (echo "Run '$(PIP) install pur' first." >&2 ; exit 1)
	@pur -r requirements.txt

deps-install:
	@type $(PIP) >/dev/null 2>&1 || (echo "Run 'curl https://bootstrap.pypa.io/get-pip.py|sudo python3' first." >&2 ; exit 1)
	@$(PIP) install -r requirements.txt

deps-create:
	@type pipreqs >/dev/null 2>&1 || (echo "Run '$(PIP) install pipreqs' first." >&2 ; exit 1)
	@pipreqs --use-local --force .

feedback:
	@open https://github.com/AlexanderWillner/KanbanView/issues
