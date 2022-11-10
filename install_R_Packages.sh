mkdir /opt/status
wget --no-check-certificate --output-document=AnomalyDetectionV1.0.0.tar.gz https://github.com/twitter/AnomalyDetection/archive/v1.0.0.tar.gz
wget https://www.rforge.net/Rserve/snapshot/Rserve_1.8-11.tar.gz
wget https://datacube.wu.ac.at/src/contrib/openNLPmodels.en_1.5-1.tar.gz 
wget https://cran.r-project.org/src/contrib/Archive/SteinerNet/SteinerNet_3.0.1.tar.gz
wget https://cran.r-project.org/src/contrib/Archive/textreadr/textreadr_1.2.0.tar.gz
R -e "install.packages('pacman')"
arch=$(uname -m)
if [[ $arch == x86_64* ]]; then
    echo "X64 Architecture"
    Rscript Packages_x86_64.R
elif  [[ $arch == arm* ]] || [[ $arch = aarch64 ]]; then
    echo "ARM Architecture"
    Rscript Packages_arm.R
    wget https://cran.r-project.org/bin/macosx/big-sur-arm64/contrib/4.2/openNLPdata_1.5.3-4.tgz
    R CMD INSTALL https://cran.r-project.org/bin/macosx/big-sur-arm64/contrib/4.2/openNLPdata_1.5.3-4.tgz
    R -e "install.packages('openNLP')"
fi
R -e "install.packages('XML', repos = 'http://www.omegahat.net/R')"
R CMD INSTALL Rserve_1.8-11.tar.gz
R CMD INSTALL openNLPmodels.en_1.5-1.tar.gz
R CMD INSTALL SteinerNet_3.0.1.tar.gz
R CMD INSTALL textreadr_1.2.0.tar.gz
