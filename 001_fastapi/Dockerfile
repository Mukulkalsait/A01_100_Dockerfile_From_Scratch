FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONDEBUFFER=1 
# TAG: pythondotnwritebytecode & pythondebuffer fror better logging.

RUN apt update \
    && apt install -y --no-install-recommends gcc \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m app-user
WORKDIR /app
RUN mkdir -p /app/logs
RUN chown -R app-user:app-user /app 

COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY ./application  /app/application
EXPOSE 8000
USER app-user
CMD [ "uvicorn","application.main:app","--host","0.0.0.0","--port","8000" ]

