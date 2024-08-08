module "rds_alarm" {
  source = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"

  for_each   = local.rdsALARM
  alarm_name = "${module.rds.db_instance_identifier}-alarm${each.key}"

  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  metric_name         = each.value.metric_name
  period              = each.value.period
  statistic           = each.value.statistic
  threshold           = each.value.threshold
  alarm_description   = each.value.alarm_description

  namespace     = "AWS/RDS"
  alarm_actions = [module.sns_topic.topic_arn]

  dimensions = {
    DBInstanceIdentifier = module.rds.db_instance_identifier
  }
}
