variable "terratowns_endpoint" {
  type = string
}

variable "teacherseat_user_uuid" {
  type = string
}

variable "terratowns_access_token" {
  type = string
}

variable "wow" {
  type = object({
    public_path = string
    content_version = number
  })
}

variable "bbq" {
  type = object({
    public_path = string
    content_version = number
  })
}