FROM python:3.9-alpine3.13
LABEL maintainer="quintonlosper88"

ENV PYTHONUNBUFFERED 1
#copy to temp directory so that it is available in the build phase
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
        fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user
#update environment variable --> all code will automatically run in virtual environment        
ENV PATH="/py/bin:$PATH"

USER django-user