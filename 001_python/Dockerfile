FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFER=1

RUN apt update -y && \
    apt install -y --no-install-recommends gcc && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m app-user

RUN mkdir -p /app/logs
RUN chown -R app-user:app-user /app
WORKDIR /app
COPY ./requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


COPY application ./application
# COPY 
#Y: applicaiton folder from host
# application 
#
#Y: create applicaiton folder inside continer.
# ./application 



USER app-user
EXPOSE 8000

CMD [ "uvicorn","application.main:app","--host","0.0.0.0","--port","8000" ]

