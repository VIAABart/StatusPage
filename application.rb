# encoding: UTF-8

module Status
  class Application < Sinatra::Base
    
    #set :public_folder, 'public'
    
    use Rack::Session::Pool, :expire_after => 2592000 
    
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
          response = open(r[:uri], :allow_redirections => :safe).status
          @json << {:device => r[:device], :uri => r[:uri], :status => {:code => response[1], :body => response[0]}}
        rescue => e
          session[:e] = e
          @json << {:device => r[:device], :uri => r[:uri], :status => {:code => "Fout", :body => e}}
          print e.inspect
        end
      end
      erb :stats
    end
      
    error do
      'An error occured: ' + request.env['sinatra.error'].message
    end
    
    get '/motd' do
      @motd = YAML.load_file("motd.yml")
      print @motd.inspect
      erb :motd
    end
    
    get '/error' do
      status 500
      erb :error
    end
    
    not_found do
      content_type :json
      halt 404, { error: 'URL not found' }.to_json
    end   
    
    error Sinatra::NotFound do
      content_type 'text/plain'
      [404, 'Not Found']
    end
    
  end
end