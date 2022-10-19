FROM golang:1.19.2-alpine3.16 AS build

RUN apk add build-base

WORKDIR /app
COPY  go.sum go.mod hd-idle.8 *.go .
COPY  diskstats diskstats
COPY  io io
COPY sgio sgio
COPY vendor vendor
RUN go mod download
RUN go build
RUN go test ./... -race -cover


FROM alpine:3.16
COPY --from=build /app/hd-idle /app/hd-idle

ENTRYPOINT [ "/app/hd-idle" ]