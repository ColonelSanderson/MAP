ConversationMessage = Struct.new(:message, :author, :timestamp) do

  def self.from_row(row)
    new(row[:message],
        row[:created_by],
        row[:create_time])
  end

  def to_json(*args)
    to_h.to_json
  end
end