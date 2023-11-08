init: _init-pip _init-hooks

_init-pip:
  python3 -m pip install cwltool==3.1.20230213100550 jinja-cli

_init-hooks:
  python3 -m pip install --upgrade pre-commit
  pre-commit install

# Builds individual workflow
build WORKFLOW:
    docker build . \
    -f ./{{WORKFLOW}}/Dockerfile \
    --build-arg WORKFLOW={{WORKFLOW}} \
    -t {{WORKFLOW}}:latest

# Builds Docker for WORKFLOW and prints packed JSON
pack WORKFLOW:
    just build {{WORKFLOW}}
    docker run {{WORKFLOW}}:latest pack

# Builds all docker images for each directory with a justfile
build-all:
    #!/bin/bash
    for dir in `ls .`; do
        if [ -d "${dir}" ]; then
            if [ -f "${dir}"/justfile ]; then
                just build "${dir}";
            fi
        fi
    done

