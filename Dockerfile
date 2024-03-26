#docker build . -t quay.io/semoss/docker-r-packages:ubi8-rhel

ARG BASE_REGISTRY=quay.io
ARG BASE_IMAGE=semoss/docker-r
ARG BASE_TAG=ubi8-rhel

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as builder

LABEL maintainer="semoss@semoss.org"

# Install R packages
RUN cd /opt \
	&& yum -y update \
	&& yum install -y glibc-langpack-en initscripts procps-ng  wget binutils curl glibc-devel glibc-headers libcurl-devel libX11 libX11-common kernel-headers openssl-devel libxml2-devel libpng-devel libjpeg-devel cmake fontconfig-devel \
	&& mkdir /opt/docker-r-packages

COPY poppler /opt/poppler
RUN cd /opt/poppler \
	&& yum install -y --nogpgcheck  /opt/poppler/poppler-*.rpm --allowerasing \
	&& rm -r /opt/poppler

COPY . /opt/docker-r-packages

RUN cd /opt/docker-r-packages \
	&& chmod +x install_R_Packages.sh \
	&& /bin/bash install_R_Packages.sh \
	&& cd .. \
	&& rm -r docker-r-packages

FROM scratch AS final
COPY --from=builder / /
WORKDIR /opt

CMD ["bash"]
