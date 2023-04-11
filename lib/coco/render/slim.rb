require 'coco/render/has_cache' unless defined? ::Coco::Base::HasStore
module Coco
    module Base
        module RenderSlim
            extend ::Coco::Base::HasStore

            def call(filename, context, &block)
                return unless defined? ::Slim
                return unless File.exist?(filename)
                engine = load_engine(filename)
                engine.render(context.receiver, &block)
            end

            if ENV['RACK_ENV'.freeze] == 'production'.freeze
                def load_engine(filename)
                end
            else
                def load_engine(filename)
                end
        end
    end
end


::Coco::Render.register :slim, ::Coco::Base::RenderSlim