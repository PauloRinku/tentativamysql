FROM php:8.2-apache

# Instala extensão mysqli
RUN docker-php-ext-install mysqli

# Copia o projeto para o diretório padrão do Apache
COPY . /var/www/html/

RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

EXPOSE 80

# Comando padrão (Apache já inicia no container)
CMD ["apache2-foreground"]
