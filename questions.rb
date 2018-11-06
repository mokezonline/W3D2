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
  
  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM users")
    data.map { |datum| User.new(datum) }
  end
  
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
  attr_accessor :id, :body, :title, :author_id
  
  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
    data.map { |datum| Question.new(datum) }
  end
  
  def self.find_by_id(id_input)
    question = QuestionsDatabase.instance.execute(<<-SQL, id_input)
      SELECT *
      FROM questions
      WHERE id = ?
    SQL
    
    return nil unless question.length > 0
    
    Question.new(question.first)
  end
  
  def self.find_by_title(question_title)
    question = QuestionsDatabase.instance.execute(<<-SQL, question_title)
      SELECT * 
      FROM questions 
      WHERE title = ?
    SQL
    
    return nil unless question.length > 0 
    
    Question.new(question.first)
  end
  
  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end
end


##########################################################################################################################################################################################################################################################################################


class QuestionFollow 
  attr_accessor :id, :user_id, :question_id
  
  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM question_follows")
    data.map { |datum| QuestionFollow.new(datum) }
  end
  
  def self.find_by_id(id_input)
    question_follow = QuestionsDatabase.instance.execute(<<-SQL, id_input)
      SELECT *
      FROM question_follows
      WHERE id = ?
    SQL
    
    return nil unless question_follow.length > 0
    
    QuestionFollow.new(question_follow.first)
  end
  
  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end 


##########################################################################################################################################################################################################################################################################################


class Reply 
  attr_accessor :id, :question_id, :user_id, :parent_id, :body
  
  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
    data.map { |datum| Reply.new(datum) }
  end
  
  def self.find_by_id(id_input)
    reply = QuestionsDatabase.instance.execute(<<-SQL, id_input)
      SELECT *
      FROM replies 
      WHERE id = ?
    SQL
    
    return nil unless reply.length > 0
    
    Reply.new(reply.first)
  end
  
  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
    @parent_id = options['parent_id']
    @body = options['body']
  end
end 


##########################################################################################################################################################################################################################################################################################


class QuestionLike 
  attr_accessor :id, :question_id, :user_id
  
  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM question_likes")
    data.map { |datum| QuestionLike.new(datum) }
  end
  
  def self.find_by_id(id_input)
    like = QuestionsDatabase.instance.execute(<<-SQL, id_input)
      SELECT *
      FROM question_likes
      WHERE id = ?
    SQL
    
    return nil unless like.length > 0
    
    QuestionLike.new(like.first)
  end
  
  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
end
