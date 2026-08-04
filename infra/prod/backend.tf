terraform {
  backend "s3" {
    bucket = "YOUR-TFSTATE-BUCKET"
    key    = "starwords/prod/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}
