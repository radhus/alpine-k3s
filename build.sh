#!/bin/sh

set -e
set -x

sudo cp ${HOME}/.abuild/*.pub /etc/apk/keys/

cd "${HOME}/repo"
for pkg in *; do
    cd ${pkg}
    abuild -r -s "$(mktemp -d)"
    cd ..
done

tmpdir=$(mktemp -d)
cd "${tmpdir}"

outdir="${tmpdir}/out"
mkdir -p "${outdir}"

git clone /home/builder/aports
cd aports/scripts
ln -s "${HOME}/mkimg.k3s.sh" .

sh ./mkimage.sh \
    --tag "$(date +%y%m%d%H%M%S)" \
    --hostkeys \
    --outdir "${outdir}" \
    --profile k3s \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    --extra-repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --extra-repository "${HOME}/out/packages/repo"

cp -a ${outdir}/* "${HOME}/out/image/"
