#!/bin/sh
# Bump srcpkgs/codium/template to the latest VSCodium release (or to $1).
# Needs: curl, jq, sha256sum, GNU sed.
set -eu
cd "$(dirname "$0")"

tpl=srcpkgs/codium/template
cur=$(sed -n 's/^version=//p' "$tpl")
new=${1:-$(curl -fsSL https://api.github.com/repos/VSCodium/vscodium/releases/latest | jq -r .tag_name)}

if [ -z "$new" ] || [ "$new" = null ]; then
	echo "cannot determine latest version" >&2
	exit 1
fi
if [ "$new" = "$cur" ]; then
	echo "already at $cur"
	exit 0
fi

url="https://github.com/VSCodium/vscodium/releases/download/${new}/VSCodium-linux-x64-${new}.tar.gz"
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
curl -fSL -o "$tmp" "$url"
sum=$(sha256sum "$tmp" | cut -d' ' -f1)

sed -i \
	-e "s/^version=.*/version=${new}/" \
	-e "s/^checksum=.*/checksum=${sum}/" \
	-e "s/^revision=.*/revision=1/" \
	"$tpl"
echo "$cur -> $new"
