# x86_64 Linux 開発環境
FROM ubuntu:20.04

ENV TZ=Asia/Tokyo

# Installing debian packages
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    build-essential \
    ca-certificates \
    curl \
    gcc \
    g++-7 \
    git \
    gpg \
    iproute2 \
    iputils-ping \
    jq \
    less \
    libboost-all-dev \
    libbz2-dev \
    libcgroup-dev \
    libtar-dev \
    libtool \
    libxml2-utils \
    lsb-release \
    python3 \
    python3-pip \
    sudo \
    tzdata \
    unzip \
    vim \
    xz-utils \
  && curl https://apt.kitware.com/keys/kitware-archive-latest.asc | gpg --dearmor > /usr/share/keyrings/kitware-archive-keyring.gpg \
  && echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal main' > /etc/apt/sources.list.d/kitware.list \
  && apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    cmake=3.31.6-0kitware1ubuntu20.04.1 \
    cmake-data=3.31.6-0kitware1ubuntu20.04.1 \
    make \
    pkg-config \
  && rm -rf /var/lib/apt/lists/*

# Installing Python packages
# RUN printf "[global]\nbreak-system-packages = true\n" > /etc/pip.conf \
#   && pip3 install --no-cache-dir \
#     jinja2 \
#     lxml \
#     setuptools

# Setting up no passwd sudoers
RUN echo "Defaults:ALL env_keep += \"HTTP_PROXY HTTPS_PROXY http_proxy https_proxy no_proxy\"" \
  > /etc/sudoers.d/sudo_no_passwd \
  && echo "ALL ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers.d/sudo_no_passwd

# Setting up entrypoint of the container
COPY --chmod=755 docker/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash", "-li"]

SHELL ["bash", "-c"]
