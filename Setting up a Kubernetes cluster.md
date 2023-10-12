-----------
## Introduction

In this document, we will walk through the steps to deploy a Managed Kubernetes Cluster within the IONOS Cloud infrastructure. The primary objective is deploy services to monitor "mail.ionos.com" URL using Prometheus for metrics collection and Grafana for visualization.

### Prerequisites

Before you begin, ensure you have the following prerequisites in place:

- An IONOS Cloud account with access to create resources.
- Basic familiarity with Kubernetes, Prometheus, Grafana, and Terraform and Helm
- A terminal with these packages installed.
	- [Golang](https://github.com/sourensam/ionos_project/blob/main/installing_golang.md)
	- [Terraform]([./Installing_Terraform](https://github.com/sourensam/ionos_project/blob/main/Installing_Terraform.md)
	- [kubectl](https://github.com/sourensam/ionos_project/blob/main/installing_kubectl.md)
	- [inonsctl](https://github.com/sourensam/ionos_project/blob/main/Installing_ionosctl.md)

---

## Propagate a kubernetes cluster on IONOS cloud

##### Initialize Terraform to use IONOS provider

Create `main.tf` file:

```bash
mkdir ~/project
cd ~/project 
vim main.tf
```

Paste this content to *main.tf* file:

```yml
terraform {  
 required_providers {  
   ionoscloud = {  
     source = "ionos-cloud/ionoscloud"  
     version = "= 6.2.1"  
   }  
 }  
}  
  
provider "ionoscloud" {  
 username = "User@domain.com"  
 password = "PaSsKeY"  
 endpoint = "api.ionos.com"  
}
```

**Note**: As an alternative to embedding the "username" and "password" keys directly within the _main.tf_ file, you can achieve the same by configuring these key-value pairs as environment variables.

```bash
export IONOS_USERNAME="User@domain.com"
export IONOS_PASSWORD="PaSsKeY"
```

Initialize the Terraform configuration in `~/project` directory:

```bash
cd ~/project
terraform init
```

* By running the `terraform init` command, the Terraform client readies the environment directory for interaction with the "ionos-cloud/ionoscloud" provider.

By applying this Terraform configuration, you will create a Kubernetes cluster within an IONOS Cloud Virtual Datacenter, adhering to the following specifications:

* The Datacenter Zone: "de/fra"
- A Virtual Datacenter Named "Frankfort Datacenter"
- A Local Area Network named "net0-frankfortDC"
- Provisioning of four IPv4 public addresses
- A Kubernetes Cluster Named "frankfort-kube-cluster"
- A Configuration of the Kubernetes NodePool

```yaml
## Define the required providers, in this case, the ionoscloud provider.
terraform {
  required_providers {
    ionoscloud = {
      source = "ionos-cloud/ionoscloud"
      version = "= 6.2.1"
    }
  }
}

## Configure the ionoscloud provider with your credentials and API endpoint.
provider "ionoscloud" {
  username = "User@domain.com"
  password = "PaSsKeY"
  endpoint = "api.ionos.com"
}

## Define a resource block for creating an Ionos Cloud datacenter.
resource "ionoscloud_datacenter" "FrankfortDC" {
  name              = "Frankfort Datacenter"
  location          = "de/fra"
  description       = "Virtual datacenter in Frankfurt"
  sec_auth_protection = false
}

## Define a resource block for creating an Ionos Cloud LAN (Local Area Network).
resource "ionoscloud_lan" "net0-frankfortDC" {
  datacenter_id = ionoscloud_datacenter.FrankfortDC.id
  public        = false
  name          = "net0-frankfortDC"

  ## Ensure LAN creation happens before its destruction to avoid conflicts.
  # "create_before_destroy" When set to `true`, 
  # it ensures that Terraform first creates a new instance of the resource
  # before destroying the old one. This is particularly useful for resources
  # like networks (LANs in this case) where you want to avoid downtime or
  # conflicts during the replacement.
  lifecycle {
    create_before_destroy = true
  }
}

# Define a resource block for creating an Ionos Cloud IP block.
resource "ionoscloud_ipblock" "ipblock-FrankfortDC" {
  location = "de/fra"
  size     = 4
  name     = "IP Block FrankfortDC"
}

# Define a resource block for creating an Ionos Cloud Kubernetes cluster.
resource "ionoscloud_k8s_cluster" "FrankforDC-Kube-Cluster" {
  name         = "frankfort-kube-cluster"
  k8s_version  = "1.25.6"
}

# Define a resource block for creating an Ionos Cloud Kubernetes Node Pool.
resource "ionoscloud_k8s_node_pool" "frankfort-Node_Pool" {
  datacenter_id  = ionoscloud_datacenter.FrankfortDC.id
  k8s_cluster_id = ionoscloud_k8s_cluster.FrankforDC-Kube-Cluster.id
  name           = "kube-Node-Pool-Franfort-DC"
  k8s_version    = ionoscloud_k8s_cluster.FrankforDC-Kube-Cluster.k8s_version
  ## define the min and max (imum) range for the nodes autoscaling
  auto_scaling {
    min_node_count = 1
    max_node_count = 2
  }
  ## Define system resources
  cpu_family         = "INTEL_SKYLAKE"
  availability_zone  = "AUTO"
  storage_type       = "HDD"
  node_count         = 2
  cores_count        = 2
  ram_size           = 4096
  storage_size       = 30

  ## Assign public IP addresses from the previously created IP block.
  public_ips = [
    ionoscloud_ipblock.ipblock-FrankfortDC.ips[0],
    ionoscloud_ipblock.ipblock-FrankfortDC.ips[1],
    ionoscloud_ipblock.ipblock-FrankfortDC.ips[2],
    ionoscloud_ipblock.ipblock-FrankfortDC.ips[3]
  ]

  ## Associate the Node Pool with the LAN and enable DHCP.
  lans {
    id   = ionoscloud_lan.net0-frankfortDC.id
    dhcp = true
  }
}
```

##### Plan the configuration

The command `terraform plan` generates an execution plan for Terraform configurations, outlining changes to be made in the infrastructure without actually applying them. It's a vital step for assessing and validating proposed changes before execution.

```bash
terraform plan
```

##### Apply the configuration

`terraform apply` is used to apply the Terraform configuration, translating it into real changes in the cloud infrastructure.

```bash
terraform apply
```

The process of deploying the infrastructure takes some time to complete. Once you receive the successful completion message in the output, the Kubernetes cluster is operational and prepared to host applications.

Additionally, you may find it beneficial to log in to [dcd.ionos.com](https://dcd.ionos.com/) to view a diagram depicting the applied configurations. 

![kluster_up](./pics/kluster_up.png) 

##### Client Tools Configuration

In our setup, we utilize two essential client tools, namely `ionosctl` and `kubectl`, to interact with IONOS Cloud and the Kubernetes cluster. These tools require specific configurations and identity files to function properly. In the following sections, we will explain these important configurations in detail. 

**ionosctl**: 

After successfully installing the [ionosctl](https://chat.openai.com/c/Installing_ionosctl) command, it's important to ensure that you have configured the necessary environment variables. These variables are crucial as they contain your credential information, which is used for authorization.

```bash
export IONOS_USERNAME="User@domain.com"
export IONOS_PASSWORD="PaSsKeY"
```

or alternatively you can use this command: 

```bash
ionosctl login --user <user_name> --password <password> -v
```

**kubectl:

To establish communication with the Kubernetes cluster, it is essential to include the cluster configuration file on your local system. We achieve this by utilizing the `ionosctl` command as follows:

Getting the cluster ID:
```bash
ionosctl k8s cluster list  
```

Creating the kubernetes configuration file:

```bash
mkdir -p ~/.kube/config 
ionosctl k8s kubeconfig get --cluster-id <cluster-id> > ~/.kube/config
```

This sequence of commands enables you to obtain the necessary cluster information and configure it for use with `kubectl`.

```bash
kubectl cluster-info
kubectl get nodes -o wide
```

---



