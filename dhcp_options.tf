# DHCP Options
resource "oci_core_dhcp_options" "dhcp_options" {
    for_each        = local.workspace
    
    compartment_id  = each.value.id
    vcn_id          = oci_core_virtual_network.vcn.id
    display_name    = "dhcp-options-${each.key}"

  options {
        type        = "DomainNameServer"
        server_type = "VcnLocalPlusInternet"
  }

  options {
        type                = "SearchDomain"
        search_domain_names = [ "${each.key}.marksome.no" ]
  }
}