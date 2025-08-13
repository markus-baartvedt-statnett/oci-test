# Network
resource "oci_core_virtual_network" "vcn" {
    compartment_id  = var.compartment_ocid
    cidr_block      = var.vcn_cidr
    dns_label       = var.vcn_dns_label
    display_name    = var.vcn_dns_label
}

resource "oci_core_subnet" "web_subnets" {
    for_each            = local.compartments_to_manage

    compartment_id      = each.value.id
    vcn_id              = oci_core_virtual_network.vcn.id
    cidr_block          = cidrsubnet(var.vcn_cidr, 8, local.compartment_cidr_indices[each.key])
    display_name        = "web-subnet-${each.key}"
    dns_label           = "web${each.key}"
    route_table_id      = oci_core_route_table.RouteTableViaIGW.id
    dhcp_options_id     = oci_core_dhcp_options.dhcp_options[each.key].id
    security_list_ids   = [oci_core_security_list.WebSecurityList.id,oci_core_security_list.SSHSecurityList.id]
}

resource "oci_core_subnet" "lb_subnets" {
    for_each            = local.compartments_to_manage

    compartment_id      = each.value.id
    vcn_id              = oci_core_virtual_network.vcn.id
    cidr_block          = cidrsubnet(var.vcn_cidr, 8, length(local.compartment_cidr_indices)+local.compartment_cidr_indices[each.key])
    display_name        = "lb-subnet-${each.key}"
    dns_label           = "lb${each.key}"
    route_table_id      = oci_core_route_table.RouteTableViaIGW.id
    dhcp_options_id     = oci_core_dhcp_options.dhcp_options[each.key].id
    security_list_ids   = [oci_core_security_list.WebSecurityList.id,oci_core_security_list.SSHSecurityList.id]
}

