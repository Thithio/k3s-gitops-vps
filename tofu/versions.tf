terraform {
  required_version = ">= 1.8"
  required_providers {
    mgc = {
      source  = "magalucloud/mgc"
      version = "~> 0.55.0"
    }
  }
  # Estado local por enquanto (arquivo fora do git). Para mais de uma pessoa ou para
  # recuperação de desastre, mova para um backend "s3" num bucket versionado.
}

provider "mgc" {
  api_key = var.mgc_api_key
  region  = var.region
}
