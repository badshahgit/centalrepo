resource "aws_ecs_cluster" "cluster" {
  name = "cluster"

  setting {
    name  = "containerInsights"
    value = "enhanced"
  }
}

# SNS Topic for Alarm Notifications
resource "aws_sns_topic" "ecs_alarm_topic" {
  name = "ecs-task-failure-topic"
}

resource "aws_sns_topic_subscription" "ecs_alarm_email_subscription" {
  topic_arn = aws_sns_topic.ecs_alarm_topic.arn
  protocol  = "email"
  endpoint  = "sultanp7161@gmail.com" # Replace with your email
}

# ECS Task Failure Alarm
resource "aws_cloudwatch_metric_alarm" "ecs_task_failure_alarm" {
  alarm_name          = "ECS-Task-Failure-Alarm"
  alarm_description   = "Alarm triggered when ECS task stops running."
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "RunningTaskCount"
  namespace           = "ECS/ContainerInsights"
  period              = 60
  statistic           = "Minimum"
  threshold           = 2

  dimensions = {
    ClusterName = "cluster"
    ServiceName = "my-ecs-service"
  }

  alarm_actions = [
    aws_sns_topic.ecs_alarm_topic.arn
  ]

  ok_actions = [
    aws_sns_topic.ecs_alarm_topic.arn
  ]
}
