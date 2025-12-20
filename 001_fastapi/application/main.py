import os 
import logging
from fastapi import FastAPI, Request
from datetime import datetime

app = FastAPI(title = "image-fastapi") # object

LOG_DIR = "/app/logs" if os.path.exists("/app") else "/home/mukuldk/Documents/"
os.makedirs(LOG_DIR,exist_ok=True)

logger = logging.getLogger(__name__)

logging.basicConfig(
    filename = f"{LOG_DIR}/application.log",
    level = logging.INFO,
    format = "%(asctime)s | %(levelname)s | %(message)s "
)

def pod_info():
    return {
        "pod" : os.getenv("POD_NAME"),
        "namespace": os.getenv("NAMESPACE"),
        "pod-ip": os.getenv("POD_ID"),
        "node-name": os.getenv("NODE_NAME"),
        "hostname": os.getenv("HOSTNAME"),
    }

@app.get("/")
async def root(request:Request):
    logger.info("Home Url Triggered.")
    return {
        "request": { 
            "method":request.method,
            "url": str(request.url),
            "client": request.client.host if request.client else NONE,
            "header": dict(request.headers)
        },
        "status": "success",
        "time": datetime.utcnow().isoformat(),
    }


@app.get("/health_check") # k9s 
def health_check():
    # logger.info("Home Url Triggered.")
    return {
        "status": "success"
    }

@app.get("/pod_info")
async def podinfo(request:Request):
    logger.info("Pod Info Triggered.")
    return {
        "pod-info": pod_info(),
        "status": "success",
        "time": datetime.utcnow().isoformat(),
    }

@app.get("/log_test")
def log_test():
    logger.info("Manual Log Generation.")
    return {
        "status": "success",
        "time": datetime.utcnow().isoformat(),
        "log_file":f"{LOG_DIR}/application.log",
    }
