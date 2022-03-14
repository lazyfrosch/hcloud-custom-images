#!/bin/bash

set -ex

if hcloud server ip image-base &>/dev/null; then
  hcloud server delete image-base
fi

hcloud server create \
    --start-after-create=false \
    --image debian-11 \
    --location nbg1 \
    --type cx21 \
    --volume images \
    --name image-base

hcloud server poweroff image-base

hcloud server enable-rescue --ssh-key "Markus Frosch <markus@lazyfrosch.de>" image-base

hcloud server poweron image-base

ip="$(hcloud server ip image-base)"

ssh-keygen -R "$ip"

#sleep 10

echo
echo Now you can:
echo hcloud server ssh image-base
