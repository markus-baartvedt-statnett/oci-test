# Security Lists
resource "oci_core_security_list" "WebSecurityList" {
    compartment_id  = var.compartment_ocid
    display_name    = "WebSecurityList"
    vcn_id          = oci_core_virtual_network.vcn.id
    
    egress_security_rules {
        protocol    = "6"
        destination = "0.0.0.0/0"
    }
    
    dynamic "ingress_security_rules" {
    for_each = var.webservice_ports
    content {
        protocol = "6"
        source = "0.0.0.0/0"
        tcp_options {
            max = ingress_security_rules.value
            min = ingress_security_rules.value
            }
        }
    }

    ingress_security_rules {
        protocol    = "6"
        source      = var.vcn_cidr
    }
}

resource "oci_core_security_list" "SSHSecurityList" {
    compartment_id  = var.compartment_ocid
    display_name    = "SSHSecurityList"
    vcn_id          = oci_core_virtual_network.vcn.id
    
    egress_security_rules {
        protocol    = "6"
        destination = "0.0.0.0/0"
    }
    
    dynamic "ingress_security_rules" {
    for_each        = var.bastion_ports
    content {
        protocol    = "6"
        source      = "0.0.0.0/0"
        tcp_options {
            max = ingress_security_rules.value
            min = ingress_security_rules.value
            }
        }
    }

    ingress_security_rules {
        protocol    = "6"
        source      = var.vcn_cidr
    }
}