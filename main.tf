module "initial_test" {
	count = var.spawn
	source = "./modules"

	display_name = "app-id-${sum([123456, count.index])}"
	protocol = "tcp"
	destination_ports = [
		443
	]
	destinations = "destination"
	sources = "source"
	action = "allow"
}



# resource "nsxt_policy_group" "destinations" {
#   display_name = "destination"
#   description  = ""

#   criteria {
#     ipaddress_expression {
#       ip_addresses = ["192.168.1.20"]
#     }
#   }
# }

# resource "nsxt_policy_group" "sources" {
#   display_name = "source"
#   description  = ""

#   criteria {
#     ipaddress_expression {
#       ip_addresses = ["192.168.1.10"]
#     }
#   }
# }



