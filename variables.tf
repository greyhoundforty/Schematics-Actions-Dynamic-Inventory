variable "region" {
  description = "The IBM Cloud VPC region where resources will be deployed."
  type        = string
  default     = "us-east"
}

variable "prefix" {
  description = "Identifier that will be prepended to all deployed resources."
  type        = string
  default     = "schtestv1"
}

variable "image_name" {
  description = "Image to use for deployed servers."
  type        = string
  default     = "ibm-ubuntu-20-04-3-minimal-amd64-2"
}

variable "profile" {
  default = "cx2-2x4"
}

variable "tags" {
  default = ["owner:ryantiffany"]
}