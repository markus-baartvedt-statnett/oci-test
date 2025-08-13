# Outputs
output "compartment_ids" {
  value = {
    for env, compartment in local.workspace : env => compartment
  }
}

output "workspace" {
  value = terraform.workspace
}