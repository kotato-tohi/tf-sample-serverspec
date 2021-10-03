variable "tag_prefix" {
  description = "resource name prefix"
  type        = string
}

variable "az_list" {
  type    = list(string)
  default = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}

variable "az_num_list" {
  type    = list(string)
  default = ["1a", "1c", "1d"]
}


variable "resource_cnt" {
  type = number
}


variable "ec2_conf" {
  type = map(string)
  default = {
    # ami           = ""
    # instance_type = ""
    # key_pair      = ""
  }
}