resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "eu-central-1a"
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "eu-central-1b"
}
