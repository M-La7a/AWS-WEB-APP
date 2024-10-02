resource "aws_launch_configuration" "web" {
  name          = "web-launch-config"
  image_id      = "ami-0ebfd941bbafe70c6"  # Replace with your valid AMI
  instance_type = "t2.micro"
  iam_instance_profile = "LabInstanceProfile"
  key_name = "key"
  //kms_name = data.aws_kms_key.existing_key.arn
  security_groups = [
    aws_security_group.app_sg.id
  ]

  user_data = <<-EOF
  #!/bin/bash -xe
  apt update -y
  apt install nodejs unzip wget npm mysql-client -y
  wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACCAP1-1-79581/1-lab-capstone-project-1/code.zip -P /home/ubuntu
  cd /home/ubuntu
  unzip code.zip -x "resources/codebase_partner/node_modules/*"
  cd resources/codebase_partner
  npm install aws aws-sdk
  export APP_PORT=80
  npm start &
  echo '#!/bin/bash -xe
  cd /home/ubuntu/resources/codebase_partner
  export APP_PORT=80
  npm start' > /etc/rc.local
  chmod +x /etc/rc.local
  EOF
}

resource "aws_instance" "jump_server" {
  ami           = "ami-0ebfd941bbafe70c6"  # Use a valid Ubuntu AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_1.id  # Ensure it's in the public subnet
  security_groups = [aws_security_group.jump_sg.id]  # SSH access allowed
  key_name = "key"
  associate_public_ip_address = true
  tags = {
    Name = "JumpServer"
  }
}
