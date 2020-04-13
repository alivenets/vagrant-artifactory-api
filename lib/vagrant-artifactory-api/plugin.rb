require "vagrant"

module VagrantPlugins
    module ArtifactoryApi
        class Plugin < Vagrant.plugin("2")
            name "Artifactory API key injection plugin"
            VAGRANT_VERSION_REQUIREMENT = ">= 2.0.0"

            def initialize(*)
                super
            end

            # Returns true if the Vagrant version fulfills the requirements
            #
            # @param requirements [String, Array<String>] the version requirement
            # @return [Boolean]
            def self.check_vagrant_version(*requirements)
                Gem::Requirement.new(*requirements).satisfied_by?(Gem::Version.new(Vagrant::VERSION))
            end

            # Verifies that the Vagrant version fulfills the requirements
            #
            # @raise [VagrantPlugins::ProxyConf::VagrantVersionError] if this plugin
            # is incompatible with the Vagrant version
            def self.check_vagrant_version!
                if !check_vagrant_version(VAGRANT_VERSION_REQUIREMENT)
                    msg = "Vagrant version must be #{VAGRANT_VERSION_REQUIREMENT}"
                    $stderr.puts msg
                    raise msg
                end
            end

            config "artifactory" do
                require_relative "config"
                Config
            end

            check_vagrant_version!
        end
    end
end

require_relative 'downloader_ext'
