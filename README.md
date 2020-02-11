# miniproject-CAHILL-MASON

This demo project is built using Ruby and Sinatra to expose a rest endpoint which returns the following JSON payload:

{"message":"Automation for the People","timestamp":1552134459}

This project utilizes Docker, ECR, ECS, and Cloudformation to provide a 'one-click' deployment to AWS.
The docker container uses an official alpine image from ruby, ensuring a small, secure, and fast container.
Thin webserver is being used for its simple setup and speed.
An ALB is utilized with a health check to ensure client requests are routed to healthy containers and unhealthy containers are replaced.
Rspec is used for tests at the application level, Serverspec is used to test docker image, and Awspec is used to test the infrastructure.

# Requirements
  - Ruby 2.5+
  - Bundler
  - AWS Credentials configured locally
  
# Demo
```   
$ bundle install
$ export AWS_ACCOUNT_ID=1234567890
$ rake demo:deploy
````
This rake task performs the following
1. Create a CloudFormation Stack with an ECR Repo
2. Builds the docker image
3. Tests the docker image and application
4. Bumps version number and tags image with that version
5. Pushes the image to ECR
6. Creates CloudFormation Stack for ECS cluster and supporting infrastructure
7. Creates CloudFormation Stack for ECS service and task definition
8. Tests the underlying AWS infrastructure

# Pushing updated docker image
Run the following rake task to deploy a new docker image
```$ rake service:update```
You may need to size up instance type of cluster to allow for rolling deployments.
    
# Cleaning Up
Run the following rake task to destroy all aws assets
```$ rake demo:cleanup```

# Build and Run Locally
Run the following rake tasks to build and run the docker image locally
```
$ rake docker:build
$ rake docker:run
```

# Additional Rake Tasks Available
1. demo:test
2. ecr:create
3. cluster:create
4. service:create
5. docker:build
6. docker:tag
7. docker:push
8. docker:run
9. ecr:authenticate
10. cluster:delete
11. service:delete
12. ecr:delete
13. infra:test
