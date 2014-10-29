class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save :generate_initials

  def name
    if surname && given_name
      "#{surname}, #{given_name}"
    elsif surname || given_name
      surname || given_name
    else
      nil
    end
  end

  def admin?
    rank == "admin"
  end

  def nurse?
    rank == "nurse"
  end

  def doctor?
    rank == "doctor"
  end

  def manager?
    rank == "manager"
  end


  private

  def generate_initials
    initials = (given_name[0] + surname[0]).upcase
    self.initials = initials + ((User.all.select{|u| u.initials =~ /^#{initials}[0-9]*$/}.map{|u| u.initials.sub(initials, "").to_i}.sort.last || 0) + 1).to_s
  end
end
