
Good, this is **exactly the right time** to learn this properly 👍
I’ll do this in **two parts**:

1. **How to run *your* `podman-compose.yml` (step-by-step)**
2. **All essential `docker-compose / podman-compose` usage you *must* know** (from basics → pro habits)

I’ll assume you’re on **Linux with Podman** (which you are).

---

# PART 1 — How to run your `podman-compose.yml`

## 1️⃣ Save the file correctly

By default, compose tools look for **`docker-compose.yml`** or **`compose.yml`**.

👉 **Rename your file** (recommended):

```bash
mv podman-compose.yml docker-compose.yml
```

> Podman **does NOT require** a special filename.

---

## 2️⃣ Make sure the image exists

Your compose file uses:

```yaml
image: fastapi_001:1.5
```

Verify:

```bash
podman images
```

If it does **not** exist, build it first:

```bash
podman build -t fastapi_001:1.5 .
```

---

## 3️⃣ Run the stack (foreground)

```bash
podman-compose up
```

You should see logs from Uvicorn immediately.

Access:

```
http://localhost:8000
```

---

## 4️⃣ Run in background (detached)

```bash
podman-compose up -d
```

---

## 5️⃣ Check running containers

```bash
podman ps
```

or

```bash
podman-compose ps
```

---

## 6️⃣ View logs

```bash
podman-compose logs
```

Follow logs:

```bash
podman-compose logs -f
```

Specific service:

```bash
podman-compose logs fastapi
```

---

## 7️⃣ Stop everything

```bash
podman-compose down
```

This stops containers **but keeps volumes**.

---

## 8️⃣ Remove EVERYTHING (containers + volumes)

```bash
podman-compose down -v
```

---

# PART 2 — Compose fundamentals (Docker & Podman)

Everything below works **almost identically** for:

* `docker compose`
* `docker-compose`
* `podman-compose`

---

## 🔹 Core Commands (MUST KNOW)

### Start services

```bash
podman-compose up
```

### Start detached

```bash
podman-compose up -d
```

### Stop services

```bash
podman-compose stop
```

### Stop + remove containers

```bash
podman-compose down
```

### Restart

```bash
podman-compose restart
```

---

## 🔹 Build images from compose

If your service has:

```yaml
build: .
```

Then:

```bash
podman-compose build
```

or

```bash
podman-compose up --build
```

---

## 🔹 Execute commands inside container

```bash
podman-compose exec fastapi sh
```

or

```bash
podman-compose exec fastapi bash
```

---

## 🔹 Scaling (multiple instances)

```bash
podman-compose up --scale fastapi=3
```

⚠️ **Port mapping must be removed** when scaling.

---

## 🔹 Environment variables

### Inline:

```yaml
environment:
  - ENV=production
```

### From file:

```yaml
env_file:
  - .env
```

---

## 🔹 Volumes (what you already used 👍)

### Named volume (persistent)

```yaml
volumes:
  - logs:/app/logs
```

Inspect:

```bash
podman volume ls
podman volume inspect logs
```

---

## 🔹 Networks (why your setup is good)

```yaml
networks:
  - fastapi-network
```

This allows:

```bash
curl http://fastapi:8000
```

from another container on same network.

Inspect:

```bash
podman network ls
```

---

## 🔹 Service dependency order

```yaml
depends_on:
  - db
```

⚠️ Only controls **startup order**, not readiness.

---

## 🔹 Override files (VERY PRO)

Use:

```bash
docker-compose.override.yml
```

Example:

```yaml
services:
  fastapi:
    environment:
      - DEBUG=true
```

Compose automatically merges it.

---

## 🔹 Clean up (important habit)

Remove stopped containers:

```bash
podman container prune
```

Remove unused volumes:

```bash
podman volume prune
```

Remove unused networks:

```bash
podman network prune
```

---

## 🔹 Podman-specific tips (important)

### Rootless mode (default)

* No sudo
* Ports <1024 not allowed
* Better security

### Podman generates systemd

```bash
podman generate systemd --new --name fastapi
```

---

## 🔹 Docker vs Podman Compose (interview question)

| Feature           | Docker   | Podman |
| ----------------- | -------- | ------ |
| Rootless          | ❌        | ✅      |
| Daemon            | Required | ❌      |
| Systemd native    | ❌        | ✅      |
| CLI compatibility | ✅        | ~95%   |

---

# 🔥 Your next logical step (based on your level)

I recommend you do **this next**:

1. Add **PostgreSQL** service
2. Add **depends_on**
3. Use `.env`
4. Add **healthcheck**
5. Convert to **production-ready stack**

If you want, I can:

* Upgrade **this compose file to production-grade**
* Explain **healthchecks**
* Show **Docker vs Podman pitfalls**
* Help you prepare **DevOps interview questions**

Just tell me what you want next 🚀
