## DevOps challenge

First of all thanks for being part of this process :)
We are going to provide you with a user and credentials in order to complete this challenge with a real AWS account.

## Entering the Matrix.

Hello NEO.

We have a Rails application that says Hello world! But is becoming really popular.
Our old infrastructure run in EC2 machines but the maintenance of this is really hard for us.
We hear that we can use containers in order to build and ship our application in a fast and safe way.

You should choose between two pills:

[The red pill]: You can take the control of the Matrix and run the containers under self managed EC2 instances.

[The blue pill]: You take this and you wake up using Fargate.

Please explain the reason for your decision.
After you take a choice, please complete the following tasks.

1. Create the infrastructure and the pipeline needed in order to serve our application from ECS containers.
2. Host our database in REDS and import the current data (/db/database.sql).
3. Create a script that easy deploy new code to the stack.
4. Set autoscaling policies in order to have a minimum of 1 task, a desired of 1, and a maximum of 10 based on the CPU usage.

## Application details:

* Ruby version: 2.2
* Rails version: 4.2
* Postgres version :11.6

Database configuration: config/database.yml
Update your host.
username: admin
password: admin
db name: hello_world

## Test your results

Is everithing is ok the route /hello_world will return the following respose:
{"id":1,"text":"Hello World!"}


# ANSWER (Work in progress)

This repository holds the Mejuri App code, as well the infrastructure definitions to deploy it on an AWS environment.

## PREREQUISITES

In order to run the commands steated below, please ensure your system meet the following requirements:

- Docker version 19.03.12, build 48a6621 (or subsequent compatible version)
- AWS CLI v2: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html
- Your AWS account is already configured and its resources accessible from your shell: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html
- Your use has an Admin role or similar persmissions

## Clone this repository
1. `git clone git@github.com:cig0/dev-ops-challenge.git`

## Build the Docker image

2. `docker build --no-cache -t mejuri-app .`
3. `docker tag app $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/app`
(Be sure to replace $AWS_ACCOUNT_ID and $REGION with your own values, i.e:
`docker tag app 1234567890.dkr.ecr.us-east-1.amazonaws.com/app`)

## ECR

Now we need to log into our AWS ECR, create a repository for our image and then  push the image there:

1. `aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_NUMBER.dkr.ecr.$REGION.amazonaws.com`
2. `aws ecr create-repository --repository-name app`
3. `docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/app`

## CloudFormation

Go into `infrastructure/aws/cf` directory inside the repository you just cloned an trigger the following CloudFormation tasks:

1. `aws cloudformation deploy --capabilities "CAPABILITY_IAM" --stack-name "fargate-app" --template-file fargate.yml`

Wait for it to complete and once it is done, go ahead with the next one:

2. `aws cloudformation deploy --capabilities "CAPABILITY_IAM" --stack-name "service-app" --template-file service-app.yml`

If everything went well, you should now have two CloudFormation stacks using named `fargate-app` and `service-app` respectively, denoting that one of the stacks creates the network and Fargate resources needed to host the app, and the other one being responsible for deploying the app as a service into Fargate.

The stacks are configured in a way you should access the application running at port 3000 in the private subnet, while being accesible through port 80.

You can finde the domain name you need to use to reach the app, in the AWS console go to EC2 -> Load Balancing/Load Balancers and click on the public one, you should see an A registry similar to this one: `http://farga-publi-1v32razi4azpv-1734796021.us-east-1.elb.amazonaws.com/hello_world` (/hello_world)

Since the intetration with the RDS PostgreSQL service isn't finished, the query will throw an error.


Ref:
https://github.com/nathanpeck/aws-cloudformation-fargate.git
https://github.com:garystafford/aws-rds-postgres.git
