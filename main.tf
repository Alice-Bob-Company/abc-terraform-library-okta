locals {
  provider_name = "Okta"
}
resource "aws_iam_saml_provider" "okta" {
  count = var.okta_enabled ? 1 : 0

  name                   = local.provider_name
  saml_metadata_document = file("Okta.xml")
  tags = {
    Name           = "${var.account_name}-idp"
    Resource_Owner = var.resource_owner
    Module         = var.module
  }
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "okta-admin" {
  count = var.okta_enabled ? 1 : 0

  name = "okta_admin"

  tags = {
    Name           = "${var.account_name}-idp-admin"
    Resource_Owner = var.resource_owner
    Module         = var.module
  }
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          "Federated" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:saml-provider/${local.provider_name}"
        }
        Action = "sts:AssumeRoleWithSAML"
        Condition = {
          StringEquals = {
            "SAML:aud" = "https://signin.aws.amazon.com/saml"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role" "okta-dev" {
  count = var.okta_enabled ? 1 : 0

  name = "okta_dev"

  tags = {
    Name           = "${var.account_name}-idp-dev"
    Resource_Owner = var.resource_owner
    Module         = var.module
  }
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          "Federated" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:saml-provider/${local.provider_name}"
        }
        Action = "sts:AssumeRoleWithSAML"
        Condition = {
          StringEquals = {
            "SAML:aud" = "https://signin.aws.amazon.com/saml"
          }
        }
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "admin-attach" {
  count = var.okta_enabled ? 1 : 0

  role       = aws_iam_role.okta-admin[0].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "dev-attach" {
  count = var.okta_enabled ? 1 : 0

  role       = aws_iam_role.okta-dev[0].name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
