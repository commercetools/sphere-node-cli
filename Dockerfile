FROM node:0.12
MAINTAINER Panshul Gupta <panshul.gupta@commercetools.de>

WORKDIR /app

COPY . /app

ENV NODE_ENV production

ENTRYPOINT ["./bin/sphere"]
