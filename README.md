## Notes and code / command lines snippets

This repo contains my technical notes.

It is available at https://sjpp.github.io/notes

## Deploy with podman (tested under Fedora)

`cd` to repo root:

	podman run --rm -it -p 8000:8000 -v ${PWD}:/docs:Z squidfunk/mkdocs-material:latest

to start devel server and display site at http://localhost:8000

To build the doc

	podman run --rm -it -v ${PWD}:/docs:Z squidfunk/mkdocs-material:latest build

Deploy on Github Pages:

	podman run --rm -it -v ~/.ssh:/root/.ssh:Z -v ${PWD}:/docs:Z squidfunk/mkdocs-material:latest gh-deploy
