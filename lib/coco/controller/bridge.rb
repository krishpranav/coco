module Coco
    module Base
      module Bridge
        CONTROLLER_NAME = "coco.controller".to_sym
        CLIENT_NAME = "@_pl__client".to_sym 

        def controller client
          client.env[CONTROLLER_NAME]
        end
  
        def on_open client
          c = controller(client)
          c.instance_variable_set(CLIENT_NAME, client)
          if client.protocol == :sse
            c.on_sse
          else
            c.on_open
          end
        end

        def on_message client, data
           controller(client).on_message(data)
        end

        def on_shutdown client
           controller(client).on_shutdown
        end

        def on_close client
           controller(client).on_close
        end

        def on_drained client
           controller(client).on_drained
        end
        extend self
      end
    end
  end