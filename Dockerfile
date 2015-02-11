FROM pataquets/ubuntu:trusty

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
      python-minimal \
  && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
      python-libxslt1 \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/
	
# Install devel packages only to allow compilation on PIP install
# @todo: Consider PIP as a install-only package
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
      python-dev \
      python-pip \
      libxml2-dev libxslt1-dev zlib1g-dev \
  && \
  pip install -U cloudooo && \
  pip install -U cloudooo.handler.ooo && \
  pip install -U cloudooo.handler.pdf && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get purge --auto-remove -y \
      python-dev \
      python-pip \
      build-essential dpkg-dev make xz-utils \
      libxml2-dev libxslt1-dev zlib1g-dev \
  && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get autoremove -y --purge && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/
