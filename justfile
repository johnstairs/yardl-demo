set shell := ['bash', '-ceuo', 'pipefail']

yardl_branch := "johnstairs/python-experiments"

@default:

install-yardl:
    #!/usr/bin/env bash
    
    temp_dir="$(mktemp -d)"
    trap 'rm -rf -- "$temp_dir"' EXIT

    git clone -b {{ yardl_branch }} https://github.com/microsoft/yardl.git "$temp_dir"

    cd $temp_dir
    just install

install-watchexec:
    #!/usr/bin/env bash
    watchexec_version="1.22.3"
    wget --quiet https://github.com/watchexec/watchexec/releases/download/v${watchexec_version}/watchexec-${watchexec_version}-x86_64-unknown-linux-musl.deb -O /tmp/watchexec.deb && sudo dpkg -i /tmp/watchexec.deb

@install-python-dependencies:
    pip install numpy

setup-completions:
    #!/usr/bin/env bash
    sudo apt update
    sudo apt-get install bash-completion -y
    just --completions bash | sudo tee /etc/bash_completion.d/just > /dev/null
    yardl completion bash | sudo tee /etc/bash_completion.d/yardl > /dev/null

@init: install-yardl install-watchexec install-python-dependencies setup-completions

@watch:
    watchexec -c -e py --workdir python -i **/__pycache__/** --on-busy-update do-nothing --no-project-ignore -- python run_demo.py