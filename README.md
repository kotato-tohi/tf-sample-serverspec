# tf-sample-serverspec
serverspecでテストするための環境

# Features

## aws 
* VPC(Subnet/Igw/Route)
* EC2(Sg/EC2Instance)

## ruby
* Bundler version 2.2.20
* serverspec
* rake

# Requirement 
* Terraform  v1.0.6
* ruby v3.0.1

# Installation
```zsh
$ git clone
## edit:terraform.tfvars
$ terraform init
$ terraform apply
$ cd serverspec
$ bundle install --path 
$ bundle exec serverspec-init
# edit:~/.ssh/config
```

``` : ~/.ssh/config
  Host test-target-server
    HostName [EC2 Instance IP adder]
    IdentityFile YOUR_SECRET_KEY.pem
    User ec2-user
```

## terraform.tfvars sample

```
tag_prefix   = "tf-sample-serverspec"
resource_cnt = 1

ec2_conf = {
  ami           = "ami-02892a4ea9bfa2192"
  instance_type = "t2.micro"
  key_pair      = "YOUR_SECRET_KEY.pem"
}
```


## serverspec sample

# Note


# Author 
* kotato-tohi