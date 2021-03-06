data "aws_route53_zone" "default" {
  name = "${var.dns_zone}"
}

module "vault_elb" {
  source = "git::https://github.com/Cimpress-MCP/terraform-aws-vault.git//modules/vault-elb?ref=v0.10.0"

  name                        = "${var.cluster_name}-vault-elb"
  vpc_id                      = "${var.vpc_id}"
  allowed_inbound_cidr_blocks = ["0.0.0.0/0"]

  subnet_ids = ["${var.vpc_public_subnets}"]

  create_dns_entry = true
  hosted_zone_id   = "${data.aws_route53_zone.default.zone_id}"
  domain_name      = "${var.dns_name}"

  vault_asg_name = "${module.vault_cluster.asg_name}"
}
