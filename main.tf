resource "aws_iam_role" "eks-iam-role" {
    name = "devopsthehardway-eks-iam-role"
    path = "/"
    assume_role_policy = "${file("${var.assume_role}")}"
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role    = aws_iam_role.eks-iam-role.name
}
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role    = aws_iam_role.eks-iam-role.name
}

resource "aws_eks_cluster" "joshna-eks" {
    name = var.cluster_name
    role_arn = aws_iam_role.eks-iam-role.arn
    enabled_cluster_log_types = ["api", "audit"]
    vpc_config {
    subnet_ids = ["subnet-00f62078c36a93954","subnet-0097d6edebd41e75c"]
    security_group_ids = ["sg-087d63db3e1de2319"]
    }
    depends_on = [
    aws_iam_role.eks-iam-role,aws_cloudwatch_log_group.eks-cwl
    ]
}

resource "aws_cloudwatch_log_group" "eks-cwl" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 7
}

resource "aws_iam_role" "workernodes" {
    name = "eks-node-group"
    assume_role_policy = "${file("${var.assume_role_policy}")}"
 }
 
 resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role    = aws_iam_role.workernodes.name
 }
 
 resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role    = aws_iam_role.workernodes.name
 }
 
 resource "aws_iam_role_policy_attachment" "EC2InstanceProfileForImageBuilderECRContainerBuilds" {
    policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
    role    = aws_iam_role.workernodes.name
 }
 
 resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly-EKS" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role    = aws_iam_role.workernodes.name
 }

 resource "aws_eks_node_group" "worker-node-group" {
    cluster_name  = aws_eks_cluster.joshna-eks.name
    node_group_name = "joshna-workernodes"
    node_role_arn  = aws_iam_role.workernodes.arn
    subnet_ids   = ["subnet-00f62078c36a93954","subnet-0097d6edebd41e75c"]
    instance_types = ["t3.xlarge"]
    
    scaling_config {
    desired_size = 1
    max_size   = 1
    min_size   = 1
    }
    
    depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    #aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    ]
 }
