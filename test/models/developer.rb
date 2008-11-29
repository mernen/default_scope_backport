class Developer < ActiveRecord::Base
end

class DeveloperOrderedBySalary < ActiveRecord::Base
  self.table_name = 'developers'
  default_scope :order => 'salary DESC'
  named_scope :by_name, :order => 'name DESC'

  def self.all_ordered_by_name
    with_scope(:find => { :order => 'name DESC' }) do
      find(:all)
    end
  end
end
