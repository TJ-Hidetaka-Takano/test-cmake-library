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
# RUN pip3 install --no-cache-dir \
#   jinja2 \
#   lxml \
#   setuptools

# Setting up no passwd sudoers
RUN echo "Defaults:ALL env_keep += \"HTTP_PROXY HTTPS_PROXY http_proxy https_proxy no_proxy\"" \
  > /etc/sudoers.d/sudo_no_passwd \
  && echo "ALL ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers.d/sudo_no_passwd

# Setting up entrypoint of the container
COPY --chmod=755 docker/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash", "-li"]

SHELL ["bash", "-c"]

# --- YamlCpp ---
# hadolint ignore=DL3003,SC1091
# RUN mkdir -p /tmp/yaml-cpp/build \
#   && curl -fsSL https://github.com/jbeder/yaml-cpp/archive/refs/tags/yaml-cpp-0.7.0.tar.gz | tar xzC /tmp/yaml-cpp --strip-components=1 \
#   && cd /tmp/yaml-cpp/build \
#   && cmake \
#     -DCMAKE_BUILD_TYPE=MinSizeRel \
#     -DCMAKE_INSTALL_PREFIX=/usr .. \
#   && cmake --build . \
#   && cmake --install . \
#   && cd /tmp && rm -rf yaml-cpp

# --- gRPC ---
# hadolint ignore=DL3003,SC2016
# RUN cd /tmp \
#   && git clone --depth=1 -b v1.52.1 --recursive https://github.com/grpc/grpc.git \
#   && mkdir -p grpc/build && cd grpc/build \
#   && cmake \
#     -DCMAKE_BUILD_TYPE=MinSizeRel \
#     -DgRPC_INSTALL=ON \
#     -DgRPC_BUILD_TESTS=OFF \
#     -DgRPC_BUILD_CSHARP_EXT=OFF \
#     -DgRPC_BUILD_GRPC_CPP_PLUGIN=ON \
#     -DgRPC_BUILD_GRPC_CSHARP_PLUGIN=OFF \
#     -DgRPC_BUILD_GRPC_NODE_PLUGIN=OFF \
#     -DgRPC_BUILD_GRPC_OBJECTIVE_C_PLUGIN=OFF \
#     -DgRPC_BUILD_GRPC_PHP_PLUGIN=OFF \
#     -DgRPC_BUILD_GRPC_PYTHON_PLUGIN=ON \
#     -DgRPC_BUILD_GRPC_RUBY_PLUGIN=OFF \
#     -DCMAKE_INSTALL_PREFIX=/usr .. \
#   && cmake --build . \
#   && cmake --install . \
#   && cd /tmp && rm -rf grpc*
