FROM debian
MAINTAINER Yossi Solomon <yosisolomon@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

ENV MININET_REPO git://github.com/mininet/mininet
ENV MININET_INSTALLER ./mininet/util/install.sh
ENV INSTALLER_SWITCHES -fbinptvwyx
ENV MLNET_REPO git://github.com/yossisolomon/ML-net

WORKDIR /tmp

# Update and install minimal.
RUN \
    apt-get update \
        --quiet \
    && apt-get install \
        --yes \
        --no-install-recommends \
        --no-install-suggests \
    autoconf \
    automake \
    ca-certificates \
    git \
    curl \
    libtool \
    net-tools \
    openssh-client \
    patch \
    vim \
    python-numpy \
    python-sklearn \

# Clone and install mininet
    && git clone -b 2.2.1 $MININET_REPO \

# A few changes to make the mininet install script behave.
    && sed -e 's/sudo //g' \
    	-e 's/~\//\//g' \
    	-e 's/\(apt-get -y install\)/\1 --no-install-recommends --no-install-suggests/g' \
    	-i $MININET_INSTALLER \

# Install script expects to find this. Easier than patching that part of the script.
    && touch /.bashrc \

# Proceed with the install.
    && chmod +x $MININET_INSTALLER \
    && ./$MININET_INSTALLER -nfv \

# Clean up source.
    && rm -rf /tmp/mininet \
              /tmp/openflow \

# Clean up packages.
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Clone and install ML-net
WORKDIR ~
RUN git clone $MLNET_REPO


# Create a start script to start OpenVSwitch
COPY docker-entry-point /docker-entry-point
RUN chmod 755 /docker-entry-point

VOLUME ["/data"]
WORKDIR /data

# Default command.
ENTRYPOINT ["/docker-entry-point"]
