FROM golang:1.13.5-alpine3.10

WORKDIR /go/src/app

COPY . .

RUN go mod download

CMD ["go", "test", "-v", "-timeout", "30m", "test/github_repository_test.go"]
