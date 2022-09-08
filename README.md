- [Local development](#local-development)
  - [Build Image](#build-image)
    - [Backend](#backend)
    - [Frontend](#frontend)
    - [Database](#database)
  - [Fire Up Minikube](#fire-up-minikube)
  - [Configure Ingress](#configure-ingress)
  - [Deployment](#deployment)
  - [Testing](#testing)
- [Staging development](#staging-development)
  - [Build Image](#build-image-1)
    - [Backend](#backend-1)
    - [Frontend](#frontend-1)
  - [Create RDS](#create-rds)
  - [Create k8s cluster with kOps](#create-k8s-cluster-with-kops)
  - [Configure Nginx Ingress Controller](#configure-nginx-ingress-controller)
  - [Configure .env](#configure-env)
  - [Deployment](#deployment-1)
  - [Testing](#testing-1)

# Local development

For local development, we build `backend`, `frontend`, and `database` separately. Then we deploy each into individual service in `minikube` cluster.

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
<your-minikube-ip>    backend.bpkurikulum.my.id
<your-minikube-ip>    frontend.bpkurikulum.my.id
127.0.1.1       hewlettpackard
...
```


## Deployment

```
cd deployment
```
```
kubectl apply -f deploy-db.yaml -n staging
```
```
kubectl apply -f configmap-be.yaml -n staging
```
```
kubectl apply -f deploy-be.yaml -n staging
```
```
kubectl apply -f ingress-be.yaml -n staging
```
```
kubectl apply -f configmap-fe.yaml -n staging
```
```
kubectl apply -f deploy-fe.yaml -n staging
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

![local-dev](/docs/local-dev.png)

# Staging development

For staging environment, we use kubernetes cluster using kOps, and database with RDS.

## Build Image

### Backend

```
cd cilist
cd backend
```
```
docker build . -t cilist_backend:staging
docker tag cilist_backend:staging <dockerhub-account>/cilist_backend:staging
docker push <dockerhub-account>/cilist_backend:staging
```

### Frontend

```
cd cilist
cd frontend
```
```
docker build . -t cilist_frontend:staging
docker tag cilist_frontend:staging <dockerhub-account>/cilist_frontend:staging
docker push <dockerhub-account>/cilist_frontend:staging
```

## Create RDS

```
cd terraform
```

Copy secret.tfvars.example

```
cp secret.tfvars.example secret.tfvars
```

Assign secret.tfvars with proper variable
Note : db_password has to be longer than 8 character.

```
db_database = "people"
db_username = "people"
db_password = "s3k0l4hd3v0p5"
```

Create RDS resource

```
terraform apply -var-file=secret.tfvars
```

Copy RDS host. We will need it later.

## Create k8s cluster with kOps

You'll need domain name for k8s cluster provisioning. Edit your domain to `kops/setup.sh` & `kops/destroy.sh` and replace `bpkurikulum.my.id`.

```
cd kops
```
```
bash setup.sh
```
Wait until output shows you your cluster is ready. Make sure your kubectl can connect to cluster.

```
Validating cluster bpkurikulum.my.id

INSTANCE GROUPS
NAME                    ROLE    MACHINETYPE     MIN     MAX     SUBNETS
master-us-east-2a       Master  t2.medium       1       1       us-east-2a
nodes-us-east-2a        Node    t2.medium       2       2       us-east-2a

NODE STATUS
NAME                    ROLE    READY
i-04eea0a28f0a2f406     node    True
i-062b10f655eeabcf4     node    True
i-0870b9d8902601a29     master  True

Your cluster bpkurikulum.my.id is ready
```

## Configure Nginx Ingress Controller

We'll configure Nginx Ingress controller with `helm`.

```
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  -n ingress-nginx --create-namespace
```

The ingress controller with create ELB. This will be out endpoint for both `backend` and `frontend` service.

```
kubectl get service ingress-nginx-controller -n=ingress-nginx
```
```
NAME                       TYPE           CLUSTER-IP       EXTERNAL-IP                                                               PORT(S)                      AGE
ingress-nginx-controller   LoadBalancer   100.70.119.170   aede63f6bd48d4881aee1819d5aed665-1708236318.us-east-2.elb.amazonaws.com   80:32347/TCP,443:32405/TCP   115m
```

Configure CNAME for backend and frontend subdomain and assign the external-ip to those two sub domain.

```
nslookup backend.bpkurikulum.my.id

Server:		192.168.200.240
Address:	192.168.200.240#53

Non-authoritative answer:
backend-staging.bpkurikulum.my.id	canonical name = aede63f6bd48d4881aee1819d5aed665-1708236318.us-east-2.elb.amazonaws.com.
Name:	aede63f6bd48d4881aee1819d5aed665-1708236318.us-east-2.elb.amazonaws.com
Address: 18.189.242.244
Name:	aede63f6bd48d4881aee1819d5aed665-1708236318.us-east-2.elb.amazonaws.com
Address: 18.216.199.135
```
```
nslookup frontend.bpkurikulum.my.id

Server:		192.168.200.240
Address:	192.168.200.240#53

Non-authoritative answer:
frontend-staging.bpkurikulum.my.id	canonical name = aede63f6bd48d4881aee1819d5aed665-1708236318.us-east-2.elb.amazonaws.com.
Name:	aede63f6bd48d4881aee1819d5aed665-1708236318.us-east-2.elb.amazonaws.com
Address: 18.216.199.135
Name:	aede63f6bd48d4881aee1819d5aed665-1708236318.us-east-2.elb.amazonaws.com
Address: 18.189.242.244
```

Edit `host` in `ingress` resource both `deployment/cilist-be-staging.yaml` and `deployment/cilist-fe-staging.yaml` with each proper subdomain.

## Configure .env

Both `backend` and frontend have each .env and will be created in `configMap`.

For backend, you have to add RDS credential. Change variable with proper variable from [RDS secret.tfstate](#create-rds).

```
...
data:
  .env: |
    # APP
    NODE_ENV=development
    BASE_URL_PORT=5000

    # Database
    DATABASE_USERNAME=people
    DATABASE_PASSWORD=s3k0l4hd3v0p5
    DATABASE_DATABASE=people
    DATABASE_HOST=rds-bp-kurikulum.cyqba9findjl.us-east-2.rds.amazonaws.com
...
```

For frontend, you have to add backend subdomain. Change variable to proper backend subdomain.

```
...
data:
  .env: |
    # APP
    REACT_APP_BACKEND_URL=http://backend.bpkurikulum.my.id/
...
```

## Deployment

Were deploying both `cilist-be-staging.yaml` and `cilist-be-staging.yaml` in order with this command

```
cd deployment
```

```
kubectl apply -f cilist-be-staging.yaml -n staging
kubectl apply -f cilist-fe-staging.yaml -n staging
```

## Testing

Simply go to frontend subdomain that has been configure to serve ingress.

If configuration is successful, you'll see 4 data like this. It means `frontend`, `backend`, and `database` successfully connected

![staging-dev-fe](/docs/staging-dev-fe.png)

Backend can be access by adding `/users` to backend subdomain.

![staging-dev-be](/docs/staging-dev-be.png)