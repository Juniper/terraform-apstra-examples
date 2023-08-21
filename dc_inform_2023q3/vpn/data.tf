data "terraform_remote_state" "fabric" {
  backend = "s3"
  config = {
    bucket = "inform-demo"
    key    = "fabric/terraform.tfstate"
    region = "us-east-1"
  }
}