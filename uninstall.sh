#!/usr/bin/env bash
set -euo pipefail
bin_dir="${OP_SHIM_BIN_DIR:-$HOME/.local/bin}"
[ -L "$bin_dir/op" ] && rm "$bin_dir/op" && echo "removed $bin_dir/op"
echo "cache left in place at ${OP_SHIM_DIR:-$HOME/.op_shim} (rm -rf it to wipe secrets)"
