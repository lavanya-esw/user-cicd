FROM node:20.19.5-alpine3.21 AS build
WORKDIR /opt/server
COPY *.json .
COPY *.js .
RUN npm install

FROM node:20.19.5-alpine3.21
WORKDIR /opt/server
RUN apk update && \
    apk upgrade --no-cache
EXPOSE 8080
LABEL com.project="roboshop" \
      component="user"
RUN addgroup -S roboshop && adduser -S roboshop -G roboshop && \
    chown -R roboshop:roboshop /opt/server
ENV MONGO="true" \
    REDIS_URL="redis://redis:6379" \
    MONGO_URL="mongodb://mongodb:27017/users"
COPY --from=build --chown=roboshop:roboshop /opt/server /opt/server
USER roboshop
ENTRYPOINT ["node","server.js"]
# FROM node:20.19.5-alpine3.21
# WORKDIR /opt/server
# EXPOSE 8080
# COPY *.json .
# COPY *.js .
# RUN npm install
# ENV MONGO="true" \
#     REDIS_URL="redis://redis:6379" \
#     MONGO_URL="mongodb://mongodb:27017/users"

# CMD ["node","server.js"]