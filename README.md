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

3. Image information
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

### Module

## Contributors 

- [Maya Iuga]([https://github.com/yourusername](https://github.com/maya-a-iuga))

## License

This project is licensed under the MIT License. For more details, refer to the [LICENSE](LICENSE) file.
