locals {
	group_files = fileset(path.module, "./files/*.json")

  // write out the contents of all of the files in the group_files local variable.
  raw_inputs = [for v in local.group_files : jsondecode(file(v))]
}

module "initial_test" {
	for_each = { for v in local.raw_inputs: v.display_name => v }
	source = "./modules"

	display_name = each.value.display_name
	protocol = each.value.protocol
	destination_ports = each.value.destination_ports
	destinations = each.value.destinations
	sources = each.value.sources
	action = upper(each.value.action)
}



