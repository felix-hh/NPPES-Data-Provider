-- 200 columns
WITH npi_concise as (
    select
        npi,
        COLUMNS(c -> c ilike 'Other Provider Identifier\_%' escape '\'), 
        COLUMNS(c -> c ilike 'Other Provider Identifier Type Code\_%' escape '\' ) ,
        COLUMNS(c -> c ilike 'Other Provider Identifier State\_%' escape '\' ),
        COLUMNS(c -> c ilike 'Other Provider Identifier Issuer\_%' escape '\' ) 
            from {{ref('raw_nppes')}}
            -- from raw_nppes
            ),

stacked as (
from npi_concise unpivot (
    (identifier, type_code, state_code, issuer) 
    for idx in (
        {{ generate_column_quartets('Other Provider Identifier_', 'Other Provider Identifier Type Code_', 'Other Provider Identifier State_', 'Other Provider Identifier Issuer_', 50) }}
        -- Macros save the day.
    )
    )
)

select 
    NPI,
    list({"Other Provider Identifier": identifier, "Other Provider Identifier Type Code": type_code, "Other Provider Identifier State": state_code, "Other Provider Identifier Issuer": issuer}) as "Other Provider Identifier List"
    from stacked
    where identifier != ''
    group by NPI



-- Note: not all license numbers are valid. to check run:
-- with t as (select NPI as c, list(row(nu, co)) from stg_nppes_provider_license_number_list where nu != '' group by NPI order by c) select count(#2) as c, #2 from t group by #2 order by c;