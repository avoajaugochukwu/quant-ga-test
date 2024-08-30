variable "name" {
  description = "Name of the CloudWatch Dashboard"
  type        = string
}

variable "region" {
  description = "Region where the CloudWatch Dashboard is deployed"
  type        = string
}

variable "widgets" {
  description = "List of CloudWatch dashboard widgets"
  type = list(object({
    type = optional(string, "metric")
    metrics = optional(list(list(string)), [])
    period = optional(number)
    stat = optional(string)
    region = string
    title  = string
    alarms = optional(list(string), [])
  }))
  default = []
}

variable "alarm_definitions" {
  description = "List of alarm definitions to create"
  type = list(object({
    name        = string
    metric_name = string
    namespace   = string

    dimensions = map(string)
    comparison_operator = optional(string, "GreaterThanThreshold")
    evaluation_periods = optional(number, 1)
    period = optional(number, 300)
    statistic = optional(string, "Average")
    threshold = optional(number, 75)
    description = optional(string)
  }))
  default = []
}

variable "default_tags" {
  type = map(string)
  default = {}
}