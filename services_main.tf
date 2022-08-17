locals {
  # Read json files and append them into a single directory
  inputfiles = [for f in fileset(path.module, "*.json") : jsondecode(file(f))]

  service_group_resources = merge(local.inputfiles...)
}

# create service
module "policy_service" {
  source            = "servicegroups"
  for_each          = local.service_group_resources
  display_name      = each.key
  description       = lookup(each.value, "description", "Terraform provisioned group")
  ip_port_set_entry = lookup(each.value, "ip_port_set_entry", [])
  tag               = lookup(each.value, "tag", [])
  icmp_entry        = lookup(each.value, "icmp_entry", [])
}
