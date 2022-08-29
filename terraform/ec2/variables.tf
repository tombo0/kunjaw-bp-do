variable "ami" {
  default = "ami-02f3416038bdb17fb"
}

variable "key_name" {
  default = "taufik_kurikulum_kp_us-east-2"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "vpc_security_group_ids" {
  default = ["sg-03b93748bea3e1a39"]
}

variable "associate_public_ip_address" {
  default = true
}