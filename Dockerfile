FROM google/cloud-sdk:250.0.0-slim

COPY entrypoint.sh /

RUN apt update && apt install -y \
    mysql-client \
    rsync \
    libunwind-dev \
    libicu57 \
  && rm -rf /var/lib/apt/lists/* \
  && chmod +x /entrypoint.sh

RUN set -ex \
    && curl -L -o azcopy.tar.gz \
    https://aka.ms/downloadazcopylinux64 \
    && tar -xf azcopy.tar.gz && rm -f azcopy.tar.gz \
    && ./install.sh && rm -f install.sh \
    && rm -rf azcopy

ENTRYPOINT ["/entrypoint.sh"]
