---
title: Terraform IaC DevOps using AWS CodePipeline
description: Create AWS CodePipeline with Multiple Environments Dev and Staging
---
# IaC DevOps using AWS CodePipeline

## Introduction
1. Terraform Backend with backend-config
2. How to create multiple environments related Pipeline with single TF Config files in Terraform ? 
3. As part of Multiple environments we are going to create `dev` and `stag` environments
4. We are going build IaC DevOps Pipelines using 
- AWS CodeBuild
- AWS CodePipeline
- Github
5. We are going to streamline the `terraform-manifests` taken from `section-15` and streamline that to support Multiple environments.

[![Image](https://stacksimplify.com/course-images/terraform-aws-codepipeline-iac-devops-1.png "Terraform on AWS with IAC DevOps and SRE")](https://stacksimplify.com/course-images/terraform-aws-codepipeline-iac-devops-1.png)

[![Image](https://stacksimplify.com/course-images/terraform-aws-codepipeline-iac-devops-2.png "Terraform on AWS with IAC DevOps and SRE")](https://stacksimplify.com/course-images/terraform-aws-codepipeline-iac-devops-2.png)

[![Image](https://stacksimplify.com/course-images/terraform-aws-codepipeline-iac-devops-3.png "Terraform on AWS with IAC DevOps and SRE")](https://stacksimplify.com/course-images/terraform-aws-codepipeline-iac-devops-3.png)

[![Image](https://stacksimplify.com/course-images/terraform-aws-codepipeline-iac-devops-4.png "Terraform on AWS with IAC DevOps and SRE")](https://stacksimplify.com/course-images/terraform-aws-codepipeline-iac-devops-4.png)

## CI/CD

### Backend Config

```shell
  # INFO: S3 Backend Block
  backend "s3" {
    # NOTE: Backend configuration moved to 'env_ENVIRONMENT.conf' files to support multiple environments.
    # NOTE: Executing backend configuration within CI/CD pipeline `terraform init -backend-config=env_dev.conf` or `terraform init -backend-config=env_stag.conf`
    # ? https://developer.hashicorp.com/terraform/cli/commands/init
  }
}
```

### CI/CD command

In order to include backend config and point env-related variables:

```shell
terraform init -backend-config=env_dev.conf 
terraform plan -var-file=dev.tfvars
terraform apply -input=false -var-file=env_dev.tfvars -auto-approve
```

## Original repo

https://github.com/stacksimplify/terraform-on-aws-ec2/blob/main/22-IaC-DevOps-using-AWS-CodePipeline/README.md

## References
- [terraform init command](https://www.terraform.io/docs/cli/commands/init.html)
- [Backend configuration partial](https://developer.hashicorp.com/terraform/language/backend#partial-configuration)
- [AWS CodeBuild Builspe file reference](https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html#build-spec.env)

## Disclaimer

This series draws heavily from **Kalyan Reddy Daida**’s [Terraform on AWS with SRE & IaC DevOps](https://www.udemy.com/course/terraform-on-aws-with-sre-iac-devops-real-world-demos/) course on Udemy.

[His content](https://www.udemy.com/user/kalyan-reddy-9/) was a game-changer in helping me understand Terraform.

<!-- About the instructor -->

<table>
  <thead>
      <tr>
          <th>About the instructor</th>
          <th></th>
      </tr>
  </thead>
  <tbody>
      <tr>
          <td>🌐 <a href="https://stacksimplify.com/" target="_blank" rel="noreferrer">Website</a>
</td>
          <td>📺 <a href="http://www.youtube.com/stacksimplify" target="_blank" rel="noreferrer">YouTube</a>
</td>
      </tr>
      <tr>
          <td>💼 <a href="http://www.linkedin.com/in/kalyan-reddy-daida" target="_blank" rel="noreferrer">LinkedIn</a>
</td>
          <td>🗃️ <a href="https://github.com/stacksimplify" target="_blank" rel="noreferrer">GitHub</a>
</td>
      </tr>
  </tbody>
</table>

<!-- /About the instructor -->
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->