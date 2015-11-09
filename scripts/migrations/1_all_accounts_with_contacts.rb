require File.expand_path("../../initializers/database_connection.rb", __FILE__)

ALL_ACCOUNTS_WITH_CONTACTS = <<-QUERY

create table if not exists salesforce_data.all_accounts_with_contacts (
  first_name text,
  last_name text,
  home_email text,
  account_id text,
  external_id text,
  last_modified_date date,
  account_name text,
  contact_id text
)

QUERY

ACUMEN.exec(ALL_ACCOUNTS_WITH_CONTACTS)
