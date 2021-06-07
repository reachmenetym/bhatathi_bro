resource "aws_security_group_rule" "allow_webserver_in_app_server" {
  type              = "ingress"
  to_port           = 8484
  protocol          = "tcp"
  source_security_group_id = "${module.web_instance.web_sg_id}"
  from_port         = 8484
  security_group_id = "${module.app_instance.app_sg_id}"
}