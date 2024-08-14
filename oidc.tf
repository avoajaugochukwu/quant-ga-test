# module "github-oidc" {
#   source  = "terraform-module/github-oidc-provider/aws"
#   version = "~> 1"

#   create_oidc_provider = true
#   create_oidc_role     = true

#   repositories = ["terraform-module/module-blueprint"]
#   oidc_role_attach_policies = [
#     "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
#   ]
# }

# Step 1: Create an OIDC provider for GitHub Actions
resource "aws_iam_openid_connect_provider" "this" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = ["ffffffffffffffffffffffffffffffffffffffff"]
}

# Step 2: Create a trust policy document for the role
data "aws_iam_policy_document" "oidc" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.this.arn]
    }

    condition {
      test     = "StringEquals"
      values   = ["sts.amazonaws.com"]
      variable = "token.actions.githubusercontent.com:aud"
    }

    condition {
      test     = "StringLike"
      values   = ["repo:avoajaugochukwu/quant-ga-test:*"]
      variable = "token.actions.githubusercontent.com:sub"
    }
  }
}

# Step 3: Create the IAM role
resource "aws_iam_role" "this" {
  name               = "github_oidc_role"
  assume_role_policy = data.aws_iam_policy_document.oidc.json
}

# Step 4: Create a policy for ECR access
data "aws_iam_policy_document" "deploy" {
  statement {
    effect  = "Allow"
    actions = [
      "ecr:*",
    ]
    resources = ["*"]
  }
}

# Step 5: Create the IAM policy
resource "aws_iam_policy" "deploy" {
  name        = "ci-deploy-policy"
  description = "Policy used for deployments on CI"
  policy      = data.aws_iam_policy_document.deploy.json
}

# Step 6: Attach the policy to the role
resource "aws_iam_role_policy_attachment" "attach-deploy" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.deploy.arn
}

output "role_arn" {
  value = aws_iam_role.this.arn
}
