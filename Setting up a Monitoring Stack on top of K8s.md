---

---
-----------

## Deployment Overview

Within this documentation, our objective is to deploy a comprehensive monitoring stack comprising the Prometheus-BlackBox exporter, Prometheus TS-DB server, and Grafana component. The BlackBox exporter will specifically monitor the availability and performance of the "mail.ionos.com" website.

![dggrm](./pics/stckdgrm.png)

------
### Prerequisites 

Before proceeding with this deployment, it is imperative to meet the following requirements:

- An operational Kubernetes cluster.
- Access to the Kubernetes cluster through the use of `kubectl`.
- Installation of the [Helm](https://chat.openai.com/c/installing_helm) package.

---

