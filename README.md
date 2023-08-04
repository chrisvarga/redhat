# redhat
Running podman within a container

Based on: https://www.redhat.com/sysadmin/podman-inside-container

First, get the Red Hat universal base image.


>**Note**: You must use `--privileged` during the initial run command; there is no way to do this after container creation.

>**Note**: You can also run this exact command with `docker` if you are using that instead.

```bash
podman run -it --hostname redhat --name redhat --privileged redhat/ubi9 /bin/bash
```

>**Note**: If you would like to use Fedora instead of Red Hat, this will work exactly the same using the fedora image:
```bash
podman run -it --hostname fedora --name fedora --privileged fedora:latest /bin/bash
```

Then, run this script to setup fuse and permissions in order to run podman within a container:

```bash
curl https://raw.githubusercontent.com/chrisvarga/redhat/main/podman.sh | sh
```

You can also manually create the script with the following contents:

>**Note**: Red Hat does not have "vim" only "vi"

```bash
vi podman.sh
```

And paste these contents:
```bash
#!/bin/bash
dnf -y update; yum -y reinstall shadow-utils; \
yum -y install podman fuse-overlayfs --exclude container-selinux; \
rm -rf /var/cache /var/log/dnf* /var/log/yum.*

useradd podman; \
echo podman:10000:5000 > /etc/subuid; \
echo podman:10000:5000 > /etc/subgid;

curl https://raw.githubusercontent.com/containers/libpod/master/contrib/podmanimage/stable/containers.conf > /etc/containers/containers.conf
mkdir -p /home/podman/.config/containers
curl https://raw.githubusercontent.com/containers/libpod/master/contrib/podmanimage/stable/podman-containers.conf > /home/podman/.config/containers/containers.conf

chown podman:podman -R /home/podman

chmod 644 /etc/containers/containers.conf; sed -i -e 's|^#mount_program|mount_program|g' -e '/additionalimage.*/a "/var/lib/shared",' -e 's|^mountopt[[:space:]]*=.*$|mountopt = "nodev,fsync=0"|g' /etc/containers/storage.conf

mkdir -p /var/lib/shared/overlay-images /var/lib/shared/overlay-layers /var/lib/shared/vfs-images /var/lib/shared/vfs-layers; touch /var/lib/shared/overlay-images/images.lock; touch /var/lib/shared/overlay-layers/layers.lock; touch /var/lib/shared/vfs-images/images.lock; touch /var/lib/shared/vfs-layers/layers.lock

_CONTAINERS_USERNS_CONFIGURED=""
```

Run the script, and voila, you can now run podman within a container.
