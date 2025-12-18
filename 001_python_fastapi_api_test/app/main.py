from fastapi import FastAPI
import logging
import os
from datetime import datetime

app = FastAPI(title="001_python_fastapi_api") # FastApi Instance Service Object


if os.path.exists("/app"):
    LOG_DIR = "/app/logs" # DEIFNE LOGDIR IN Contienre
else:
    LOG_DIR = "logs" # DEIFNE LOGDIR in OS


os.makedirs(LOG_DIR,exist_ok=True) # make-dir, if_esist=ok(dont crash)

logging.basicConfig(
    filename=f"{LOG_DIR}/api.log",  # Log_file_path+Name
    level=logging.INFO,             # LogsLevel = Info and above (Debug-info-warning-error)
    format="%(asctime)s | $(levelname)s | %(message)s" # foramt Date | level | message
)

logger = logging.getLogger(__name__) # Loger Object for apis => to store log and not print them.

@app.get("/") # Http GET endpint for "/"
def root(): # name for /
    logger.info("Root endpoint accessed") # log when accessed /
    return{ 
        "message": "FastAPI service is running",
        "timestamp": datetime.utcnow().isoformat()
    } # FastAPI automatically convert return into JSON

@app.get("/health") # Health chekcpint for Docker/LoadBalancer/Kubernetes
def health_check():
    return{
        "status": "ok" # HTTP 200 if healthy.
    }

@app.get("/info")
def system_info():
    logger.info("System info endpint accessed")
    return {
        "python_versoin": os.sys.version, #sys version
        "working_directory": os.getcwd(), #current working directory
        "pid": os.getpid(), # processID
        "time": datetime.utcnow().isoformat()
    }

@app.get("/log-test")
def log_test():
    logger.info("Manual log test Trigger")
    return{
        "message":"Log Success",
        "log_file":f"{LOG_DIR}/api.log" 
    }
