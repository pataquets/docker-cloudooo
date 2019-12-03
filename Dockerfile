FROM pataquets/default-jre-headless:xenial

RUN \
  apt-key adv --keyserver hkp://hkps.pool.sks-keyservers.net --recv-keys 1378B444 && \
  . /etc/lsb-release && \
  echo "deb http://ppa.launchpad.net/libreoffice/ppa/ubuntu ${DISTRIB_CODENAME} main" \
    | tee /etc/apt/sources.list.d/libreoffice.list \
  && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
      python-minimal \
  && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
      python-libxslt1 \
  && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
      libreoffice-script-provider-python \
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
  pip install --no-cache-dir cloudooo && \
  pip install --no-cache-dir cloudooo.handler.ooo && \
  pip install --no-cache-dir cloudooo.handler.pdf && \
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
