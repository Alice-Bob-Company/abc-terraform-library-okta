locals {
  provider_name = "Okta"
}
resource "aws_iam_saml_provider" "okta" {
  name                   = local.provider_name
  saml_metadata_document = file("${path.module}/Okta.xml")
  tags = {
    Name           = "${var.account_name}-${var.environment}-buchner-idp"
    Resource_Owner = var.Resource_Owner
    Module         = var.Module
  }
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "okta-admin" {
  name = "okta_admin"

  tags = {
    Name           = "${var.account_name}-${var.environment}-buchner-idp-admin"
    Resource_Owner = var.Resource_Owner
    Module         = var.Module
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
  name = "okta_dev"

  tags = {
    Name           = "${var.account_name}-${var.environment}-buchner-idp-dev"
    Resource_Owner = var.Resource_Owner
    Module         = var.Module
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
  role       = aws_iam_role.okta-admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "dev-attach" {
  role       = aws_iam_role.okta-dev.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
