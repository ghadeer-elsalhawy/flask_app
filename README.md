# Kubernetes Web Application with Prometheus Monitoring

## Steps and Insights

### Flask Application
- The application is built using Flask with 2 endpoints `/gandalf` and `/colombo` in addition to the `/metrics` endpoint to export the prometheus metrics for total requests for each URI
- The Dockerfile uses Gunicorn as the production WSGI server to run the Flask application.

### K8s Manifests
- The manifest file exposes port `80` for the application.
- Resource limitation has been added to the deployment to ensure efficient CPU and memory usage.

### Infrastructure Provisioning
- Used Terraform to create AWS security group, EC2 instance, and an elastic group to ensure that the application has a static IP
- The EC2 key is first generated locally and passed to the ec2
- Terraform automatically creates the key file locally to be used afterwards by ansible.
- Terraform saves the elastic IP in host file to be used by ansible to access the VM.

### Infrastructure Configuration
- Ansible access the VM using the hosts and key files created previously by Terraform.
- The playbook installs K3s (light weight k8s distribution) and helm if not installed.
- Used Kube-prometheus-stack helm chart to be able to use ServiceMonitor.
- Added custom values for prometheus helm chart to be accessed from another machine.

Note: Ansible playbook was tested successfully on multipass VM and the instance type was chosen based on the multipass VM resources usage.
