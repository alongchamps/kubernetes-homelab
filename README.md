# kubernetes-homelab
This is a repo that stores kubernetes related files for my home lab.

`opentofu/vmware/kubernetes` - This directory holds files to deploy 5 VMs from a template in my home lab. The code for all my templates can be seen over at my (https://github.com/alongchamps/packer)[packer] repo.

`ansible/kubernetes` - This one holds Ansible playbooks to setup a small Kubernetes environment. This includes installing all packages, setting up 3 control plane nodes, 2 worker nodes, and all the networking pieces of Kubernetes.