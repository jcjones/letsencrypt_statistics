--
-- This query shows how many certificates were issued on a given @hourPeriod for all CAs
--
SET @hourPeriod = 6;
SELECT
    MIN(c.notBefore) AS date,
    COUNT(1) AS numIssued,
    COUNT(1) / (60*@hourPeriod) AS issuedPerMinute,
    i.commonName as issuer
FROM
    certificate AS c
JOIN issuer as i ON c.issuerID = i.issuerID
WHERE
    c.notBefore > DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY i.commonName, DAY(c.notBefore), HOUR(c.notBefore) DIV @hourPeriod
ORDER BY date DESC;