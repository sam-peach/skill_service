class WordsProcessor

  SKILLS = { 
    :ANGULAR=>true,
    :BOOTSTRAP=>true,
    :JQUERY=>true,
    :REACT=>true,
    :JAVASCRIPT=>true,
    :POSTGRESQL=>true,
    :MYSQL=>true,
    :NOSQL=>true,
    :PHP=>true,
    :PYTHON=>true,
    :RUBY=>true,
    :RAILS=>true,
    :JAVA=>true,
    :"C#"=>true,
    :C=>true,
    :PERL=>true,
    :SCALA=>true,
    :NODE=>true,
    :DOCKER=>true,
    :MONGODB=>true,
    :AWS=>true,
    :LINUX=>true,
    :AZURE=>true,
    :IOS=>true,
    :KUBERNETES=>true,
    :"C++"=>true
   }

  def self.process(data:)
    freq_table = {}

    data.each do |skill|
      upcase_skill = skill.upcase
      if SKILLS[upcase_skill.to_sym]
        freq_table[upcase_skill.to_sym] = 0 if freq_table[upcase_skill.to_sym ].blank?
        freq_table[upcase_skill.to_sym] = freq_table[upcase_skill.to_sym  ] += 1
      end
    end
    save_occurrences(freq_table: freq_table)
  end

  private 

  def self.save_occurrences(freq_table:)
      HTTParty.post(ENV["MONOLITH_URL"], query: { skills: freq_table })
  end
end