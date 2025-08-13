# NAT Gateway
resource "oci_core_nat_gateway" "nat" {
    compartment_id  = var.compartment_ocid
    display_name    = "${var.vcn_dns_label}nat"
    vcn_id        = oci_core_virtual_network.vcn.id
}