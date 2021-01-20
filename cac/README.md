### Command And Control 

This is the base image for the command and control node for automated builds

It contains:-

  * AWS CLI
  * Ansible
  * Hashicorp Packer
  * Hashicorp Terraform
  * kubectl
  * kustomize
  * eksctl
  * Other useful tools, see the Dockerfile for details

Note, no credentials are installed, you should inject credentials as required.

