require "vagrant"

module VagrantPlugins
    module ArtifactoryApi
        class Config < Vagrant.plugin("2", :config)
            # FIXME: rename to api_key
            # @return [Hash<String, String>]
            attr_accessor :api_key

            def initialize
                super
                @api_key = UNSET_VALUE
            end
        end
    end
end
