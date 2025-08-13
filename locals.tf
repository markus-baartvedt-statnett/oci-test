# Local variables
locals {
    compartment_keys = sort(keys(local.workspace))

    # Assign a unique index to each compartment key
    compartment_cidr_indices = {
        for i, key in local.compartment_keys : key => i
    }
}


locals {
    # All compartments
    all_compartments = merge(
        { for k, v in local.active_compartments : k => v if k == terraform.workspace },
        { for k, v in oci_identity_compartment.compartments : k => v.id if k == terraform.workspace }
    )
    # Current workspace
    workspace = local.all_compartments[terraform.workspace]
}