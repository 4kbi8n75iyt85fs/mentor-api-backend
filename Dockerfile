FROM golang:1.21-alpine

WORKDIR /app

COPY go.mod go.sum ./
COPY main.go ./

RUN go mod tidy
RUN go build -o main .

EXPOSE 3001

CMD ["./main"]
