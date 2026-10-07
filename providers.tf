terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }

  # Remote state is strongly recommended for anything beyond experiments.
  # See backend.tf.example.
}

provider "azurerm" {
  features {}

  # Authenticate with `az login` (or ARM_* environment variables in CI).
  # Never put credentials in this repository.
}
