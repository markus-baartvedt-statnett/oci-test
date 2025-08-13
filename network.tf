# Network
resource "oci_core_virtual_network" "vcn" {
    compartment_id  = var.compartment_ocid
    cidr_block      = var.vcn_cidr
    dns_label       = var.vcn_dns_label
    display_name    = var.vcn_dns_label
}

resource "oci_core_subnet" "web_subnets" {
    for_each            = local.workspace

    compartment_id      = local.all_compartments[local.workspace]
    vcn_id              = oci_core_virtual_network.vcn.id
    cidr_block          = cidrsubnet(var.vcn_cidr, 8, local.compartment_cidr_indices[local.workspace])
    display_name        = "web-subnet-${local.workspace}"
    dns_label           = "web${local.workspace}"
    route_table_id      = oci_core_route_table.RouteTableViaIGW.id
    dhcp_options_id     = oci_core_dhcp_options.dhcp_options[local.workspace].id
    security_list_ids   = [oci_core_security_list.WebSecurityList.id,oci_core_security_list.SSHSecurityList.id]
}

resource "oci_core_subnet" "lb_subnets" {
    for_each            = local.workspace

    compartment_id      = local.all_compartments[local.workspace]
    vcn_id              = oci_core_virtual_network.vcn.id
    cidr_block          = cidrsubnet(var.vcn_cidr, 8, length(local.compartment_cidr_indices)+local.compartment_cidr_indices[local.workspace])
    display_name        = "lb-subnet-${local.workspace}"
    dns_label           = "lb${local.workspace}"
    route_table_id      = oci_core_route_table.RouteTableViaIGW.id
    dhcp_options_id     = oci_core_dhcp_options.dhcp_options[local.workspace].id
    security_list_ids   = [oci_core_security_list.WebSecurityList.id,oci_core_security_list.SSHSecurityList.id]
}

