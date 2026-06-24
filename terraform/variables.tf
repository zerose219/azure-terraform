variable "project_name" {
  description = "리소스 이름에 붙일 프로젝트 식별자"
  type        = string
  default     = "cloudportfolio"
}

variable "location" {
  description = "Azure 리전"
  type        = string
  default     = "koreacentral"
}

variable "environment" {
  description = "환경 구분 (dev/prod)"
  type        = string
  default     = "dev"
}



variable "db_admin_username" {
  description = "PostgreSQL 관리자 계정명"
  type        = string
  default     = "pgadmin"
}

variable "db_admin_password" {
  description = "PostgreSQL 관리자 비밀번호"
  type        = string
  sensitive   = true   # plan/apply 출력에 값이 안 찍히게
}