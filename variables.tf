variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "environment" {
  type        = string
  description = "Infrastructure Environment"
}

variable "create_vpc" {
  type        = bool
  default     = true
  description = "Toggle the creation of the module's resources "
}

variable "vpc_name" {
  description = "Name of VPC"
  type        = string
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC."
}


variable "public_subnets" {
  type        = list(string)
  description = "List of public subnets"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnets"
}

variable "eks_cluster_name" {
  description = "Name of EKS cluster to be created in this VPC."
  type        = string
}

variable "eks_cluster_version" {
  type    = string
  default = "1.20"
}

variable "node_count_min" {
  description = "Minimum autoscale (number of EC2)"
  default     = "1"
}

variable "node_count_max" {
  description = "Maximum autoscale (number of EC2)"
  default     = "10"
}

variable "node_count_desired" {
  description = "Desired autoscale (number of EC2)"
  default     = "2"
}

variable "node_disk_size" {
  description = "Disk size for workers"
  type        = string
  default     = ""
}

variable "node_disk_type" {
  description = "EBS type"
  type        = string
  default     = ""
}

variable "node_disk_iops" {
  description = "EBS IO/s"
  type        = string
  default     = ""
}

variable "node_disk_throughput" {
  description = "EBS transfer rate"
  type        = string
  default     = ""
}

variable "node_disk_encrypt" {
  description = "EBS encryption"
  type        = bool
  default     = false
}

variable "delete_on_termination" {
  type    = bool
  default = true
}

variable "node_instance_types" {
  description = "instance types for worker nodes"
}

variable "node_keyname" {
  description = "Key name to ssh into worker nodes."
}

variable "eks_enable_irsa" {
  description = "Whether to create OpenID Connect Provider for EKS to enable IRSA"
  type        = bool
  default     = true
}


variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint."
  type        = list(string)
}

