variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "azs" {
  description = "List of availability zones in which subnet has to be created"
  type        = list(string)
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
