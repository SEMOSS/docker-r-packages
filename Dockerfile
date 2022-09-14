#docker build . -t quay.io/semoss/docker-r-packages:R4.1.2-debian11

ARG BASE_REGISTRY=quay.io
ARG BASE_IMAGE=semoss/docker-r
ARG BASE_TAG=R4.1.2-debian11

ARG BUILDER_BASE_REGISTRY=quay.io
ARG BUILDER_BASE_IMAGE=semoss/docker-r
ARG BUILDER_BASE_TAG=R4.1.2-debian11-builder

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as base

FROM ${BUILDER_BASE_REGISTRY}/${BUILDER_BASE_IMAGE}:${BUILDER_BASE_TAG} as rbuilder

LABEL maintainer="semoss@semoss.org"

# Install R packages
RUN apt-get update \
	&& cd ~/ \
	&& apt-get update \
	&& apt-get install -y libpoppler-cpp-dev gfortran libblas-dev liblapack-dev cmake \
	&& git clone https://github.com/SEMOSS/docker-r-packages.git \
	&& cd docker-r-packages \
	&& git checkout R4.1.2-debian11 \
	&& cd .. \
	&& mkdir /opt/status \
	&& wget --no-check-certificate --output-document=AnomalyDetectionV1.0.0.tar.gz https://github.com/twitter/AnomalyDetection/archive/v1.0.0.tar.gz \
	&& wget https://www.rforge.net/Rserve/snapshot/Rserve_1.8-11.tar.gz \
	&& wget https://datacube.wu.ac.at/src/contrib/openNLPmodels.en_1.5-1.tar.gz \
	&& wget https://cran.r-project.org/src/contrib/Archive/SteinerNet/SteinerNet_3.0.1.tar.gz \
	&& R -e "install.packages('pacman')" \
	&& Rscript docker-r-packages/Packages.R \
	&& R -e "install.packages('XML', repos = 'http://www.omegahat.net/R')" \
	&& R CMD INSTALL Rserve_1.8-11.tar.gz \
	&& R CMD INSTALL openNLPmodels.en_1.5-1.tar.gz \
	&& R CMD INSTALL SteinerNet_3.0.1.tar.gz \
	&& rm Rserve_1.8-11.tar.gz \
	&& rm SteinerNet_3.0.1.tar.gz \
	&& rm openNLPmodels.en_1.5-1.tar.gz \
	&& rm AnomalyDetectionV1.0.0.tar.gz \
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
