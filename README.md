# Notes and code / command lines snippets and other stuff

This repo contains my technical notes.

It is available at https:// sjpp.github.io/notes

## Test Build with podman (tested under Fedora)

`cd` to repo root:

	podman run --rm -it -p 8000:8000 -v ${PWD}:/docs:Z squidfunk/mkdocs-material:latest

to start devel server and display site at http://localhost:8000

To build the doc

	podman run --rm -it -v ${PWD}:/docs:Z squidfunk/mkdocs-material:latest build

## Automatically build and deploy on Github

Edit `.github/workflows/main.yml` file and add:

```
name: build
on:
  push:
    branches:
      - main
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-python@v2
        with:
          python-version: 3.x
      - run: pip install mkdocs mkdocs-material
      - run: mkdocs gh-deploy --force --clean --verbose
```
