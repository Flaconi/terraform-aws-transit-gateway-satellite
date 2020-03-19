data "aws_vpc" "this" {
  provider = aws.satellite
  count    = local.create ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.vpc_name_to_attach]
  }
}

data "aws_subnet_ids" "this" {
  provider = aws.satellite
  count    = local.create ? 1 : 0
  vpc_id   = data.aws_vpc.this[0].id
  tags = {
    Name = "*${var.subnet_name_keyword_selector}*"
  }
}

data "aws_route_table" "this" {
  provider = aws.satellite
  count    = local.create ? length(data.aws_subnet_ids.this[0].ids) : 0

  subnet_id = sort(data.aws_subnet_ids.this[0].ids)[count.index]
}
