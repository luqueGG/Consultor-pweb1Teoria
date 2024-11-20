FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

# Instalar Apache
RUN apt-get update && \
    apt-get install -y apache2 dos2unix libcgi-pm-perl libtext-csv-perl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*