#!/usr/bin/env bash
docker build -t sparshik.azurecr.io/multi-client:latest -t sparshik.azurecr.io/multi-client:$GIT_SHA -f ./client/Dockerfile ./client
docker build -t sparshik.azurecr.io/multi-server:latest -t sparshik.azurecr.io/multi-server:$GIT_SHA -f ./server/Dockerfile ./server
docker build -t sparshik.azurecr.io/multi-worker:latest -t sparshik.azurecr.io/multi-worker:$GIT_SHA -f ./worker/Dockerfile ./worker

# Take those images and push them to docker hub
docker push sparshik.azurecr.io/multi-client:latest
docker push sparshik.azurecr.io/multi-client:$GIT_SHA
docker push sparshik.azurecr.io/multi-server:latest
docker push sparshik.azurecr.io/multi-server:$GIT_SHA
docker push sparshik.azurecr.io/multi-worker:latest
docker push sparshik.azurecr.io/multi-worker:$GIT_SHA
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=sparshik.azurecr.io/multi-server:$GIT_SHA
kubectl set image deployments/client-deployment client=sparshik.azurecr.io/multi-client:$GIT_SHA
kubectl set image deployments/worker-deployment worker=sparshik.azurecr.io/multi-worker:$GIT_SHA