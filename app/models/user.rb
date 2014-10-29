class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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

  # Set up initials
end
