resource "azurerm_policy_definition" "this" {
  for_each = {
    for k, v in var.policies : k => v
    if v.policy_type == "Custom"
  }

  name                  = each.key
  display_name          = each.value.display_name
  description           = lookup(each.value, "description", null)
  policy_type           = lookup(each.value, "policy_type")
  mode                  = lookup(each.value, "mode", "Indexed")
  management_group_name = lookup(each.value, "management_group_name", null)
  policy_rule           = lookup(each.value, "policy_rule", null)
  metadata              = lookup(each.value, "metadata", null)
  parameters            = lookup(each.value, "parameters", null)

  lifecycle {
    ignore_changes = [metadata]
  }
}

resource "azurerm_policy_assignment" "this" {
  for_each = var.policies

  name                 = each.key
  display_name         = each.value.display_name
  scope                = each.value.scope
  policy_definition_id = lookup(each.value, "policy_type", null) == "Custom" ? azurerm_policy_definition.this[each.key].id : lookup(each.value, "policy_definition_id", null)
  description          = lookup(each.value, "description", null)
  metadata             = lookup(each.value, "assignment_metadata", null)
  parameters           = lookup(each.value, "assignment_parameters", null)
  enforcement_mode     = lookup(each.value, "enforcement_mode", false)

  lifecycle {
    ignore_changes = [metadata]
  }
}
