-- 15 columns
WITH t AS (
    SELECT NPI,
        COLUMNS(
            c->c ILIKE 'Healthcare Provider Taxonomy Group\_%' ESCAPE '\'
        )
    FROM {{ref('raw_nppes')}}
),
taxonomies_raw AS (
    unpivot t ON COLUMNS(
        c->c ILIKE 'Healthcare Provider Taxonomy Group\_%' ESCAPE '\'
    ) INTO name "Healthcare Provider Taxonomy Group Index" value "Healthcare Provider Taxonomy Group"
),
taxonomies AS (
    SELECT NPI,
        "Healthcare Provider Taxonomy Group"
    FROM taxonomies_raw
    WHERE "Healthcare Provider Taxonomy Group" != ''
)
SELECT NPI,
    list("Healthcare Provider Taxonomy Group") AS "Healthcare Provider Taxonomy Group List"
FROM taxonomies
GROUP BY NPI