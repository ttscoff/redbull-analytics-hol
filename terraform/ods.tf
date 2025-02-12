# Copyright (c) 2021 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#

#*************************************
#           ODS Project
#*************************************

resource "oci_datascience_project" "ods-project" {
  count = var.enable_ods ? 1 : 0
  
  compartment_id = var.compartment_ocid
  display_name   = var.ods_project_name
  
  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"] ]
  }
  defined_tags = {
    "${oci_identity_tag_namespace.devrel.name}.${oci_identity_tag.release.name}" = local.release
  }
}

#*************************************
#           ODS Project Session
#*************************************

resource "oci_datascience_notebook_session" "ods-notebook-session" {
  count = var.enable_ods ? var.ods_number_of_notebooks : 0

  compartment_id = var.compartment_ocid
  notebook_session_configuration_details {
    shape     = var.ods_compute_shape
    subnet_id = local.private_subnet_id
    block_storage_size_in_gbs = var.ods_storage_size
  }
  project_id = oci_datascience_project.ods-project[0].id
  display_name = "${var.ods_notebook_name}-${count.index}"
  
  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"] ]
  }
  defined_tags = {
    "${oci_identity_tag_namespace.devrel.name}.${oci_identity_tag.release.name}" = local.release
  }
}