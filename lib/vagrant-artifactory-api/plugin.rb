require "vagrant"

module VagrantPlugins
    module ArtifactoryApi
        class Plugin < Vagrant.plugin("2")
            name "Artifactory API key injection plugin"
            VAGRANT_VERSION_REQUIREMENT = ">= 2.0.0"

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

            # TODO: Add logic of using value from Vagrantfile
            config "artifactory" do
                require_relative "config"
                Config
            end

            check_vagrant_version!
        end
    end
end

# NOTE: The following code is a monkey patching of Downloader class to include required header.
#       Vagrant does not provide any API for it, so it is truly hacking.
#       There is no guarantee, that the code will work
#       for the future Vagrant versions.
module VagrantPlugins
    module DownloaderExtensions
        require_relative "defs"
        def initialize(*args)
            super(*args)

            # TODO: Get API key from plugin config
            header_value = ENV[VagrantPlugins::ArtifactoryApi::Defs::API_KEY_ENV_VARIABLE]
            if header_value
                artifactory_header = "#{VagrantPlugins::ArtifactoryApi::Defs::API_KEY_HEADER_NAME}: #{header_value}"
                @headers << artifactory_header

                @logger.info("Artifactory API header has been added: #{artifactory_header}")
            end
        end
    end
end

module Vagrant
    module Util
        class Downloader
            prepend VagrantPlugins::DownloaderExtensions
        end
    end
end
