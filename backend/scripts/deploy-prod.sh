#!/usr/bin/env bash
set -e

# Production Deployment Script
# Usage: ./scripts/deploy-prod.sh

echo "Starting Nihongo Learning API production deployment..."

if [ ! -f .env ]; then
  echo "Error: .env file not found. Please create one based on .env.example"
  exit 1
fi

echo "Pulling latest changes (assuming git)..."
git pull origin main || echo "Not a git repository or no upstream branch. Skipping git pull."

echo "Building Docker images..."
docker compose -f docker-compose.production.yml build

echo "Bringing down old containers safely..."
docker compose -f docker-compose.production.yml down

echo "Starting new containers in detached mode..."
docker compose -f docker-compose.production.yml up -d

echo "Waiting for database to be healthy..."
sleep 5

echo "Running migrations..."
docker compose -f docker-compose.production.yml run --rm migrate

echo "Deployment completed successfully! API should be running."
echo "You can view logs with: docker compose -f docker-compose.production.yml logs -f api"
