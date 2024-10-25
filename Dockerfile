FROM golang:1.22.5 AS base

#all commands will be executed in this work directory
WORKDIR /app

# copies the go.mod file from local
COPY go.mod .

#any dependies of the application 
RUN go mod download

# copy the source code to docker image
COPY . .

RUN go build -o main .

## distroless image to reduce size and security

FROM gcr.io/distroless/base

#Copy the base image binary from above ¨RUN go build -o main .¨ command
COPY --from=base /app/main .

COPY --from=base /app/static ./static

EXPOSE 8080

CMD ["./main"]