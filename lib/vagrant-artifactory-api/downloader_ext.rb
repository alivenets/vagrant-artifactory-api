# NOTE: The following code is a monkey patching of Downloader class to include required header.
#       Vagrant does not provide any API for it, so it is truly hacking.
#       There is no guarantee, that the code will work
#       for the future Vagrant versions.
module VagrantPlugins
    module ArtifactoryApi
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
end

module Vagrant
    module Util
        class Downloader
            prepend VagrantPlugins::ArtifactoryApi::DownloaderExtensions
        end
    end
end
