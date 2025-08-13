# Compute Instance
resource "oci_core_instance" "webservers" {
    availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0].name
    compartment_id      = local.all_compartments[terraform.workspace]
    display_name        = "Webserver-${terraform.workspace}"
    shape               = var.instance_shape

    create_vnic_details {
        subnet_id       = oci_core_subnet.web_subnets.id
        display_name    = "webserver-vnic-${terraform.workspace}"
    }
    
    source_details {
        source_type             = "image"
        source_id               = data.oci_core_images.compute_images[terraform.workspace].images[0].id
        boot_volume_size_in_gbs = 50
    }

    metadata = {
        ssh_authorized_keys = chomp(file(var.ssh_public_key))
        user_data           = base64encode(file("./userdata/bootstrap"))
    }

    shape_config {
        memory_in_gbs   = 1
        ocpus           = 1
    }
}