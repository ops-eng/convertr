# angular service
resource "aws_ecs_service" "angular" {
  name            = "angular"
  cluster         = "${aws_ecs_cluster.ecs-test.id}"
  task_definition = "${aws_ecs_task_definition.angular-def.arn}"
  desired_count   = 2
  iam_role        = "${aws_iam_role.ecs-service-role.arn}"
  depends_on      = ["aws_iam_role_policy_attachment.ecs-service-attachment"]

  load_balancer {
    target_group_arn = "${aws_alb_target_group.angular-tg.id}"
    container_name   = "angular"
    container_port   = "80"
  }

  lifecycle {
    ignore_changes = ["task_definition"]
  }
}

resource "aws_ecs_task_definition" "angular-def" {
  family = "angular"

  container_definitions = <<EOF
[
  {
    "portMappings": [
      {
        "hostPort": 0,
        "protocol": "tcp",
        "containerPort": 80
      }
    ],
    "cpu": 256,
    "memory": 512,
    "image": "angular:latest",
    "essential": true,
    "name": "angular",
    "logConfiguration": {
    "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs-logs/angular",
        "awslogs-region": "eu-west-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
EOF
}

resource "aws_cloudwatch_log_group" "angular" {
  name = "/ecs-logs/angular"
}
