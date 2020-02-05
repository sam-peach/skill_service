module V1
  class WordProcessor
    SKILLS = HTTParty.get(
      ENV['MONOLITH_SKILLS'], 
      headers: {"X-HTTP-AUTHORIZATION": ENV['HTTP_AUTH']} 
    )

    def initialize(data)
      @data = data
    end
  
    def process
      freq_table = {}

      SKILLS.each do |skill|
        if @data.scan(/#{skill}($|[ ,\/.:-;_])/m).size > 0
          freq_table[skill] = 0 if freq_table[skill].blank?
          freq_table[skill] = freq_table[skill] += 1
        end
      end
    
      do_callback(freq_table: freq_table.to_json)
    end
  
    private 
  
    def do_callback(freq_table:)
      return if freq_table == "{}"

      puts "====> SENDING TO MONOLITH"

      HTTParty.post(
        ENV['MONOLITH_URL'], 
        headers: {"X-HTTP-AUTHORIZATION": ENV['HTTP_AUTH']}, 
        query: { skills: freq_table}
      )
    end
  end
end