module Coco
    module Base
      module Identification
  
        module_function
  
        @ppid = ::Process.pid

        def pid
           process_pid = ::Process.pid
           if @ppid != process_pid
              @pid = nil
              @ppid = process_pid
           end
           @pid ||= SecureRandom.urlsafe_base64.tap { |str| @prefix_len = str.length }
        end

        def target2uuid(target)
           return nil unless target.start_with? pid
           target[@prefix_len..-1].to_i
        end
  
        def target2pid(target)
           target ? target[0..(@prefix_len - 1)] : Coco.app_name
        end
      end
    end
  end