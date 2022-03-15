{{ config(materialized='table') }}

with transfersClub as (
    SELECT year, club_name, sum(fee_cleaned) as total
    FROM {{ source('staging','transfers') }}
    WHERE transfer_movement='in'
    group by year, club_name
    order by total desc
),
groupsByYear as (
    select *
    from (
        select tc.*, row_number() over (partition by year order by total desc) rn
        from transfersClub tc
    ) tc
    where rn=1
    order by year
)
select 
    year as year,
    club_name as club,
    CAST(total as decimal) as total,
from groupsByYear
