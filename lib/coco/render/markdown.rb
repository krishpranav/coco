require 'coco/render/has_cache' unless defined? ::Coco::Base::HasStore

unless defined?(::Redcarpet::Markdown)
   begin
      require('redcarpet')
   rescue Exception

   end
end

if defined?(Redcarpet::Markdown)
   module Coco
      module Base
         module RenderMarkDown
            class NewPageLinksMDRenderer < Redcarpet::Render::HTML

               def link(link, title, content)
                  "<a href=\"#{link}\"#{" target='_blank'" if link =~ /^http[s]?\:\/\//}#{" title=\"#{title}\"" if title}>#{content}</a>"
               end
            end

            MD_EXTENSIONS = { with_toc_data: true, strikethrough: true, autolink: true, fenced_code_blocks: true, no_intra_emphasis: true, tables: true, footnotes: true, underline: true, highlight: true }.freeze

            MD_RENDERER = Redcarpet::Markdown.new NewPageLinksMDRenderer.new(MD_EXTENSIONS.dup), MD_EXTENSIONS.dup

            MD_RENDERER_TOC = Redcarpet::Markdown.new Redcarpet::Render::HTML_TOC.new(MD_EXTENSIONS.dup), MD_EXTENSIONS.dup

            extend ::Coco::Base::HasStore

            module_function

            def call(filename, _context)
               return unless File.exist?(filename)
               load_engine(filename)
            end

            if ENV['RACK_ENV'.freeze] == 'production'.freeze

               def load_engine(filename)
                  engine = self[filename]
                  return engine if engine
                  data = IO.read filename
                  self[filename] = "<div class='toc'>#{::Coco::Base::RenderMarkDown::MD_RENDERER_TOC.render(data)}</div>\n#{::Coco::Base::RenderMarkDown::MD_RENDERER.render(data)}"
               end
            else

               def load_engine(filename)
                  engine, tm = self[filename]
                  return engine if engine && tm == File.mtime(filename)
                  data = IO.read filename
                  (self[filename] = ["<div class='toc'>#{::Coco::Base::RenderMarkDown::MD_RENDERER_TOC.render(data)}</div>\n#{::Coco::Base::RenderMarkDown::MD_RENDERER.render(data)}", File.mtime(filename)])[0]
               end
            end
         end
      end
   end

   ::Coco::Renderer.register :md, ::Coco::Base::RenderMarkDown
end