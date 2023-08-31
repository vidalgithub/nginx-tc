resource "null_resource" "generate_keys" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "ssh-keygen -t rsa -b 2048 -f ~/.ssh/nginx -N \"\""
  }
}
  

resource "aws_key_pair" "example" {
   key_name   = "nginx"
  public_key = file("~/.ssh/nginx.pub")  

  tags = {
    Name = "${local.resource_name_prefix}keypair"
  }
}
