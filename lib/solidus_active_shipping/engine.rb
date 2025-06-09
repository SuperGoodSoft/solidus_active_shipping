module Spree::ActiveShipping
end

module SolidusActiveShipping
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    require 'spree/core'
    isolate_namespace Spree
    engine_name 'solidus_active_shipping'

    config.autoload_paths += %W(#{config.root}/lib)

    initializer 'solidus_active_shipping.environment', before: :load_config_initializers do |app|
      config.to_prepare do
        Spree::ActiveShipping::Config = SolidusActiveShipping::Configuration.new
      end
    end

    config.to_prepare do
      Dir[File.join(File.dirname(__FILE__), "../../app/models/spree/calculator/**/base.rb")].sort.each do |c|
        Rails.env.production? ? require(c) : load(c)
      end

      Dir.glob(File.join(File.dirname(__FILE__), "../../app/decorators/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    initializer "solidus_active_shipping.register.calculators", after: "spree.register.calculators" do |app|
      config.to_prepare do
        if app.config.spree.calculators.shipping_methods
          classes = Dir.chdir File.join(File.dirname(__FILE__), "../../app/models") do
            Dir["spree/calculator/**/*.rb"].reject {|path| path =~ /base.rb$/ }.map do |path|
              path.gsub('.rb', '').camelize.constantize
            end
          end

          app.config.spree.calculators.shipping_methods.concat classes
        end
      end
    end

    # sets the manifests / assets to be precompiled, even when initialize_on_precompile is false
    initializer 'spree.assets.precompile', group: :all do |app|
      app.config.assets.precompile += %w[
        admin/product_packages/new.js
        admin/product_packages/edit.js
      ]
    end
  end
end
