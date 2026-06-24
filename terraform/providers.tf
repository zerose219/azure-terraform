terraform {
  # 이 프로젝트를 실행하는 데 필요한 Terraform CLI 최소 버전 지정
  # 1.5.0 미만 버전에서 실행하면 에러 발생 (문법/기능 호환성 보장)
  required_version = ">= 1.5.0"

  required_providers {
    # 이 프로젝트가 사용할 provider(클라우드 플러그인)와 버전을 고정
    azurerm = {
      source  = "hashicorp/azurerm"  # provider 출처 (HashiCorp Registry의 azurerm)
      version = "~> 4.0"   # 4.0.x ~ 4.x대(4.78도 포함) 전부 허용, 5.0 메이저는 차단
    }
  }
}

provider "azurerm" {
  # 위에서 선언한 azurerm provider를 실제로 활성화/초기화
  features {}
  # azurerm provider 동작 방식을 세부 조정하는 옵션 블록
  # 지금은 커스텀 설정 없이 기본값 사용 (빈 블록이지만 필수로 적어야 함)
}