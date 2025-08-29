// Create a new Compute Disk.
resource "yandex_compute_disk" "disk" {
  name     = var.disk_name
  type     = var.disk_type
  zone     = var.zone
  image_id = var.image_id
}

// Create a new Compute Instance
resource "yandex_compute_instance" "vm" {
  name        = var.vm_name
  platform_id = var.platform_id
  zone        = var.zone
  allow_stopping_for_update = true

  service_account_id = yandex_iam_service_account.bucket-sa.id
  resources {
    cores  = var.vm_cores
    memory = var.vm_memory
  }

  boot_disk {
    disk_id = yandex_compute_disk.disk.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.data-proc-subnet.id
    nat       = true
    security_group_ids = [
      yandex_vpc_security_group.data-proc-security-group.id
    ]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key)}"
  }
}

// Auxiliary resources for Compute Instance
resource "yandex_vpc_network" "data-proc-network" {
  description = "Network for the Yandex Data Processing cluster"
  name        = "data-proc-network"
}

resource "yandex_vpc_subnet" "subnet" {
  zone           = var.zone
  name           = var.subnet_name
  network_id     = yandex_vpc_network.data-proc-network.id
  v4_cidr_blocks = ["10.5.0.0/24"]
}

resource "yandex_vpc_gateway" "nat-gateway" {
  name = "test-nat-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "route-table-nat" {
  name       = "route-table-nat"
  network_id = yandex_vpc_network.data-proc-network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat-gateway.id
  }
}

resource "yandex_vpc_subnet" "data-proc-subnet" {
  description    = "Subnet for the Yandex Data Processing cluster"
  name           = "data-proc-subnet"
  network_id     = yandex_vpc_network.data-proc-network.id
  v4_cidr_blocks = ["192.168.1.0/24"]
  zone           = var.zone
  route_table_id = yandex_vpc_route_table.route-table-nat.id
}

resource "yandex_vpc_security_group" "data-proc-security-group" {
  description = "Security group for DataProc"
  name        = "data-proc-security-group"
  network_id  = yandex_vpc_network.data-proc-network.id

  egress {
    description    = "Allow outgoing HTTPS traffic"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description       = "Allow any incoming traffic within the security group"
    protocol          = "ANY"
    from_port         = 0
    to_port           = 65535
    predefined_target = "self_security_group"
  }

  ingress {
    description       = "Allow incoming external SSH connections"
    protocol          = "TCP"
    from_port         = 22
    to_port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description       = "Allow any outgoing traffic within the security group"
    protocol          = "ANY"
    from_port         = 0
    to_port           = 65535
    predefined_target = "self_security_group"
  }

  egress {
    description    = "Allow outgoing traffic to NTP servers for time synchronization"
    protocol       = "UDP"
    port           = 123
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

// Simple Private Bucket With Static Access Keys.
# Create a service account for Data Processing cluster
resource "yandex_iam_service_account" "dataproc-sa" {
  folder_id = var.YC_FOLDER_ID
  name      = "data-proc-sa"
}

# Create a service account for S3 Bucket
resource "yandex_iam_service_account" "bucket-sa" {
  folder_id = var.YC_FOLDER_ID
  name      = "bucket-sa"
}

# Grant permissions to the service account
resource "yandex_resourcemanager_folder_iam_member" "sa-admin" {
  folder_id = var.YC_FOLDER_ID
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.bucket-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "dataproc-sa-role-dataproc-agent" {
  folder_id = var.YC_FOLDER_ID
  role      = "dataproc.agent"
  member    = "serviceAccount:${yandex_iam_service_account.dataproc-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "dataproc-sa-role-dataproc-provisioner" {
  folder_id = var.YC_FOLDER_ID
  role      = "dataproc.provisioner"
  member    = "serviceAccount:${yandex_iam_service_account.dataproc-sa.id}"
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  description        = "Static access key for Object Storage"
  service_account_id = yandex_iam_service_account.bucket-sa.id
}

# Use keys to create a bucket
resource "yandex_storage_bucket" "obj-storage-bucket" {
  depends_on = [
    yandex_resourcemanager_folder_iam_member.sa-admin
  ]

  grant {
    id          = yandex_iam_service_account.dataproc-sa.id
    type        = "CanonicalUser"
    permissions = ["READ", "WRITE"]
  }

  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = var.bucket_name
}

resource "yandex_dataproc_cluster" "dataproc-cluster" {
  description        = "Yandex Data Processing cluster"
  name               = "dataproc-cluster"
  environment        = "PRODUCTION"
  service_account_id = yandex_iam_service_account.dataproc-sa.id
  zone_id            = var.zone
  bucket             = var.bucket_name

  security_group_ids = [
    yandex_vpc_security_group.data-proc-security-group.id
  ]

  depends_on = [
    yandex_resourcemanager_folder_iam_member.dataproc-sa-role-dataproc-provisioner,
    yandex_resourcemanager_folder_iam_member.dataproc-sa-role-dataproc-agent
  ]

  cluster_config {
    hadoop {
      services = ["HDFS", "YARN", "SPARK", "TEZ", "MAPREDUCE", "HIVE"]
      ssh_public_keys = [
        file(var.ssh_public_key)
      ]
    }

    subcluster_spec {
      name        = "subcluster-master"
      role        = "MASTERNODE"
      subnet_id   = yandex_vpc_subnet.data-proc-subnet.id
      hosts_count = 1 # For MASTERNODE only one hosts assigned

      resources {
        resource_preset_id = "s3-c2-m8"    # 4 vCPU Intel Cascade, 16 GB RAM
        disk_type_id       = "network-ssd" # Fast network SSD storage
        disk_size          = 40            # GB
      }
    }

    subcluster_spec {
      name        = "subcluster-data"
      role        = "DATANODE"
      subnet_id   = yandex_vpc_subnet.data-proc-subnet.id
      hosts_count = 3

      resources {
        resource_preset_id = "s3-c4-m16"    # 4 vCPU, 16 GB RAM
        disk_type_id       = "network-ssd" # Fast network SSD storage
        disk_size          = 128            # GB
      }
    }
  }
}