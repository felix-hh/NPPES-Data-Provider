-- 60 columns
WITH npi_concise as (
    select
        npi,
        COLUMNS(
            c -> c ilike 'Healthcare Provider Taxonomy Code\_%' escape '\'), 
            COLUMNS(c -> c ilike 'Provider License Number\_%' escape '\' ) ,
            COLUMNS(c -> c ilike 'Provider License Number State Code\_%' escape '\' ),
            COLUMNS(c -> c ilike 'Healthcare Provider Primary Taxonomy Switch\_%' escape '\' ) 
            from {{ref('raw_nppes')}}
            -- from raw_nppes
            ),

stacked as (
from npi_concise unpivot (
    (taxonomy_code, license_no, state_code, taxonomy_switch) 
    for idx in (
        {{ generate_column_quartets('Healthcare Provider Taxonomy Code_', 'Provider License Number_', 'Provider License Number State Code_', 'Healthcare Provider Primary Taxonomy Switch_', 15) }}
        -- Macros save the day.
    )
    )
)

select 
    NPI,
    list({"Healthcare Provider Taxonomy Code": taxonomy_code, "Provider License Number": license_no, "Provider License Number State Code": state_code, "Healthcare Provider Primary Taxonomy Switch": taxonomy_switch}) as "Healthcare Provider Taxonomy Code List"
    from stacked
    where taxonomy_code != ''
    group by NPI



-- Note: not all license numbers are valid. to check run:
-- with t as (select NPI as c, list(row(nu, co)) from stg_nppes_provider_license_number_list where nu != '' group by NPI order by c) select count(#2) as c, #2 from t group by #2 order by c;