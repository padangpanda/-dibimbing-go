# ================================
# Build Stage
# ================================
FROM golang:1.26.5-alpine AS builder

# Set working directory di dalam container
WORKDIR /app

# Install git dan certificates (diperlukan jika mendownload modul via git/https)
RUN apk add --no-cache git ca-certificates

# Copy modul Go terlebih dahulu untuk memanfaatkan Docker layer caching
COPY go.mod go.sum ./
RUN go mod download

# Copy seluruh kode sumber proyek
COPY . .

# Build biner aplikasi (dioptimalkan tanpa overhead debugging)
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o /app/tiketkilat ./main.go

# ================================
# Final Stage
# ================================
FROM alpine:3.19

WORKDIR /app

# Install ca-certificates dan timezone data
RUN apk --no-cache add ca-certificates tzdata

# Copy biner yang sudah di-compile dari stage builder
COPY --from=builder /app/tiketkilat .

# Expose port aplikasi
EXPOSE 8080

# Jalankan biner aplikasi
CMD ["./tiketkilat"]