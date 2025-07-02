locals {
  ip_group-uksouth_files = fileset("${path.module}/IP_Groups-uksouth/", "*-uksouth.yaml")
  concatenate-uksouth_yaml = join("\n", [
    for file in local.ip_group-uksouth_files : file("${path.module}/IP_Groups-uksouth/${file}")
  ])
  ip_groups-uksouth     = format("%s%s", "ip_groups:\n", local.concatenate-uksouth_yaml)
  ip_group-uksouth_data = yamldecode(local.ip_groups-uksouth)

}

resource "azurerm_ip_group" "uksouth-ipgroup" {
  for_each            = try(local.ip_group-uksouth_data.ip_groups, {})
  name                = each.value.name
  resource_group_name = var.uksouth_resource_group_name
  location            = var.uksouth_location
  cidrs               = each.value.cidrs
}

output "debug_ip_groups-uksouth" {
  value = local.ip_group-uksouth_data
}
