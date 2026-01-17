# Docker Setup Guide

This guide explains how to build and run the microservices using Docker and Docker Compose.

## Prerequisites

- Docker Desktop (or Docker Engine + Docker Compose)
- Docker version 20.10 or later
- Docker Compose version 2.0 or later

## Quick Start

### Using Docker Compose (Recommended)

**Start all services:**
```bash
docker-compose up -d
```

**View logs:**
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f productservice
docker-compose logs -f orderservice
docker-compose logs -f notificationservice
```

**Stop all services:**
```bash
docker-compose down
```

**Rebuild and start:**
```bash
docker-compose up -d --build
```

### Individual Service Commands

**Build individual service:**
```bash
# ProductService
cd src/ProductService
docker build -t productservice:latest .

# OrderService
cd src/OrderService
docker build -t orderservice:latest .

# NotificationService
cd src/NotificationService
docker build -t notificationservice:latest .
```

**Run individual service:**
```bash
# ProductService
docker run -d -p 5000:8080 --name productservice productservice:latest

# OrderService
docker run -d -p 5001:8081 --name orderservice orderservice:latest

# NotificationService
docker run -d -p 5002:8082 --name notificationservice notificationservice:latest
```

## Service Endpoints

| Service | Local Port | Container Port | Health Check | Swagger |
|---------|------------|----------------|-------------|---------|
| ProductService | 5000 | 8080 | http://localhost:5000/health | http://localhost:5000/swagger |
| OrderService | 5001 | 8081 | http://localhost:5001/health | http://localhost:5001/swagger |
| NotificationService | 5002 | 8082 | http://localhost:5002/health | http://localhost:5002/swagger |

## Testing Services

### Health Checks
```bash
# ProductService
curl http://localhost:5000/health

# OrderService
curl http://localhost:5001/health

# NotificationService
curl http://localhost:5002/health
```

### API Endpoints
```bash
# Get all products
curl http://localhost:5000/api/products

# Get all orders
curl http://localhost:5001/api/orders

# Get all notifications
curl http://localhost:5002/api/notifications
```

## Docker Compose Configuration

### Services

1. **ProductService**
   - Build context: `./src/ProductService`
   - Port mapping: `5000:8080`
   - Health check: `/health` endpoint
   - Restart policy: `unless-stopped`

2. **OrderService**
   - Build context: `./src/OrderService`
   - Port mapping: `5001:8081`
   - Health check: `/health` endpoint
   - Restart policy: `unless-stopped`

3. **NotificationService**
   - Build context: `./src/NotificationService`
   - Port mapping: `5002:8082`
   - Health check: `/health` endpoint
   - Restart policy: `unless-stopped`

### Network

All services are connected to a bridge network (`microservices-network`) allowing them to communicate with each other.

### Health Checks

Each service has a health check configured:
- **Interval:** 30 seconds
- **Timeout:** 3 seconds
- **Retries:** 3
- **Start Period:** 5 seconds

## Useful Commands

### View Running Containers
```bash
docker-compose ps
```

### View Container Status
```bash
docker ps
```

### Check Service Health
```bash
docker-compose ps
# Shows health status for each service
```

### Execute Commands in Container
```bash
# ProductService
docker-compose exec productservice sh

# OrderService
docker-compose exec orderservice sh
```

### View Resource Usage
```bash
docker stats
```

### Clean Up
```bash
# Stop and remove containers
docker-compose down

# Remove containers, networks, and volumes
docker-compose down -v

# Remove images
docker-compose down --rmi all
```

## Troubleshooting

### Service Won't Start
1. Check logs: `docker-compose logs [service-name]`
2. Verify port is not in use: `netstat -an | grep 5000`
3. Check Docker is running: `docker ps`

### Health Check Failing
1. Check if service is running: `docker-compose ps`
2. View service logs: `docker-compose logs [service-name]`
3. Test health endpoint manually: `curl http://localhost:5000/health`

### Build Errors
1. Ensure Dockerfile exists in service directory
2. Check .dockerignore doesn't exclude necessary files
3. Verify .NET SDK is available in build context

### Port Conflicts
If ports are already in use, modify `docker-compose.yml`:
```yaml
ports:
  - "5003:8080"  # Change external port
```

## Development Workflow

1. **Make code changes** in service directories
2. **Rebuild service:**
   ```bash
   docker-compose build productservice
   docker-compose up -d productservice
   ```
3. **Or rebuild all:**
   ```bash
   docker-compose up -d --build
   ```

## Production Considerations

For production, consider:
- Using environment-specific docker-compose files
- Setting up proper logging (e.g., ELK stack)
- Configuring reverse proxy (e.g., nginx)
- Using container orchestration (Kubernetes, Docker Swarm)
- Setting up monitoring and alerting
- Using secrets management for sensitive data

## Environment Variables

You can override environment variables using:
1. `.env` file in the same directory as `docker-compose.yml`
2. `docker-compose.override.yml` (not tracked in git)

Example `.env`:
```env
ASPNETCORE_ENVIRONMENT=Production
```

## Next Steps

- Add database containers (SQL Server, PostgreSQL, etc.)
- Add API Gateway container
- Add message queue (RabbitMQ, Azure Service Bus)
- Add monitoring stack (Prometheus, Grafana)
- Add logging stack (ELK, Seq)
