-- The total number of crimes recorded
SELECT 
  DISTINCT(
    COUNT(CASE_NUMBER)
  ) AS NUMBER_OF_CRIMES 
FROM 
  ChicagoCrimeData


-- Community areas with per capita income (average per-person income for an area) less than 11000
SELECT 
  COMMUNITY_AREA_NAME, 
  PER_CAPITA_INCOME 
FROM 
  ChicagoCensusData 
WHERE 
  PER_CAPITA_INCOME < 11000


-- All case numbers for crimes involving minors?(children are not considered minors for the purposes of crime analysis)
SELECT 
  CASE_NUMBER 
FROM 
  ChicagoCrimeData 
WHERE 
  DESCRIPTION LIKE '%MINOR%'


-- All kidnapping crimes involving a child
SELECT 
  CASE_NUMBER 
FROM 
  ChicagoCrimeData 
WHERE 
  DESCRIPTION LIKE '%CHILD%' 
  AND PRIMARY_TYPE = 'KIDNAPPING'


-- Types of crimes recorded at schools
SELECT 
  DISTINCT(PRIMARY_TYPE), 
  LOCATION_DESCRIPTION 
FROM 
  ChicagoCrimeData 
WHERE 
  LOCATION_DESCRIPTION LIKE '%SCHOOL%'


-- The average safety score in Chicago public schools
SELECT 
  AVG(SAFETY_SCORE) AS AVERAGE_SAFETY_SCORE 
FROM 
  ChicagoPublicSchools


-- Top 5 community areas with highest % of households below poverty line (minimum level of income needed to secure the necessities of life)
SELECT 
  TOP(5) COMMUNITY_AREA_NAME, 
  PERCENT_HOUSEHOLDS_BELOW_POVERTY 
FROM 
  ChicagoCensusData 
ORDER BY 
  PERCENT_HOUSEHOLDS_BELOW_POVERTY DESC


-- The community area that is most crime prone
SELECT 
  TOP 1 COMMUNITY_AREA_NUMBER, 
  COUNT(COMMUNITY_AREA_NUMBER) AS CRIME_FREQUENCY 
FROM 
  ChicagoCrimeData 
GROUP BY 
  COMMUNITY_AREA_NUMBER 
ORDER BY 
  COUNT(COMMUNITY_AREA_NUMBER) DESC


-- The community area with the highest hardship index
SELECT 
  COMMUNITY_AREA_NAME, 
  HARDSHIP_INDEX 
FROM 
  ChicagoCensusData 
WHERE 
  HARDSHIP_INDEX = (
    SELECT 
      MAX(HARDSHIP_INDEX) 
    FROM 
      ChicagoCensusData
  )


-- The Community Area with the most crime
SELECT 
  COMMUNITY_AREA_NAME 
FROM 
  ChicagoCensusData 
WHERE 
  COMMUNITY_AREA_NUMBER = (
    SELECT 
      TOP 1 COMMUNITY_AREA_NUMBER 
    FROM 
      ChicagoCrimeData 
    GROUP BY 
      COMMUNITY_AREA_NUMBER 
    ORDER BY 
      COUNT(COMMUNITY_AREA_NUMBER) DESC
  )



