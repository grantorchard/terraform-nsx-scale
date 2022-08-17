locals {
  # Read json files and append them into a single directory
  inputfiles = [for f in fileset(path.module, "*_objects.json") : jsondecode(file(f))]

  security_group_resources = merge(local.inputfiles...)
}

# create security group
module "security_group" {
  source       = "policygroups"
  for_each     = local.security_group_resources
  display_name = each.key
  description  = lookup(each.value, "description", "Terraform provisioned group")
  ip_list      = lookup(each.value, "ipaddress_list", [])
  tag          = lookup(each.value, "tag", [])
  conditions   = lookup(each.value, "conditions", [])
  conjunction  = lookup(each.value, "conjunction", [])
}
