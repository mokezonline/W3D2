require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton
  
  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true 
  end
  
end

##########################################################################################################################################################################################################################################################################################


class User 
  attr_accessor :id, :fname, :lname
  
  def self.find_by_id(id_input)
    user = QuestionsDatabase.instance.execute(<<-SQL, id_input)
      SELECT *
      FROM users 
      WHERE id = ?
    SQL
    
    return nil unless user.length > 0
    
    User.new(user.first)
  end
  
  def self.find_by_fname(first_name)
  end
  
  def self.find_by_lname(last_name)
  end
  
  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
  
  
end

##########################################################################################################################################################################################################################################################################################

class Question   
  attr_accessor :_____, :______, :______, :______
  
  def self.find_by_id(id_input)
    _______ = QuestionsDatabase.instance.execute(<<-SQL, id_input)
      SELECT *
      FROM ________ 
      WHERE id = ?
    SQL
    
    return nil unless _______.length > 0
    
    _________.new(______.first)
  end
  
  def self.find_by_title(question_title)
  end
  
  def initialize(options)
    @id = options['id']
    @______ = options['______']
    @_____ = options['______']
    @________ = options['_______']
  end
end


##########################################################################################################################################################################################################################################################################################


class QuestionFollows 
  attr_accessor :_____, :______, :______
  
  def self.find_by_id(id_input)
    _______ = QuestionsDatabase.instance.execute(<<-SQL, id_input)
      SELECT *
      FROM ________ 
      WHERE id = ?
    SQL
    
    return nil unless _______.length > 0
    
    _________.new(______.first)
  end
  
  def initialize(options)
    @id = options['id']
    @______ = options['______']
    @_____ = options['______']
  end
end 

##########################################################################################################################################################################################################################################################################################

class Reply 
  attr_accessor :_____, :______, :______, :________, :______
  
  def self.find_by_id(id_input)
    _______ = QuestionsDatabase.instance.execute(<<-SQL, id_input)
      SELECT *
      FROM ________ 
      WHERE id = ?
    SQL
    
    return nil unless _______.length > 0
    
    _________.new(______.first)
  end
  
  def initialize(options)
    @id = options['id']
    @______ = options['______']
    @_____ = options['______']
    @________ = options['_______']
    @________ = options['_______']
  end
end 

##########################################################################################################################################################################################################################################################################################

class QuestionLikes 
  attr_accessor :_____, :______, :______
  
  def self.find_by_id(id_input)
    _______ = QuestionsDatabase.instance.execute(<<-SQL, id_input)
      SELECT *
      FROM ________ 
      WHERE id = ?
    SQL
    
    return nil unless _______.length > 0
    
    _________.new(______.first)
  end
  
  def initialize(options)
    @id = options['id']
    @______ = options['______']
    @_____ = options['______']
  end
end
