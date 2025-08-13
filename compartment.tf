# Compartments
data "oci_identity_compartments" "existing" {
    compartment_id = var.tenancy_ocid
}

# Check which components exist and which to create
locals {
    # Active compartments in oci
    active_compartments = {
        for compartment in data.oci_identity_compartments.existing.compartments : 
        compartment.name => compartment
        if contains(keys(var.compartments), compartment.name)
    }
    # Compartment to manage based on current workspace
    compartments_to_manage = {
        for name, desc in var.compartments :
        name => desc
        if name == terraform.workspace && !contains(keys(local.active_compartments), name)
  }
}

# Create (or destroy) the compartment for the current workspace
resource "oci_identity_compartment" "compartments" {
    for_each       = local.compartments_to_manage
    name           = each.key
    description    = each.value
    enable_delete  = true
    compartment_id = var.tenancy_ocid
}

locals {
    # All compartments
    all_compartments = merge(
        { for k, v in local.active_compartments : k => v if k == terraform.workspace },
        { for k, v in oci_identity_compartment.compartments : k => v.id if k == terraform.workspace }
    )
    # Current workspace
    workspace = { for k, v in oci_identity_compartment.compartments : k => v.id if k == terraform.workspace }
}