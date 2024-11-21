# Automated Kubernetes Cluster on Azure  

This repository contains files to automate the provisioning and configuration of a Kubernetes cluster on Azure using Terraform and Ansible.  

## Directory Overview  

- **Infrastructure provisioning files/**  
  Contains Terraform files for provisioning Azure infrastructure, including virtual machines, storage, and networking.  

- **Kubernetes cluster/**  
  Contains Ansible playbooks for setting up and configuring a Kubeadm-based Kubernetes cluster on the provisioned infrastructure.  

## How to Use  

1. **Provision Infrastructure**  
   Navigate to the `Infrastructure provisioning files/` directory and use Terraform to provision the Azure infrastructure:  

   ```bash
   terraform init  
   terraform apply  
