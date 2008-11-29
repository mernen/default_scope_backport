ActiveRecord::Schema.define(:version => 0) do
  create_table :developers, :force => true do |t|
    t.string   :name
    t.integer  :salary, :default => 70000
    t.datetime :created_at
    t.datetime :updated_at
  end
end
