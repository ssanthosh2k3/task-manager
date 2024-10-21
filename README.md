# End-to-End CI/CD Workflow for a Java To-Do Application Using Jenkins and Kubernetes

This project demonstrates a Continuous Integration and Continuous Deployment (CI/CD) pipeline for a Java application using Jenkins, Docker, and Kubernetes. The pipeline includes automated build and deployment processes, ensuring that the latest code changes are always deployed.

## Prerequisites

Before you begin, ensure you have the following installed and configured:

- A Jenkins node with the following tools:
  - **Trivy**: For container security scanning.
  - **kubectl**: To interact with your Kubernetes cluster.
  - **Docker**: To build and push Docker images.
  - **Maven**: For building the Java application.
- Access to a Kubernetes (K8) cluster.

The project repository should include the following files and directories:

. ├── application_code/ # Your Java application code ├── Jenkinsfile # Jenkins pipeline configuration └── Dockerfile # Dockerfile for building the application image



## Steps to Set Up the CI/CD Pipeline

### Step 1: Create GitHub Repository

1. Create a new GitHub repository.
2. Commit all project code (application code, `Jenkinsfile`, `Dockerfile`) into the repository under the main branch.

### Step 2: Install Required Tools on Jenkins Server

- Install the following tools on the Jenkins server:
  - **Trivy**
  - **kubectl**
  - **Docker**

*Note: If using worker nodes, ensure that all dependencies are installed on those nodes as well.*

### Step 3: Write a Pipeline Script

- Create a Jenkins pipeline script to:
  - Checkout code from GitHub.
  - Build the Docker image.
  - Push the Docker image to Docker Hub.

![Pipeline Script](https://github.com/ssanthosh2k3/task-manager/blob/main/assests/java-docker-repo.png)

### Step 4: Install Jenkins Plugins

- Install the following plugins via the Jenkins dashboard:
  - **Docker Pipeline**
  - **Kubernetes Plugin**
  - **Git Plugin**
  - **Kubernetes Credentials Plugin**

- Add Docker Hub credentials as secret text in the Jenkins dashboard.
- Configure a generic webhook trigger for the Docker Hub webhook.

### Step 5: Add Credentials and Kube Config

- Navigate to the credentials section in Jenkins and add:
  - Docker Hub credentials.
  - Kube config file.

![Credentials Configuration](https://github.com/ssanthosh2k3/task-manager/blob/main/assests/cred.png)

### Step 6: Create Pipeline from Docker Hub to Kubernetes Cluster

- Create a new Jenkins job (Job name: **Task-manager**) to deploy the application from Docker Hub to your Kubernetes cluster.

![Jenkins Job Configuration](https://github.com/ssanthosh2k3/task-manager/blob/main/assests/jenkinsjobs.png)

### Step 7: Create Deployment File

- Create a deployment YAML file to specify the desired state of your application. Save the following configuration in a file named `deployment.yaml`:

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

```


### Step 8: Configure Webhook in Docker Hub

Set up a webhook in Docker Hub with the token for the project repository. This allows Docker Hub to notify Jenkins whenever a new image is pushed.

### Step 9: Create Kubernetes Deployment Pipeline

Develop a Jenkins pipeline that triggers on Jenkins jobs or any push events to deploy the latest image to the Kubernetes cluster. This ensures that your application is always running the most recent version.

### Step 10: Create Load Balancer Service

Set up a LoadBalancer service to expose the deployment. Save the following configuration in a file named `service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: java-task-service
  namespace: default
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
  selector:
    app: java-task
```
## Additional Notes

- In the Jenkins pipeline, add the `kubectl rollout restart` command to reflect any changes in the deployment.
- Set the deployment file `imagePullPolicy` to `Always` to ensure that the latest image is always pulled.
- Use the `latest` tag for your Docker image to see the newest version of the application.

## Tools Used

- **Trivy**: For scanning Docker images for vulnerabilities.
- **Kubernetes (K8)**: For managing containerized applications.
- **Jenkins**: For continuous integration and continuous deployment.
- **Docker**: For containerizing the Java application.
- **Docker Hub**: For storing Docker images.
- **GitHub**: For version control of the project.

## Learning Outcomes

Through this project, you will learn:

- Principles of Continuous Integration and Continuous Deployment (CI/CD).
- How to manage Kubernetes deployments and services.
- Automation using Jenkins.
- Writing Dockerfiles and managing Docker images.




