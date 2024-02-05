variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "cidr_range" {
  description = "The IPv4 CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "A list of Public subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  description = "A list of Private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "intra_subnets" {
  description = "A list of Intra subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

variable "azs" {
  description = "List of availability zones in which subnet has to be created"
  type        = list(string)
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default     = {}
}

variable "intra_subnet_tags" {
  description = "Additional tags for the intra subnets"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
