

data "template_file" "kube-config" {
	template = file("${path.module}/templates/kube_config.yaml.tpl")

	vars = {
		CERTIFICATE = aws_eks_cluster.eks.certificate_authority[0].data
		MASTER_ENDPOINT = aws_eks_cluster.eks.endpoint
		CLUSTER_NAME = var.cluster_name
		ROLE_ARN = aws_iam_role.eks.arn
	}
}


### 기존 코드에 추가  ###

data "template_file" "aws-auth" {
  template = file("${path.module}/templates/aws_auth.yaml.tpl")

  vars = {
    rolearn   = aws_iam_role.worker.arn
  }
}



