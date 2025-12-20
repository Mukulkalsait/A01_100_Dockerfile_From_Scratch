
import os
import logging
from datetime import datetime
from fastapi import FastAPI, Request

app = FastAPI(title="k8s-echo-python")

LOG_DIR = "/app/logs" if os.path.exists("/app") else "/tmp"
os.makedirs(LOG_DIR, exist_ok=True)

logging.basicConfig(
    filename=f"{LOG_DIR}/application.log",
    level=logging.INFO,
    format="%(asctime)s | %(levelname)s | %(message)s"
)
logger = logging.getLogger(__name__)

def pod_info():
    return {
        "pod_name": os.getenv("POD_NAME"),
        "namespace": os.getenv("POD_NAMESPACE"),
        "pod_ip": os.getenv("POD_IP"),
        "node_name": os.getenv("NODE_NAME"),
        "hostname": os.getenv("HOSTNAME"),
    }

@app.get("/")
async def root(request: Request):
    logger.info("Root endpoint hit")
    return {
        "message": "Echo Home",
        "datetime": datetime.utcnow().isoformat(),
        "request": {
            "method": request.method,
            "url": str(request.url),
            "client": request.client.host if request.client else None,
            "headers": dict(request.headers),
        },
        "pod": pod_info(),
        "status_code": 200,
    }

@app.get("/health_check")
def health_check():
    return {"status": "ok"}

@app.get("/system_info")
def system_info():
    return {
        "python_version": os.sys.version,
        "pid": os.getpid(),
        "cwd": os.getcwd(),
        "datetime": datetime.utcnow().isoformat(),
        "pod": pod_info(),
    }


#Y:  Deployment needed ENVS: 
#  -----------------------
# env:
    # - name: POD_NAME
    # valueFrom:
    #     fieldRef:
    #     fieldPath: metadata.name
    # -----------------------
    # - name: POD_NAMESPACE
    # valueFrom:
    #     fieldRef:
    #     fieldPath: metadata.namespace
    # -----------------------
    # - name: POD_IP
    # valueFrom:
    #     fieldRef:
    #     fieldPath: status.podIP
    # -----------------------
    # - name: NODE_NAME
    # valueFrom:
    #     fieldRef:
    #     fieldPath: spec.nodeName
    #
