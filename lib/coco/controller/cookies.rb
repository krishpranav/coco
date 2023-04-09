#!/usr/bin/env ruby

module Coco
    module Controller

        class Cookies < Hash
            attr_reader :request :response

            def initialize(request, response)
                @request = request
                @response = response
            end

            def[](key)
                if key.is_a? Symbol
                    super(key)
                elsif key.is_a? String
                    super(key)
                else 
                    super(key) || @request.cookies[key]
                end
            end
        end
    end
end
