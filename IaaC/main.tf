# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key = "AKIAI33NLWPMLG6U2BZA"
  secret_key = "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"
}

# Create a VPC
resource "aws_instance" "my-fierst-server" {
  ami           = "ami-0c20b8b385217763f"
  instance_type = "t3.micro"
}