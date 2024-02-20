--describe for listing table
EXEC sp_help 'listings';

-- Using system catalog views
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    TABLE_NAME = 'listings'

--describe for calendar table
EXEC sp_help 'calendar';

-- Using system catalog views
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    TABLE_NAME = 'calendar'

--describe for neighbourhoods table
EXEC sp_help 'neighbourhoods';

-- Using system catalog views
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    TABLE_NAME = 'neighbourhoods'

--describe for reviews table
EXEC sp_help 'reviews';

-- Using system catalog views
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    TABLE_NAME = 'reviews'

--checking for duplicates 
SELECT id, COUNT(*) AS duplicate_count
FROM dbo.listings
GROUP BY id
HAVING COUNT(*) > 1

SELECT  COUNT(*) AS duplicate_count
FROM dbo.reviews
HAVING COUNT(*) > 1

SELECT  COUNT(*) AS duplicate_count
FROM dbo.neighbourhoods
HAVING COUNT(*) > 1


SELECT  COUNT(*) AS duplicate_count
FROM dbo.calendar
HAVING COUNT(*) > 1

--checking  granularity for calendar table
SELECT DISTINCT count( date) AS Counts,date, listing_id
FROM calendar
GROUP BY listing_id,date;

--checking  granularity for listings table
SELECT DISTINCT count( name) AS Counts, id
FROM listings
GROUP BY id;


SELECT DISTINCT count( neighbourhood_group) AS Counts, neighbourhood
FROM neighbourhoods
GROUP BY neighbourhood;
