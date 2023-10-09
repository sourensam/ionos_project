The installation of Helm packages offers various methods, and in this context, we opt for the "from binary" installation approach:

Begin by downloading the binary package from the Helm [releases](https://github.com/helm/helm/releases) page 

```bash
mkdir -p /opt/helm
cd /opt/helm
wget https://get.helm.sh/helm-v3.13.0-linux-amd64.tar.gz
```

Un-archive the package:

```bash
tar -zxvf helm-v3.0.0-linux-amd64.tar.gz
```

Find the `helm` binary in the unpacked directory, and move it to its desired destination:

```bash
mv ./linux-amd64/helm /usr/local/bin/helm
```

For verification: 

```bash
$ helm version
version.BuildInfo{Version:"v3.13.0", GoVersion:"go1.20.8"}
```
