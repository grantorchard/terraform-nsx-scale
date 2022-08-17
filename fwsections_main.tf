locals {
  # Read json files and append them into a single directory
  inputfiles = [for f in fileset(path.module, "*_rules.json") : jsondecode(file(f))]

  # Filter and append distinct security group contents from JSON file
  security_group_resources = distinct(flatten([for item in local.inputfiles : item.security_group_resources]))

  # Filter and append distinct service group contents from JSON file
  service_resources = distinct(flatten([for item in local.inputfiles : item.service_resources]))

  # Filter and append distinct firewall section contents from JSON file
  fw_section_resources = distinct(flatten([for item in local.inputfiles : item.fw_section]))
}

# create security group
module "fw_sections" {
  source               = "rules"
  data_sg_resources    = local.security_group_resources
  data_srv_resources   = local.service_resources
  fw_section_resources = local.fw_section_resources
}
