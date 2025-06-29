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
- A key was created in order to access the instance via ssh.
- A security step can be added to the `.pub` file to encrypt it using sealed-secrets.

### Infrastructure Provisioning
I will continue working on that step, but here is the approach I will take in the ansible playbook:
* Install K3s on the instance.
* Install Helm in order to use the prometheus helm chart or the kube-prometheus stack in order to visualize using Grafana.
* Apply the application manifest files.
* Create a Kubernetes ServiceMonitor to scrape the endpoints.
