variable "display_name" {

}

variable "description" {

}

variable "ip_list" {
  type = list(any)
}

variable "tag" {
  type = list(any)
}

variable "conditions" {
  type = list(any)
}

variable "conjunction" {
  type = list(any)
}
