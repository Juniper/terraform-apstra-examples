#
# Global variables
#

# change to true/false for QFX/PTX spines
# PTX is the high-radix large template option, creating the GPU fabric blueprint
# Also:
# terraform apply -var="all_qfx_backend=false"

variable "all_qfx_backend" {
  type    = bool
  default = false
}
