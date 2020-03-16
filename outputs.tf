output "transit_gateway_vpc_attachment_id" {
  description = "Identifier of the Transit Gateway VPC Attachment"
  value       = element(concat(aws_ec2_transit_gateway_vpc_attachment.this.*.id, list("")), 0)
}
