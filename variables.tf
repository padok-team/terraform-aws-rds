variable "example_of_required_variable" {
  type        = string
  description = "Short description of the variable"
}

variable "example_of_variable_with_default_value" {
  type        = string
  description = "Short description of the variable"
  default     = "default_value"
}

variable "example_with_validation" {
  type        = list(string)
  description = "Short description of the variable"

  validation {
    condition     = length(var.example_with_validation) >= 2
    error_message = "Error message which explains what's required and finished with a dot ."
  }
}
