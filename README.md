# Java Application CI/CD with Jenkins and Kubernetes

This project demonstrates a Continuous Integration and Continuous Deployment (CI/CD) pipeline for a Java application using Jenkins, Docker, and Kubernetes. The pipeline includes automated build and deployment processes, ensuring that the latest code changes are always deployed.

## Prerequisites

- A Jenkins node with the following installed:
  - Trivy
  - kubectl
  - Docker
  - Maven
- Access to a Kubernetes (K8) cluster.

## Project Structure

The project repository should include the following files:

- Application code
- `Jenkinsfile`
- `Dockerfile`

## Steps to Set Up the CI/CD Pipeline

### Step 1: Create GitHub Repository

1. Create a GitHub repository.
2. Commit all project code in the repository under the main branch.

### Step 2: Install Required Tools on Jenkins Server

- Install the following tools on the Jenkins server:
  - Trivy
  - kubectl
  - Docker

*Note: If using worker nodes, ensure all dependencies are installed on those nodes as well.*

### Step 3: Write a Pipeline Script

- Create a pipeline script in Jenkins to:
  - Checkout code from GitHub.
  - Build the Docker image.
  - Push the Docker image to Docker Hub.

![Docker Image Example](https://github.com/ssanthosh2k3/task-manager/blob/main/assests/java-docker-repo.png)

### Step 4: Install Jenkins Plugins

- Install the following plugins via the Jenkins dashboard:
  - Docker Pipeline
  - Kubernetes Plugin
  - Git Plugin
  - Kubernetes Credentials Plugin

- Add Docker Hub credentials as secret text in the Jenkins dashboard.
- Configure a generic webhook trigger for the Docker Hub webhook.

### Step 5: Add Credentials and Kube Config

- Navigate to the credentials section in Jenkins and add:
  - Docker Hub credentials.
  - Kube config file.

![Credentials Setup](https://github.com/ssanthosh2k3/task-manager/blob/main/assests/cred.png)

### Step 6: Create Kubernetes Deployment

- Create a deployment YAML file to specify the desired state of your application.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: java-task
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: java-task
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: java-task
    spec:
      containers:
      - name: java-task
        image: santhoshadmin/java-task:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 8080
          protocol: TCP
      restartPolicy: Always
