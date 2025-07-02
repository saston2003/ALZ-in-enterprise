locals {
  ip_group-ukwest_files = fileset("${path.module}/IP_Groups-ukwest/", "*-ukwest.yaml")
  concatenate-ukwest_yaml = join("\n", [
    for file in local.ip_group-ukwest_files : file("${path.module}/IP_Groups-ukwest/${file}")
  ])
  ip_groups-ukwest     = format("%s%s", "ip_groups:\n", local.concatenate-ukwest_yaml)
  ip_group-ukwest_data = yamldecode(local.ip_groups-ukwest)

}

resource "azurerm_ip_group" "ukwest-ipgroup" {
  for_each            = try(local.ip_group-ukwest_data.ip_groups, {})
  name                = each.value.name
  resource_group_name = var.ukwest_resource_group_name
  location            = var.ukwest_location
  cidrs               = each.value.cidrs
}

output "debug_ip_groups-ukwest" {
  value = local.ip_group-ukwest_data
}
