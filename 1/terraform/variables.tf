variable "account_file" {
    default = "/etc/kubestack-account.json"
}

variable "image" {
    default = "kubestack-0-17-1-v20150606"
}

variable "project" {}

variable "portal_net" {
    default = "10.200.0.0/16"
}

variable "region" {
    default = "us-central1"
}

variable "sshkey_metadata" {}

variable "token_auth_file" {
    default = "secrets/tokens.csv"
}

variable "worker_count" {
    default = 1
}

variable "zone" {
    default = "us-central1-a"
}

variable "cluster_name" {
    default = "testing"
}
