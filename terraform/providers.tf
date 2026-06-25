terraform {
  # 이 프로젝트를 실행하는 데 필요한 Terraform CLI 최소 버전 지정
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # state를 로컬이 아닌 Azure Storage에 저장 (CI/CD 자동화의 전제조건)
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstatekim2026"
    container_name       = "tfstate"
    key                  = "azure-portfolio.tfstate"
  }
}

provider "azurerm" {
  features {}
}