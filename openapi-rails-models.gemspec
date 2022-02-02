# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = 'openapi-rails-models'
  spec.version = '0.0.1'
  spec.authors = ['Kaspar Vollenweider']
  spec.email = ['vok@panter.ch']
  spec.homepage = 'https://github.com/casaper/openapi-rails-models'
  spec.summary = "Generates OpenAPI schemas from Rails' ActiveRecord Models"
  spec.license = 'MIT'

  spec.metadata = {
    # "bug_tracker_uri" => "",
    # "changelog_uri" => "",
    # "documentation_uri" => "",
    'label' => 'Openapi Rails Models',
    'rubygems_mfa_required' => 'true',
    'source_code_uri' => 'https://github.com/casaper/openapi-rails-models'
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = '>= 2.6.3'
  spec.add_dependency 'rails', '>= 6.1.0'
  spec.add_dependency 'zeitwerk', '>= 2.5'

  spec.extra_rdoc_files = Dir['README*', 'LICENSE*']
  spec.files = Dir['*.gemspec', 'lib/**/*']
end
