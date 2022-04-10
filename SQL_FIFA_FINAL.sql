-- Selecting all entries from the Fifa 22 table
select *
from dbo.players_22

-- Ranking players by their wage over 80,000 euros a week and by their individual club
select short_name, wage_eur, club_name,
DENSE_RANK() OVER(PARTITION BY club_name ORDER BY wage_eur DESC) as rnk
FROM dbo.players_22
GROUP BY wage_eur, short_name, club_name
HAVING wage_eur >80000

-- Ranking players by their wage over 80,000 euros a week, where their club is Manchester City 
SELECT short_name, wage_eur, club_name,
DENSE_RANK() OVER(PARTITION BY club_name ORDER BY wage_eur DESC) as rnk
FROM dbo.players_22
WHERE club_name = 'Manchester City'
GROUP BY wage_eur, short_name, club_name
HAVING wage_eur >80000

-- Using a CTE to create a list of 'Manchester City's' high earners
WITH Manchester_City_High_Earners
AS
(
SELECT short_name, wage_eur, club_name,
DENSE_RANK() OVER(PARTITION BY club_name ORDER BY wage_eur DESC) as rnk
FROM dbo.players_22
WHERE club_name = 'Manchester City'
GROUP BY wage_eur, short_name, club_name
HAVING wage_eur >80000
)
SELECT short_name as High_Earners
FROM Manchester_City_High_Earners

-- Selecting the second highest release clause 
SELECT MAX(release_clause_eur) as SecondHighestReleaseClause 
FROM dbo.players_22
WHERE release_clause_eur NOT IN (SELECT MAX(release_clause_eur) FROM dbo.players_22);

-- Selecting the player with the second highest release 
SELECT TOP 1 short_name, MAX(release_clause_eur) as SecondHighestRC
FROM dbo.players_22
WHERE short_name IS NOT NULL AND release_clause_eur NOT IN (SELECT MAX(release_clause_eur) FROM dbo.players_22)
GROUP BY release_clause_eur, short_name
ORDER BY release_clause_eur DESC

-- finding the top 10 players with the highest release clauses 
SELECT TOP 10 short_name, release_clause_eur
FROM dbo.players_22
ORDER BY release_clause_eur DESC

-- retrieving total number of duplicate entries in short_name
SELECT short_name
FROM dbo.players_22
GROUP BY short_name
HAVING COUNT(*) >1;

-- retrieving the teams with the highest overall squad potential
SELECT club_name, AVG(potential) as avg_pot
FROM dbo.players_22
GROUP BY club_name
ORDER BY avg_pot DESC;

-- selecting team names ending in 'United'
SELECT DISTINCT club_name
FROM dbo.players_22
WHERE club_name LIKE '%United'

-- selecting team names ending in 'City'
SELECT DISTINCT club_name
FROM dbo.players_22
WHERE club_name LIKE '%City'

-- retrieving the fastest English player from the Premier League 
Select TOP 1 short_name, pace, nationality_name, league_name 
FROM dbo.players_22
WHERE pace >85 AND nationality_name = 'England' AND league_name = 'English Premier League'
ORDER BY pace DESC

-- retrieving all entries from the female players table
SELECT *
FROM dbo.female_players_22

-- using a Union to join all entries from the female table onto the mens table
SELECT *
FROM dbo.players_22
UNION
SELECT *
FROM dbo.female_players_22

-- retrieving all entries for male and female players above 88
(SELECT *
FROM dbo.players_22
WHERE overall >88
UNION
SELECT *
FROM dbo.female_players_22
WHERE overall >88)
ORDER BY overall DESC

-- turning the union into a cte to retrieve a list of best womens and mens English players in order
WITH Best_English_Players
AS
(SELECT *
FROM dbo.players_22
WHERE nationality_name ='England'
UNION
SELECT *
FROM dbo.female_players_22
WHERE nationality_name ='England')
SELECT long_name as Name, overall as The_Best
FROM Best_English_Players
ORDER BY overall DESC