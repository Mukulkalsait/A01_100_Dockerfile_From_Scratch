import os
import logging
from datetime import datetime
from fastapi import FastAPI

app = FastAPI(title="pytest")

if os.path.exists("/app"):
    LOG_DIR = "/app/logs"
else: 
    LOG_DIR = "/temp"

os.makedirs(LOG_DIR,exist_ok=True)
logger = logging.getLogger(__name__)

logging.basicConfig(
    filename = f"{LOG_DIR}/application.log",
    level = logging.INFO,
    format ="%(asctime)s | %(levelname)s | %(message)s"
)

@app.get("/")
def root():
    logger.info("endpoint hit.")
    return{
    "message":"Home Point",
    "datetime": datetime.utcnow().isoformat(),
    "status_code": 200,
    }

@app.get("/health_check")
def health_check():
    logger.info("Health check hit.")
    return{
    "status":"success",
    }

@app.get("/system_info")
def system_info():
    logger.info("System info hit.")
    return{
    "python_version": os.sys.version,
    "datetime":datetime.utcnow().isoformat(),
    "workdirectory": os.getcwd(),
    "pid": os.getpid(),
    "status_code": 200
    }

@app.get("/log_test")
def log_test():
    logger.info("Manual Log test.")
    return{
    "status_code": 200,
    "datetime":datetime.utcnow().isoformat(),
    "log_file": f"{LOG_DIR}/applicaiton.log",
    }
