# Security Group
resource "oci_core_network_security_group" "WebSecurityGroup" {
    compartment_id  = var.compartment_ocid
    display_name    = "WebSecurityGroup"
    vcn_id          = oci_core_virtual_network.vcn.id
}

resource "oci_core_network_security_group" "SSHSecurityGroup" {
    compartment_id  = var.compartment_ocid
    display_name    = "SSHSecurityGroup"
    vcn_id          = oci_core_virtual_network.vcn.id
}