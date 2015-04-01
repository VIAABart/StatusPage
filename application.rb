# encoding: UTF-8
require 'timeout'

module Status
  class Application < Sinatra::Base
    
    #set :public_folder, 'public'
    
    #use Rack::Session::Pool, :expire_after => 1000 
    
    configure :development do
      register Sinatra::Reloader
      enable :raise_errors
      enable :show_exceptions
      set :dump_errors, true
    end

    def initialize(app)
      super(app)
    end
        
    get '/' do
      # File.read(File.join('public', 'index.html'))
      html :index
    end
 
    def html(view)
      File.read(File.join('public', "#{view.to_s}.html"))
    end
    
    get '/status-rows' do
      erb :stats
    end
      
    get '/stats' do
      @json = Array.new
      requests = YAML.load_file("sites.yml").map(&:symbolize_keys)
      requests.each do |r|
        begin
          Timeout.timeout(1) do
            response = open(r[:uri], :allow_redirections => :safe, :read_timeout => 5).status
            @json << {:device => r[:device], :uri => r[:uri], :status => {:code => response[1], :body => "Service is up (#{response[0]} #{response[1].capitalize})"}}
          end
        rescue Timeout::Error
          @json << {:device => r[:device], :uri => r[:uri], :status => {:code => "Fout", :body => "Connection timed out (#{$!})"}}
          #print "Timeout::Error: #{$!}\n"
          next
        rescue => e
          #session[:e] = e
          status = e.io.status[0]
          if status == '403'
            @json << {:device => r[:device], :uri => r[:uri], :status => {:code => "OK", :body => "Service is up, authenticated only (#{e})"}}
          else
            @json << {:device => r[:device], :uri => r[:uri], :status => {:code => "Fout", :body => "Service is down #{e}"}}
          end
          next
        end
      end
      erb :stats
    end
      
    error do
      'An error occured: ' + request.env['sinatra.error'].message
    end
    
    get '/motd' do
      if File.exists? ("motd.yml")
        @motd = YAML.load_file("motd.yml")
        erb :motd
      end
    end
    
    get '/error' do
      status 500
      erb :error
    end
    
    error Sinatra::NotFound do
      content_type 'text/plain'
      [404, 'Not Found']
    end
    
  end
end