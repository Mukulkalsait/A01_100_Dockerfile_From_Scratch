
### Best & Fastest Path Forward (Recommended)
Use the **host's Podman** via its socket. The CLI inside Jenkins will talk to the already-working Podman on the host. This is the standard, stable approach for Jenkins + Podman.

## Error-1
- The socket (`/run/user/$(id -u)/podman/podman.sock` or similar) is usually owned by your host user (and mode 600/700).
- The `jenkins` user (UID 1000 inside the container) can't read it.

#### Step 1: Fix Socket Permissions on the Host (One-time)
On your **host** (server1), run these commands as your normal user (the one that runs Podman):

```bash
# Make sure the user socket is active
systemctl --user enable --now podman.socket

# Check the exact socket path and ownership
ls -lZ /run/user/$(id -u)/podman/podman.sock
podman info | grep -E 'socket|remote|rootless'
```

To allow the Jenkins user (UID 1000) to access it without making it world-readable (reasonably secure):

```bash
# Option A: Add read permission for others (quickest, common for this use case)
chmod 666 /run/user/$(id -u)/podman/podman.sock

# Option B: Better — make a group (if you want to avoid 666)
# sudo groupadd -g 1000 podman-jenkins   # if gid 1000 not taken
# sudo usermod -aG podman-jenkins $(whoami)
# chgrp podman-jenkins /run/user/$(id -u)/podman/podman.sock
# chmod 660 /run/user/$(id -u)/podman/podman.sock
```

**Note**: The socket permissions reset on reboot or when the socket restarts. You can make this persistent with a systemd tmpfiles snippet or a small script, but start with `chmod 666` for testing.

#### Step 2: Restart Jenkins with Correct Mount + Env
Stop and remove the old container, then run this (use the exact socket path from the `ls` command above):

```bash
podman stop jenkins && podman rm jenkins

podman run -d --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /run/user/$(id -u)/podman/podman.sock:/run/podman/podman.sock \
  -e CONTAINER_HOST=unix:///run/podman/podman.sock \
  --security-opt label=disable \
  jenkins-with-podman:latest
```

If the socket path on your host is `/run/podman/podman.sock` (rootful Podman), use that instead.

#### Step 3: Test Inside the Container
```bash
podman exec -it jenkins bash
podman --version
podman info          # This should now show host info without permission denied
podman ps -a
```

If it still says permission denied on the socket, also try mounting it as Docker-compatible (many pipelines prefer this):

```bash
-v /run/user/$(id -u)/podman/podman.sock:/var/run/docker.sock \
-e DOCKER_HOST=unix:///var/run/docker.sock
```

Then inside the container you can use `docker build`, `docker push`, etc., and Podman will handle it via its Docker API compatibility.

### Alternative: Don't Run Jenkins in a Container at All (Simplest if This Still Fails)
Since the Jenkins container is only for building Podman images on the **same server**, this might be the least painful option now:

1. Install Jenkins directly on the host (as a service or via podman but run it rootless as your normal user).
2. Or even simpler: Run Jenkins as your normal host user (the one that already has working Podman).
3. Give the jenkins user on host access to Podman (add to the right group or just run as your user).

This completely avoids container-in-container problems and permission drama.

**Quick host install example** (if you want to go this route):
```bash
# On host
sudo apt update && sudo apt install -y jenkins   # or follow official Jenkins repo
# Then configure Jenkins to run as your normal user or add your user to jenkins group
```

### Once Podman Works from Jenkins
We'll set up **SSH credentials** properly in Jenkins (no more mounting `.ssh` folder and fighting permissions). It's much cleaner:
- Go to Jenkins → Manage Credentials → Add → "SSH Username with private key"
- Use it in pipelines with the `sshagent` step.

Let me know the output of these two commands from the **host** right now:

```bash
ls -lZ /run/user/$(id -u)/podman/podman.sock
podman info | grep -E 'socket|remote'
```

And tell me if you want to:
- Stick with fixing the socket mount, or
- Switch to running Jenkins directly on the host.

We'll get you unblocked today.
