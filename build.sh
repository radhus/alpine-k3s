#!/bin/sh

set -e
set -x

sudo cp ${HOME}/.abuild/*.pub /etc/apk/keys/

tmpdir=$(mktemp -d)
cd "${tmpdir}"

outdir="${tmpdir}/out"
mkdir -p "${outdir}"

git clone /home/builder/aports
cd aports/scripts
ln -s "${HOME}/mkimg.k3s.sh" .

sh ./mkimage.sh \
    --hostkeys \
    --outdir "${outdir}" \
    --profile k3s \
    --repository http://dl-cdn.alpinelinux.org/alpine/v3.11/main \
    --extra-repository http://dl-cdn.alpinelinux.org/alpine/v3.11/community \
    --extra-repository "${HOME}/out/packages/repo"

cp -a ${outdir}/* "${HOME}/out/image/"
