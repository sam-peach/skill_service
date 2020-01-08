class WordsProcessor

  SKILLS = {JAVA: true, PYHTON: true, C: true, JAVASCRIPT: true}

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
    # skills = Skill.all
    # freq_table.each do |k, v|
    #   skills.find_by(name: k).occurrences.create(data: v)
    # end

    HTTParty.post('http://localhost:3000/microservices', query: { test: { table: freq_table } })
  end
end