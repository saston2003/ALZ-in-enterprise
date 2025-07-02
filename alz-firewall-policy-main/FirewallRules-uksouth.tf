locals {
  firewall_rules-uksouth_files = fileset("${path.module}/Firewallrules-uksouth/", "*-uksouth.yaml")
  concatenated-uksouth_yaml = join("\n", [
    for file in local.firewall_rules-uksouth_files : file("${path.module}/Firewallrules-uksouth/${file}")
  ])
  rules-uksouth          = format("%s%s", "rule_collection_groups:\n", local.concatenated-uksouth_yaml)
  firewall_rules-uksouth = yamldecode(local.rules-uksouth)
}

data "azurerm_firewall_policy" "fwp-uksouth" {
  provider            = azurerm
  name                = var.uksouth_firewall_policy_name
  resource_group_name = var.uksouth_resource_group_name
}

resource "azurerm_firewall_policy_rule_collection_group" "fwp-uksouth-rcg" {
  for_each           = try(local.firewall_rules-uksouth.rule_collection_groups, {})
  name               = each.value.name
  firewall_policy_id = data.azurerm_firewall_policy.fwp-uksouth.id
  priority           = each.value.priority

  dynamic "network_rule_collection" {
    for_each = try(each.value.network_rule_collections, [])
    content {
      name     = network_rule_collection.value.name
      priority = network_rule_collection.value.priority
      action   = network_rule_collection.value.action

      dynamic "rule" {
        for_each = try(network_rule_collection.value.rules, [])
        content {
          name                  = rule.value.name
          source_addresses      = rule.value.source_addresses
          destination_addresses = rule.value.destination_addresses
          destination_ports     = rule.value.destination_ports
          protocols             = rule.value.protocols
        }
      }
    }
  }

  dynamic "application_rule_collection" {
    for_each = try(each.value.application_rule_collections, [])
    content {
      name     = application_rule_collection.value.name
      priority = application_rule_collection.value.priority
      action   = application_rule_collection.value.action

      dynamic "rule" {
        for_each = try(application_rule_collection.value.rules, [])
        content {
          name              = rule.value.name
          source_addresses  = rule.value.source_addresses
          destination_fqdns = rule.value.destination_fqdns

          dynamic "protocols" {
            for_each = try(rule.value.protocols, [])
            content {
              type = protocols.value.type
              port = protocols.value.port
            }
          }
        }
      }
    }
  }

  dynamic "nat_rule_collection" {
    for_each = try(each.value.nat_rule_collections, [])
    content {
      name     = nat_rule_collection.value.name
      priority = nat_rule_collection.value.priority
      action   = nat_rule_collection.value.action

      dynamic "rule" {
        for_each = try(nat_rule_collection.value.rules, [])
        content {
          name                  = rule.value.name
          source_addresses      = rule.value.source_addresses
          destination_address = rule.value.destination_address
          destination_ports     = rule.value.destination_ports
          protocols             = rule.value.protocols
          translated_address    = rule.value.translated_address
          translated_port       = rule.value.translated_port
        }
      }
    }
  }
}
