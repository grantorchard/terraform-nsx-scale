resource "nsxt_policy_service" "this" {
  description  = var.description
  display_name = var.display_name

  l4_port_set_entry {
    display_name      = var.display_name
    description       = var.description
    protocol          = upper(var.protocol)
    destination_ports = var.destination_ports
  }

  tag {
    scope = "color"
    tag   = "pink"
  }
}

resource "nsxt_policy_group" "destinations" {
  display_name = "destination-${var.display_name}"
  description  = var.description

  criteria {
    ipaddress_expression {
      ip_addresses = var.destinations
    }
  }
}

resource "nsxt_policy_group" "sources" {
  display_name = "source-${var.display_name}"
  description  = var.description

  criteria {
    ipaddress_expression {
      ip_addresses = var.sources
    }
  }
}

resource "nsxt_policy_security_policy" "this" {
	display_name = var.display_name
	description = var.description
	category = "Application"
	locked = false
	sequence_number = 3
	stateful = true
	tcp_strict = false
	scope        = [
		nsxt_policy_group.sources.path
	]

	tag {
		scope = "color"
		tag = "orange"
	}

	rule {
		display_name = var.display_name
		source_groups = [
			nsxt_policy_group.sources.path
		]
		destination_groups = [
			nsxt_policy_group.destinations.path
		]
		services = [
			nsxt_policy_service.this.path
		]
		disabled = false
		action = upper(var.action)
		logged = true
		scope = [
			nsxt_policy_group.sources.path
		]
	}
}


