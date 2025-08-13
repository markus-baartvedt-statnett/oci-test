# Internet Gateway
resource "oci_core_internet_gateway" "igw" {
    compartment_id  = var.compartment_ocid
    display_name    = "${var.vcn_dns_label}igw"
    vcn_id          = oci_core_virtual_network.vcn.id
}