terraform {
  required_providers {
    ionoscloud = {
      source = "ionos-cloud/ionoscloud"
      version = "= 6.2.1"
    }
  }
}

provider "ionoscloud" {
  username = "sme20231002_cloud_hs@itohm.de"
  password = "P805y2-X.6"
  endpoint = "api.ionos.com"
}

resource "ionoscloud_datacenter" "FrankfortDC" {
  name                  = "Frankfort Datacenter"
  location              = "de/fra"
  description           = "Virtual datacenter in frankfort"
  sec_auth_protection   = false
}

resource "ionoscloud_lan" "net0-frankfortDC" {
  datacenter_id         = ionoscloud_datacenter.FrankfortDC.id
  public                = false
  name                  = "net0-frankfortDC"
  lifecycle {
    create_before_destroy = true
  }
}

resource "ionoscloud_ipblock" "ipblock-FrankfortDC" {
  location  = "de/fra"
  size      = 4
  name      = "IP Block FrankfortDC"
}

resource "ionoscloud_k8s_cluster" "FrankforDC-Kube-Cluster" {
  name                  = "frankfort-kube-cluster"
  k8s_version           = "1.25.6"
#  maintenance_window {
#    day_of_the_week     = "Sunday"
#    time                = "09:00:00Z"
#  }
}

resource "ionoscloud_k8s_node_pool" "frankfort-Node_Pool" {
  datacenter_id         = ionoscloud_datacenter.FrankfortDC.id
  k8s_cluster_id        = ionoscloud_k8s_cluster.FrankforDC-Kube-Cluster.id
  name                  = "kube-Node-Pool-Franfort-DC"
  k8s_version           = ionoscloud_k8s_cluster.FrankforDC-Kube-Cluster.k8s_version

#  maintenance_window {
#    day_of_the_week     = "Monday"
#    time                = "09:00:00Z"
#  } 
  auto_scaling {
    min_node_count      = 1
    max_node_count      = 2
  }
  cpu_family            = "INTEL_SKYLAKE"
  availability_zone     = "AUTO"
  storage_type          = "HDD"
  node_count            = 2
  cores_count           = 2
  ram_size              = 4096
  storage_size          = 30
  public_ips            = [ ionoscloud_ipblock.ipblock-FrankfortDC.ips[0], ionoscloud_ipblock.ipblock-FrankfortDC.ips[1], ionoscloud_ipblock.ipblock-FrankfortDC.ips[2] , ionoscloud_ipblock.ipblock-FrankfortDC.ips[3] ]
  lans {
    id                  = ionoscloud_lan.net0-frankfortDC.id
    dhcp                = true
   } 
} 
