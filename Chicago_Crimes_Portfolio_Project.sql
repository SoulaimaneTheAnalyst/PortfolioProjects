-- Problem 1: Find the total number of crimes recorded in the CRIME table.

SELECT DISTINCT(COUNT(CASE_NUMBER)) 
FROM ChicagoCrimeData (533 cases) 

-- Problem 2: List community areas with per capita income less than 11000.

SELECT COMMUNITY_AREA_NAME, PER_CAPITA_INCOME 
FROM ChicagoCensusData
WHERE PER_CAPITA_INCOME<11000 

-- Problem 3: List all case numbers for crimes involving minors?(children are not considered minors for the purposes of crime analysis)

SELECT CASE_NUMBER 
FROM ChicagoCrimeData 
WHERE DESCRIPTION LIKE '%MINOR%' 

-- Problem 4: List all kidnapping crimes involving a child?

SELECT CASE_NUMBER 
FROM ChicagoCrimeData 
WHERE DESCRIPTION LIKE '%CHILD%' AND PRIMARY_TYPE='KIDNAPPING' 

-- Problem 5: What kinds of crimes were recorded at schools?

SELECT DISTINCT(PRIMARY_TYPE), LOCATION_DESCRIPTION 
FROM ChicagoCrimeData 
WHERE LOCATION_DESCRIPTION LIKE '%SCHOOL%' 

-- Problem 6: what is the average safety score in chicago public schools?

SELECT AVG(SAFETY_SCORE) AS AVERAGE_SAFETY_SCORE 
FROM ChicagoPublicSchools 

-- Problem 7: List 5 community areas with highest % of households below poverty line

SELECT TOP(5) COMMUNITY_AREA_NAME, PERCENT_HOUSEHOLDS_BELOW_POVERTY 
FROM ChicagoCensusData 
ORDER BY PERCENT_HOUSEHOLDS_BELOW_POVERTY DESC 

-- Problem 8: Which community area is most crime prone?
  
SELECT TOP 1 COMMUNITY_AREA_NUMBER ,COUNT(COMMUNITY_AREA_NUMBER) AS CRIME_FREQUENCY 
FROM ChicagoCrimeData 
GROUP BY COMMUNITY_AREA_NUMBER 
ORDER BY COUNT(COMMUNITY_AREA_NUMBER) DESC 

-- Problem 9: Use a sub-query to find the name of the community area with highest hardship index

SELECT COMMUNITY_AREA_NAME, HARDSHIP_INDEX 
FROM ChicagoCensusData 
WHERE HARDSHIP_INDEX = (SELECT MAX(HARDSHIP_INDEX) FROM ChicagoCensusData) 

-- Problem 10: Use a sub-query to determine the Community Area Name with most number of crimes?

SELECT COMMUNITY_AREA_NAME 
FROM ChicagoCensusData 
WHERE COMMUNITY_AREA_NUMBER = (SELECT TOP 1 COMMUNITY_AREA_NUMBER FROM ChicagoCrimeData GROUP BY COMMUNITY_AREA_NUMBER ORDER BY COUNT(COMMUNITY_AREA_NUMBER) DESC) 
