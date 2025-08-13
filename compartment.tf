# Compartments
data "oci_identity_compartments" "existing" {
    compartment_id = var.tenancy_ocid
}

# Check which components exist and which to create
locals {
    active_compartments = {
        for compartment in data.oci_identity_compartments.existing.compartments : 
        compartment.name => compartment
        if contains(keys(var.compartments), compartment.name)
    }
    compartments_to_create = {
        for k, v in var.compartments :
        k => v
        if !contains(keys(local.active_compartments), k)
    }
}

resource "oci_identity_compartment" "compartments" {
    for_each       = local.compartments_to_create
    name           = each.key
    description    = each.value
    enable_delete  = true
    compartment_id = var.tenancy_ocid
}

# Merge existing + newly created compartments
locals {
  all_compartments = merge(
    local.active_compartments,
    { for k, v in oci_identity_compartment.compartments : k => v.id }
  )
}