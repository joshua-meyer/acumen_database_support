require File.expand_path("../../initializers/database_connection.rb", __FILE__)

COURSE_DATA_UNIVERSE = <<-QUERY

create table if not exists salesforce_data.course_data_universe (
  full_name text,
  home_email text,
  reg_age_group text,
  num_discussions_started integer,
  num_peer_reviews_received integer,
  num_peer_reviews_submitted integer,
  num_replies integer,
  post_apply_learned text,
  post_would_change text,
  post_nps_explanation text,
  post_most_informative text,
  post_likely_recommend integer,
  post_course_survey_completion_date date,
  mid_nps_explanation text,
  mid_likely_recommend integer,
  mid_course_survey_completion_date date,
  pre_why_sign_up text,
  pre_rate_familiarity text,
  pre_name_of_business text,
  pre_know_course_partner boolean,
  pre_know_acumen_before boolean,
  pre_how_much_work text,
  pre_highest_degree text,
  pre_course_survey_completion_date date,
  pre_course_in_team text,
  other_course_level_unsubscribe_reason text,
  course_level_unsubscribe_reason text,
  course_level_unsubscribe text,
  course_level_unsubscribe_date date,
  reg_internet_connection text,
  reg_employment_status text,
  age_group text,
  reg_current_sector text,
  course_registration_completion_date date,
  contact_id text,
  welcome_email_datetime timestamp,
  completed_module_1 integer,
  completed_module_2 integer,
  completed_module_3 integer,
  completed_module_4 integer,
  completed_module_5 integer,
  completed_module_6 integer,
  completed_the_course integer,
  course_session text,
  course_signup_name text
)

QUERY

ACUMEN.exec(COURSE_DATA_UNIVERSE)
