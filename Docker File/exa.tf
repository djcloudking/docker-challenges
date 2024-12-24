resource "aws_s3tables_table_bucket" "example" {
  name = "example-bucket"
}
resource "aws_s3tables_table_bucket_policy" "example" {
  resource_policy  = data.aws_iam_policy_document.table_bucket.json
  table_bucket_arn = aws_s3tables_table_bucket.example.arn
}
data "aws_iam_policy_document" "table_bucket" {
  statement {
    actions = ["s3tables:*"]
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }
    resources = ["${aws_s3tables_table_bucket.example.arn}/*"]
  }
}
resource "aws_s3tables_namespace" "example" {
  namespace        = "example-namespace"
  table_bucket_arn = aws_s3tables_table_bucket.example.arn
}
resource "aws_s3tables_table" "example" {
  name             = "example-table"
  namespace        = aws_s3tables_namespace.example
  table_bucket_arn = aws_s3tables_namespace.example.table_bucket_arn
  format           = "ICEBERG"
}
resource "aws_s3tables_table_policy" "example" {
  resource_policy  = data.aws_iam_policy_document.table.json
  name             = aws_s3tables_table.example.name
  namespace        = aws_s3tables_table.example.namespace
  table_bucket_arn = aws_s3tables_table.example.table_bucket_arn
}
data "aws_iam_policy_document" "table" {
  statement {
    actions = ["s3tables:*"]
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }
    resources = ["${aws_s3tables_table.example.arn}"]
  }
}
data "aws_caller_identity" "current" {}
