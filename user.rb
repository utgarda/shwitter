class User
  @@users={}

  def self.users
    @@users
  end

  attr_reader :password
  attr_reader :username
  attr_reader :details

  def initialize(username, password)
    @details = {:admin => (@@users.empty?), :new => true}
    @username = username
    @password = password
    @@users[username] = self
  end

  def User.authenticate(username, password)
    u = @@users[username]
    u ? u.password == password ? u : nil : User.new(username, password)
  end

  def User.update(user, new_details)
    puts user
    puts new_details
    user.details.merge! new_details
  end

end
