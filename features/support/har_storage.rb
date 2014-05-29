class HarStorage
    include HTTParty
    host = ENV['HARSTORAGE_HOST'] || 'localhost'
    port = ENV['HARSTORAGE_PORT'] || 5000
    base_uri "http://#{host}:#{port}"
    headers  'Content-Type' =>  "application/x-www-form-urlencoded" , 'Automated' => "true"


   def self.upload(har)
       post("/results/upload", :body => { :file => har.to_json})
   end
end