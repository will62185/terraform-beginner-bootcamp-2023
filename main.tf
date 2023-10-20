terraform {
  cloud {
    organization = "will-will-org"

    workspaces {
      name = "terra-house-01"
    }
  }

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

module "home_wow_hosting" {
  source          = "./modules/terrahome_aws"
  user_uuid       = var.teacherseat_user_uuid
  public_path     = var.wow.public_path
  content_version = var.wow.content_version
}

resource "terratowns_home" "home_wow" {
  name        = "Intro to World of Warcraft in 2023!"
  description = <<Description
World of Warcraft changed the landscape of MMORPGS Forever.
People of all ages played it, and obsesed over it.
Blizzard, the company that created the game, recently re-released it,
calling it World of Warcraft Classic.
Description
  domain_name = module.home_wow_hosting.domain_name
  # domain_name = "abc3dgrz.cloudfront.net"
  town            = "missingo"
  content_version = var.wow.content_version
}

module "home_bbq_hosting" {
  source              = "./modules/terrahome_aws"
  user_uuid           = var.teacherseat_user_uuid
  public_path  = var.bbq.public_path
  content_version     = var.bbq.content_version
}

resource "terratowns_home" "home_bbq" {
  name        = "Instant Pot BBQ Chicken"
  description = <<Description
This Instant Pot BBQ Chicken is an easy recipe you can make for a weeknight meal. You can use in so many ways!
Description
  domain_name = module.home_bbq_hosting.domain_name
  # domain_name = "abc3dgrz.cloudfront.net"
  town            = "missingo"
  content_version = var.bbq.content_version
}