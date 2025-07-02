# alz-firewall-policy
Firewall policy configurations for Azure Landing Zone firewall in both UK South and UK West regional hubs.
Written so:
- Each YAML file is an IP Group per region.
- Each YAML files is a rule collection group per region.

To help keep track of how many of each are being used and if approaching the limits.

## Architecture best practices
[Best practices - Azure Firewall](https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-firewall)

[Performance Best Practice - Azure Firewall](https://learn.microsoft.com/en-us/azure/firewall/firewall-best-practices)

## Limits
| Limit | Resource |
| ----------- | ----------- |
| 1 | Azure Firewall per vNet |
| 30 Gbps | Standard Max Data Throughput. 100 Gbps for Premium, 30 Gbps for Standard, 250 Mbps for Basic (preview) SKU |
| 20,000 | Unique Source/Destination Combinations in rules. (Soft limit that can affect performance) |
| 2 MB | Total size of rules within a single Rule Collection Group |
| 90 | Rule collection groups per firewall policy. |
| 250 | maximum DNAT rules (Maximum external destinations) [number of firewall public IP addresses + unique destinations (destination address, port, and protocol)] |
| /26 | Minimum AzureFirewallSubnet size |
| 1 - 65535 | Port range in network and application rules |
| 250 | Maximum Public IP addresses |
| 200 | Maximum IP Groups |
| 5,000 | Individual IP addresses or IP prefixes per each IP Group. |
| 1000 | FQDNs in network rules. Recommeded maximum for performance. |
| 120 seconds | TLS inspection timeout |

Reference: [Azure firewall limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-firewall-limits)

## Rule processing order:

Firewall policy processes DNAT → Network → Application rules, respecting Rule Collection Groups and Rule Collection priorities (100–65,000) 

## Performance considerations:

Exceeding the 20,000 unique source/dest limit may degrade performance.

Every new firewall adds another pool of ~20,000 unique rules, unless you're using inherited policies. In that case, the child still counts the parent's rules too 

## SKU differences:

Premium SKU supports more advanced features like TLS inspection, IDPS, URL filtering, web categories, and higher throughput (up to 100 Gbps vs. 30 Gbps for Standard) 

## IP Group benefits:

Use IP Groups to consolidate multiple IPs/ranges: each group counts as one item, saving rule entry count 

## Known Issues - Azure Firewall
[Known Issues](https://learn.microsoft.com/en-us/azure/firewall/firewall-known-issues#azure-firewall-standard)