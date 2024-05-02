# smallcase-DevOps-Assignment

1. Terraform Configuration:
   I've created Terraform code to launch an EC2 server with a public IP. You're using a dynamic AMI to ensure that the server is always launched with the latest available image. Additionally, you're attaching a KMS encrypted EBS volume of 10GiB to the EC2 instance. This ensures data security and persistence.

2. CI/CD Approach:
   I've implemented a small CI/CD approach. As soon as the EC2 instance launches, a script runs to create an inventory file with the IP address of the launched EC2 server. This allows dynamic management of server configurations.

3. Python Application and Docker:
   I've developed a Python application and written a Dockerfile for it. 

4. Integration with Ansible:
   I've integrated my Docker setup with Ansible. Ansible is being used for configuration management and deployment automation. 

5. Docker Build Playbook:
   The first Ansible playbook, `docker-build`, is responsible for building the Docker images. It authenticates with Docker Hub and pushes the images. This ensures that the latest version of your application is available in the Docker Hub repository.

6. Docker Launch Playbook:
   The second Ansible playbook, `docker-launch`, adds the Docker repository, installs dependencies, starts the Docker service, and pulls the latest images from Docker Hub. It then launches the container with the respective port mappings, making the application accessible.
