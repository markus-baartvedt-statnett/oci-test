# DHCP Options
resource "oci_core_dhcp_options" "dhcp_options" {
    compartment_id  = local.all_compartments[terraform.workspace]
    vcn_id          = oci_core_virtual_network.vcn.id
    display_name    = "dhcp-options-${terraform.workspace}"

  options {
        type        = "DomainNameServer"
        server_type = "VcnLocalPlusInternet"
  }

  options {
        type                = "SearchDomain"
        search_domain_names = [ "${terraform.workspace}.marksome.no" ]
  }
}