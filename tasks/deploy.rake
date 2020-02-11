require 'aws-sdk'
require_relative 'constants'

desc 'Run Demo'
task 'demo:deploy' do
  if ENV['AWS_ACCOUNT_ID'].nil?
    raise 'Set environment variable AWS_ACCOUNT_ID and try again.'
  end

  %w[
    ecr:create
    docker:build
    demo:test
    docker:tag
    docker:push
    cluster:create
    service:create
    infra:test
  ].each do |task_name|
    Rake::Task[task_name].reenable
    Rake::Task[task_name].invoke
  end
end

desc 'Create ECR repository'
task 'ecr:create' do
  cloudformation_client = Aws::CloudFormation::Client.new

  cloudformation_client.create_stack(
    stack_name: @ecr_name,
    template_body: File.read('cfn/ecr.yml').to_s
  )

  cloudformation_client.wait_until(:stack_create_complete,
                                   stack_name: @ecr_name)

  puts "Cloudformation Stack: #{@stack_name} created."
end

desc 'Deploy ECS Cluster'
task 'cluster:create' do
  cloudformation_client = Aws::CloudFormation::Client.new

  cloudformation_client.create_stack(
    stack_name: @cluster_name,
    template_body: File.read('cfn/cluster.yml').to_s,
    capabilities: ['CAPABILITY_IAM'],
    parameters: [
      {
        parameter_key: 'KeyPair',
        parameter_value: 'mason-aws'
      },
      {
        parameter_key: 'AlbName',
        parameter_value: 'demo-app-alb'
      },
      {
        parameter_key: 'ClusterName',
        parameter_value: 'demo-app-cluster'
      }
    ]
  )

  cloudformation_client.wait_until(:stack_create_complete,
                                   stack_name: @cluster_name)

  puts "Cloudformation Stack: #{@cluster_name} created."
end

desc 'Deploy ECS Service'
task 'service:create' do
  version = File.read(@version_url_path).to_s
  cloudformation_client = Aws::CloudFormation::Client.new

  cloudformation_client.create_stack(
    stack_name: @service_name,
    template_body: File.read('cfn/service.yml').to_s,
    parameters: [
      {
        parameter_key: 'ImageUrl',
        parameter_value: "#{File.read(@ecr_repo_url_path)}/demo-app:#{version}"
      },
      {
        parameter_key: 'StackName',
        parameter_value: @cluster_name
      },
      {
        parameter_key: 'ContainerPort',
        parameter_value: '3000'
      }
    ]
  )

  cloudformation_client.wait_until(:stack_create_complete,
                                   stack_name: @service_name)

  puts "Cloudformation Stack: #{@service_name} created."
end

desc 'Update ECS Service'
task 'service:update' do
  version = File.read(@version_url_path).to_s
  cloudformation_client = Aws::CloudFormation::Client.new

  cloudformation_client.update_stack(
    stack_name: @service_name,
    template_body: File.read('cfn/service.yml').to_s,
    parameters: [
      {
        parameter_key: 'ImageUrl',
        parameter_value: "#{File.read(@ecr_repo_url_path)}/demo-app:#{version}"
      },
      {
        parameter_key: 'StackName',
        parameter_value: @cluster_name
      },
      {
        parameter_key: 'ContainerPort',
        parameter_value: '3000'
      }
    ]
  )

  cloudformation_client.wait_until(:stack_update_complete,
                                   stack_name: @service_name)

  puts "Cloudformation Stack: #{@service_name} updated."
end
