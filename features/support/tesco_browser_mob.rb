module BrowserMob
  module Proxy
    class Client
      def self.from(server_url)
        port = JSON.parse(
            RestClient.post(URI.join(server_url, "proxy?httpProxy=dev01isa01:8080").to_s, '')
        ).fetch('port')

        uri = URI.parse(File.join(server_url, "proxy", port.to_s))
        resource = RestClient::Resource.new(uri.to_s)

        Client.new resource, uri.host, port
      end
    end
    class WebDriverListener
      def har_present
        begin
          @client.har
        rescue JSON::ParserError => e
          false
        else
          true
        end
      end

      def before_navigate_to(url, driver)
       # save_har if har_present # first request
        @current_url = url
        name = "navigate-to-#{url}"
        @client.new_har("navigate-to-#{url}", @new_har_opts)
        @client.new_page name

      end

      def after_navigate_to(url, driver)
        save_har if har_present && url != 'about:blank'
      end

      def after_click(element, driver)
        save_har
      end



      def before_click(element, driver)
        @client.new_har("click-element-#{@current_url}", @new_har_opts)
        name = "click-element-#{identifier_for element}_in#{@current_url}"
        @client.new_page name
      end

      def before_quit(driver)
        #save_har
      end
    end

  end

end

