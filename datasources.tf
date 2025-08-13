# Get list of availablility domains
data "oci_identity_availability_domains" "ADs" {
    compartment_id = var.compartment_ocid
}

# Gets a list of supported images based on the shape, operating_system and operating_system_version provided
data "oci_core_images" "compute_images" {
    for_each                    = local.workspace

    compartment_id              = local.all_compartments[local.workspace]
    operating_system            = var.image_operating_system
    operating_system_version    = var.image_operating_system_version
    shape                       = var.instance_shape
    sort_by                     = "TIMECREATED"
    sort_order                  = "DESC"
}