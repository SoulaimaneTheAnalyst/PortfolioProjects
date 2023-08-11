--I- Ride Analysis


----What is the average trip distance traveled by passengers? 

SELECT 
  AVG(trip_distance) AS average_distance 
FROM 
  yellow_tripdata

----What is the average fare amount for rides paid with credit cards versus cash? 

SELECT 
  AVG (fare_amount) AS avergae_fare_amount_credit_card 
FROM 
  yellow_tripdata 
WHERE 
  payment_type = 1 

SELECT 
  AVG (fare_amount) AS avergae_fare_amount_cash 
FROM 
  yellow_tripdata 
WHERE 
  payment_type = 2

----Which vendor (TPEP provider) has the highest number of trips in the dataset? 

SELECT 
  TOP 1 VendorID, 
  COUNT(VendorID) AS top_number_trips_vendor 
FROM 
  yellow_tripdata 
group by 
  VendorID 
order by 
  top_number_trips_vendor

----How many trips were store-and-forward trips versus real-time trips?

SELECT 
  COUNT(store_and_fwd_flag) AS trip_count_store_and_fwd 
FROM 
  yellow_tripdata 
WHERE 
  store_and_fwd_flag = 'Y'

SELECT 
  COUNT(store_and_fwd_flag) AS trip_count_real_time 
FROM 
  yellow_tripdata 
WHERE 
  store_and_fwd_flag = 'N'


--II- Temporal Analysis


----What are the top 5 busiest hours of the day in terms of taxi pickups?

SELECT 
  TOP 5 DATEPART(HOUR, tpep_pickup_datetime) AS hour_of_day,
  COUNT(*) AS event_count 
FROM 
  yellow_tripdata 
GROUP BY 
  DATEPART(HOUR, tpep_pickup_datetime) 
ORDER BY 
  event_count DESC;

----Is there a correlation between the day of the week and the total fare amount earned?

SELECT 
  DATENAME(WEEKDAY, tpep_pickup_datetime) AS day_of_week, 
  SUM(fare_amount) AS total_fare_amount 
FROM 
  yellow_tripdata 
GROUP BY 
  DATENAME(WEEKDAY, tpep_pickup_datetime) 
ORDER BY 
  total_fare_amount DESC

	
----What is the average trip duration for rides originating from JFK Airport?
		
SELECT 
  AVG(
    DATEDIFF(
      MINUTE, tpep_pickup_datetime, tpep_dropoff_datetime
    )
  ) AS Average_duration_JFK_airport 
FROM 
  yellow_tripdata 
WHERE 
  RatecodeID = 2

----Are there any seasonal patterns in the number of passengers in January?

SELECT 
  DISTINCT CONVERT(DATE, tpep_pickup_datetime) AS day_of_week, 
  SUM(passenger_count) AS total_passengers 
FROM 
  yellow_tripdata 
WHERE 
  tpep_pickup_datetime LIKE '2023%' 
  AND tpep_pickup_datetime NOT LIKE '2023-02%' 
GROUP BY 
  CONVERT(DATE, tpep_pickup_datetime) 
ORDER BY 
  total_passengers DESC


--III-Geospatial Analysis:	


----Which TLC Taxi Zone had the highest number of drop-offs in the dataset?

SELECT 
  TOP 1 DOLocationID, 
  COUNT(DOLocationID) AS top_number_trips_vendor 
FROM 
  yellow_tripdata 
GROUP BY 
  DOLocationID 
ORDER BY 
  top_number_trips_vendor DESC

----What are the top 5 TLC Taxi Zones for pick-ups during rush hours?

SELECT 
  TOP 5 PULocationID, 
  COUNT(PULocationID) AS total_pickups 
FROM 
  yellow_tripdata 
WHERE 
  tpep_pickup_datetime LIKE '%T07%' 
  OR tpep_pickup_datetime LIKE '%T08%' 
  OR tpep_pickup_datetime LIKE '%T09%' 
  OR tpep_pickup_datetime LIKE '%T16%' 
  OR tpep_pickup_datetime LIKE '%T17%' 
  OR tpep_pickup_datetime LIKE '%T18%' 
  OR tpep_pickup_datetime LIKE '%T19%' 
GROUP BY 
  PULocationID 
ORDER BY 
  total_pickups DESC

----How many trips had drop-offs at LaGuardia and JFK Airports, respectively?

SELECT 
  COUNT(airport_fee) AS number_DO_JFK 
FROM 
  yellow_tripdata 
WHERE 
  airport_fee = 1.25 
  AND passenger_count > 0


--IV-Payment Analysis:


----What is the percentage breakdown of different payment types (credit card, cash, etc.) for all trips?
		
--1-Credit Card:

SELECT 
  (
    COUNT(CASE WHEN payment_type = 1 THEN 1 END) * 100 / COUNT(payment_type)
  ) AS percentage_credit_card 
FROM 
  yellow_tripdata;		

--2-Cash: 

SELECT 
  (
    COUNT(CASE WHEN payment_type = 2 THEN 2 END) * 100 / COUNT(payment_type)
  ) AS percentage_cash 
FROM 
  yellow_tripdata		

--3-No charge:

SELECT 
  (
    COUNT(CASE WHEN payment_type = 3 THEN 3 END) * 100 / COUNT(payment_type)
  ) AS percentage_no_charge 
FROM 
  yellow_tripdata		

--4-Dispute:

SELECT 
  (
    COUNT(CASE WHEN payment_type = 4 THEN 4 END) * 100 / COUNT(payment_type)
  ) AS percentage_dispute 
FROM 
  yellow_tripdata		

--5-Unknown:

SELECT 
  (
    COUNT(CASE WHEN payment_type = 5 THEN 5 END) * 100 / COUNT(payment_type)
  ) AS percentage_unknown 
FROM 
  yellow_tripdata		

--6-Voided trip

SELECT 
  (
    COUNT(CASE WHEN payment_type = 6 THEN 6 END) * 100 / COUNT(payment_type)
  ) AS percentage_voided_trip 
FROM 
  yellow_tripdata


----Are there any differences in tip amounts for credit card payments versus cash payments?
		
SELECT 
  SUM(tip_amount) AS total_tip_credit_card 
FROM 
  yellow_tripdata 
WHERE 
  payment_type = 1		

SELECT 
  SUM(tip_amount) AS total_tip_cash 
FROM 
  yellow_tripdata 
WHERE 
  payment_type = 2

----How many trips resulted in disputes or voided trips?

SELECT 
  COUNT(payment_type) AS count_voided_dispute_trips 
FROM 
  yellow_tripdata 
WHERE 
  payment_type = 4 
  OR payment_type = 6


--V-Rate Code and Surcharge Analysis:


----Which rate code is most commonly used by passengers?

SELECT 
  TOP 1 RatecodeID, 
  COUNT (RatecodeID) AS count_used_ratecode 
FROM 
  yellow_tripdata 
GROUP BY 
  RatecodeID 
ORDER BY 
  count_used_ratecode DESC
	
----What is the average total amount collected for trips with a negotiated fare rate code?

SELECT 
  AVG(total_amount) AS avg_amount_negotiated_fare 
FROM 
  yellow_tripdata 
WHERE 
  RatecodeID = 5

----How much revenue was generated from the congestion surcharge in January?
		
SELECT 
  SUM(congestion_surcharge) AS total_revenue_surcharge_congestion 
FROM 
  yellow_tripdata


--VI- Passenger Count Analysis:


----What is the distribution of passenger counts per trip?

SELECT 
  passenger_count, 
  COUNT(passenger_count) AS total_trips 
FROM 
  yellow_tripdata 
WHERE 
  passenger_count > 0 
GROUP BY 
  passenger_count 
ORDER BY 
  passenger_count ASC

----Are there any correlations between the number of passengers and trip distance?
		
SELECT 
  DISTINCT(passenger_count) AS passenger_count, 
  SUM(trip_distance) AS total_distance 
FROM 
  yellow_tripdata 
WHERE 
  passenger_count > 0 
GROUP BY 
  passenger_count 
ORDER BY 
  total_distance DESC

----What is the average fare amount for trips with a specific number of passengers?

SELECT 
  DISTINCT(passenger_count) AS passenger_count, 
  AVG(fare_amount) AS avg_fare_amount 
FROM 
  yellow_tripdata 
WHERE 
  passenger_count > 0 
GROUP BY 
  passenger_count 
ORDER BY 
  avg_fare_amount DESC


--VII- Airport Analysis:


----How many trips originated from Newark Airport?

SELECT 
  COUNT(*) AS total_trips_newark_airport 
FROM 
  yellow_tripdata 
WHERE 
  RatecodeID = 3

----What is the average fare amount for trips with a pick-up at JFK Airport?

SELECT 
  AVG(fare_amount) AS avg_fare_amount_jfk 
FROM 
  yellow_tripdata 
WHERE 
  RatecodeID = 2

----Are there any differences in trip distances for JFK Airport pick-ups?

SELECT 
  TOP 10 trip_distance AS trip_distance_jfk 
FROM 
  yellow_tripdata 
WHERE 
  RatecodeID = 2 
GROUP BY 
  trip_distance 
ORDER BY 
  trip_distance_jfk DESC
