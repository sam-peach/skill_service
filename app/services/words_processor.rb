class WordsProcessor

  SKILLS = Hash[Skill.all.collect { |skill| [skill.name.upcase.to_sym, true]}]

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
    skills = Skill.all
    freq_table.each do |k, v|
      skills.find_by(name: k).occurrences.create(data: v)
    end
  end
end