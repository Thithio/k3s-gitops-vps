variable "mgc_api_key" {
  description = "API key da Magalu Cloud. Passe por TF_VAR_mgc_api_key, nunca no git."
  type        = string
  sensitive   = true
}

variable "region" {
  description = "br-se1 (Sudeste) ou br-ne1 (Nordeste)"
  type        = string
  default     = "br-se1"
}

variable "name" {
  type    = string
  default = "app-homolog"
}

variable "machine_type" {
  description = "Tipo da VM (ex.: BV4-8-100 = 4 vCPU, 8 GB, 100 GB)"
  type        = string
  default     = "BV4-8-100"
}

variable "image" {
  type    = string
  default = "cloud-ubuntu-24.04 LTS"
}

variable "ssh_public_key" {
  description = "Chave pública de quem administra a VM (conteúdo de ~/.ssh/id_ed25519.pub)"
  type        = string
}

variable "admin_cidrs" {
  description = "IPs que podem abrir SSH (ex.: [\"203.0.113.25/32\"]). Nunca 0.0.0.0/0."
  type        = list(string)
}
