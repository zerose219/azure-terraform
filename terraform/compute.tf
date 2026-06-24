# 2-1. Log Analytics Workspace: Container Apps Environment의 로그/메트릭이 모이는 곳
# Container Apps Environment를 만들려면 필수로 연결해야 함
resource "azurerm_log_analytics_workspace" "main" {
  name                = "log-${var.project_name}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30   # 무료 한도는 5GB/월, 보관기간은 비용에 영향 적음

  tags = {
    project     = var.project_name
    environment = var.environment
  }
}

# Container Apps Environment: 컨테이너 앱들이 입주할 "건물"
resource "azurerm_container_app_environment" "main" {
  name                       = "cae-${var.project_name}-${var.environment}"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  infrastructure_subnet_id   = azurerm_subnet.container_apps.id

  tags = local.common_tags
}






# 2-2. Container App: Environment(건물) 안에 입주하는 실제 컨테이너(가게)
resource "azurerm_container_app" "backend" {
  name                         = "ca-${var.project_name}-backend"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  template {
    container {
      name   = "demo"
      image  = "mcr.microsoft.com/k8se/quickstart:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  ingress {
    external_enabled = true
    target_port       = 80
    transport          = "auto"

    traffic_weight {
      latest_revision = true
      percentage       = 100
    }
  }

  tags = local.common_tags
}