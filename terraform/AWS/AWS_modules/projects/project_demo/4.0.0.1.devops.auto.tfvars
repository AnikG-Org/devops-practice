/*

#################### code pipeline #########################
pipeline_name   = "devops-pipeline"
description     = "AWS Code Pipeline"
stages = [
  {
    name = "Source"
    action = {
      name     = "Source"
      category = "Source"
      owner    = "AWS"
      provider = "CodeCommit"
      version  = "1"
      input_artifacts  = []
      output_artifacts = ["SourceArtifact"]
      configuration = {
        BranchName           = "main"
        PollForSourceChanges = "false"
        RepositoryName       = "devops-repo"
      }
      run_order        = 1
    }
  },
  {
    name = "Build"
    action = {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"

      configuration = {
        ProjectName = "codebuild-app-vpc"
      }
      run_order        = 2
    }
  },
  {
    name = "Approval"
    action = {
      name             = "Manual-Approval"
      category         = "Approval"
      owner            = "AWS"
      provider         = "Manual"
      version          = "1"
      input_artifacts  = []
      output_artifacts = []
      configuration = {
        NotificationArn = "arn:aws:sns:ap-south-1:388891221585:customer_notification"
      }
      run_order = 3
    }
  }, 
  {
    name = "Deploy"
    action = {
      name             = "Deploy"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "CodeDeploy"
      version          = "1"
      input_artifacts  = ["BuildArtifact"]
      output_artifacts = []

      configuration = {
        ApplicationName     = "MyCodeDeployApp"
        DeploymentGroupName = "MyCodeDeployDeploymentGroup"
      }
      run_order = 5
    },
  }
#   {
#     name = "Deploy"
#     action = {
#       name             = "Deploy"
#       category         = "Deploy"
#       owner            = "AWS"
#       provider         = "ECS"
#       version          = "1"
#       input_artifacts  = ["BuildArtifact"]
#       output_artifacts = []
#       configuration = {
#         ClusterName = "test"
#         ServiceName = "cron-poll"
#       }
#       run_order = 6
#     }
#   }  
]

common_tags = {
  name   = "aws-codebuild-instance"
  module = "anik/codepipeline/aws"
}
*/ 