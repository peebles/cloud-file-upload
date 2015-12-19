FROM ubuntu:15.04
RUN apt-get install -y nano curl nginx imagemagick apache2-utils

ENV NODE_VERSION 0.10.40
ENV NPM_VERSION 2.14.1

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
        && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
        && rm "node-v$NODE_VERSION-linux-x64.tar.gz" \
        && npm install -g npm@"$NPM_VERSION" \
        && npm cache clear

RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

RUN mkdir /deploy
ADD . /deploy
RUN cp /deploy/nginx.conf /etc/nginx/sites-enabled/app.conf
RUN rm -f /etc/nginx/sites-enabled/default

ENV SITE_USER admin
ENV SITE_PASSWORD password
ENV SITE_TITLE "File Upload"
ENV SITE_DESCRIPTION "Drag and drop files from your desktop onto the page below to add files, then Start Upload." 

EXPOSE 80
VOLUME ["/deploy/server/public"]

WORKDIR /deploy
CMD [ "/deploy/run.sh" ]
