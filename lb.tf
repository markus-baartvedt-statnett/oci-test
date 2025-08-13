# Load Balancer
resource "oci_load_balancer" "PublicLoadBalancer" {
  for_each                      = local.workspace

  compartment_id                = local.all_compartments[terraform.workspace]
  display_name                  = "PublicLB-${terraform.workspace}"
  network_security_group_ids    = [oci_core_network_security_group.WebSecurityGroup.id] # or per compartment if available
  subnet_ids                    = [oci_core_subnet.lb_subnets[terraform.workspace].id]
  shape                         = "flexible"
  shape_details {
    minimum_bandwidth_in_mbps = 10
    maximum_bandwidth_in_mbps = 1000
  }
}

resource "oci_load_balancer_backendset" "PublicLoadBalancerBackendset" {
  for_each          = oci_load_balancer.PublicLoadBalancer
  name              = "LBBackendset"
  load_balancer_id  = local.all_compartments[terraform.workspace]
  policy            = "ROUND_ROBIN"

  health_checker {
    port                = "80"
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/"
  }
}

resource "oci_load_balancer_listener" "PublicLoadBalancerListener" {
  for_each                  = oci_load_balancer.PublicLoadBalancer
  load_balancer_id          = local.all_compartments[terraform.workspace]
  name                      = "LBListener"
  default_backend_set_name  = oci_load_balancer_backendset.PublicLoadBalancerBackendset[terraform.workspace].name
  port                      = 80
  protocol                  = "HTTP"
}

resource "oci_load_balancer_backend" "PublicLoadBalancerBackend" {
  for_each          = oci_load_balancer.PublicLoadBalancer
  load_balancer_id  = local.all_compartments[terraform.workspace]
  backendset_name   = oci_load_balancer_backendset.PublicLoadBalancerBackendset[terraform.workspace].name

  # Assuming one instance per compartment with the same key
  ip_address       = oci_core_instance.webservers[local.workspace].private_ip
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}