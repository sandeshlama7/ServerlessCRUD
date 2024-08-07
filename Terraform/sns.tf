module "sns_topic" {
  source  = "terraform-aws-modules/sns/aws"
  version = "6.1.0"

  name                = local.sns.name
  create_topic_policy = local.sns.create_topic_policy
  topic_policy_statements = {
    pub = {
      actions = ["sns:Publish"]
      principals = [{
        type        = "Service"
        identifiers = ["events.amazonaws.com"]
      }]
      effect = "Allow"
    },
  }

  subscriptions = {
    emailsub = {
      protocol = local.sns.subscription_protocol
      endpoint = local.sns.subscription_endpoint
    }
  }
}
