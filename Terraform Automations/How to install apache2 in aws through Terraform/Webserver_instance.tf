provider "aws" {
    region = var.region_webserver
}

resource "aws_security_group" "Webserver_SG" {
    name = "Webserver_SG"
    description = "Securty group for Webserver instance"

    ingress {
        from_port = 80
        protocol = "TCP"
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        protocol = "TCP"
        to_port = 22
        cidr_blocks = ["Your IP/32"] #Your IP to restrict wider access to everyone or 0.0.0.0/0 to give access for everyone which is risky and should be avoided
    }

    egress {
        from_port = 0
        protocol = "-1"
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "Webserver_Instance" {
        instance_type = var.type_webserver
        ami = var.ami_webserver
        key_name = ""
        tags = {
            name = "Webserver_Instance"
        }
        security_groups = ["${aws_security_group.Webserver_SG.name}"]
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
