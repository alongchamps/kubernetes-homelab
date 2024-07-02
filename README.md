# kubernetes-homelab
This is a repo that stores kubernetes related files for my home lab.

`opentofu/vmware/kubernetes` - This directory holds files to deploy 5 VMs from a template. I'm using OpenTofu here to provision 5 VMs and also run a quick startup script. This is based on the template which I build with packer [over here](https://github.com/alongchamps/packer).

`ansible/kubernetes` - This one holds Ansible playbooks to setup a 5-node Kubernetes cluster. This includes installing all packages, setting up 3 control plane nodes, 2 worker nodes, and all the networking pieces of Kubernetes.

`10-cluster-construction` is an Ansible playbook for standing up the cluster. This will install packages, apply configurations, initialize the cluster, join other nodes, setup all networking components, DNS for *.kubes.homelab, and add an NFS CSI Provider.

`20-monitoring` is an Ansible script for standing up Grafana, Prometheus, and Telegraf. As of now, that's a work in progress. Once this playbook runs, Grafana will be reachable at https://grafana.kubes.homelab, Prometheus is my TSDB, and Telegraf will ingest metrics from the targeted endpoints. This builds on the ingress and DNS configuration that is setup in the previous playbook.
