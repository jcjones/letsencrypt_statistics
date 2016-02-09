SELECT 
    COUNT(DISTINCT n.name) AS numNames,
    MAX(DATE(c.notBefore)) AS date,
    i.commonName AS issuer
FROM
    certificate AS c
        JOIN
    name AS n ON c.certID = n.certID
        JOIN
    issuer AS i ON i.issuerID = c.issuerID
WHERE
    c.notBefore > DATE_SUB(NOW(), INTERVAL 7 DAY)
GROUP BY DATE(c.notBefore) , i.commonName
LIMIT 10;

