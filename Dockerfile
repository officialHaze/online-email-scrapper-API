FROM python:3.9-alpine3.13
LABEL maintainer="Moinak Dey"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt
COPY ./app /app

WORKDIR /app
# EXPOSE 5000

RUN python -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .temp-deps \
        build-base postgresql-dev musl-dev linux-headers && \
    /venv/bin/pip install -r /requirements.txt && \
    apk del .temp-deps && \
    adduser --disabled-password --no-create-home nonrootuser && \
    mkdir -p /vol/web/static && \
    chown -R nonrootuser:nonrootuser /vol && \
    chmod -R 755 /vol && \
    chmod -R +x /scripts

ENV PATH="/scripts:/venv/bin:$PATH"

USER nonrootuser

CMD [ "run.sh" ]