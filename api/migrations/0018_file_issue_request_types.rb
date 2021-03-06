Sequel.migration do
  up do

    # Request types are no longer codified, so change them to their
    # corresponding AppConfig[:file_issue_request_types] entry
    self[:file_issue_request]
      .filter(:request_type => 'NATIONAL_REDRESS_SCHEME')
      .update(:request_type => 'National Redress Scheme',
              :system_mtime => Time.now)
    self[:file_issue_request]
      .filter(:request_type => 'RIGHT_TO_INFORMATION')
      .update(:request_type => 'Right to Information',
              :system_mtime => Time.now)

    self[:file_issue]
      .filter(:request_type => 'NATIONAL_REDRESS_SCHEME')
      .update(:request_type => 'National Redress Scheme',
              :system_mtime => Time.now)
    self[:file_issue]
      .filter(:request_type => 'RIGHT_TO_INFORMATION')
      .update(:request_type => 'Right to Information',
              :system_mtime => Time.now)

  end
end
