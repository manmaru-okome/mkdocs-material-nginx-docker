FROM python:3.9.6-slim as build

RUN pip install --upgrade pip \
  && pip install mkdocs mkdocs-material

WORKDIR /usr/src/app
COPY mkdocs/ /usr/src/app
RUN mkdocs build


# ---------------
FROM nginx:1.21.0-alpine as prod

COPY --from=build /usr/src/app/site/ /var/www/site/

ADD nginx/default.conf /etc/nginx/conf.d/

CMD ["nginx", "-g", "daemon off;"]


# ---------------
FROM python:3.9.6-slim as dev

EXPOSE 8000

RUN pip install --upgrade pip \
  && pip install mkdocs mkdocs-material

WORKDIR /usr/src/app
COPY mkdocs/ /usr/src/app

CMD ["mkdocs", "serve"]