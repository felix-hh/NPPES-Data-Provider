{{config(
    materialized = 'external',
    location = './data/outputs/nppes.zstd.parquet',
    format = 'parquet',
    options = { 'codec': 'zstd' }
)}}
SELECT r.*,
    op.* exclude NPI,
    tg.* exclude NPI,
    t.* exclude NPI,
    FROM {{ref('stg_nppes_root')}} AS r
    LEFT JOIN {{ref("stg_nppes_other_provider_identifier_list")}} op ON r.NPI == op.NPI
    LEFT JOIN {{ref("stg_nppes_taxonomy_group_list")}} tg ON r.NPI == tg.NPI
    LEFT JOIN {{ref("stg_nppes_taxonomy_list")}} t ON r.NPI == t.NPI