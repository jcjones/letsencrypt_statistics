--
-- This query shows how many certificates were issued on a given hour.
--
SELECT 
    DATE(c.notBefore) AS date,
    HOUR(c.notBefore) AS hour,
    COUNT(1) AS numIssued,
    COUNT(1) / (60) AS issuedPerMinute,
    COUNT(DISTINCT n.name) AS numNames,
    COUNT(DISTINCT n.name) / (60) as namesPerMinute
FROM
    certificate AS c
        JOIN
    name AS n ON n.certID = c.certID
WHERE
    c.notBefore > DATE_SUB(NOW(), INTERVAL 3 DAY)
GROUP BY DATE(c.notBefore) , HOUR(c.notBefore)
ORDER BY DATE(c.notBefore) DESC , HOUR(c.notBefore) DESC;