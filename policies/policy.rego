package main

# 策略 1：禁止过于开放的防火墙规则
deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "azurerm_network_security_group"
  rule := resource.change.after.security_rule[_]
  rule.direction == "Inbound"
  rule.source_address_prefix == "0.0.0.0/0"
  rule.destination_port_range != "443"
  msg := sprintf("NSG '%s' contains an overly permissive inbound rule allowing '0.0.0.0/0' on port '%s'.", [resource.change.after.name, rule.destination_port_range])
}
# 策略 2：强制 Environment 标签
deny[msg] {
  resource := input.resource_changes[_]
  allowed_types := ["azurerm_resource_group", "azurerm_network_security_group"]
  resource.type == allowed_types[_]
  not resource.change.after.tags["Environment"]
  msg := sprintf("Resource '%s' is missing required tag 'Environment'.", [resource.change.after.name])
}
# 策略 3：强制 Owner 标签
deny[msg] {
  resource := input.resource_changes[_]
  allowed_types := ["azurerm_resource_group", "azurerm_network_security_group"]
  resource.type == allowed_types[_]
  not resource.change.after.tags["Owner"]
  msg := sprintf("Resource '%s' is missing required tag 'Owner'.", [resource.change.after.name])
}