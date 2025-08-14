# Local variables
locals {
    compartment_keys = sort(keys(local.all_compartments))

    # Assign a unique index to each compartment key
    compartment_cidr_indices = {
        for i, key in local.compartment_keys : key => i
    }
    
}