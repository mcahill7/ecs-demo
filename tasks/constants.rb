@image_id_path = 'demo-image-id'
@cluster_name = 'demo-app-cluster'
@service_name = 'demo-app'
@ecr_name = 'demo-app-ecr'
@ecr_repo_url_path = 'demo-ecr-repo'
@version_url_path = 'version'
@container = Docker::Container.create(
  'Image' => 'demo:latest',
  'ExposedPorts' => { '3000/tcp' => {} },
  'HostConfig' => {
    'PortBindings' => {
      '3000/tcp' => [{ 'HostPort' => '80' }]
    }
  }
)
