# module "rds_alarm" {
#   source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
#   alarm_name = "{module.rds.db_instance_identifier}-alarm"
#   comparison_operator =
#   evaluation_periods =
#   alarm_actions = [module.sns_topic.topic_arn]

#   dimensions = {
#     DBInstanceIdentifier = module.rds.db_instance_identifier
#   }
# }
