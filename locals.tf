# Local variables
locals {
    compartment_keys = sort(keys(local.compartments_to_manage))

    # Assign a unique index to each compartment key
    compartment_cidr_indices = {
        for i, key in local.compartment_keys : key => i
    }
}

# Workspace
locals {
    workspace = terraform.workspace
}