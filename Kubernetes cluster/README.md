# Ansible Kubernetes Deployment

This folder contains Ansible roles, playbooks, and inventory for deploying and managing a Kubernetes cluster.

## Structure

- `roles/`: Directory containing Ansible roles
- `hosts`: Inventory file defining the target hosts
- `ping.yml`: Playbook for testing connectivity to hosts
- `playbook.yml`: Main playbook for Kubernetes deployment and management

## Recent Updates

- Roles have been modified to dynamically use `ansible_user` for paths and commands
- The main playbook (`playbook.yml`) has been updated to upgrade Kubernetes to version 1.29

## Usage

1. Ensure you have Ansible installed on your control node.
2. Update the `hosts` file with your target servers' information.
3. Review and modify the roles in the `roles/` directory as needed.
4. Run the ping playbook to test connectivity: `ansible-playbook -i hosts ping.yml`
5. Execute the main playbook to deploy or update your Kubernetes cluster: `ansible-playbook -i hosts playbook.yml`
## Roles

The `roles/` directory contains various roles for setting up different components of the Kubernetes cluster. Each role has been updated to use `ansible_user` dynamically for improved flexibility across different environments.

## Inventory

The `hosts` file defines the inventory of target hosts. It has been updated to work with the dynamic `ansible_user` implementation in the roles.

## Playbooks

- `ping.yml`: Use this playbook to verify connectivity to your hosts.
- `playbook.yml`: The main playbook for Kubernetes deployment and management. It has been recently updated to support Kubernetes version 1.29.

## Contributing

If you'd like to contribute to this project, please submit a pull request with your proposed changes.


