require_relative '../spec_helper'

describe alb('demo-app-alb') do
  it { should exist }
  it { should be_active }
end

describe ecs_cluster('demo-app-cluster') do
  it { should exist }
end
