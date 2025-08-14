# Outputs
output "compartment_ids" {
  value = {
    for env, compartment in local.all_compartments : env => compartment
  }
}

output "loadbalancer_ip" {
  value = {
    for env, lb in oci_load_balancer.PublicLoadBalancer : env => lb.ip_address_details[0].ip_address
  }
}

output "workspace" {
  value = terraform.workspace
}