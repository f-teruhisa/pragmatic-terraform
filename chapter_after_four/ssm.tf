resource "aws_ssm_parameter" "db_username" {
  name        = "/db/username"
  value       = "root"
  type        = "String"
  description = "データベースの接続ユーザ名"
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/db/password"
  type        = "SecureString"
  value       = "uninitialized" # あとでAWS CLIで更新する
  description = "データベースのパスワード"

  lifecycle {
    ignore_changes = [value]
  }
}


