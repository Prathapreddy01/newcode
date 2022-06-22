provider "aws" {
  access_key = "AKIA3H44NZGG5UGMVMDV"
     secret_key = "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"
     region     = "us-east-1"
}

#Plan - execute 
resource "aws_s3_bucket" "my_s3_bucket" {
    bucket = "yeswinmys3bucket1"
    versioning {
        enabled = true
    }
}

resource "aws_iam_user" "my_iam_user"{
    name = "prathap"
}

resource "aws_default_vpc" "default" {
}

resource "aws_security_group" "http_security_group" {
  name = "http_security_group"
  vpc_id = aws_default_vpc.default.id	

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 }
  tags = {
    name = "http_server_sg"
  }
}

resource "aws_instance" "http_server" {
  ami      		= "data.aws_ami.aws_linux_2_latest.id"
  key_name              = "default_ec2"
  instance_type         = "t2.micro"
 
  connection {
    host        = self.public_ip
    type = "ssh"
    user = "ec2_user"
 }

provisioner "remote-exec" {
  inline = [
    "yum install httpd -y",
    "service httpd start",
    "echo welcome http server"
   ]
 } 
}

resource "aws_elb" "elb" {
  name = "elb"

 listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}


resourcce "aws_ec2" "temp" {
  instance_port = 8080
  instance_type = "t2.micro"
}

listener {
  instance_port = 8080
  instance_type = "t2.micro"
}