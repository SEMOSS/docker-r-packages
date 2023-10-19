#docker build . -t quay.io/semoss/docker-r-packages:ubi8

ARG BASE_REGISTRY=quay.io
ARG BASE_IMAGE=semoss/docker-r
ARG BASE_TAG=ubi8

ARG BUILDER_BASE_REGISTRY=quay.io
ARG BUILDER_BASE_IMAGE=semoss/docker-r
ARG BUILDER_BASE_TAG=ubi8

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as base

# FROM ${BUILDER_BASE_REGISTRY}/${BUILDER_BASE_IMAGE}:${BUILDER_BASE_TAG} as rbuilder

LABEL maintainer="semoss@semoss.org"

# Install R packages
RUN cd /opt \
	&& yum -y update \
	&& yum install -y glibc-langpack-en initscripts procps-ng  binutils curl glibc-devel glibc-headers libcurl-devel libX11 libX11-common kernel-headers openssl-devel libxml2-devel libpng-devel libjpeg-devel cmake fontconfig-devel  \
	&& mkdir /opt/docker-r-packages

COPY poppler /opt/poppler
RUN cd /opt/poppler \
	&& yum install -y --nogpgcheck  /opt/poppler/poppler-20.11.0-2.el8.x86_64.rpm --allowerasing \
	&& yum install -y --nogpgcheck  /opt/poppler/poppler-cpp-20.11.0-2.el8.x86_64.rpm --allowerasing \
	&& yum install -y --nogpgcheck /opt/poppler/poppler-devel-20.11.0-2.el8.x86_64.rpm --allowerasing \ 
	&& yum install -y --nogpgcheck  /opt/poppler/poppler-cpp-devel-20.11.0-2.el8.x86_64.rpm --allowerasing \
	&& rm -r /opt/poppler


COPY . /opt/docker-r-packages

RUN cd /opt/docker-r-packages \
	&& chmod +x install_R_Packages.sh \
	&& /bin/bash install_R_Packages.sh \
	&& cd .. \
	&& rm -r docker-r-packages
	
	
# FROM base

# RUN apt-get update \
# 	&& cd ~/ \
# 	&& apt-get update \
# 	&& apt-get install -y libpoppler-cpp-dev
	
# COPY --from=rbuilder /opt/R/ /opt/R/

WORKDIR /opt

CMD ["bash"]
