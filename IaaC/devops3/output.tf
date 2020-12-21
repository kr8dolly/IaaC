output "address" {
  value      = "http://${aws_lb.webapp.dns_name}/wp-admin/install.php"
  depends_on = [aws_lb.webapp]
}
