resource "aws_cloudwatch_dashboard" "cloudwatch_dashboard" {
  dashboard_name = var.name

  dashboard_body = jsonencode(
    {
      "widgets" = concat(
        [
          for index, item in var.widgets : {
          type = lookup(item, "type", "metric")
          x      = (index % 2) * 12
          y      = (index) * 7
          width  = 12
          height = 6
          properties = {
            metrics = lookup(item, "metrics", null)
            "region" = var.region
            "title" = lookup(item, "title", "Metrics")
            "period" = lookup(item, "period", 300)
            "stat" = lookup(item, "stat", "Average")
          }
        }
        ],
        [
          {
            type   = "alarm"
            width  = 24
            height = 6
            properties = {
              "region" = var.region
              "title"  = "All Alarms"
              "alarms" = [for alarm in aws_cloudwatch_metric_alarm.metric_alarm : alarm.arn]
            }
          }
        ]
      )
    }
  )
}

# ------------------------

resource "aws_cloudwatch_metric_alarm" "metric_alarm" {
  for_each = {for index, alarm in var.alarm_definitions : alarm.name => alarm}
  # required
  alarm_name          = each.value.name
  metric_name         = each.value.metric_name
  namespace           = each.value.namespace
  dimensions = each.value.dimensions
  # optional
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  period              = each.value.period
  statistic           = each.value.statistic
  threshold           = each.value.threshold
  alarm_description = try(each.value.description, "Alarm when ${each.value.metric_name} exceeds ${each.value.threshold}")

  tags = merge(var.default_tags, {
    Name : "${terraform.workspace}-${each.value.name}"
  })
}

output "alarm_arns" {
  value = [for alarm in aws_cloudwatch_metric_alarm.metric_alarm : alarm.arn]
}