# Terraform AWS ECS on EC2 - Complete Infrastructure

A complete, production-ready Terraform setup for deploying containerized applications on AWS ECS using EC2 launch type (Free Tier eligible).

## 🎯 What This Deploys

- **VPC** with public subnet, internet gateway, and route table
- **EC2 Instance** (t3.micro) running ECS agent
- **ECS Cluster** (EC2 launch type)
- **ECS Service** running containerized application
- **ECR Repository** for Docker images
- **IAM Roles** for ECS tasks and EC2 instances
- **Security Groups** for SSH (22) and application (8080)
- **CloudWatch Logs** for container logging

## 📁 Project Structure

```
terraform_KT/
├── main.tf                  # Root module orchestrating all resources
├── variables.tf             # Input variables with defaults
├── outputs.tf              # Output values (IPs, URLs, names)
├── terraform.tfvars        # Environment-specific values
├── user_data.sh            # EC2 bootstrap script for ECS agent
├── test-app/               # Sample Docker application
│   └── Dockerfile
└── modules/
    ├── vpc/               # VPC, subnet, IGW, routes
    ├── ec2/               # EC2 instance, security group, key pair
    ├── ecs/               # ECS cluster
    ├── ecs_service/       # ECS task definition and service
    ├── ecr/               # ECR repository
    └── iam/               # IAM roles and policies
```

## 🚀 Deployment

### Prerequisites
- AWS CLI configured with credentials
- Terraform >= 1.2.0
- Docker Desktop (for building images)
- SSH public key

### Step 1: Configure Variables

Edit `terraform.tfvars`:
```hcl
env = "dev"
ssh_public_key = "ssh-rsa YOUR_PUBLIC_KEY_HERE"
tags = {
  Owner       = "YourName"
  Environment = "dev"
}
```

### Step 2: Deploy Infrastructure

```bash
terraform init
terraform plan
terraform apply
```

### Step 3: Build and Push Docker Image

**Important:** Build for linux/amd64 architecture:

```bash
cd test-app

# Authenticate to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(terraform output -raw ecr_repo_url | cut -d'/' -f1)

# Build for correct architecture
docker build --platform linux/amd64 -t test-app:latest .

# Tag and push
docker tag test-app:latest $(terraform output -raw ecr_repo_url):latest
docker push $(terraform output -raw ecr_repo_url):latest
```

### Step 4: Verify Deployment

```bash
# Check ECS service status
aws ecs describe-services --cluster $(terraform output -raw ecs_cluster_name) --services $(terraform output -raw ecs_service_name) --region us-east-1

# Test the application
curl http://$(terraform output -raw ec2_public_ip):8080
```

## 🌍 Multi-Environment Setup

To deploy the same infrastructure for INTEG or PROD:

### Option 1: Using Different tfvars Files

```bash
# Create integ.tfvars
cp terraform.tfvars integ.tfvars

# Edit integ.tfvars
env = "integ"
prefix = "terraform-demo-integ"
tags = {
  Owner       = "YourName"
  Environment = "integ"
}

# Deploy
terraform apply -var-file="integ.tfvars"
```

### Option 2: Using Terraform Workspaces

```bash
# Create integ workspace
terraform workspace new integ
terraform workspace select integ

# Update terraform.tfvars for integ
terraform apply
```

## 📊 Deployed Resources

| Resource | Details |
|----------|---------|
| **EC2 Public IP** | `terraform output ec2_public_ip` |
| **Application URL** | `http://<ec2-ip>:8080` |
| **ECR Repository** | `terraform output ecr_repo_url` |
| **ECS Cluster** | `terraform output ecs_cluster_name` |
| **ECS Service** | `terraform output ecs_service_name` |

## 🔍 Debugging & Verification

### Check if EC2 Joined ECS Cluster

```bash
aws ecs list-container-instances --cluster $(terraform output -raw ecs_cluster_name) --region us-east-1
```

### SSH into EC2 Instance

```bash
ssh ec2-user@$(terraform output -raw ec2_public_ip)

# Once logged in, check:
sudo cat /etc/ecs/ecs.config
sudo docker ps
sudo cat /var/log/ecs/ecs-agent.log
```

### View ECS Task Logs

```bash
aws logs tail /ecs/terraform-demo --follow --region us-east-1
```

### Check ECS Service Status

```bash
aws ecs describe-services \
  --cluster $(terraform output -raw ecs_cluster_name) \
  --services $(terraform output -raw ecs_service_name) \
  --region us-east-1 \
  --query 'services[0].[serviceName,status,runningCount,desiredCount]'
```

## 🛠️ Module Descriptions

### VPC Module (`modules/vpc/`)
Creates networking infrastructure with:
- VPC with customizable CIDR
- Public subnet
- Internet Gateway
- Route table with route to IGW

### EC2 Module (`modules/ec2/`)
Manages compute resources:
- Security group (SSH + port 8080)
- EC2 key pair from SSH public key
- EC2 instance with ECS-optimized AMI
- User data script to join ECS cluster

### IAM Module (`modules/iam/`)
Creates IAM roles:
- **ECS Instance Role**: Allows EC2 to communicate with ECS
- **ECS Task Execution Role**: Allows ECS to pull images and write logs

### ECR Module (`modules/ecr/`)
Creates Docker image repository with mutable tags

### ECS Module (`modules/ecs/`)
Creates ECS cluster for EC2 launch type

### ECS Service Module (`modules/ecs_service/`)
Manages containerized workload:
- Task definition with container specs
- ECS service with desired count
- CloudWatch log group for container logs

## 💰 Cost Optimization

This setup uses **Free Tier eligible resources**:
- ✅ t3.micro EC2 instance (750 hours/month free)
- ✅ ECR (500 MB storage free)
- ✅ CloudWatch Logs (5 GB free)
- ✅ ECS (no additional charge)

**Estimated cost:** $0-5/month (depending on usage beyond free tier)

## 🧹 Cleanup

To destroy all resources:

```bash
terraform destroy
```

**Note:** Manually delete Docker images from ECR if needed:
```bash
aws ecr batch-delete-image \
  --repository-name terraform-demo-repo \
  --image-ids imageTag=latest \
  --region us-east-1
```

## 📝 Important Notes

1. **Architecture**: Always build Docker images with `--platform linux/amd64` flag if building on Mac M1/M2
2. **Security**: The security group allows SSH from anywhere (0.0.0.0/0). Restrict to your IP in production
3. **Logs**: Container logs are retained for 7 days in CloudWatch
4. **Updates**: To deploy new image versions, push to ECR and run:
   ```bash
   aws ecs update-service --cluster <cluster> --service <service> --force-new-deployment
   ```

## 🎓 Learning Resources

- [AWS ECS Documentation](https://docs.aws.amazon.com/ecs/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [ECS Task Definitions](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definitions.html)

## 🤝 Contributing

This is a demo/learning project. Feel free to modify and extend as needed!

## 📄 License

This project is for educational purposes.

---

**Environment:** DEV
**Last Updated:** October 30, 2025
**Status:** ✅ Fully Operational

