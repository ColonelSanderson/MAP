Sequel.migration do

  up do
    alter_table(:file_issue) do
      add_column(:completed_date, String, :null => true)
      add_column(:remarks, :text, :null => true)
    end

  end

end
