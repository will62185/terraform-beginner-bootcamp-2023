terraform {
  # cloud {
  #   organization = "will-will-org"

  #   workspaces {
  #     name = "terra-house-01"
  #   }
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.17.0"
    }
    terratowns = {
      source  = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
}

provider "aws" {
  # Configuration options
}

provider "terratowns" {
  # endpoint  = "http://localhost:4567/api"
  endpoint  = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token     = var.terratowns_access_token
}

module "terrahouse_aws" {
  source              = "./modules/terrahouse_aws"
  user_uuid           = var.teacherseat_user_uuid
  # bucket_name         = var.bucket_name
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  content_version     = var.content_version
  assets_path         = var.assets_path
}

resource "terratowns_home" "home" {
  name        = "Intro to World of Warcraft in 2023!"
  description = <<Description
World of Warcraft changed the landscape of MMORPGS Forever.
People of all ages played it, and obsesed over it.
Blizzard, the company that created the game, recently re-released it,
calling it World of Warcraft Classic.
Description
  domain_name = module.terrahouse_aws.cloudfront_url
  # domain_name = "abc3dgrz.cloudfront.net"
  town            = "missingo"
  content_version = 1
}