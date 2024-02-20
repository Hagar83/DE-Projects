--what was the cheapest most avaliable listing in Jan 2024? (the cheapest listing which was avaliable the most of the month)

WITH AvailableListings AS (
    SELECT lf.id AS listing_id, lf.name,
        COUNT(*) AS available_days
    FROM listingsFact lf
    JOIN CalendarDIM cd ON lf.id = cd.listing_id
    JOIN DateDim dd ON cd.date = dd.date
    WHERE dd.Year = 2024 AND dd.Month = 1 AND cd.available = 'true' 
    GROUP BY lf.id,lf.name
),
CheapestListing AS (
    SELECT TOP 1
        lf.id AS listing_id,MIN(cd.price) AS min_price
    FROM listingsFact lf
    JOIN CalendarDIM cd ON lf.id = cd.listing_id
    JOIN DateDim dd ON cd.date = dd.date
    WHERE dd.Year = 2024 AND dd.Month = 1
    GROUP BY lf.id
)
SELECT cl.listing_id, al.name,cl.min_price AS cheapest_min_price,
    al.available_days
FROM CheapestListing cl
JOIN AvailableListings al ON cl.listing_id = al.listing_id
ORDER BY cl.min_price DESC;


--what are the most reviewed listings in November 2023 ?
WITH NovemberReviews AS (
    SELECT listing_id,SUM(number_of_reviews) AS total_reviews
    FROM reviewsDim
    WHERE YEAR(date) = 2023 AND MONTH(date) = 11
    GROUP BY listing_id
)
SELECT TOP 10
    lf.name AS listing_name, nr.total_reviews
FROM NovemberReviews nr
JOIN listingsFact lf ON nr.listing_id = lf.id
ORDER BY nr.total_reviews DESC;

--what is the most expensive neighbourhood in Barcelona ?

SELECT TOP 1
    neighbourhood,MAX(price) AS max_price
FROM listingsFACT AS lf
JOIN neighbourhood AS nd ON lf.neighbourhood_group=nd.neighbourhood_group
GROUP BY neighbourhood
ORDER BY max_price DESC

--Recommend me a listing if I am :
--A man with his wife and 2 children looking for a week vacation around March 2024.

SELECT TOP 1
    id,name,neighbourhood,
    room_type,price,
    availability_365
FROM listingsFACT AS lf
JOIN neighbourhood AS nd ON lf.neighbourhood_group=nd.neighbourhood_group
WHERE minimum_nights <= 7
    AND room_type IN ('Entire home/apt', 'Private room')
    AND availability_365 >= 7
    AND date >= '2024-03-01' AND date < '2024-04-01'
	ORDER BY  price ASC 

--Recommend me a listing if I am :
--A colleage student with 4 other students who don't have alot of money and want to spend the new year's eve in Barcelona with perhaps two days before and/or two days after.

SELECT TOP 1
    id,name,neighbourhood,room_type,
    price,availability_365
FROM listingsFACT AS lf
JOIN neighbourhood AS nd ON lf.neighbourhood_group=nd.neighbourhood_group
WHERE room_type IN ('Entire home/apt', 'Private room') 
    AND price <= (SELECT MAX(price) FROM listingsFACT) 
    AND date >= '2023-12-28' AND date <= '2024-01-02' 
ORDER BY price ASC;