#docker build . -t quay.io/semoss/docker-r-packages:R4.2.1-debian11

ARG BASE_REGISTRY=quay.io
ARG BASE_IMAGE=semoss/docker-r
ARG BASE_TAG=R4.2.1-debian11

ARG BUILDER_BASE_REGISTRY=quay.io
ARG BUILDER_BASE_IMAGE=semoss/docker-r
ARG BUILDER_BASE_TAG=R4.2.1-debian11-builder

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as base

FROM ${BUILDER_BASE_REGISTRY}/${BUILDER_BASE_IMAGE}:${BUILDER_BASE_TAG} as rbuilder

LABEL maintainer="semoss@semoss.org"

# Install R packages
RUN apt-get update \
	&& cd /opt \
	&& apt-get update \
	&& apt-get install -y libpoppler-cpp-dev gfortran libblas-dev liblapack-dev cmake \
	&& git clone https://github.com/SEMOSS/docker-r-packages.git \
	&& cd docker-r-packages \
	&& git checkout R4.2.1-debian11 \
	&& chmod +x install_R_Packages.sh \
	&& /bin/bash install_R_Packages.sh \
	&& cd .. \
	&& rm -r docker-r-packages \
	&& apt-get clean all
	
	
FROM base

RUN apt-get update \
	&& cd ~/ \
	&& apt-get update \
	&& apt-get install -y libpoppler-cpp-dev
	
COPY --from=rbuilder /usr/lib/R /usr/lib/R
COPY --from=rbuilder /usr/local/lib/R /usr/local/lib/R

WORKDIR /opt

CMD ["bash"]
