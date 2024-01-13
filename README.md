# Web-App-DevOps-Project

Welcome to the Web App DevOps Project repo! This application allows you to efficiently manage and track orders for a potential business. It provides an intuitive user interface for viewing existing orders and adding new ones.

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
- [Technology Stack](#technology-stack)
- [Contributors](#contributors)
- [License](#license)

## Features

- **Order List:** View a comprehensive list of orders including details like date UUID, user ID, card number, store code, product code, product quantity, order date, and shipping date.
  
![Screenshot 2023-08-31 at 15 48 48](https://github.com/maya-a-iuga/Web-App-DevOps-Project/assets/104773240/3a3bae88-9224-4755-bf62-567beb7bf692)

- **Pagination:** Easily navigate through multiple pages of orders using the built-in pagination feature.
  
![Screenshot 2023-08-31 at 15 49 08](https://github.com/maya-a-iuga/Web-App-DevOps-Project/assets/104773240/d92a045d-b568-4695-b2b9-986874b4ed5a)

- **Add New Order:** Fill out a user-friendly form to add new orders to the system with necessary information.
  
![Screenshot 2023-08-31 at 15 49 26](https://github.com/maya-a-iuga/Web-App-DevOps-Project/assets/104773240/83236d79-6212-4fc3-afa3-3cee88354b1a)

- **Data Validation:** Ensure data accuracy and completeness with required fields, date restrictions, and card number validation.

## Getting Started

### Prerequisites

For the application to succesfully run, you need to install the following packages:

- flask (version 2.2.2)
- pyodbc (version 4.0.39)
- SQLAlchemy (version 2.0.21)
- werkzeug (version 2.2.3)

### Usage

To run the application, you simply need to run the `app.py` script in this repository. Once the application starts you should be able to access it locally at `http://127.0.0.1:5000`. Here you will be meet with the following two pages:

1. **Order List Page:** Navigate to the "Order List" page to view all existing orders. Use the pagination controls to navigate between pages.

2. **Add New Order Page:** Click on the "Add New Order" tab to access the order form. Complete all required fields and ensure that your entries meet the specified criteria.

## Technology Stack

- **Backend:** Flask is used to build the backend of the application, handling routing, data processing, and interactions with the database.

- **Frontend:** The user interface is designed using HTML, CSS, and JavaScript to ensure a smooth and intuitive user experience.

- **Database:** The application employs an Azure SQL Database as its database system to store order-related data.

## Docker containerization

1. Details about building the application's Dockerfile - dockerfile.
  1.1 Base image is build on **python:3.8-slim**
  1.2 The working directory is set to **/app**
  1.3 Files are coppied from the current directory **..** or **/app**
  1.4 Installation runs completed in the listed order:
   - System dependencies
   - ODBC driver
   - pip
   - setuptools
   - python packages (based on requirements.txt)
  1.5 Access to application granted by exposing port 5000
  1.6 Startup command [python] [CMD]
#### Local environemnt
- flask (version 2.2.2)
- pyodbc (version 4.0.39)
- SQLAlchemy (version 2.0.21)
- werkzeug (version 2.2.3)

#### Azure Kubernetes Cluster (active)
- flask (version 2.2.2)
- pyodbc (version 4.0.39)
- SQLAlchemy (version 2.0.21)
- werkzeug (version 2.2.3)
- azure-identity (version 1.15.0)
- azure-keyvault-secrets (version 4.7.0) 

2. Docker commands used throughout the project, including building the Docker image, running containers, tagging, and pushing to Docker Hub. Provide examples and explanations for each command.
   docker build -t ivanyankov993/iy-app:latest
   docker tag <name of the image> <docker-hub-username>/<image-name>:<tag>
   docker push
   docker pull
   
   docker run -p 5000:5000 ivanyankov993/iy-app:latest

   http://127.0.0.1:5000

4. Image information
ivanyankov993/iy-app:latest
- dockerhub    -> ivanyankov993
- Image name   -> iy-app
- Tags         -> latest # include tag for operating in local environment.
- image currently setup for operations on Azure Kubernetes Server (AKS) with Azure Key Vault and Azure Secrets Management.

## Infrastructure as Code (IaC)
### Steps taken to define the networking resources

0   Create a service principal, defined the azure provider and set remote state file management.
1   Created a directory tree of root and two dir (networking-module and aks-cluster-module)
1.1 Each Dir contain a variabls.tf outputs.tf main.tf 
1.2 Root contains main.tf

root/
│
└── main.tf
│
└── networking-module/
│   │   main.tf
│   │   variables.tf
│   │   outputs.tf
│
└── aks-cluster-module/
    │   main.tf
    │   variables.tf
    │   outputs.tf

### Rresource created, their purpose, and any dependencies. 
### root
main.tf 
  - provide service principal, the azure provider and instructions for remote state file management. 
  - depends on contents in networking-module and aks-cluster-module
### networking-module
main.tf
  - creates azurerm: 
      - resource group (example)
      - VNet (example)
      - two subnets (control_plane_subnet and worker_node_subnet)
      - network security group (example) with two inbond rules
          - Inbond rule for kube-apiserver
          - Inbond rule for SSH traffic
variables.tf
    - resource_group_name
    - location
    - vnet_address_space
outputs.tf
    - vnet_id
    - control_plane_subnet_id
    - worker_node-subnet_id
    - resource_group_name
    - aks_nsg_id

### aks-cluster-module
main.tf
  - creates azurerm: 
      - kubernetes_cluster (aks_cluster)
        - default_node_pool
        - service_principal
variables.tf
    - cluster_location
    - dns_prefix
    - kubernetes_version
    - service_principal_client_id
    - service_principal_client_secret
    - and the 5 outputs produce from the networking-module/output.tf 
outputs.tf
    - aks_cluster_name
    - aks_cluster_id
    - aks_kubeconfig

Accessing the cluster
az aks get-credentials --resource-group networking-rg --name terraform-aks-cluster

kubectl port-forward <pod-name>

http://127.0.0.1:5000

## Deployment

#### Deployment and Service Manifests:
    
    The deployment manifest creates a flask-app-deployment (under name in metadata), which runs 2 replicas of the kubernets cluster (under replicas in specs). The deployment creates a container called flask-app-cotainer, using the ivanyankov993/iy-app:latest image and exposes port 5000 for the application (look in template, under spec). The deployment applies a Rolling Update where a maximum of 1 new pod is created and a maximum of 1 pod can be down/terminated. (look at strategy)

    The Service manifests creates a ClusterIP service named falsk-app-service. This service is configured to direct traffic to Pods labeled with app: flask-app. When services within the cluster want to communicate with this application, they can use the service's cluster IP address and port 80 (for internal communication) and target port 5000 is exposed by the container. The service uses a TCP protocop. 


#### Deployment Strategy: Rolling Updates 
    Reason: This approach ensures minimal or no downtime during the update process and maintains the availability and reliability of the application. It aligns with the applications requirements of remaining accessible to users throughout the update process. 
    
#### Testing and Validation: 
  Access the Cluster on the cloud
az aks get-credentials --resource-group networking-rg	--name terraform-aks-cluster
  Check if deployment and pods are running
kubectl get deployment
kubectl get pods
kubectl get nodes
  or 
kubectl get all

  Inspect errors with:, correct .yaml file and resolve errors
kubectl describe <pods/deployment/> <pod/deployment-name>

Access the applicaiton
kubectl port-forward deployment/flask-app-deployment 5000:5000
kubectl port-forward <pod-name> 5000:5000

Check application on and ensure funcitonality
http://127.0.0.1:5000



#### Include a section detailing how you plan to distribute the application to other internal users within your organization without relying on port forwarding. Describe the steps and mechanisms you would use to make the application accessible to team members. 

To make your application accessible to other internal users within your organization without relying on port forwarding, we can expose it through a Kubernetes Service of type LoadBalancer. 

LoadBalancer Service:
Modify flask-app-service in your application-manifest.yaml to use LoadBalancer type:

yaml
Copy code
apiVersion: v1
kind: Service
metadata:
  name: flask-app-service
spec:
  selector:
    app: flask-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 5000
  type: LoadBalancer
Apply the changes:

kubectl apply -f application-manifest.yaml

#### Additionally, discuss how you would share the application with external users if the need arises. Highlight any considerations or additional steps required to provide external access securely. 

Providing External Access Securely:
If you need to share the application with external users, consider using an Ingress resource along with TLS for secure external access. Below is an example:

yaml
Copy code
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: flask-app-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    cert-manager.io/cluster-issuer: "letsencrypt-prod"  # Replace with your cluster issuer
spec:
  tls:
  - hosts:
    - your-domain.com
    secretName: your-tls-secret
  rules:
  - host: your-domain.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: flask-app-service
            port:
              number: 80

## CI/CD Pipeline

information about the source repository, build pipeline, release pipeline, and integration with Docker Hub and AKS. 
Organisation & Billing
Project in Azure Devops
Security connecitons

**Source repository** is configured based on this GitHub repository IvanYankovSci993/Web-App-DevOps-Project

**Build and Start Pileline** is configured in two steps based on the azure-pipelines.yml (pipeline name IvanYankovSci993.Web-App-DevOps-Project)
 1. Creat and Push a docker image based on the latest Git Hub updates onto docker hub ivanyankov993/iy-app:latest
    1.1 Required the creation of a docker hub New Access Token via Docker and a service connection 
 2. Execute the kubernetes manifest, which creates, if necessary, the required infrastructure for AKS. 

Validation Steps:
After granting autheirsation, jobs were monitoring and errors were resolved.
- syntax
- case sensitive
- inclusing of python packages e.g. azure vault etcc.

Completed testing like in kubernetes
access to azure
az aks get-credentials --resource-group networking-rg	--name terraform-aks-cluster

verifying deployment, service and pods are running
kubectl get all

access the applicaiton in the browser
kubectl port-forward <pod-name> 5000:5000

Check application on and ensure funcitonality
http://127.0.0.1:5000

## AKS monitoring

![image](https://github.com/IvanYankovSci993/Web-App-DevOps-Project/assets/148336174/70ae9415-8c7e-44f9-ae9f-eb3507879a8f)


## Azure Key Vault
https://aks-iy.vault.azure.net/

Azure Role-Based Access Control (RBAC) 
Key Vault Administrator -> ivan.yankov.2016@uni.strath.ac.uk 

secrets - 4 
password, user, database, server - mandatory

requirements:
- azure-identity (version 1.15.0)
- azure-keyvault-secrets (version 4.7.0)
- key_vault_url  (https://aks-iy.vault.azure.net/)
- client_id (48ac02e0-f6eb-4f53-91b3-d6614d9d581c)
  
## Architercture overview:
![DevOps Pipeline Architecture(1)](https://github.com/IvanYankovSci993/Web-App-DevOps-Project/assets/148336174/a2e5ad41-9683-4b2a-90a7-55005cd4f7f5)




## Contributors 

- [Maya Iuga]([https://github.com/yourusername](https://github.com/maya-a-iuga))
- [Ivan Yankov](https://github.com/IvanYankovSci993)
## License

This project is licensed under the MIT License. For more details, refer to the [LICENSE](LICENSE) file.
