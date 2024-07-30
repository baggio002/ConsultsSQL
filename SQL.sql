
EXPORT DATA
  OPTIONS (
    format = 'trix',
    url_or_path = 'https://docs.google.com/spreadsheets/d/<id>',
    header = TRUE,
    worksheet = 'Consults',
    overwrite_worksheet = TRUE)
AS 
SELECT
      case_number,
      -- consults,
      -- count(consult_id) AS consult_count,
      consult_creator.ldap AS creator_ldap,
      consult_creator.metadata.support.team AS creator_team,
      case_owner.metadata.roster.shard AS creator_shard,
      consult_id,
      consult_number,
      consult_subject,
      consult_specialization,
      consult_contributor,
      consult_owner.ldap AS owner_ldap,
      is_helpful_consult_response,
      consult_helpfulness,
      consult_helpfulness_detail,
      is_nonpreventable_consult,
      preventative_action,
      preventative_action_detail,
      consult_channel,
      consult_type,
      consult_status,
      TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), c.created.timestamp,  HOUR) AS consult_age,
      CONCAT(FORMAT_TIMESTAMP("%F", c.created.timestamp, "EST"), " ", FORMAT_TIMESTAMP("%T", c.created.timestamp, "EST")) AS consult_created_timestamp,
      -- CAST(c.created.timestamp AS String) AS consult_created_timestamp,
      CONCAT(FORMAT_TIMESTAMP("%F", c.closed.timestamp, "EST"), " ", FORMAT_TIMESTAMP("%T", c.closed.timestamp, "EST")) AS consult_closed_timestamp
      -- CAST(c.closed.timestamp AS String) AS consult_closed_timestamp,
    FROM <case database> AS t, UNNEST(<consult nest data>) AS c WHERE 
        --(business_line = 'GCP Tech Non-Premium' OR business_line = 'GCP Tech Premium') AND consult_status = 'Closed' AND 
        consult_owner.metadata.support.team = '<site name>' --AND case_owner.metadata.roster.shard = 'Data'
