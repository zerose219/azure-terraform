
# 3-1. PostgreSQL Flexible Server: 관리형 DB
# Private Endpoint 대신 public access + 방화벽 규칙 선택
# (이유: Private Endpoint는 시간당 과금 + VNet 통합 복잡도 ↑,
#  포트폴리오 단계에선 방화벽 규칙으로 충분. 실무 운영에선 Private Endpoint 권장)
resource "azurerm_postgresql_flexible_server" "db" {
  name                          = "psql-${var.project_name}-${var.environment}"
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  version                       = "16"
  administrator_login           = var.db_admin_username
  administrator_password        = var.db_admin_password

  sku_name   = "B_Standard_B1ms"   # Burstable 최소 사양 (비용 최소화)
  storage_mb = 32768               # 32GB (최소값)

  public_network_access_enabled = true

  zone = "1"

  tags = local.common_tags
}

# 방화벽 규칙: Azure 내부 서비스(Container Apps 등)의 접근 허용
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure" {
  name             = "allow-azure-services"
  server_id        = azurerm_postgresql_flexible_server.db.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}