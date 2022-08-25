

resource "local_file" "foo" {
		count = 2000
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
