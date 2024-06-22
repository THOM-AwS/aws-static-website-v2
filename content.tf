
resource "null_resource" "clone_html_repo" {
  provisioner "local-exec" {
    command = <<EOT
      rm -rf ${path.module}/cloned_html_repo
      git clone --branch ${var.html_source_git_branch} ${var.html_source_git_repo_url} ${path.module}/cloned_html_repo
    EOT
  }
}

resource "null_resource" "upload_html_files" {
  depends_on = [aws_s3_bucket.thiswww.bucket, null_resource.clone_html_repo]
  provisioner "local-exec" {
    command = <<EOT
      aws s3 sync ${path.module}/cloned_html_repo s3://${aws_s3_bucket.thiswww.bucket}
    EOT
  }
}
