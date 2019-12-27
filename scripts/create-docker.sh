#!/bin/bash

git clone https://github.com/gothinkster/angular-realworld-example-app.git
touch Dockerfile
echo "FROM nginx:stable-alpine" >> Dockerfile
echo "COPY nginx.conf /etc/nginx/nginx.conf" >> Dockerfile
echo "WORKDIR /usr/share/nginx/html" >> Dockerfile
echo "COPY /dist/angular-realworld-example-app /usr/share/nginx/html" >> Dockerfile
ng build --prod
docker image build -t angular:prod .
