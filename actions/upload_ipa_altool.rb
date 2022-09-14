module Fastlane
  module Actions
    class UploadIpaAltoolAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        app_type = params[:app_type]
        ipa_path = "\"#{params[:ipa_path]}\""
        key_id = params[:key_id]
        key_issuer = params[:key_issuer]
        validate_app = params[:validate]
        output_format = params[:output_format]
        verbose = params[:verbose]
        # UI.message "Parameter App type: #{app_type}"
        # UI.message "Parameter IPA: #{ipa_path}"
        # UI.message "Parameter KeyId: #{key_id}"
        # UI.message "Parameter Issuer: #{key_issuer}"
        # UI.message "Validate app: #{validate_app}"
        # UI.message "Outpout format: #{output_format}"

        command = [
          'xcrun altool',
          validate_app ? '--validate-app' : '--upload-app',
          '-f',
          ipa_path,
          verbose ? '--verbose' : '',
          '--type',
          app_type,
          '--apiKey',
          key_id,
          '--apiIssuer',
          key_issuer,
          '--output-format',
          output_format
        ]

        final_command = command.join(' ')
        UI.message("========== Validating and Uploading #{ipa_path} file to AppStoreConnect via altool ==========")
        #UI.message "altool command #{final_command}"
        UI.message("========== This may take a while, please wait ==========")
        sh final_command
        UI.message("========== Upload to AppStoreConnect finished ==========")

      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Uploads IPA to AppStore Connect using altool. Key must be stored in ~/.appstoreconnect/private_keys"
      end

      def self.details
        "Use this action to upload the "
      end

      def self.available_options
        # Define all options your action supports.
        [
          FastlaneCore::ConfigItem.new(key: :app_type,
                                    env_name: "APP_TYPE",
                                    description: "Type or platform of application e.g osx, ios, appletvos",
                                    default_value: "ios",
                                    type: String,
                                    optional: true),
          FastlaneCore::ConfigItem.new(key: :key_id,
                                    env_name: "KEY_ID",
                                    description: "The key id",
                                    default_value: ENV["APPLE_KEY_ID"],
                                    type: String,
                                    optional: true),
          FastlaneCore::ConfigItem.new(key: :key_issuer,
                                    env_name: "KEY_ISSUER",
                                    description: "The key issuer",
                                    default_value: ENV["APPLE_KEY_ISSUER_ID"],
                                    type: String,
                                    optional: true),
          FastlaneCore::ConfigItem.new(key: :output_format,
                                    env_name: "OUTPUT_FORMAT",
                                    description: "Output formal xml or json or normal",
                                    default_value: "json",
                                    type: String,
                                    optional: true),
          FastlaneCore::ConfigItem.new(key: :ipa_path,
                                    env_name: "IPA_PATH",
                                    description: "Path to IPA file ",
                                    type: String,
                                    default_value: Dir["*.ipa"].sort_by { |x| File.mtime(x) }.last,
                                    optional: false,
                                    verify_block: proc do |value|
                                      value = File.expand_path(value)
                                      UI.user_error!("Could not find ipa file at path '#{value}'") unless File.exist?(value)
                                      UI.user_error!("'#{value}' doesn't seem to be an ipa file") unless value.end_with?(".ipa")
                                    end),
          FastlaneCore::ConfigItem.new(key: :validate,
                                    env_name: "IPA_PATH",
                                    description: "If true uses validate-app, otherwise upload-app",
                                    type: Fastlane::Boolean,
                                    default_value: false,
                                    optional: true),
          FastlaneCore::ConfigItem.new(key: :verbose,
                                    env_name: "VERBOSE",
                                    description: "If true uses --verbose",
                                    type: Fastlane::Boolean,
                                    default_value: false,
                                    optional: true)
        ]
      end

      def self.output
        # Define the shared values you are going to provide
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        ["dbeltram"]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end