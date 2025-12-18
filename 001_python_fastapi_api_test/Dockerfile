FROM python:3.12-slim

# Y: PythonDontWriteByTeCode => stops .pyc files + PythonUnBUffered => better logs.
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1  

WORKDIR /app

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends gcc && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m app-user

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app ./app
RUN mkdir -p /app/logs

RUN chown -R app-user:app-user /app
USER app-user

EXPOSE 8000
CMD ["uvicorn","app.main:app","--host","0.0.0.0","--port","8000"]
