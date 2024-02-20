USE [AirbnbDW]
GO

-- Drop the existing DateDIM table if it already exists
IF OBJECT_ID('dbo.DateDIM', 'U') IS NOT NULL
    DROP TABLE dbo.DateDIM
GO

-- Recreate the DateDIM table with modifications
CREATE TABLE [dbo].[DateDIM](
    [date] [datetime] NOT NULL,
    [Year] [int] NULL,
    [Month] [int] NULL,
    [Day] [int] NULL,
    [Quarter] [int] NULL,
    CONSTRAINT [PK_DateDIM] PRIMARY KEY CLUSTERED 
    (
        [date] ASC
    ) WITH (
        PAD_INDEX = OFF, 
        STATISTICS_NORECOMPUTE = OFF, 
        IGNORE_DUP_KEY = OFF, 
        ALLOW_ROW_LOCKS = ON, 
        ALLOW_PAGE_LOCKS = ON
    ) ON [PRIMARY]
) ON [PRIMARY]



INSERT INTO [dbo].[DateDIM] ([date], [Year], [Month], [Day], [Quarter])
SELECT 
    DISTINCT [date],
    YEAR([date]) AS [Year],
    MONTH([date]) AS [Month],
    DAY([date]) AS [Day],
    DATEPART(QUARTER, [date]) AS [Quarter]
FROM 
    CalendarDIM
WHERE
    [date] NOT IN (SELECT [date] FROM DateDIM)
GO



