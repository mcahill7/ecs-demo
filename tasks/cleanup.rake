require 'aws-sdk'
require_relative 'constants'

desc 'Delete AWS Assets'
task 'demo:cleanup' do
  if ENV['AWS_ACCOUNT_ID'].nil?
    raise 'Set environment variable AWS_ACCOUNT_ID and try again.'
  end

  %w[
    ecr:delete
    service:delete
    cluster:delete
  ].each do |task_name|
    Rake::Task[task_name].reenable
    Rake::Task[task_name].invoke
  end
end

desc 'Destroy ECS Cluster'
task 'cluster:delete' do
  cloudformation_client = Aws::CloudFormation::Client.new

  cloudformation_client.delete_stack(
    stack_name: @cluster_name
  )

  cloudformation_client.wait_until(:stack_delete_complete,
                                   stack_name: @cluster_name)

  puts "Cloudformation Stack: #{@cluster_name} destroyed."
end

desc 'Destroy ECS Service'
task 'service:delete' do
  cloudformation_client = Aws::CloudFormation::Client.new

  cloudformation_client.delete_stack(
    stack_name: @service_name
  )

  cloudformation_client.wait_until(:stack_delete_complete,
                                   stack_name: @service_name)

  puts "Cloudformation Stack: #{@service_name} destroyed."
end

desc 'Delete ECR repository'
task 'ecr:delete' do
  cloudformation_client = Aws::CloudFormation::Client.new
  ecr_client = Aws::ECR::Client.new

  image_ids = ecr_client.list_images(
    registry_id: ENV['AWS_ACCOUNT_ID'],
    repository_name: 'demo-app'
  ).image_ids

  # Delete all the pushed images, if any exist (prerequisite for deletion)
  images = ecr_client.list_images(repository_name: 'demo-app')
  if images[0].any?
    ecr_client.batch_delete_image(repository_name: 'demo-app',
                                  image_ids: image_ids)
  end

  # Delete the stack
  cloudformation_client.delete_stack(
    stack_name: @ecr_name
  )

  cloudformation_client.wait_until(:stack_delete_complete,
                                   stack_name: @ecr_name)

  puts "Cloudformation Stack: #{@ecr_name} deleted."
end
