resource "nsxt_policy_group" "security_group" {
  display_name = var.display_name
  description  = var.description

  dynamic "criteria" {
    for_each = var.ip_list

    content {
      ipaddress_expression {
        ip_addresses = lookup(criteria.value, "ipaddr")
      }
    }
  }

  dynamic "tag" {
    for_each = var.tag

    content {
      scope = lookup(tag.value, "tag_scope")
      tag   = lookup(tag.value, "tag_value")
    }
  }

  dynamic "criteria" {
    for_each = length(var.conditions) != 0 ? { criteria = toset(var.conditions) } : {}

    content {
      dynamic "condition" {
        for_each = criteria.value
        content {
          key         = condition.value.key
          member_type = condition.value.member_type
          operator    = condition.value.operator
          value       = condition.value.value
        }
      }
    }
  }

  dynamic "conjunction" {
    for_each = var.conjunction
    content {
      operator = conjunction.value
    }
  }
}
