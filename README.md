[![GitHub Release](https://img.shields.io/github/v/release/AlexanderWillner/kanbanview?sort=semver)](https://github.com/AlexanderWillner/KanbanView/releases)
[![GitHub Download Count](https://img.shields.io/github/downloads/AlexanderWillner/KanbanView/total.svg)](https://github.com/AlexanderWillner/KanbanView/releases)
[![GitHub Issues](https://img.shields.io/github/issues/alexanderwillner/kanbanview)](https://github.com/AlexanderWillner/KanbanView/issues)
[![Scrutinizer Code Quality](https://img.shields.io/scrutinizer/quality/g/alexanderwillner/kanbanview)](https://scrutinizer-ci.com/g/AlexanderWillner/KanbanView/?branch=master)

# CLI, API, Web Service and Kanban for Things 3

This repository contains a simple read-only CLI, API and Web Service for [Things3](http://culturedcode.com). It further includes an example web application to create a visual task-level overview (Kanban) of what is on your plate. Clone and contribute to the repository or download a [release](https://github.com/AlexanderWillner/KanbanView/releases).

![view2020](doc/view-2020.png)



## Commands

The available commands are listed by executing `make`:

```bash
$ make
CLI, API and Web Service for Things3.

Configuration:
 * Static Kanban : src/kanban-static.html
 * Dynamic Kanban: http://localhost:8088/kanban.html

Avaliable environment variables:
 * THINGSDB    - Path to database
 * TAG_WAITING - Tag for tasks you are waiting for
 * TAG_MIT     - Tag for most important tassk

Available commands:
 * run          - Run code in static mode.
 * run-server   - Run code in server mode.
 * open         - Open GUI in static mode.
 * open-server  - Open GUI in server mode.
 * kill-server  - Kill a running server.
 * app          - Create KanbanView App.
 * test         - Run unit tests and test coverage.
 * doc          - Document code (pydoc).
 * clean        - Cleanup (e.g. pyc files).
 * auto-style   - Automatially style code (autopep8).
 * code-style   - Check code style (pycodestyle).
 * code-lint    - Check code lints (pyflakes, pyline, flake8).
 * css-lint     - Check CSS styke lints (csslint).
 * js-lint      - Check JS code lints (jslint).
 * html-lint    - Check HTML file lints (tidy).
 * code-count   - Count code lines (cloc).
 * deps-install - Install dependencies (see requirements.txt).
 * deps-update  - Update dependencies (pur).
 * deps-create  - Create dependencies (pipreqs).
 * feedback     - Create a GitHub issue.
```



## Command Line Interface (CLI)

The CLI allows you to access the Things3 database via the comand line:

```bash
$ ./src/things3_cli.py today
 -  Today Todo  ( Today Project )
```

It is also possible to get the information formatted as ```json``` strings:

```bash
$ ./src/things3_cli.py --json inbox
[{"uuid": "29ACB795-2037-4FFD-BB09-851CDE53B4B9", "title": "Inbox Todo", "context": null, "context_uuid": null, "due": null}]
```

However, the CLI is only in a beginning state. The original ```bash``` based version can be found at [another GitHub repo](http://github.com/alexanderwillner/things.sh).



## Application Programmer Interface  (API)

The API allows you to access the Things3 database within other Python scripts:

```bash
$ make doc
...
class Things3(builtins.object)
     |  Things3()
     |  
     |  Simple read-only API for Things 3.
     |  
     |  Methods defined here:
     |  
     |  get_anytime(self)
     |      Get anytime tasks.
     |  
     |  get_inbox(self)
     |      Get all tasks from the inbox.
     |  

...
```



## Web Service

The web service allows you to access the Things3 database via a web service:

```bash
$ make run-server
Starting up...
Serving API at http://localhost:8088/api/{command}
```

Via ```curl``` you can browse the ```json``` data via command line:

```bash
$ curl http://localhost:8088/api/inbox
[{"uuid": "29ACB795-2037-4FFD-BB09-851CDE53B4B9", "title": "Inbox Todo", "context": null, "context_uuid": null, "due": null}]
```



## Kanban Application

The Kanban Application allows you to visualize the Things3 database following the Kanban approach. There are different implementations of the application available.

The **static** version creates a snapshot of the current status and writes an HTML file to ```src/kanban-static.html:

```bash
$ make run
```

The **dynamic** version runs a web application at http://localhost:8088/kanban.html and updates the GUI via JavaScript automatically using the **Web Service**:

```bash
$ make run-server
```

The **KanbanView.app** version encapsulates the **dynamic** version in a macOS bundle (alpha). Note: when you download the pre-compiled binary, as the App is not digitally signed, you need to execute the following command once, after you've copied it to the Applications folder:

```xattr -rd com.apple.quarantine /Applications/KanbanView.app```

