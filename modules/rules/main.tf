terraform {
  required_providers {
    nsxt = {
      source  = "vmware/nsxt"
      version = "3.2.8"
    }
  }
}

# Data block for retreiving exisiting security groups and service groups

data "nsxt_ns_groups" "sg_object" {

}

data "nsxt_ns_services" "srv_object" {

}

resource "nsxt_firewall_section" "firewall" {
  for_each = { for item in var.fw_section_resources : item.section_name => item }

  display_name  = lookup(each.value, "section_name")
  description   = lookup(each.value, "description", "")
  section_type  = "LAYER3"
  stateful      = true
  insert_before = lookup(each.value, "inser_before", "")

  applied_to {
    target_id   = lookup(each.value, "applied_target")
    target_type = "LogicalPort"
  }

  dynamic "tag" {
    for_each = lookup(each.value, "tag", null)

    content {
      scope = lookup(tag.value, "tag_scope")
      tag   = lookup(tag.value, "tag_value")
    }
  }

  dynamic "rule" {
    for_each = lookup(each.value, "rules")

    content {
      action       = lookup(rule.value, "action")
      direction    = lookup(rule.value, "direction")
      display_name = lookup(rule.value, "display_name")
      ip_protocol  = lookup(rule.value, "ip_protocol")
      description  = lookup(rule.value, "description", "Terraform configured rule")
      logged       = tobool(lookup(rule.value, "logged", "true"))
      disabled     = tobool(lookup(rule.value, "disabled", "false"))

      dynamic "destination" {
        for_each = lookup(rule.value, "destination", null)

        content {
          target_id   = data.nsxt_ns_groups.sg_object.results["default.${destination.value}"]
          target_type = "NSGroup"
        }
      }

      dynamic "source" {
        for_each = lookup(rule.value, "source", null)

        content {
          target_id   = data.nsxt_ns_groups.sg_object.results["default.${source.value}"]
          target_type = "NSGroup"
        }
      }

      dynamic "service" {
        for_each = lookup(rule.value, "service", null)

        content {
          target_id   = data.nsxt_ns_services.srv_object.results[service.value]
          target_type = "NSService"
        }
      }
    }
  }

}
