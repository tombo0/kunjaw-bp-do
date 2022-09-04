# Local development

For localdevelopment, we build `backend`, `frontend`, and `database` separately. Then we deploy each into individual service in `minikube` cluster.

## Build Image

### Backend

```
cd cilist
cd backend
```
```
docker build . -t cilist_backend:latest
docker tag cilist_backend:latest <dockerhub-account>/cilist_backend:latest
docker push <dockerhub-account>/cilist_backend:latest
```

### Frontend

```
cd cilist
cd frontend
```
```
docker build . -t cilist_frontend:latest
docker tag cilist_frontend:latest <dockerhub-account>/cilist_frontend:latest
docker push <dockerhub-account>/cilist_frontend:latest
```

### Database

```
cd cilist
cd database
```
```
docker build . -t cilist_database:latest
docker tag cilist_database:latest <dockerhub-account>/cilist_database:latest
docker push <dockerhub-account>/cilist_database:latest
```

## Fire Up Minikube 

```
minikube start
```

## Configure Ingress

Enable minikube `ingress` addons

```
minikube addons enable ingress
```

Check minikube IP with this command

```
minikube ip
```

Then add backend host in /etc/hosts with your minikube IP

```
...
127.0.0.1       localhost
<your-minikube-ip>    backend
127.0.1.1       hewlettpackard
...
```


## Deployment

```
cd deployment
```
```
kubectl apply -f namespace.yaml
```
```
kubectl apply -f deploy-db.yaml --namespace staging
```
```
kubectl apply -f configmap-be.yaml --namespace staging
```
```
kubectl apply -f deploy-be.yaml --namespace staging
```
```
kubectl apply -f ingress-be.yaml --namespace staging
```
```
kubectl apply -f configmap-fe.yaml --namespace staging
```
```
kubectl apply -f deploy-fe.yaml --namespace staging
```

If backend can't run properly, check `logs`. And if it doesn't help, wait 2-3 minute after database deployment, then you can deploy backend


## Testing

Check frontend nodeport port

```
kubectl get svc -n staging
```

The output similar to this

```
NAME       TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
backend    ClusterIP   10.102.242.153   <none>        5000/TCP         8m5s
database   ClusterIP   10.106.4.161     <none>        3306/TCP         8m26s
frontend   NodePort    10.110.218.25    <none>        3000:30236/TCP   6m32s
```

Then go to browser and access minikubeIP:30236

If configuration is successful, you'll see 4 data like this. It means `frontend`, `backend`, and `database` successfully connected

![test](/docs/test.png)


