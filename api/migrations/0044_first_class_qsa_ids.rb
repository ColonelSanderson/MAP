Sequel.migration do

  up do
    alter_table(:file_issue) do
      add_column(:qsa_id, Integer, :null => true)
    end

    alter_table(:transfer) do
      add_column(:qsa_id, Integer, :null => true)
    end

  end

end
