--
-- This query shows how many certificates were issued on a given day.
--
SELECT 
    DATE(c.notBefore) AS periodEnding, COUNT(1) AS numIssued, COUNT(1)/(24*60) as issuedPerMinute
FROM
    `ctdb`.le_certificate AS c
WHERE
    c.notBefore > DATE_SUB(NOW(), INTERVAL 180 DAY)
GROUP BY DATE(c.notBefore)
ORDER BY DATE(c.notBefore) ASC;