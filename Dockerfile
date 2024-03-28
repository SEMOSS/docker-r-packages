#docker build . -t quay.io/semoss/docker-r-packages:debian11

ARG BASE_REGISTRY=quay.io
ARG BASE_IMAGE=semoss/docker-r
ARG BASE_TAG=debian11

ARG BUILDER_BASE_REGISTRY=quay.io
ARG BUILDER_BASE_IMAGE=semoss/docker-r
ARG BUILDER_BASE_TAG=debian11-builder

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as base

LABEL maintainer="semoss@semoss.org"

# Install R packages
COPY . /opt/docker-r-packages

RUN apt-get update \
	&& cd /opt \
	&& apt-get update \
	&& apt-get install -y gfortran libblas-dev liblapack-dev cmake \
	&& cd docker-r-packages \
	&& chmod +x install_R_Packages.sh \
	&& /bin/bash install_R_Packages.sh \
	&& cd .. \
	&& apt-get clean all

FROM base as intermediate

RUN apt-get update \
	&& cd ~/ \
	&& apt-get update \
	&& apt-get install -y libpoppler-cpp-dev

COPY --from=base /usr/lib/R /usr/lib/R
COPY --from=base /usr/local/lib/R /usr/local/lib/R

FROM scratch AS final

COPY --from=intermediate  / /
WORKDIR /opt

CMD ["bash"]
