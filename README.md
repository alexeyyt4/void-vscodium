# void-vscodium

[xbps-src](https://github.com/void-linux/void-packages) template for
[VSCodium](https://vscodium.com) on Void Linux (x86_64, glibc).

It repackages the official VSCodium Linux tarball (MIT licensed), so
nothing is compiled and the build takes about a minute. It is **not**
meant for the official void-packages tree, which only accepts packages
built from source.

## Build and install

```sh
git clone https://github.com/alexeyyt4/void-vscodium
cp -r void-vscodium/srcpkgs/codium /path/to/void-packages/srcpkgs/
cd /path/to/void-packages
./xbps-src pkg codium
sudo xbps-install -R hostdir/binpkgs codium
```

## Updating

```sh
./update.sh            # latest VSCodium release
./update.sh 1.2.3.45   # specific tag
```

The script rewrites `version=`, `checksum=` and `revision=` in the template.
A weekly GitHub Action (`.github/workflows/update.yml`) does the same and
opens a pull request.

## Notes

- Electron needs either unprivileged user namespaces or a setuid
  `chrome-sandbox`. If the window does not start with a sandbox error, check
  that first.
- If a runtime library is missing, add it to `depends=` in the template.
