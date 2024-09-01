# rocky
Running podman within a container

Based on: https://www.redhat.com/sysadmin/podman-inside-container

## Step 1: Create a privileged container

```bash
podman run -it --hostname rocky -p 80:80 --name rocky --privileged rockylinux:9 /bin/bash
```

## Step 2: Setup fuse-overlayfs and container permissions

```bash
curl https://raw.githubusercontent.com/chrisvarga/rocky/main/podman.sh | sh
```

And voila, you can now run podman within a container.
