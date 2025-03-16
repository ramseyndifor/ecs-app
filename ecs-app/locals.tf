locals {
  project = "ecs-app"
  env = "dev"
  default_tags = {
    Project = "ecs-app"
    Env = "Dev"
    Owner = "Ramsey"
    Tier = local.env == "Prod" ? "high" : local.env == "Dev" ? "medium" : "low"
  }
}