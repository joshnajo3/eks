variable "assume_role" {
  type = string
  default = "assume-role.json"
}
variable "assume_role_policy" {
  type = string
  default = "assume-role-policy.json"
}
variable "public_subnet" {
  type = string
  default = "subnet-089eab8c5e3f4b32e"
}

variable "profile_name" {
  type = string
  default = "jo"
}

variable "aws_region" {
  type = string 
  default = "us-east-2"
}
variable "cluster_name" {
  type = string 
  default = "joshna-eks"
}

variable "joshna_sg" {
  type = string 
  default = "sg-0626d219d990f2cb3"
}
