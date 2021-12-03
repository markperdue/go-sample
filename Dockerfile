FROM golang:1.17.3-alpine AS build
WORKDIR /go/src/app
ADD go.mod /go/src/app
ADD *.go /go/src/app
ENV CGO_ENABLED=0
RUN go build -o /go/bin/app

FROM gcr.io/distroless/base-debian11
COPY --from=build /go/bin/app /

EXPOSE 8080
USER nonroot:nonroot
CMD [ "/app" ]
