variable "spawn" {
  type        = number
  description = "How many module instances to spin out. Count is a reserved keyword. Each module has four resources, so multiply this number bny four to get the total number of resources that will be under management."
  default     = 500
}

variable "host" {

}
