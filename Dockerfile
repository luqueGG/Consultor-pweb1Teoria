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

COPY html/ /var/www/html/
COPY css/ /var/www/html/css/ 
COPY cgi-bin/ /usr/lib/cgi-bin/
COPY ./Data_Universidades_LAB06.csv /usr/lib/cgi-bin/

RUN find /usr/lib/cgi-bin/ -type f -name "*.pl" -exec dos2unix {} \; && \
    chmod +x /usr/lib/cgi-bin/*.pl

EXPOSE 80

# Iniciar Apache en primer plano
CMD ["apache2ctl", "-D", "FOREGROUND"]