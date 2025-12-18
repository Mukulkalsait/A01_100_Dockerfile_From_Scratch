from fastapi import FastAPI
from datetime import datetime
import os
import logger

app = FastAPI(titel="001_python") #Fastapi Instance Service Object

LOG_DIR = "/app/logs"
os .makedire(LOG_DIR,exist_ok=True)

logging.basicConfig(
    filename=f"{LOG_DIR}/api.log",
    level=logging.INFO,
    foramt="%(asctime)s | %(levelname)s | %(message)s"
)

logger = logging.getLogger(__name__) # Logger Ojbect 

@app.get("/")
def root():
    logger.info("Root-endpoint Accessed.")
    return{
        "message": "Home Running !!",
        "timestamp": datetime.utcnow().isoformat(),
        "statuscode": 200
    }

@app.get("/health_check")
def health_check():
    return{
        "status": "success"
    }

@app.get("/system_info")
def system_info():
    logger.info("system-endpoint Accessed.")
    return{
        "version": os.sys.version,
        "workdirectory": os.getcwd(),
        "pid": os.getpid(),
        "timestamp": datetime.utcnow().isoformat(),
        "statuscode": 200
    }

@app.get("/log_test")
def log_test():
    logger.info("Manual test Success.")
    return{
        "logfile": f"{LOG_DIR}/api.log"
        "time": datetime.utcnow().isoformat(),
        "statuscode": 200
    }

