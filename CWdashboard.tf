
# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "rds_ecs_dashboard" {
  dashboard_name = "RDS-ECS-Monitoring-Dashboard"

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
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "database-1"]
          ],
          "title"    : "RDS CPU Utilization",
          "view"     : "timeSeries",
          "region"   : "us-east-1",
          "stat"     : "Average",
          "period"   : 300
        }
      },

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
              "/ecs/nginx"
            ]
          ],
          "view"    : "timeSeries",
          "stacked" : false,
          "region"  : "us-east-1",
          "period"  : 300
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
            ["AWS/RDS", "FreeableMemory", "DBInstanceIdentifier", "database-1"]
          ],
          "title"    : "RDS Freeable Memory",
          "view"     : "timeSeries",
          "region"   : "us-east-1",
          "stat"     : "Average",
          "period"   : 300
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
            ["AWS/ECS", "CPUUtilization", "ClusterName", "my-ecs-cluster", "ServiceName", "my-ecs-service"]
          ],
          "title"    : "ECS CPU Utilization",
          "view"     : "timeSeries",
          "region"   : "us-east-1",
          "stat"     : "Average",
          "period"   : 300
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
            ["AWS/ECS", "MemoryUtilization", "ClusterName", "my-ecs-cluster", "ServiceName", "my-ecs-service"]
          ],
          "title"    : "ECS Memory Utilization",
          "view"     : "timeSeries",
          "region"   : "us-east-1",
          "stat"     : "Average",
          "period"   : 300
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
            ["ECS/ContainerInsights", "RunningTaskCount", "ClusterName", "my-ecs-cluster", "ServiceName", "my-ecs-service"]
          ],
          "title"    : "ECS Running Tasks Count",
          "view"     : "timeSeries",
          "region"   : "us-east-1",
          "stat"     : "Minimum",
          "period"   : 300
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
            ["AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", "database-1"]
          ],
          "title"    : "RDS Database Connections",
          "view"     : "timeSeries",
          "region"   : "us-east-1",
          "stat"     : "Sum",
          "period"   : 300
        }
      }
    ]
  })
}
