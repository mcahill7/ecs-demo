require 'docker'
require 'serverspec'

describe 'Dockerfile' do
  before(:all) do
    set :os, family: :alpine
    set :backend, :docker
    set :docker_image, ENV['DOCKER_IMAGE_ID']
  end

  [
    '/app/Gemfile',
    '/app/Gemfile.lock',
    '/app/version',
    '/app/app.rb',
    '/app/config.ru',
    '/app/config.yml'
  ].each do |file|
    describe file(file.to_s) do
      it { should exist }
      it { should be_file }
    end
  end

  describe user('nobody') do
    it { should exist }
    it { should belong_to_group 'nobody' }
  end

  describe port(3000) do
    it { should be_listening }
  end
end
