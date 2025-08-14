# Outputs
output "compartment_ids" {
    value = {
        for env, compartment in local.all_compartments : env => compartment
    }
}

output "loadbalancer_ip" {
    value = oci_load_balancer.PublicLoadBalancer.ip_address_details
}

output "instance_public_ip" {
  value = data.oci_core_vnic.webserver_vnic.public_ip
}

output "workspace" {
    value = terraform.workspace
}