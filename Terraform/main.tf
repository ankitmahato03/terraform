terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.67.0"
    }
  }
  required_version = ">=1.9.0"
}

# }

provider "azurerm" {
  features {}
    subscription_id                 = "enter your sub id here "
}

locals {
  resource_groups = [
    "rg-vizamate-dev",
    "rg-project-kickoff-dev",
    "rg-englishedge-dev",
    "rg-opticomply-dev",
    "rg-requisitonreferral-dev",
    "rg-mailcortex-dev",
    "rg-timesheet-compliance-dev",
    "rg-presales-agent-dev",
    "rg-employee-pulse-dev",
    "rg-expense-approval-dev",
    "rg-artifacts-query-dev",
    "rg-project-health-dev",
  ]
}

resource "azurerm_resource_group" "terraform_test" {
  for_each = toset(local.resource_groups)

  name     = each.value
  location = "Central India"
}

