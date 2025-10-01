# Configure the Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Define input variables that will be passed from GitHub Actions
variable "resource_group_name" {
  type        = string
  description = "The name of the Azure resource group."
}

variable "docker_image" {
  type        = string
  description = "The full name of the Docker image to deploy (e.g., myacr.azurecr.io/my-app:tag)."
}

# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "rg" {
  name     = "sit722-staging-rg" # A dedicated resource group for staging
  location = "Australia East"
}

# Define the container instance for the staging environment
resource "azurerm_container_group" "staging_app" {
  name                = "staging-app-instance"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_address_type = "Public"
  dns_name_label  = "sit722-staging-app-${random_id.unique.hex}" # Creates a unique URL
  os_type         = "Linux"

  container {
    name   = "my-app-container"
    image  = var.docker_image # Uses the image built in the CI step
    cpu    = "1"
    memory = "1.5"
    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  tags = {
    environment = "staging"
  }
}

# Resource to generate a random string for the unique URL
resource "random_id" "unique" {
  byte_length = 4
}