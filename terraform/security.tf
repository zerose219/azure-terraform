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

# DB 비밀번호를 Key Vault에 시크릿으로 저장
resource "azurerm_key_vault_secret" "db_password" {
  name         = "db-admin-password"
  value        = var.db_admin_password
  key_vault_id = azurerm_key_vault.main.id
}

# 참고: Key Vault 시크릿 접근 권한(Key Vault Secrets Officer)은
# Terraform이 아닌 Azure CLI로 별도 관리함.
# 이유: 권한 부여 주체가 로컬(사용자)과 CI(Service Principal)에 따라 달라져
#       매 실행마다 replace가 발생하고, SP는 roleAssignments 관리 권한이 없어 실패함.
#       IAM(권한)과 인프라 프로비저닝을 분리하는 것이 최소권한 원칙에도 부합함.