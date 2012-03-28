class Post
  @@posts=[]

  def self.posts
    @@posts
  end

  attr_reader :message
  attr_reader :is_private
  attr_reader :user

  def initialize(user, message, is_private)
    @message = message
    @is_private = is_private
    @user = user
    @@posts << self
  end

  def self.delete(id)
    @@posts.delete_at id if id < @@posts.length
  end

end