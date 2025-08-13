# Outputs
output "compartment_ids" {
  value = {
    for env, compartment in local.workspace : env => compartment
  }
}

output "webserver_ids" {
  value = { for env, value in oci_core_instance.webservers : env => value.id }
}

output "webserver_private_ips" {
  value = {
    for env, instance in oci_core_instance.webservers : env => instance.create_vnic_details[0].private_ip
  }
}

output "PublicLoadBalancer_Public_IPs" {
  value = {
    for env, loadbalancer in oci_load_balancer.PublicLoadBalancer :
    env => loadbalancer.ip_addresses
  }
}

output "workspace" {
  value = terraform.workspace
}

output "dhcp_options_keys" {
  value = keys(oci_core_dhcp_options.dhcp_options)
}