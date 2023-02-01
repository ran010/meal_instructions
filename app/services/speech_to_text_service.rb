class SpeechToText
  attr_reader :url
  
  def initialize(url)
    @url = url
  end

  def call
    return unless url.start_with?("http")
    uri = URI('https://api.assemblyai.com/v2/transcript')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(
      uri,
      'authorization' => Rails.application.credentials.assemblyai,
      'content-type'  => 'application/json'
    )
    request.body = {
      'audio_url' => url
    }.to_json
    
    response = http.request(request)
    response.read_body
  rescue => e
    Rails.logger.error "Error: #{e.message}"
  end
end
