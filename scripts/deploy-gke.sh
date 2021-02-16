#!/bin/bash
# This script will deploy a new GKE cluster in a default network
# Please  provide the 6 arguments in this order PROJECT_ID, FOLDER_ID, BILLING, REGION, CLUSTER_NAME and NUMBER_OF_NODES
# Example : ./deploy-gke.sh gke-project-demo 422615538687 3461CD-G9A478-AF75C9 europe-west2-a gke-cluster1 2


# Variables
PROJECT_ID=${1} # The Google Project ID (example "gke-project-demo")
FOLDER_ID=${2} # the folder id  of the parent folder
BILLING=${3}  # the billing account number you want to associate the project
REGION=${4}  # The Region where the cluster is deployed (example "europe-west2-a")
CLUSTER_NAME=${5} # The name of the cluster (example "gke-cluster1")
NUMBER_OF_NODES=${6} # The number of nodes (example "2")

usage() {
 echo "Usage: ${0} [PROJECT_NAME] [FOLDER_ID] [BILLING_ACCOUNT] [REGION] [CLUSTER_NAME] [NUMBER_OF_NODES] " >&2
 echo "Example :"
 echo
 echo " ./deploy-gke.sh gke-project-demo 422615538687 3461CD-G9A478-AF75C9 europe-west2-a gke-cluster1 2"
 echo
 exit 1
}

if [[ "${#}" -lt 6 ]]
then
    usage
fi

# Create a  new project
gcloud projects create ${PROJECT_ID} --folder=${FOLDER_ID} |& cat -n


# Link new project to existing billing account
gcloud alpha billing projects link ${PROJECT_ID} --billing-account ${BILLING}

# Set the configuration of your project
gcloud config set project ${PROJECT_ID}

# Enabble container apis
gcloud services enable compute.googleapis.com

# Enabble container apis
gcloud services enable container.googleapis.com

# Create a new network
gcloud compute networks create default

# Set the region for your GKE Cluster
gcloud config set compute/zone ${REGION}

# Create the GKE Cluster
gcloud container clusters create ${CLUSTER_NAME} --num-nodes=${NUMBER_OF_NODES}

# Configure kubectl to use the cluster
gcloud container clusters get-credentials ${CLUSTER_NAME}

# Display the nodes
kubectl get nodes

exit 0
