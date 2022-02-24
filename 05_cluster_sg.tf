

resource "aws_security_group" "eks" {
	name = "oebinu-eks"
	description = "Cluster communication with worker nodes"
	vpc_id = aws_vpc.cluster.id

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
		Name = "oebinu-eks"
	}
}

