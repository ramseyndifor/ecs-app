#vpc 
resource "aws_vpc" "ecs-app-vpc" {
  cidr_block       = "10.10.16.0/24"
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = merge(
    local.default_tags,
    {
        Name = "${local.project}-vpc"
    }
  )
}

#private subnets
resource "aws_subnet" "privsub_1" {
  vpc_id     = aws_vpc.ecs-app-vpc.id
  cidr_block = "10.10.16.0/26"
  availability_zone = "us-east-1a"

  tags = merge(
    local.default_tags,
    {
        Name = "${local.project}-privsub-1"
    }
  )
}

resource "aws_subnet" "privsub_2" {
  vpc_id     = aws_vpc.ecs-app-vpc.id
  cidr_block = "10.10.16.64/26"
  availability_zone = "us-east-1b"

  tags = merge(
    local.default_tags,
    {
        Name = "${local.project}-privsub-2"
    }
  )
}

#public subnets
resource "aws_subnet" "pubsub_1" {
  vpc_id     = aws_vpc.ecs-app-vpc.id
  cidr_block = "10.10.16.128/26"
  availability_zone = "us-east-1a"

  tags = merge(
    local.default_tags,
    {
        Name = "${local.project}-pubsub-1"
    }
  )
}

resource "aws_subnet" "pubsub_2" {
  vpc_id     = aws_vpc.ecs-app-vpc.id
  cidr_block = "10.10.16.192/26"
  availability_zone = "us-east-1b"

  tags = merge(
    local.default_tags,
    {
        Name = "${local.project}-pubsub-2"
    }
  )
}

#Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.ecs-app-vpc.id

    tags = merge(
    local.default_tags,
    {
        Name = "${local.project}-igw"
    }
  )
}

# Not Required
# resource "aws_internet_gateway_attachment" "igw_attach" {
#     internet_gateway_id = aws_internet_gateway.igw.id
#     vpc_id = aws_vpc.ecs-app-vpc.id
# }

#Nat Gateway 
resource "aws_eip" "ngw_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "ngw" {
    allocation_id = aws_eip.ngw_eip.id
    subnet_id = aws_subnet.pubsub_1.id

    tags = merge(
        local.default_tags,
        {
            Name = "${local.project}-ngw"
        }
    )
}

#Route Tables
resource "aws_route_table" "privrt" {
  vpc_id = aws_vpc.ecs-app-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }

  tags = merge(
        local.default_tags,
        {
            Name = "${local.project}-privrt"
        }
    )
}

resource "aws_route_table_association" "privrt_assoc_1" {
  subnet_id = aws_subnet.privsub_1.id
  route_table_id = aws_route_table.privrt.id
}

resource "aws_route_table_association" "privrt_assoc_2" {
  subnet_id = aws_subnet.privsub_2.id
  route_table_id = aws_route_table.privrt.id
}

resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.ecs-app-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
        local.default_tags,
        {
            Name = "${local.project}-pubrt"
        }
    )
}

resource "aws_route_table_association" "pubrt_assoc_1" {
  subnet_id = aws_subnet.pubsub_1.id
  route_table_id = aws_route_table.pubrt.id
}

resource "aws_route_table_association" "pubrt_assoc_2" {
  subnet_id = aws_subnet.pubsub_2.id
  route_table_id = aws_route_table.pubrt.id
}