FROM python:3.9 as builder
RUN apt-get update && apt-get install -y build-essential
COPY requirements.txt .
RUN pip install --user -r requirements.txt

FROM python:3.9
MAINTAINER iskoldt
COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH
COPY . /app
WORKDIR /app
ENV my_api_key empty
ENV dockerrun yes
RUN sed -i 's/websocket\.cookies\.get("access-token")/websocket.cookies.get("access-token-unsecure")/' /root/.local/lib/python3.9/site-packages/gradio/routes.py
CMD ["python3", "-u", "ChuanhuChatbot.py", "2>&1", "|", "tee", "/var/log/application.log"]
