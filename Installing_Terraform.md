In this context, we shall employ Terraform as the provisioning tool to orchestrate the deployment of a [Managed Kubernetes](https://cloud.ionos.com/managed/kubernetes) cluster within the [IONOS virtual datacenter](https://cloud.ionos.com/data-center-designer) environment. This documentation indicates the installation of Terraform as the client interface to facilitate the creation of said infrastructure.

Add Terraform GPG key for apt package manager:

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
```

Add Hashicorp repository for apt:

```bash
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```

Installing Terraform:

```bash
sudo apt update && sudo apt install terraform
```

For verification:

```bash
$ terraform -version  
Terraform v1.6.0  
on linux_amd64
```
