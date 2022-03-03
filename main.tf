module "bastion" {
  source = "we-work-in-the-cloud/vpc-bastion/ibm"

  vpc_id            = data.ibm_is_vpc.east_lab.id
  resource_group_id = data.ibm_resource_group.cde_lab_rg.id
  name              = "${var.prefix}-bastion"
  ssh_key_ids       = [data.ibm_is_ssh_key.sshkey.id]
  subnet_id         = data.ibm_is_vpc.east_lab.subnets[0].id
  create_public_ip  = true
  init_script       = file("install.yml")
}


resource "ibm_is_instance" "instance" {
  count          = length(data.ibm_is_zones.us_east.zones)
  name           = "${var.prefix}-${count.index + 1}-instance"
  vpc            = data.ibm_is_vpc.east_lab.id
  profile        = var.profile
  zone           = data.ibm_is_zones.us_east.zones[0]
  image          = data.ibm_is_image.image.id
  keys           = [data.ibm_is_ssh_key.sshkey.id]
  resource_group = data.ibm_resource_group.cde_lab_rg.id
  user_data      = file("./install.yml")
  primary_network_interface {
    allow_ip_spoofing = false
    subnet            = data.ibm_is_vpc.east_lab.subnets[0].id
  }

  boot_volume {
    name = "${var.prefix}-instance-boot"
  }

  tags = concat(var.tags, ["instancetype:compute"])
}


resource "ibm_is_security_group_target" "under_maintenance" {
  count          = length(data.ibm_is_zones.us_east.zones)
  target         = element(ibm_is_instance.instance[*].primary_network_interface[0].id, count.index)
  security_group = module.bastion.bastion_maintenance_group_id
}

