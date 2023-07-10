set shell := ['bash', '-ceuo', 'pipefail']

yardl_branch := "main"

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

install-python-dependencies:
    pip install numpy

init: install-yardl install-watchexec install-python-dependencies


