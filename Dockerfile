FROM registry.cn-beijing.aliyuncs.com/g7-base/golang:1.16 as build

COPY ./ /code
ENV GOPROXY=https://goproxy.cn
ENV GO111MODULE="on"

WORKDIR /code

RUN go build -o blackbox_exporter main.go

FROM registry.cn-beijing.aliyuncs.com/g7-base/base-centos7:v0.2 as runner
WORKDIR /go/bin
COPY --from=build /code/blackbox_exporter /go/bin/
COPY --from=build /code/blackbox.yml /etc/blackbox_exporter/config.yml
EXPOSE      9115
ENTRYPOINT  [ "/go/bin/blackbox_exporter" ]
CMD         [ "--config.file=/etc/blackbox_exporter/config.yml" ]
