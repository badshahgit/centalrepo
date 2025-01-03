resource "aws_cloudwatch_dashboard" "dashboard" {
  dashboard_name = var.dashboard_name

  dashboard_body = jsonencode({
    widgets = [
      # RDS: CPU Utilization
      {
        "type"       : "metric",
        "x"          : 0,
        "y"          : 0,
        "width"      : 6,
        "height"     : 6,
        "properties" : {
          "metrics" : [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.rds_instance_id]
          ],
          "title"    : "RDS CPU Utilization",
          "view"     : "timeSeries",
          "region"   : var.region,
          "stat"     : "Average",
          "period"   : var.period
        }
      },

      # ECS: Incoming Log Events
      {
        "type" : "metric",
        "x"    : 0,
        "y"    : 6,
        "width": 6,
        "height": 6,
        "properties": {
          "title"   : "ECS Nginx Incoming Log Events",
          "metrics" : [
            [
              "AWS/Logs",
              "IncomingLogEvents",
              "LogGroupName",
              var.log_group_name
            ]
          ],
          "view"    : "timeSeries",
          "stacked" : false,
          "region"  : var.region,
          "period"  : var.period
        }
      },

      # RDS: Freeable Memory
      {
        "type"       : "metric",
        "x"          : 6,
        "y"          : 0,
        "width"      : 6,
        "height"     : 6,
        "properties" : {
          "metrics" : [
            ["AWS/RDS", "FreeableMemory", "DBInstanceIdentifier", var.rds_instance_id]
          ],
          "title"    : "RDS Freeable Memory",
          "view"     : "timeSeries",
          "region"   : var.region,
          "stat"     : "Average",
          "period"   : var.period
        }
      },

      # ECS: CPU Utilization
      {
        "type"       : "metric",
        "x"          : 6,
        "y"          : 6,
        "width"      : 6,
        "height"     : 6,
        "properties" : {
          "metrics" : [
            ["AWS/ECS", "CPUUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", var.ecs_service_name]
          ],
          "title"    : "ECS CPU Utilization",
          "view"     : "timeSeries",
          "region"   : var.region,
          "stat"     : "Average",
          "period"   : var.period
        }
      },

      # ECS: Memory Utilization
      {
        "type"       : "metric",
        "x"          : 18,
        "y"          : 6,
        "width"      : 6,
        "height"     : 6,
        "properties" : {
          "metrics" : [
            ["AWS/ECS", "MemoryUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", var.ecs_service_name]
          ],
          "title"    : "ECS Memory Utilization",
          "view"     : "timeSeries",
          "region"   : var.region,
          "stat"     : "Average",
          "period"   : var.period
        }
      },

      # ECS: Running Tasks Count
      {
        "type"       : "metric",
        "x"          : 12,
        "y"          : 12,
        "width"      : 6,
        "height"     : 6,
        "properties" : {
          "metrics" : [
            ["ECS/ContainerInsights", "RunningTaskCount", "ClusterName", var.ecs_cluster_name, "ServiceName", var.ecs_service_name]
          ],
          "title"    : "ECS Running Tasks Count",
          "view"     : "timeSeries",
          "region"   : var.region,
          "stat"     : "Minimum",
          "period"   : var.period
        }
      },

      # RDS: Database Connections
      {
        "type"       : "metric",
        "x"          : 12,
        "y"          : 6,
        "width"      : 6,
        "height"     : 6,
        "properties" : {
          "metrics" : [
            ["AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", var.rds_instance_id]
          ],
          "title"    : "RDS Database Connections",
          "view"     : "timeSeries",
          "region"   : var.region,
          "stat"     : "Sum",
          "period"   : var.period
        }
      }
    ]
  })
}


variable "dashboard_name" {
  description = "Name of the CloudWatch dashboard"
  type        = string
}

variable "rds_instance_id" {
  description = "RDS instance identifier"
  type        = string
}

variable "log_group_name" {
  description = "Log group name for ECS logs"
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "ecs_service_name" {
  description = "ECS service name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "period" {
  description = "Period for metrics in seconds"
  type        = number
  default     = 300
}


module "rds_ecs_dashboard" {
  source            = "../../modules/cloudwatch_dashboard"
  dashboard_name    = "RDS-ECS-Monitoring-Dashboard"
  rds_instance_id   = "database-1"
  log_group_name    = "/ecs/nginx"
  ecs_cluster_name  = "my-ecs-cluster"
  ecs_service_name  = "my-ecs-service"
  region            = "us-east-1"
  period            = 300
}
