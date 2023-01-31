# Use the official lightweight Python image.
# https://hub.docker.com/_/python
FROM python:latest

# Allow statements and log messages to immediately appear in the Knative logs
ENV PYTHONUNBUFFERED True

ENV PIP_ROOT_USER_ACTION=ignore

RUN apt-get update
# RUN apt-get install -y python

COPY ./py/requirements.txt ./
COPY ./py/bigquery-sql-sqlalchemy.py ./
COPY ./py/connect_connector.py ./
RUN ls -lR ./


RUN pip install -r requirements.txt

CMD [ "python", "./bigquery-sql-sqlalchemy.py"]