#!/usr/bin/env bash
docker build -t navendux/multi-client:latest -t navendux/multi-client:$GIT_SHA -f ./client/Dockerfile ./client
docker build -t navendux/multi-server:latest -t navendux/multi-server:$GIT_SHA -f ./server/Dockerfile ./server
docker build -t navendux/multi-worker:latest -t navendux/multi-worker:$GIT_SHA -f ./worker/Dockerfile ./worker

# Take those images and push them to docker hub
docker push navendux/multi-client:latest
docker push navendux/multi-client:$GIT_SHA
docker push navendux/multi-server:latest
docker push navendux/multi-server:$GIT_SHA
docker push navendux/multi-worker:latest
docker push navendux/multi-worker:$GIT_SHA
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=navendux/multi-server:$GIT_SHA
kubectl set image deployments/client-deployment server=navendux/multi-client:$GIT_SHA
kubectl set image deployments/worker-deployment server=navendux/multi-worker:$GIT_SHA