region = "us-east-2" #Region Name where you want to provision the application
access_key = "<AWS_Access_Key>" #AWS Access Key
secret_key = "<AWS Secret Access Key>" #AWS Secret Key

ssh_key_name = "ssh_key_pair" #Name of the rsa keypair to be created. It will create the keyfile in the root module directory for furure use

provision_app = "true" #Flag to provision app instances
app_instance_count = 3 #How many application instances to provision
app_instance_type = "t2.micro" #Application instance Type
app_userdata_path = "files/app_deploy.sh" #Path where the application deployment script exists

provision_web = "true" #Flag to provision web instance
web_instance_count = 1 #Number of reverse proxy webserver to be created
web_instance_type = "t2.micro" #Web Server instance type
# web_userdata_script_path = "files/web_deploy.sh"

vpc_id = "default" #VPC Id where to provision the resources. i.e: if you want to use default vpc put "default" else put vpc_id like "vpc-caec7db7"