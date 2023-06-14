# abc-terraform-library-okta
Alice&Bob.Company specific Okta terraform modules

## Step 1: Get SAML MetaData Document

## Step 2: Include module

    module "okta" {
      source = "git::https://github.com/Alice-Bob-Company/abc-terraform-library-okta.git"

      #general
      account_name   = "customer-project-environment"
      module         = "abc-terraform-library-okta"
      resource_owner = "customer@example.org"
    }
