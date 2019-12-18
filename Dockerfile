FROM semoss/docker-r:R3.5.2-T9.0.26

LABEL maintainer="semoss@semoss.org"

# Install R packages
RUN apt-get update \
	&& cd ~/ \
	&& apt-get update \
	&& apt-get install -y libpoppler-cpp-dev \
	&& git clone https://github.com/SEMOSS/docker-r-packages.git \
	&& mkdir /opt/status \
	&& wget --no-check-certificate --output-document=AnomalyDetectionV1.0.0.tar.gz https://github.com/twitter/AnomalyDetection/archive/v1.0.0.tar.gz \
	&& wget https://www.rforge.net/Rserve/snapshot/Rserve_1.8-6.tar.gz \
	&& wget https://datacube.wu.ac.at/src/contrib/openNLPmodels.en_1.5-1.tar.gz \
	&& Rscript docker-r-packages/Packages.R \
	&& R CMD INSTALL Rserve_1.8-6.tar.gz \
	&& R CMD INSTALL openNLPmodels.en_1.5-1.tar.gz \
	&& rm Rserve_1.8-6.tar.gz \
	&& rm openNLPmodels.en_1.5-1.tar.gz \
	&& rm AnomalyDetectionV1.0.0.tar.gz \
	&& rm -r docker-r-packages \
	&& apt-get clean all

WORKDIR /opt

CMD ["bash"]
