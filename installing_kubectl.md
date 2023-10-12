# Installing Kubectl

To facilitate remote interaction with a Kubernetes cluster from our local machine, it's imperative to deploy the `kubectl` command line utility. The following instructions outline the specific steps for installing this essential utility.

Update the `apt` package index and install prerequisites to use the Kubernetes `apt` repository:

```bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
```

Download the public signing key for the Kubernetes package repositories.

```bash
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```

Add the appropriate Kubernetes `apt` repository:

```bash
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
```

Install kubectl: 

```bash
sudo apt-get update
sudo apt-get install -y kubectl
```

For verification:

```bash
$ kubectl version  
Client Version: v1.28.2
```

