module Coco
    module Controller
        module ClassMethods

            def self.extended(base)
                base._pl_init_class_data
            end

            def publish(*args)
                Iodine.publish *args
            end

            def url_for(func, params={})
                ::Coco::Base::Router.url_for self, func, params
            end

            RESERVED_METHODS = [:delete, :create, :update, :new, :show, :pre_connect, :on_sse, :on_open, :on_close, :on_shutdown, :on_message].freeze

        end
    end

end
