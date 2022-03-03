data "ibm_is_vpc" "east_lab" {
  name = "vpc-us-east-2022-cde-lab"
}

data "ibm_resource_group" "cde_lab_rg" {
  name = "2022-cde-lab"
}

data "ibm_is_ssh_key" "sshkey" {
  name = "europa-us-east"
}

data "ibm_is_image" "image" {
  name = var.image_name
}

data "ibm_is_zones" "us_east" {
  region = var.region
}