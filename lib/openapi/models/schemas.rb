# frozen_string_literal: true

require 'yaml'
require 'file'

module Openapi
  module Models
    class Schemas
      CONFIG_FILE_PATH = 'swagger/generated_model_schemas.yml'
      DEFAULT_OUT_PATH = 'swagger/generated_model_schemas.yml'

      attr_reader :config, :models, :model_configs, :schemas

      def initialize
        @models = []
        @model_keys = []
        load_all_models!
        if File.exist?(Rails.root.join(CONFIG_FILE_PATH))
          load_config!
        else
          generate_default_config!
        end
        select_models!
        build_model_configs!
      end

      def generate!
        @models = model_configs.map do |key, conf|
          [
            key,
            Model.new(conf[:model], conf.except(:model))
          ]
        end
      end

      private

      def select_models!
        @model_classes = @all_model_classes.reject do |model|
          config[model.model_name.i18n_key] == false
        end
      end

      def build_model_configs!
        @model_configs = @model_classes.index_with do |model|
          [
            model.model_name.i18n_key,
            (config[model.model_name.i18n_key] || { only: [], except: [], optional: [], methods: [] }).merge(
              model: model
            )
          ]
        end
      end

      def load_config!
        file_config = YAML.load_file(Rails.root.join('config/openapi_rails_models.yml'), symbolize_names: true) || {}
        @config = {
          schemas_output_path: file_config.fetch(:schemas_output_path, DEFAULT_OUT_PATH),
          models: file_config&.fetch(:models, @all_models_blank_config)
        }
      end

      def generate_default_config!
        @config = {
          schemas_output_path: DEFAULT_OUT_PATH,
          models: @all_models_blank_config
        }
        config_file = File.open(Rails.root.join(CONFIG_FILE_PATH), 'w')
        config_file.write(config.deep_stringify_keys.to_yaml)
        config_file.close
      end

      def load_all_models!
        # makr sure all ApplicationRecord decendants can be found
        Rails.application.eager_load!
        @all_model_classes = ApplicationRecord.descendants
        @all_model_keys = @all_model_classes.map { |m| m.model_name.i18n_key }
        @all_models_blank_config = @all_model_keys.index_with do
          { only: [], except: [], optional: [], methods: [] }
        end
      end
    end
  end
end
