SELECT
    MIN(c.notBefore) AS date,
    COUNT(1) AS numIssued,
    COUNT(1) / (60) AS issuedPerMinute
FROM
    le_certificate AS c
WHERE
    c.notBefore > DATE_SUB(NOW(), INTERVAL 4 DAY)
GROUP BY DAY(c.notBefore), HOUR(c.notBefore) DIV 6
ORDER BY date DESC;