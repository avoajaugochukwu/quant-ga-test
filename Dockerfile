# # Use an official Go runtime as the base image
# FROM golang:1.20-alpine AS build

# # Set the Current Working Directory inside the container
# WORKDIR /app

# # Copy go.mod and go.sum files
# COPY go.mod ./
# # COPY go.sum ./

# # Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
# RUN go mod download

# # Copy the source code into the container
# COPY . .

# # Build the Go app
# RUN go build -o /hello-world

# # Start a new stage from scratch
# FROM alpine:latest  

# # Set the working directory
# WORKDIR /

# # Copy the pre-built binary file from the build stage
# COPY --from=build /hello-world /hello-world

# # Command to run the executable
# CMD ["/hello-world"]


FROM golang:latest as builder
WORKDIR /app
ADD . /app/
# Compile the application to a static binary
RUN CGO_ENABLED=0 go build -a -installsuffix cgo -o hello-world .
RUN go build -o hello-world

#FROM scratch
#FROM alpine:latest
#WORKDIR /app
#COPY --from=builder /app/hello-world .
#RUN ls -l /app
CMD ["./hello-world"]
