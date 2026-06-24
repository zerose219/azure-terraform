# 1. 가상 네트워크: 이 안에서 만들어지는 리소스들끼리만 격리된 사설 네트워크로 통신
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.project_name}-${var.environment}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = local.common_tags
}

# 서브넷: VNet 안을 더 작은 단위로 쪼갠 영역
# Container Apps Environment는 자체적으로 서브넷을 통째로 위임받아 써야 해서
# /23 이상의 넉넉한 대역을 따로 분리해둠
resource "azurerm_subnet" "container_apps" {
  name                 = "snet-containerapps"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.0.0/23"]

  delegation {
    name = "containerapps-delegation"

    service_delegation {
      name    = "Microsoft.App/environments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}