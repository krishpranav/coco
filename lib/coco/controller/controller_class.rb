module Coco
    module Controller
       module ClassMethods
          def self.extended(base)
             base._pl_init_class_data
          end
 
          def publish(*args)
             Iodine.publish *args
          end
 
          def url_for(func, params = {})
             ::Coco::Base::Router.url_for self, func, params
          end
 
          RESERVED_METHODS = [:delete, :create, :update, :new, :show, :pre_connect, :on_sse, :on_open, :on_close, :on_shutdown, :on_message].freeze

          def _pl_get_map
             return @_pl_get_map if @_pl_get_map
 
             @_pl_get_map = {}
             mths = public_instance_methods false
             mths.delete_if { |mthd| mthd.to_s[0] == '_' || !(-1..0).cover?(instance_method(mthd).arity) }
             @_pl_get_map[nil] = :index if mths.include?(:index)
             RESERVED_METHODS.each { |mthd| mths.delete mthd }
             mths.each { |mthd| @_pl_get_map[mthd.to_s.freeze] = mthd }
 
             @_pl_get_map
          end
 
          def _pl_has_delete
             @_pl_has_delete
          end

          def _pl_has_update
             @_pl_has_update
          end
 
          def _pl_has_create
             @_pl_has_create
          end
 
          def _pl_has_new
             @_pl_has_new
          end
 
          def _pl_has_show
             @_pl_has_show
          end
 
          def _pl_is_websocket?
             @_pl_is_websocket
          end
 
          def _pl_is_sse?
             @_pl_is_sse
          end
 
          def _pl_is_ad?
             @auto_dispatch
          end

          def _pl_ws_map
             return @_pl_ws_map if @_pl_ws_map
 
             @_pl_ws_map = {}
             mths = instance_methods false
             mths.delete :index
             RESERVED_METHODS.each { |mthd| mths.delete mthd }
             mths.each { |mthd| @_pl_ws_map[mthd.to_s.freeze] = mthd; @_pl_ws_map[mthd] = mthd }
 
             @_pl_ws_map
          end
 
          def _pl_ad_map
             return @_pl_ad_map if @_pl_ad_map
 
             @_pl_ad_map = {}
             mths = public_instance_methods false
             mths.delete_if { |m| m.to_s[0] == '_' || ![-2, -1, 1].freeze.include?(instance_method(m).arity) }
             mths.delete :index
             RESERVED_METHODS.each { |m| mths.delete m }
             mths.each { |m| @_pl_ad_map[m.to_s.freeze] = m; @_pl_ad_map[m] = m }
 
             @_pl_ad_map
          end
 
          def _pl_params2method(params, env)
             par_id = params['id'.freeze]
             meth_id = _pl_get_map[par_id]
             return meth_id if par_id && meth_id

             case params['_method'.freeze]
             when :get 
                if env['rack.upgrade?'.freeze]
                   if (env['rack.upgrade?'.freeze] == :websocket && _pl_is_websocket?) || (env['rack.upgrade?'.freeze] == :sse && _pl_is_sse?)
                      @_pl_init_global_data ||= ::Coco.coco_initialize 
                      return :preform_upgrade
                   end
                end
                return :new if _pl_has_new && par_id == 'new'.freeze
                return meth_id || (_pl_has_show && :show) || nil
             when :put, :patch
                return :create if _pl_has_create && (par_id.nil? || par_id == 'new'.freeze)
                return :update if _pl_has_update
             when :post
                return :create if _pl_has_create
             when :delete
                return :delete if _pl_has_delete
             end
             meth_id || (_pl_has_show && :show) || nil
          end
 
          def _pl_init_class_data
             @auto_dispatch ||= nil
             @_pl_get_map = @_pl_ad_map = @_pl_ws_map = nil
             @_pl_has_show = public_instance_methods(false).include?(:show)
             @_pl_has_new = public_instance_methods(false).include?(:new)
             @_pl_has_create = public_instance_methods(false).include?(:create)
             @_pl_has_update = public_instance_methods(false).include?(:update)
             @_pl_has_delete = public_instance_methods(false).include?(:delete)
             @_pl_is_websocket = (instance_variable_defined?(:@auto_dispatch) && instance_variable_get(:@auto_dispatch)) || instance_methods(false).include?(:on_message)
             @_pl_is_sse = instance_methods(false).include?(:on_sse)
             _pl_get_map
             _pl_ad_map
             _pl_ws_map
          end
       end
    end
 end