# 리소스 그룹: 모든 리소스를 묶어서 한 번에 관리/삭제하기 위한 컨테이너
# 포트폴리오 정리할 때 이 그룹만 삭제하면 하위 리소스 전부 삭제됨
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project_name}-${var.environment}"
  location = var.location

  tags = local.common_tags
}


# 공통 값을 한 곳에 모아 재사용 (DRY 원칙)
locals {
  common_tags = {
    project     = var.project_name
    environment = var.environment
  }
}