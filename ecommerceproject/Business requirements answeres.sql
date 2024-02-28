--a.When is the peak season of our ecommerce?
SELECT DATEPART(YEAR, order_date) AS OrderYear,DATEPART(MONTH, order_date) AS OrderMonth,
    COUNT(*) AS TotalOrders
FROM OrdersDim
GROUP BY
    DATEPART(YEAR, order_date),
    DATEPART(MONTH, order_date)
ORDER BY TotalOrders DESC

SELECT TOP 1
    DATEPART(YEAR, order_date) AS OrderYear,
    DATEPART(MONTH, order_date) AS OrderMonth,
    COUNT(*) AS TotalOrders
FROM OrdersDim
GROUP BY
    DATEPART(YEAR, order_date),
    DATEPART(MONTH, order_date)
ORDER BY TotalOrders DESC

--b.What time users are most likely make an order or using the ecommerce app?
SELECT
    FORMAT(order_date, 'hh tt') AS FormattedOrderHour,COUNT(*) AS TotalOrders
FROM OrdersDim
GROUP BY FORMAT(order_date, 'hh tt')
ORDER BY TotalOrders DESC

SELECT TOP 1
    FORMAT(order_date, 'hh tt') AS Order_Hour,
    COUNT(*) AS TotalOrders
FROM OrdersDim
GROUP BY FORMAT(order_date, 'hh tt')
ORDER BY TotalOrders DESC

--c.What is the preferred way to pay in the ecommerce?
SELECT payment_type, COUNT(*) AS TotalTransactions
FROM PaymentDim
GROUP BY payment_type
ORDER BY TotalTransactions DESC

SELECT TOP 1 payment_type, COUNT(*) AS TotalTransactions
FROM PaymentDim
GROUP BY payment_type
ORDER BY TotalTransactions DESC

--d.How many installment is usually done when paying in the ecommerce?
SELECT
    payment_installments,
    COUNT(*) AS InstallmentCountFrequency
FROM
    PaymentDim
WHERE
    payment_installments IS NOT NULL
GROUP BY
    payment_installments
ORDER BY
    InstallmentCountFrequency DESC;
--e.What is the average spending time for user for our ecommerce?
SELECT
    customer_id,
    AVG(DATEDIFF(HOUR, order_date, delivered_date)) AS AverageSpendingTimeHours
FROM
    OrdersDim
WHERE
    delivered_date IS NOT NULL  
GROUP BY
    customer_id

--f.what is the frequency of purchase on each state?
SELECT payment_type,COUNT(*) AS PurchaseCountFrequency,customer_state
FROM PaymentDim
JOIN ItemsFact ON PaymentDim.order_id=ItemsFact.order_id
JOIN CustomerDim ON ItemsFact.customer_id=CustomerDim.customer_id
GROUP BY payment_type,customer_state

--g. which logistic route that have heavy traffic in our ecommrece?
SELECT SellerDim.seller_city,CustomerDim.customer_city,COUNT(*) AS OrderCount,
    SUM(ItemsFact.shipping_cost) AS TotalShippingCost,
	ABS(DATEPART(DAY, delivered_date) - DATEPART(DAY, pickup_date)) AS DifferenceBetweenDeliveryAndPickup
FROM ItemsFact
JOIN OrdersDim ON ItemsFact.order_id = OrdersDim.order_id
JOIN SellerDim ON ItemsFact.seller_id = SellerDim.seller_id
JOIN CustomerDim ON OrdersDim.customer_id = CustomerDim.customer_id
WHERE OrdersDim.order_status = 'Delivered'
GROUP BY SellerDim.seller_city, CustomerDim.customer_city
ORDER BY OrderCount DESC

--h How many late delivered order in our ecommerce? Are late order affecting the customer satisfaction?
SELECT COUNT(*) AS LateDeliveredOrders
FROM OrdersDim
WHERE delivered_date > estimated_time_delivery;

SELECT
    CASE
        WHEN delivered_date > estimated_time_delivery THEN 'Late'
        ELSE 'On-time'
    END AS DeliveryStatus,
    AVG(feedback_score) AS AverageSatisfactionScore,
    COUNT(*) AS TotalOrders
FROM
    OrdersDim
JOIN
    FeedbackDim ON OrdersDim.order_id = FeedbackDim.order_id
GROUP BY
    CASE
        WHEN delivered_date > estimated_time_delivery THEN 'Late'
        ELSE 'On-time'
    END

--How long are the delay for delivery / shipping process in each state?
SELECT
    customer_state,
    AVG(DATEDIFF(DAY, estimated_time_delivery, delivered_date)) AS AverageDelay
FROM
    OrdersDim
JOIN
    CustomerDim ON OrdersDim.customer_id = CustomerDim.customer_id
WHERE
    delivered_date IS NOT NULL
    AND estimated_time_delivery IS NOT NULL
GROUP BY
    customer_state;

--j. How long are the difference between estimated delivery time and actual delivery time in each state?
SELECT
    customer_state,
    AVG(DATEDIFF(DAY, estimated_time_delivery, delivered_date)) AS AverageDifference
FROM
    OrdersDim
JOIN
    CustomerDim ON OrdersDim.customer_id = CustomerDim.customer_id
WHERE
    delivered_date IS NOT NULL
    AND estimated_time_delivery IS NOT NULL
GROUP BY
    customer_state;


