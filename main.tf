module "initial_test" {
	count = var.spawn
	source = "./modules"

	display_name = "app-id-${sum([123456, count.index])}"
	protocol = "tcp"
	destination_ports = [
		443
	]
	destinations = ["10.0.0.0/24"]
	sources = ["192.168.20.0/24"]
	action = "allow"
}



