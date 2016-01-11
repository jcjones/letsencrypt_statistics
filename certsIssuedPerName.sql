--
-- This query determines the distribution of how often a given DNS Name 
-- appears in certificates. Many names are reissued over and over.
--
SELECT 
    nd.numIssued, count(1) as 'count'
FROM
    (SELECT 
        n.name, COUNT(1) AS numIssued
    FROM
        `ct`.name AS n
	JOIN `ct`.certificate AS c ON n.issuer = c.issuer
        AND n.serial = c.serial
    WHERE
		c.notAfter > NOW()
    GROUP BY n.name
    ORDER BY numIssued DESC) as nd
GROUP BY nd.numIssued;