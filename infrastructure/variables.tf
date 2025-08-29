variable "zone" {
  description = "The availability zone to use for resources"
  type        = string
  default     = "ru-central1-a"
}

variable "YC_CLOUD_ID" {
  description = "The ID of the Yandex Cloud"
  type        = string
}

variable "YC_FOLDER_ID" {
  description = "The ID of the Yandex Cloud folder"
  type        = string
}

variable "YC_TOKEN" {
  description = "The OAuth token for Yandex Cloud"
  type        = string
}

variable "image_id" {
  description = "The ID of the Yandex Cloud image to use for the VM"
  type        = string
  default     = "fd805090je9atk2b9jon"
}

variable "disk_name" {
  description = "The name of the disk to create"
  type        = string
  default     = "otus-disk"
}

variable "disk_type" {
  description = "The type of disk to create"
  type        = string
  default     = "network-ssd"
}

variable "vm_name" {
  description = "The name of the VM to create"
  type        = string
  default     = "otus-vm"
}

variable "vm_cores" {
  description = "The number of CPU cores for the VM"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "The amount of memory (in GB) for the VM"
  type        = number
  default     = 4
}

variable "platform_id" {
  description = "The platform ID for the VM"
  type        = string
  default     = "standard-v3"
}

variable "ssh_public_key" {
  description = "The path to the SSH public key file"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "network_name" {
  description = "The name of the VPC network to create"
  type        = string
  default     = "otus-network"
}

variable "subnet_name" {
  description = "The name of the VPC subnet to create"
  type        = string
  default     = "otus-subnet"
}

variable "sa_name" {
  description = "The name of the service account to create"
  type        = string
  default     = "otus-sa"
}

variable "bucket_name" {
  description = "The name of the storage bucket to create"
  type        = string
  default     = "neclud-otus-mlops"
}

variable "source_bucket_name" {
  description = "The name of the storage bucket to create"
  type        = string
  default     = "otus-mlops-source-data"
}

variable "yc_storage_endpoint" {
  description = "yandex s3 endpoint"
  type        = string
  default     = "https://storage.yandexcloud.net/"
}



variable "cluster_name" {
  description = "The name of the cluster to create"
  type        = string
  default     = "otus-ml-cluster"
}

#variable "ACCESS_KEY" {
#  description = "yandex s3 access key"
#  type        = string
#}

#variable "SECRET_KEY" {
#  description = "yandex s3 secret key"
#  type        = string
#}