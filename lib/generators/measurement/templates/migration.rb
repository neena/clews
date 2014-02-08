class Create<%= name %>Measurements < ActiveRecord::Migration
  def change
    create_table :<%= name.underscore + "_measurements" %> do |t|
      t.belongs_to :observation
      <%- if options[:numeric] -%>
      t.float :value
      <%- else -%>
      t.string :value
      <%- end -%>
      t.datetime :recorded_at
      t.timestamps
    end
  end
end
