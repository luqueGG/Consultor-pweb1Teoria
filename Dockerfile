FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

# Instalar Apache
RUN apt-get update && \
    apt-get install -y apache2 dos2unix libcgi-pm-perl libtext-csv-perl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN a2enmod cgi && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    echo '<Directory "/usr/lib/cgi-bin">' >> /etc/apache2/apache2.conf && \
    echo '    AllowOverride None' >> /etc/apache2/apache2.conf && \
    echo '    Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch' >> /etc/apache2/apache2.conf && \
    echo '    Require all granted' >> /etc/apache2/apache2.conf && \
    echo '</Directory>' >> /etc/apache2/apache2.conf && \
    echo 'AddHandler cgi-script .cgi .pl' >> /etc/apache2/apache2.conf