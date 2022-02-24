data "aws_ami" "worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.eks.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"]
}

locals {
  eks_worker_userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks.certificate_authority.0.data}' '${var.cluster_name}'
USERDATA
}

resource "aws_launch_configuration" "worker" {
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.worker.name
  image_id                    = data.aws_ami.worker.id
  instance_type               = var.instance_type
  name_prefix                 = var.cluster_name
  security_groups             = [aws_security_group.worker.id]
  user_data_base64            = base64encode(local.eks_worker_userdata)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "worker" {
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.worker.id
  max_size             = 1
  min_size             = 1
  name                 = var.cluster_name
  vpc_zone_identifier  = [aws_subnet.cluster-0.id, aws_subnet.cluster-1.id]

  tag {
    key                 = "Name"
    value               = var.cluster_name
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
}

