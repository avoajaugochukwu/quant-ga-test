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
      values   = [var.repository]
      variable = "token.actions.githubusercontent.com:sub"
    }
  }
}

# Step 3: Create the IAM role
resource "aws_iam_role" "this" {
  name               = var.role_name
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
  name        = var.policy_name
  description = "Policy used for deployments on CI"
  policy      = data.aws_iam_policy_document.deploy.json
}

# Step 6: Attach the policy to the role
resource "aws_iam_role_policy_attachment" "attach-deploy" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.deploy.arn
}
