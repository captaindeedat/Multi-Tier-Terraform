provider "aws" {
  region = "us-west-2"
}

# Security Group for EC2 instances
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Security group for EC2 instances"
  
  // Allow SSH from your IP and HTTP from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["YOUR_IP/32"] // Replace with your IP
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for Load Balancer
resource "aws_security_group" "lb_sg" {
  name        = "lb-security-group"
  description = "Security group for Load Balancer"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Key Pair
resource "aws_key_pair" "ec2_keypair" {
  key_name   = "aws-lift"
  public_key = file("path/to/aws-lift.pub") // Provide the path to your public key file
}

# EC2 Instances
resource "aws_instance" "ec2_instances" {
  count         = 2
  ami           = "ami-xxxxxxxxxxxxx" // Specify your desired AMI ID
  instance_type = "t2.micro"          // Or any other instance type you prefer
  subnet_id     = aws_default_subnet.default.id
  security_groups = [aws_security_group.ec2_sg.name]
  key_name      = aws_key_pair.ec2_keypair.key_name
  user_data     = file("path/to/script.sh") // Provide the path to your script file
  
  tags = {
    Name = "EC2Instance-${count.index + 1}"
  }
}

# Target Group
resource "aws_lb_target_group" "target_group" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.default.id
}

# Application Load Balancer
resource "aws_lb" "application_load_balancer" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_default_subnet.default[*].id

  enable_deletion_protection = false

  tags = {
    Name = "my-alb"
  }
}

# Attach EC2 instances to Target Group
resource "aws_lb_target_group_attachment" "target_group_attachment" {
  count             = 2
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.ec2_instances[count.index].id
  port             = 80
}

# Listener
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.target_group.arn
    type             = "forward"
  }
}
