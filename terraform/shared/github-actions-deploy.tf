data "aws_caller_identity" "deploy_current" {}

resource "aws_iam_role" "github_actions_deploy" {
  name = "${local.name_prefix}-github-actions-deploy"

  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "github_actions_deploy_power_user" {
  role       = aws_iam_role.github_actions_deploy.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

data "aws_iam_policy_document" "github_actions_deploy_iam" {
  statement {
    sid    = "ManageProjectIAM"
    effect = "Allow"

    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:GetRole",
      "iam:UpdateRole",
      "iam:UpdateAssumeRolePolicy",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListRolePolicies",
      "iam:GetRolePolicy",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:CreatePolicy",
      "iam:DeletePolicy",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:ListPolicyVersions",
      "iam:CreatePolicyVersion",
      "iam:SetDefaultPolicyVersion",
      "iam:DeletePolicyVersion",
      "iam:TagPolicy",
      "iam:UntagPolicy"
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.deploy_current.account_id}:role/${var.project_name}-*",
      "arn:aws:iam::${data.aws_caller_identity.deploy_current.account_id}:policy/${var.project_name}-*"
    ]
  }

  statement {
    sid    = "PassProjectRoles"
    effect = "Allow"

    actions = [
      "iam:PassRole"
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.deploy_current.account_id}:role/${var.project_name}-*"
    ]

    condition {
      test     = "StringEqualsIfExists"
      variable = "iam:PassedToService"

      values = [
        "eks.amazonaws.com",
        "ec2.amazonaws.com",
        "autoscaling.amazonaws.com"
      ]
    }
  }

  statement {
    sid    = "ManageEKSIdentityProviders"
    effect = "Allow"

    actions = [
      "iam:CreateOpenIDConnectProvider",
      "iam:DeleteOpenIDConnectProvider",
      "iam:GetOpenIDConnectProvider",
      "iam:TagOpenIDConnectProvider",
      "iam:UntagOpenIDConnectProvider",
      "iam:UpdateOpenIDConnectProviderThumbprint",
      "iam:AddClientIDToOpenIDConnectProvider",
      "iam:RemoveClientIDFromOpenIDConnectProvider"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "CreateServiceLinkedRoles"
    effect = "Allow"

    actions = [
      "iam:CreateServiceLinkedRole"
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "iam:AWSServiceName"

      values = [
        "eks.amazonaws.com",
        "elasticloadbalancing.amazonaws.com",
        "autoscaling.amazonaws.com",
        "spot.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_policy" "github_actions_deploy_iam" {
  name   = "${local.name_prefix}-github-actions-deploy-iam"
  policy = data.aws_iam_policy_document.github_actions_deploy_iam.json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "github_actions_deploy_iam" {
  role       = aws_iam_role.github_actions_deploy.name
  policy_arn = aws_iam_policy.github_actions_deploy_iam.arn
}

output "github_actions_deploy_role_arn" {
  value = aws_iam_role.github_actions_deploy.arn
}
