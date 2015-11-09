require File.expand_path("../../initializers/database_connection.rb", __FILE__)

INDIVIDUAL_EMAIL_RESULTS = <<-QUERY
create table if not exists salesforce_data.individual_email_results (
  contact_home_email text,
  individual_email_result_email_name text,
  tracking_as_of timestamp,
  contact_first_name text,
  contact_last_name text,
  subject_line text,
  opened integer,
  number_of_unique_clicks integer,
  time_opened timestamp,
  clicked integer,
  time_unsubscribed timestamp,
  hard_bounce integer,
  soft_bounce integer,
  time_bounced timestamp,
  time_sent timestamp
)

QUERY

ACUMEN.exec(INDIVIDUAL_EMAIL_RESULTS)
