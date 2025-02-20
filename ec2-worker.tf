provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "private_worker" {
  count         = 1
  ami           = "ami-0e1bed4f06a3b463d" # Update with the latest Ubuntu AMI
  instance_type = "t3.medium"
  iam_instance_profile = aws_iam_instance_profile.worker_profile.name

  tags = {
    Name = "Spacelift-Worker-${count.index}"
  }
 user_data = templatefile("${path.module}/user_data.sh", {
  WORKER_POOL_ID        = spacelift_worker_pool.private_workers.id
  SPACELIFT_ACCESS_KEY  = var.spacelift_access_key
  SPACELIFT_SECRET_KEY  = var.spacelift_secret_key
})

}
 

resource "aws_iam_role" "worker_role" {
  name = "SpaceliftWorkerRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_instance_profile" "worker_profile" {
  name = "SpaceliftWorkerProfile"
  role = aws_iam_role.worker_role.name
}
