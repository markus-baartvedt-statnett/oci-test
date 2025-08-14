# Load Balancer
resource "oci_load_balancer" "PublicLoadBalancer" {
  compartment_id                = local.all_compartments[terraform.workspace]
  display_name                  = "PublicLB-${terraform.workspace}"
  network_security_group_ids    = [oci_core_network_security_group.WebSecurityGroup.id]
  subnet_ids                    = [oci_core_subnet.lb_subnets.id]
  shape                         = "flexible"
  shape_details {
    minimum_bandwidth_in_mbps = 10
    maximum_bandwidth_in_mbps = 1000
  }
}

resource "oci_load_balancer_backendset" "PublicLoadBalancerBackendset" {
  name              = "LBBackendset"
  load_balancer_id  = oci_load_balancer.PublicLoadBalancer.id
  policy            = "ROUND_ROBIN"

  health_checker {
    port                = "80"
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/"
  }
}

resource "oci_load_balancer_listener" "PublicLoadBalancerListener" {
  load_balancer_id          = oci_load_balancer.PublicLoadBalancer.id
  name                      = "LBListener"
  default_backend_set_name  = oci_load_balancer_backendset.PublicLoadBalancerBackendset.name
  port                      = 80
  protocol                  = "HTTP"
}

resource "oci_load_balancer_backend" "PublicLoadBalancerBackend" {
  load_balancer_id  = oci_load_balancer.PublicLoadBalancer.id
  backendset_name   = oci_load_balancer_backendset.PublicLoadBalancerBackendset.name

  # Assuming one instance per compartment with the same key
  ip_address       = oci_core_instance.webservers.private_ip
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}