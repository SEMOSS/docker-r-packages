FROM semoss/docker-r:user

LABEL maintainer="semoss@semoss.org"
ENV R_HOME=/usr/lib/R
# Install R packages
RUN sudo apt-get update \
	&& cd ~/ \
	&& sudo apt-get update \
	&& sudo apt-get install -y libpoppler-cpp-dev \
	&& git clone https://github.com/SEMOSS/docker-r-packages.git \
	&& cd docker-r-packages \
	&& git checkout User \
	&& cd ~/ \
	&& mkdir /home/semoss/status \
	&& wget --no-check-certificate --output-document=AnomalyDetectionV1.0.0.tar.gz https://github.com/twitter/AnomalyDetection/archive/v1.0.0.tar.gz \
	&& wget https://www.rforge.net/Rserve/snapshot/Rserve_1.8-6.tar.gz \
	&& wget https://datacube.wu.ac.at/src/contrib/openNLPmodels.en_1.5-1.tar.gz \
	&& R -e "install.packages('pacman')" \
	&& Rscript docker-r-packages/Packages.R \
	&& R CMD INSTALL Rserve_1.8-6.tar.gz \
	&& R CMD INSTALL openNLPmodels.en_1.5-1.tar.gz \
	&& rm Rserve_1.8-6.tar.gz \
	&& rm openNLPmodels.en_1.5-1.tar.gz \
	&& rm AnomalyDetectionV1.0.0.tar.gz \
	&& sudo rm -r docker-r-packages \
	&& sudo apt-get clean all

RUN sudo cp /home/semoss/R/x86_64-pc-linux-gnu-library/3.5/Rserve/libs/Rserve.dbg /usr/lib/R/bin \
	&& sudo cp /home/semoss/R/x86_64-pc-linux-gnu-library/3.5/Rserve/libs/Rserve /usr/lib/R/bin

WORKDIR /home/semoss

CMD ["bash"]
