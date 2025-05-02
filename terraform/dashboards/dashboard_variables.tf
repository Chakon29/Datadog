variable "dashboard_params" {
  type = list(object({
    dashboard_id = string
    title = string
    description = optional(string)
  }))
  default = []
}