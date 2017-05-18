provider "aws" {
  region = "ca-central-1"
}

resource "aws_instance" "test" {
  ami = "ami-9062d0f4"
  instance_type = "t2.micro"
  key_name = "can01"
  security_groups = ["launch-wizard-4"]
  user_data = <<-EOF
              #!/bin/sh
              echo -e 'PS1="\u@\h:\w> "\nset -o vi' >> /etc/bashrc
              echo -e "preserve_hostname: true" >> /etc/cloud/cloud.cfg
              echo -e "redhat02" > /etc/hostname
              echo -e "\nPort 443" >> /etc/ssh/sshd_config
              echo -e "0 17 * * * /sbin/init 0" > /var/spool/cron/root
              chown root:root /var/spool/cron/root
              chmod 600 /var/spool/cron/root
              semanage port -m -t ssh_port_t -p tcp 443
              service sshd restart
              nohup sleep 360; init 6
              EOF
  tags {
    Name = "redhat02"
  }
}
