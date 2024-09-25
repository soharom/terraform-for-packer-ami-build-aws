

resource "aws_codecommit_repository" "packer_ami_template_repository" {
  repository_name = var.repository_name
  description     = "This is repository for adding packer configuration"
  
  tags = {
    Environment = "POC"
    Tools       = "Packer"
  }
}

resource "aws_iam_user" "pipeline_codecommit_user" {
  name = var.codecommit_user
}


data "aws_iam_policy_document" "codecommit_pullpush_policy" {
    
  statement {
    effect = "Allow"
    resources = [aws_codecommit_repository.packer_ami_template_repository.arn]
    actions = [
          "codecommit:GitPull",
          "codecommit:GitPush"
        ]
  }
}

resource "aws_iam_policy" "codecommit_pullpush_policy" {
  name        = "codecommit_pullpush"
  path        = "/"
  
  description = "CodeCommit policy for the pipeline_codecommit_user used by a CI/CD pipeline"
  policy = data.aws_iam_policy_document.codecommit_pullpush_policy.json

}

resource "aws_iam_user_policy_attachment" "codecommit_policy_attachment" {
  user       = aws_iam_user.pipeline_codecommit_user.name
  policy_arn = aws_iam_policy.codecommit_pullpush_policy.arn
}

resource "aws_iam_access_key" "pipeline_codecommit_user" {
  user = aws_iam_user.pipeline_codecommit_user.name
}

resource "aws_iam_service_specific_credential" "git" {
          service_name = "codecommit.amazonaws.com"
          user_name    = aws_iam_user.pipeline_codecommit_user.name
          
}

resource "null_resource" "git_clone" {
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command = <<EOT
      export AWS_ACCESS_KEY_ID=${aws_iam_access_key.pipeline_codecommit_user.id}
      export AWS_SECRET_ACCESS_KEY=${aws_iam_access_key.pipeline_codecommit_user.secret}  
      mkdir -p ./temp-location && cd ./temp-location && git init && git pull ${var.remote_repository} 
      git config --global credential.helper '!aws codecommit credential-helper $@'
      git config --global credential.UseHttpPath true
      git push ${aws_codecommit_repository.packer_ami_template_repository.clone_url_http}  master:${var.branch}
      
    EOT
  }
}

