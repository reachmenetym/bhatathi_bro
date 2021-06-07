module "ssh_key" {
  source = "./modules/ssh_key"
  provision_ssh_key = "true"
  key_name = var.ssh_key_name
}

module "app_instance" {
  source = "./modules/app_instance"
  provision_app = var.provision_app
  vpc_id = var.vpc_id
  instance_count = var.app_instance_count
  instance_type = var.app_instance_type
  ami_id = data.aws_ami.ubuntu18.image_id
  ssh_key_name = var.ssh_key_name
  userdatab64 = filebase64("${path.root}/${var.app_userdata_path}")
}

# module "create_web_userdata" {
#   source = "./modules/create_user_data"
#   script_file_path = "${path.root}/${var.web_userdata_script_path}"
#   ip_list = module.app_instance.app_private_ips
# } 
# TODO: Need to learn template rendering

module "web_instance" {
  source = "./modules/web_instance"
  provision_web = var.provision_web
  web_instance_count = var.web_instance_count
  web_instance_type = var.web_instance_type
  ami_id = data.aws_ami.ubuntu18.image_id
  ssh_key_name = var.ssh_key_name
  vpc_id = var.vpc_id
  # userdatab64 = ""
  userdata = <<EOT
#!/bin/bash
apt upgrade
apt install nginx -y 
rm -rf /etc/nginx/sites-enabled/*
cat <<EOF > /etc/nginx/sites-enabled/proxy.conf
upstream app_backend {
  %{ for ip in module.app_instance.app_private_ips ~}
    server ${ip}:8484;
  %{ endfor ~}
}

server {
    listen 80;
    server_name _;
    location / {
      proxy_pass http://app_backend;
    }
  }
EOF

systemctl enable nginx.service
systemctl restart nginx.service
EOT

  # filebase64(module.create_web_userdata.filename)
  # depends_on = [module.app_instance]
}

data "aws_ami" "ubuntu18" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}


output "web_url" {
  value = "%{ for dns in module.web_instance.web_public_dns } http://${dns} %{endfor}"
}
