#!/usr/bin/env bash
# Installs the op shim as ~/.local/bin/op (symlink) and prepares ~/.op_shim.
set -euo pipefail

here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
bin_dir="${OP_SHIM_BIN_DIR:-$HOME/.local/bin}"
shim_dir="${OP_SHIM_DIR:-$HOME/.op_shim}"

command -v op >/dev/null 2>&1 || { echo "❌ real 1Password CLI not found: brew install 1password-cli" >&2; exit 1; }

mkdir -p "$bin_dir" "$shim_dir"
chmod 700 "$shim_dir"
ln -sfn "$here/op" "$bin_dir/op"
echo "✅ linked $bin_dir/op -> $here/op"
echo "✅ cache dir $shim_dir"

resolved=$(command -v op)
if [ "$resolved" != "$bin_dir/op" ]; then
    echo "⚠️  'op' still resolves to $resolved in this shell." >&2
    echo "   Put $bin_dir before it in PATH, e.g. add to your shell rc:" >&2
    echo "   export PATH=\"$bin_dir:\$PATH\"" >&2
    exit 1
fi
echo "✅ 'op' now resolves to the shim ($("$bin_dir/op" shim real) is the real CLI)"
