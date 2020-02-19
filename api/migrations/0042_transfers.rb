Sequel.migration do

  up do
    alter_table(:transfer) do
      set_column_allow_null(:status)
      add_column(:description, String, :null => true)
      add_column(:previous_identifiers, String, :null => true)
      add_column(:date_completed, String, :null => true)
      add_column(:remarks, :text, :null => true)
      add_column(:checklist_transfer_cancelled, Integer, :default => 0)
    end
  end

end
