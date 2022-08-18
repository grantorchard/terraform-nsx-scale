

resource "local_file" "foo" {
		count = 500
    content  = jsonencode({
			display_name = "app-id-${sum([123456, count.index])}",
			protocol = "tcp",
			destination_ports = [
				443
			],
			destinations = ["10.0.0.0/24"],
			sources = ["192.168.20.0/24"],
			action = "allow"
		})
    filename = "${path.module}/app-id-${sum([123456, count.index])}.json"
}

locals {
	group_files = fileset(path.module, "./*.json")

  // write out the contents of all of the files in the group_files local variable.
  raw_inputs = [for v in local.group_files : jsondecode(file(v))]
}

output "app-ids" {
	value = local.raw_inputs
}