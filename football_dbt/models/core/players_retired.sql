{{ config(materialized='table') }}

with players_retired as (
    select  DISTINCT(player_name) as player_name,
            club_name as last_club,
            league_name as league,
            cast(year as integer) as year
    from {{ source('staging','transfers') }}
    where club_involved_name='Retired'
)

select *
from players_retired
