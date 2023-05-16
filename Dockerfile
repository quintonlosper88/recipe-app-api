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
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user
#update environment variable --> all code will automatically run in virtual environment        
ENV PATH="/py/bin:$PATH"

USER django-user



# Set the PYTHONUNBUFFERED environment variable to 1

# Copy the requirements.txt and requirements.dev.txt files to a temporary directory.
# Copy the app directory into the working directory.
# Expose port 8000.
# Create a virtual environment in /py and install the packages listed in the requirements.txt file.

# If the DEV argument is set to true, the packages listed in the requirements.dev.txt file are also installed.
# Remove the temporary directory.Add the user django-user with a disabled password and no home directory.
# Update the PATH environment variable to include the virtual environment.
# Set the user to django-user.
