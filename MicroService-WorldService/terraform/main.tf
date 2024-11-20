module "ecs-fargate-service" {
  source              = "../../modules/ecs-fargate-service"
  vpc_id              = var.vpc_id
  application         = var.application
  region              = var.region
  ecs_cluster         = "${var.environment}-cluster"
  lb_name             = "${var.environment}-alb"
  environment         = var.environment
  container_version   = var.container_version
  log_group_name      = "dev/world-service"
  ecr_repository_name = "public.ecr.aws/w0f5g4k6/hello-svc"
  port                = 80
  health_check_path   = "/world"
  cloudmap_namespace  =  var.cloudmap_namespace
  cpu                 = "512"
  memory              = "1024"
  path_pattern        = "hello"
}