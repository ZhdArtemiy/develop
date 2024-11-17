FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y tzdata && apt-get install -y curl apache2 git php7.4 php-mysql php-cli php-json php-curl php-xml libapache2-mod-php php-zip unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    rm -rf /var/www/html/* && \
    git clone https://github.com/yiisoft/yii2-app-basic.git /var/www/html/ && \
    mkdir -p /root/.ssh && \
    ssh-keyscan github.com >> /root/.ssh/known_hosts && \
    composer install --working-dir=/var/www/html && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html && \
    sed -i "s/'cookieValidationKey' => ''/'cookieValidationKey' => 'test123'/g" /var/www/html/config/web.php && \
    sed -i "s/'password' => ''/'password' => 'yii2basic_password'/g" /var/www/html/config/db.php && \
    sed -i "s/'username' => 'root'/'username' => 'yiitest'/g" /var/www/html/config/db.php && \
    sed 's/localhost/db/g' /var/www/html/config/db.php && \
    a2enmod rewrite
COPY ./default.conf /etc/apache2/sites-available/000-default.conf
EXPOSE 80/tcp
CMD ["apachectl", "-D", "FOREGROUND"]