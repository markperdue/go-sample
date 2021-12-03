FROM golang:1.17.3-alpine AS build
WORKDIR /app
COPY go.mod ./
# COPY go.sum ./
RUN go mod download
COPY *.go ./
RUN go build -o /docker-go

FROM gcr.io/distroless/base-debian10
WORKDIR /
COPY --from=build /docker-go /docker-go

EXPOSE 8080
USER nonroot:nonroot
CMD [ "/docker-go" ]
