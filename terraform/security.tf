# 3-2. 현재 로그인한 사용자/테넌트 정보를 자동으로 가져옴 (하드코딩 방지)
data "azurerm_client_config" "current" {}

# Key Vault: 비밀번호 같은 민감 정보를 중앙에서 관리하는 금고
resource "azurerm_key_vault" "main" {
  name                = "kv-${var.project_name}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  # RBAC 방식으로 권한 관리 (구식 access policy 대신 권장 방식)
  rbac_authorization_enabled = true   # enable_rbac_authorization에서 이름 변경됨

  tags = local.common_tags
}

# 내 계정에 "이 Key Vault의 시크릿을 관리할 수 있는" 권한 부여
resource "azurerm_role_assignment" "kv_admin" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

# DB 비밀번호를 Key Vault에 시크릿으로 저장
resource "azurerm_key_vault_secret" "db_password" {
  name         = "db-admin-password"
  value        = var.db_admin_password
  key_vault_id = azurerm_key_vault.main.id

  # 권한이 먼저 부여된 뒤에 시크릿을 쓸 수 있으므로 명시적 의존성
  depends_on = [azurerm_role_assignment.kv_admin]
}