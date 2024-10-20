provider "aws" {
  region = "us-east-1"  # Use the appropriate region
}

resource "aws_wafv2_web_acl" "allow_block_regions_acl" {
  name        = "allow-block-regions-acl"
  scope       = "REGIONAL"  # Set to "CLOUDFRONT" for CloudFront distributions
  default_action {
    allow {}
  }

  # Allow rule using OrStatement
  rule {
    name     = "allow-allowed-regions"
    priority = 1

    action {
      allow {}
    }

    statement {
      or_statement {
        statement {
          geo_match_statement {
            country_codes = [
              "AL", "AD", "AM", "AT", "AZ", "BY", "BE", "BA", "BG", "HR", "CY", "CZ",
              "DK", "EE", "FI", "FR", "GE", "DE", "GR", "HU", "IS", "IE", "IT", "KZ",
              "XK", "LV", "LI", "LT", "LU", "MT", "MD", "MC", "ME", "NL", "MK", "NO"
            ]
          }
        }
        statement {
          geo_match_statement {
            country_codes = [
              "PL", "PT", "RO", "RU", "SM", "RS", "SK", "SI", "ES", "SE", "CH", "IN", 
              "TR", "UA", "GB", "VA"
            ]
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AllowAllowedRegions"
      sampled_requests_enabled   = true
    }
  }

  # Block rule for other regions using OrStatement
  rule {
    name     = "block-other-regions"
    priority = 2
    statement {
      or_statement {
        statement {
          geo_match_statement {
            country_codes = ["AL", "AD", "AM", "AT", "AZ", "BY", "BE", "BA", "BG", "HR", "CY", "CZ", "PL", "PT", "RO", "RU", "SM", "RS", "DK", "EE", "FI", "FR", "GE", "DE", "GR", "HU", "IS", "IE", "IT", "KZ", "PH", "SK", "SI", "ES", "SE", "CH"]
          }
        }
        statement {
          geo_match_statement {
            country_codes = ["TR", "XK", "LV", "LI", "LT", "LU", "MT", "MD", "MC", "ME", "NL", "MK", "NO", "NZ", "UA", "GB", "VA", "KW"]
          }
        }
      }
    }
    action {
      block {}
    }
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockOtherRegions"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "AllowBlockRegionsWebACL"
    sampled_requests_enabled   = true
  }
}
