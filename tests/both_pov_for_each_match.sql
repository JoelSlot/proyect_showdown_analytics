SELECT 
    BATTLE_ID,
    COUNT(DISTINCT pov) AS NUM_POV
FROM {{source('showdown_data', 'match_data')}}
GROUP BY BATTLE_ID
HAVING NUM_POV != 2