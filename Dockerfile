FROM semoss/docker-r:R4.1.0-debian10.5 as base

FROM semoss/docker-r:R4.1.0-debian10.5-builder as rbuilder

LABEL maintainer="semoss@semoss.org"

# Install R packages
RUN apt-get update \
	&& cd ~/ \
	&& apt-get update \
	&& apt-get install -y libpoppler-cpp-dev \
	&& git clone https://github.com/SEMOSS/docker-r-packages.git \
	&& cd docker-r-packages \
	&& git checkout R4.1.0-debian10.5 \
	&& cd .. \
	&& mkdir /opt/status \
	&& wget --no-check-certificate --output-document=AnomalyDetectionV1.0.0.tar.gz https://github.com/twitter/AnomalyDetection/archive/v1.0.0.tar.gz \
	&& wget https://www.rforge.net/Rserve/snapshot/Rserve_1.8-6.tar.gz \
	&& wget https://datacube.wu.ac.at/src/contrib/openNLPmodels.en_1.5-1.tar.gz \
	&& wget https://cran.r-project.org/src/contrib/Archive/SteinerNet/SteinerNet_3.0.1.tar.gz \
	&& R -e "install.packages('pacman')" \
	&& Rscript docker-r-packages/Packages.R \
	&& R -e "install.packages('XML', repos = 'http://www.omegahat.net/R')" \
	&& R CMD INSTALL Rserve_1.8-6.tar.gz \
	&& R CMD INSTALL openNLPmodels.en_1.5-1.tar.gz \
	&& R CMD INSTALL SteinerNet_3.0.1.tar.gz \
	&& rm Rserve_1.8-6.tar.gz \
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
