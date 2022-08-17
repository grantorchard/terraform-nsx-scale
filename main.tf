module "initial_test" {
	count = var.spawn
	source = "./modules"

	display_name = "app-id-${sum([123456, count.index])}"
	protocol = "tcp"
	destination_ports = [
		443
	]
	destinations = []
	sources = []
	action = "allow"
}


# DD_AGENT_MAJOR_VERSION=7 DD_API_KEY=ba1f4cb12fb31f2b6f321d2cfd2d119d DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"
