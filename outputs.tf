# Outputs
output "compartment_ids" {
  value = {
    for env, compartment in local.all_compartments : env => compartment
  }
}

output "loadbalancer" {
  value = {
    for env, loadbalancer in oci_load_balancer.PublicLoadBalancer : env => loadbalancer
  }
}

output "workspace" {
  value = terraform.workspace
}