# Teraform Azure Policies

This module creates Azure Policies definitions and their attachments.

## Usage example

```hcl
module "az_policy" {
  source = "github.com/scalair/terraform-azure-policy"

  policies = {
    naming-resource-groups = {
      display_name = "Resource Group Name Constraints"
      policy_type  = "Custom"
      mode         = "Indexed"

      policy_rule           = file("files/naming-resource-groups/policy.json")
      parameters            = file("files/naming-resource-groups/parameters.json")
      assignment_parameters = file("files/naming-resource-groups/assignment_parameters.json")

      scope = "/subscriptions/${get_env("ARM_SUBSCRIPTION_ID")}"

    }
  }
}
```

## Notes

- Enforcement is disabled by default
- Identity is not implemented
- Excluding scopes is not implemented
