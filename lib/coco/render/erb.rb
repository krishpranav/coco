require 'coco/render/has_cache' unless defined? ::Coco::Base::HasStore
module Coco
   module Base
      module RenderERB
         extend ::Coco::Base::HasStore

         module_function

         def call(filename, context, &block)
            return unless defined? ::ERB
            return unless File.exist?(filename)
            engine = load_engine(filename)
            engine.result(context, &block)
         end
         if ENV['RACK_ENV'.freeze] == 'production'.freeze
            def load_engine(filename)
               engine = self[filename]
               return engine if engine
               self[filename] = ::ERB.new(::Coco.try_utf8!(IO.binread(filename)))
            end
         else
            def load_engine(filename)
               engine, tm = self[filename]
               return engine if engine && (tm == File.mtime(filename))
               self[filename] = [(engine = ::ERB.new(::Coco.try_utf8!(IO.binread(filename)))), File.mtime(filename)]
               engine
            end
         end
      end
   end
end

::Coco::Renderer.register :erb, ::Coco::Base::RenderERB