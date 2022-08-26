locals {
	group_files = fileset(path.module, "./files/*.json")

  // write out the contents of all of the files in the group_files local variable.
  raw_inputs = [for v in local.group_files : jsondecode(file(v))]
}



module "security-group" {
	for_each = { for v in local.raw_inputs: v.display_name => v }

  source  = "terraform-aws-modules/security-group/aws"
  version = "4.13.0"

	vpc_id = "vpc-01488b5e1568e0020"

	name = each.value.display_name
	ingress_rules = ["mysql-tcp"]
	ingress_cidr_blocks = each.value.sources
}



# module "initial_test" {
# 	for_each = { for v in local.raw_inputs: v.display_name => v }
# 	source = "./modules"

# 	display_name = each.value.display_name
# 	protocol = each.value.protocol
# 	destination_ports = each.value.destination_ports
# 	destinations = each.value.destinations
# 	sources = each.value.sources
# 	action = upper(each.value.action)
# }



