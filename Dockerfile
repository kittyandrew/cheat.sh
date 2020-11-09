FROM python:3.8-slim-buster
WORKDIR /app

COPY requirements.txt .
# installing dependencies
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    build-essential \
    bash \
    gawk \
    libicu-dev \
    pkg-config \
    git \
 # upgrading infrastructure
 && pip3 install --no-cache-dir -U pip wheel setuptools \
 # deps
 && pip3 install --no-cache-dir -r requirements.txt \
 # clean up after installs
 && rm -rf /var/lib/apt/lists/* \
 && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false

## fetching cheat sheets
#RUN apk add --update --no-cache git py3-six py3-pygments py3-yaml py3-gevent \
#       py3-colorama py3-requests py3-icu py3-redis

## building missing python packages
#RUN apk add --no-cache --virtual build-deps py3-pip g++ python3-dev \
##    && pip3 install -U pip wheel setuptools \
#    && pip3 install --no-cache-dir rapidfuzz colored polyglot pycld2 \
#    && apk del build-deps

# Project files
COPY bin/srv.py bin/srv.py
COPY lib lib
COPY share share
# COPY etc etc

# fetching cheat sheets
RUN mkdir -p /root/.cheat.sh/log/ \
 && python3 lib/fetch.py fetch-all

ENTRYPOINT ["python3", "-u", "bin/srv.py"]
# CMD [""]
