
The utilization of IONOS Cloud Terraform modules may necessitate the installation of the Go programming language (Golang) as a prerequisite.

Create a directory to download the GO installation source:

```bash
mkdir /opt/go
```

Download the "tar.gz" file:

```bash
wget -d /opt/go https://dl.google.com/go/go1.21.2.linux-amd64.tar.gz
```

Changed to the downloaded file's directory:

```bash
cd /opt/go
```

Untar the archive: 

```bash
tar -C /usr/local -xzf go1.21.2.linux-amd64.tar.gz
```

Enable `go` command for the shell by editing the file `~/.bashrc`:

```bash 
echo "export PATH=$PATH:/usr/local/go/bin" ~/.bashrc
source ~/.bashrc
```

For verification:

```bash
$ go version  
go version go1.21.2 linux/amd64
```
