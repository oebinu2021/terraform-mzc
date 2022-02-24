

resource "local_file" "kube_config" {
 content = data.template_file.kube-config.rendered
 filename = "${path.cwd}/.output/kube_config.yaml"
}

### 기존 코드에 추가 ###

resource "local_file" "aws-auth" {
  content  = data.template_file.aws-auth.rendered
  filename = "${path.cwd}/.output/aws_auth.yaml"
}