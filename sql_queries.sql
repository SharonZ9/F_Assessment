-- 1.
-- top_5_brands_current_month.sql
-- What are the top 5 brands by receipts scanned for the most recent month?
WITH RecentMonth AS (
    SELECT 
        DATE_FORMAT(MAX(r.CreateDate), '%Y-%m') AS most_recent_month
    FROM Receipts r
)
SELECT 
    b.Name AS BrandName,
    COUNT(DISTINCT r.ReceiptID) AS ReceiptCount
FROM Receipts r
JOIN ReceiptItems ri ON r.ReceiptID = ri.ReceiptID
JOIN Brands b ON ri.Barcode = b.Barcode
WHERE DATE_FORMAT(r.CreateDate, '%Y-%m') = (SELECT most_recent_month FROM RecentMonth)
GROUP BY b.Name
ORDER BY ReceiptCount DESC
LIMIT 5;

-- 2.
-- top_brand_transactions_recent_users.sql
-- Which brand has the most transactions among users who were created within the past 6 months?
WITH RecentUsers AS (
    SELECT 
        UserID
    FROM Users
    WHERE CreatedDate >= CURDATE() - INTERVAL 6 MONTH
)
SELECT 
    b.Name AS BrandName,
    COUNT(DISTINCT r.ReceiptID) AS TransactionCount
FROM Receipts r
JOIN ReceiptItems ri ON r.ReceiptID = ri.ReceiptID
JOIN Brands b ON ri.Barcode = b.Barcode
WHERE r.UserID IN (SELECT UserID FROM RecentUsers)
GROUP BY b.Name
ORDER BY TransactionCount DESC
LIMIT 1;

-- 3.
-- total_items_by_status.sql
-- When considering the total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected,’ which is greater?
SELECT 
    r.RewardsReceiptStatus,
    SUM(ri.QuantityPurchased) AS TotalItemsPurchased
FROM Receipts r
JOIN ReceiptItems ri ON r.ReceiptID = ri.ReceiptID
WHERE r.RewardsReceiptStatus IN ('Accepted', 'Rejected')
GROUP BY r.RewardsReceiptStatus
ORDER BY TotalItemsPurchased DESC;