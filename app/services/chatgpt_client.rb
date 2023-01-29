class ChatgptClient
  attr_reader :client

  def initialize
    @client = OpenAI::Client.new
  end

  def create_completion(prompt)
    response = client.completions(
      parameters: {
        model: "text-davinci-002", # text-davinci-002 is
        prompt: prompt,
        max_tokens: 500, # 500 is the maximum words
        temperature: 0.5,
        top_p: 0.2
      }
    )
    response.dig("choices", 0, "text").split("\n").reject { |text| text.empty? }
  rescue => e
    Rails.logger.error "Error: #{e.message}"
    raise "Error: #{e.message}"
  end
end
