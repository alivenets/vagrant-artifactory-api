require "artifactory-api/version"

Gem::Specification.new do |s|
  s.name          = "vagrant-artifactory-api"
  s.version       = VagrantPlugins::ArtifactoryApi::VERSION
  s.license       = "MIT"
  s.authors       = "Alexander Livenets"
  s.email         = "alivenets@zoho.eu"
  s.summary       = "TODO"
  s.description   = "TODO"

  s.required_rubygems_version = ">= 1.3.6"

  # The following block of code determines the files that should be included
  # in the gem. It does this by reading all the files in the directory.
  root_path      = File.dirname(__FILE__)
  all_files      = Dir.chdir(root_path) { Dir.glob("**/{*,.*}") }
  all_files.reject! { |file| [".", ".."].include?(File.basename(file)) }

  s.files         = all_files
  s.executables   = all_files.map { |f| f[/^bin\/(.*)/, 1] }.compact
  s.require_path  = 'lib'
end
