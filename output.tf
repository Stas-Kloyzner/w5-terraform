output "ss_password" {
  value = module.vm_scale_set.scaleset_password
  sensitive = true
}