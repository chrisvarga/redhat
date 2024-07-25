#!/bin/bash
dnf -y update; yum -y reinstall shadow-utils; \
yum -y install podman fuse-overlayfs --exclude container-selinux; \
rm -rf /var/cache /var/log/dnf* /var/log/yum.*

useradd podman; \
echo podman:10000:5000 > /etc/subuid; \
echo podman:10000:5000 > /etc/subgid;

curl https://raw.githubusercontent.com/containers/common/main/pkg/config/containers.conf > /etc/containers/containers.conf
mkdir -p /home/podman/.config/containers
curl https://raw.githubusercontent.com/containers/common/main/pkg/config/containers.conf  > /home/podman/.config/containers/containers.conf

chown podman:podman -R /home/podman

chmod 644 /etc/containers/containers.conf; sed -i -e 's|^#mount_program|mount_program|g' -e '/additionalimage.*/a "/var/lib/shared",' -e 's|^mountopt[[:space:]]*=.*$|mountopt = "nodev,fsync=0"|g' /etc/containers/storage.conf

mkdir -p /var/lib/shared/overlay-images /var/lib/shared/overlay-layers /var/lib/shared/vfs-images /var/lib/shared/vfs-layers; touch /var/lib/shared/overlay-images/images.lock; touch /var/lib/shared/overlay-layers/layers.lock; touch /var/lib/shared/vfs-images/images.lock; touch /var/lib/shared/vfs-layers/layers.lock

_CONTAINERS_USERNS_CONFIGURED=""
