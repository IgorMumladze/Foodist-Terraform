variable values_path {
  type        = string
  description = "Path to ArgoCD values.yml"
}

variable main_cd_path {
  type        = string
  description = "Path to bootsrap application resource manifest"
}

variable "repo_url" {
  description = "GitOps repo url"
  type = string
  
}