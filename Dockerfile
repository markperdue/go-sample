FROM docker.io/golang:1.20.0-alpine AS build
ARG version=999
WORKDIR /go/src/app
ADD go.mod /go/src/app
ADD main.go /go/src/app
RUN CGO_ENABLED=0 go build -o /go/bin/app -ldflags "-X main.version=${version}"

FROM gcr.io/distroless/static-debian11
COPY --from=build /go/bin/app /

EXPOSE 8080
USER nonroot:nonroot
CMD [ "/app" ]
