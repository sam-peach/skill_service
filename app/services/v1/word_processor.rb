module V1
  class WordProcessor
    SKILLS = { 
      "ANGULAR"=>true,
      "BOOTSTRAP"=>true,
      "JQUERY"=>true,
      "REACT"=>true,
      "JAVASCRIPT"=>true,
      "POSTGRESQL"=>true,
      "MYSQL"=>true,
      "NOSQL"=>true,
      "PHP"=>true,
      "PYTHON"=>true,
      "RUBY"=>true,
      "RAILS"=>true,
      "JAVA"=>true,
      "C#"=>true,
      "C"=>true,
      "PERL"=>true,
      "SCALA"=>true,
      "NODE"=>true,
      "DOCKER"=>true,
      "MONGODB"=>true,
      "AWS"=>true,
      "LINUX"=>true,
      "AZURE"=>true,
      "IOS"=>true,
      "KUBERNETES"=>true,
      "C++"=>true,
      "TYPESCRIPT"=>true
      }

    def initialize(data)
      @data = data
    end
  
    def process
      freq_table = {}
  
      @data.each do |skill|
        upcase_skill = skill.strip.upcase.to_s
        if SKILLS[upcase_skill]
          freq_table[upcase_skill] = 0 if freq_table[upcase_skill].blank?
          freq_table[upcase_skill] = freq_table[upcase_skill] += 1
        end
      end
    
      do_callback(freq_table: freq_table.to_json)
    end
  
    private 
  
    def do_callback(freq_table:)
      puts "====> SENDING TO MONOLITH"

      HTTParty.post(
        ENV['MONOLITH_URL'], 
        headers: {"X-HTTP-AUTHORIZATION": ENV['HTTP_AUTH']}, 
        query: { skills: freq_table}
      )
    end
  end
end