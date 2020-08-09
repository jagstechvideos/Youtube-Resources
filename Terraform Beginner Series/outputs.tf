output "publicip" {
    value = "${aws_instance.webserver.*.public_ip}"
}
