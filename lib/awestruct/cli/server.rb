require 'awestruct/rack/app'

module Awestruct
  module CLI

    class Server
      attr_reader :server

      def initialize(path, bind_addr='0.0.0.0', port=4242)
        @path      = path
        @bind_addr = bind_addr
        @port      = port
      end

      def run
        RUBY_PLATFORM == 'java' ? run_webrick : run_thin
      end

      def run_thin
        require 'thin'
        @server = Thin::Server.new( '0.0.0.0', @port, Awestruct::Rack::App.new( @path ) )
        @server.start
      end

      def run_webrick
        require 'webrick'
        WEBrick::HTTPUtils::DefaultMimeTypes.store('atom', 'application/atom+xml')
        WEBrick::HTTPUtils::DefaultMimeTypes.store('appcache', 'text/cache-manifest')
        @server = WEBrick::HTTPServer.new( :DocumentRoot=>@path, :Port=>@port, :BindAddress=>@bind_addr )
        @server.start
      end
    end
  end
end
