provider aws {
    region = var.web_region
}

resource "aws_security_group" "ec2_webserver_security_group" {
  name        = "EC2-webserver-SG"
  description = "Webserver for EC2 Instances"
  
  ingress {
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22
    cidr_blocks = ["115.97.103.44/32"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "webserver" {
    instance_type = var.web_instance_type
    ami           = var.ami_id
    count         = 2
    key_name      = "jagstechvideodemo"
    tags = {
      Name = "Apache_Webserver_${count.index}",
    }
    security_groups = ["${aws_security_group.ec2_webserver_security_group.name}"]
    user_data = <<-EOF
      #!/bin/sh
      sudo apt-get update
      sudo apt install -y apache2
      sudo systemctl status apache2
      sudo systemctl start apache2
      sudo chown -R $USER:$USER /var/www/html
      sudo echo "<html><body><h1>Hello from Webserver at instance id `curl http://169.254.169.254/latest/meta-data/instance-id` </h1></body></html>" > /var/www/html/index.html
      EOF
}
