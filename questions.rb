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
  
  def self.find_by_name(first_name, last_name)
    user = QuestionsDatabase.instance.execute(<<-SQL, first_name, last_name) 
      SELECT *
      FROM users 
      WHERE fname = ? AND lname = ?
    SQL
    
    return nil unless user.length > 0
    
    User.new(user.first)
  end
  
  def authored_questions
    Question.find_by_author_id(@id)
  end
  
  def authored_replies
    Reply.find_by_user_id(@id)
  end
  
  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
  
  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
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
  
  def self.find_by_author_id(a_id)
    array_questions = QuestionsDatabase.instance.execute(<<-SQL, a_id)
      SELECT * 
      FROM questions 
      WHERE author_id = ?
    SQL
    
    return nil unless array_questions.length > 0
    
    array_questions.map { |question| Question.new(question) }
  end
  
  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end
  
  def author
    User.find_by_id(@author_id)
  end
  
  def replies
    Reply.find_by_question_id(@id)
  end
  
  def followers 
    QuestionFollow.followers_for_question_id(@id)
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
  
  def self.followers_for_question_id(question_id)
    followers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT users.id, fname, lname 
      FROM question_follows 
      JOIN users ON users.id = question_follows.user_id 
      WHERE question_id = ?;
    SQL
    
    return nil unless followers.length > 0
    
    followers.map { |person| User.new(person) }
  end
  
  def self.followed_questions_for_user_id(user_id)
    followed = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT *
      FROM question_follows
      JOIN questions ON questions.id = question_follows.question_id
      WHERE user_id = ?
    SQL
    
    return nil unless followed.length > 0
    
    followed.map { |question| Question.new(question) }
  end
  
  def self.most_followed_questions(n)
    # most_followed = QuestionsDatabase.instance.execute(<<-SQL, n)
    # SELECT *
    # FROM questions
    # JOIN followed_questions ON question_follows.question_id = questions.id
    # WHERE COUNT
    # SQL 
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
  
  def self.find_by_user_id(u_id)
    
    replies_array = QuestionsDatabase.instance.execute(<<-SQL, u_id)
      SELECT *
      FROM replies 
      WHERE user_id = ?
    SQL
    
    return nil unless replies_array.length > 0 
    
    replies_array.map { |reply| Reply.new(reply) }
  end
  
  def self.find_by_question_id(q_id)
    replies_array = QuestionsDatabase.instance.execute(<<-SQL, q_id)
        SELECT *
        FROM replies 
        WHERE question_id = ? OR parent_id = ?
      SQL
      
    return nil unless replies_array.length > 0 
    
    replies_array.map { |reply| Reply.new(reply) }
  end
  
  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
    @parent_id = options['parent_id']
    @body = options['body']
  end
  
  def author
    User.find_by_id(@user_id)
  end
  
  def question
    Question.find_by_id(@question_id)
  end
  
  def parent_reply
    if @parent_id
      Reply.find_by_id(@parent_id)
    else
      puts "No Parent Reply"
    end
  end
  
  def child_replies
    replies_array = QuestionsDatabase.instance.execute(<<-SQL, @id)
        SELECT *
        FROM replies 
        WHERE parent_id = ?
      SQL
      
    return nil unless replies_array.length > 0 
    
    replies_array.map { |reply| Reply.new(reply) }
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
