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
        `ctdb`.name AS n
	JOIN `ctdb`.le_certificate AS c ON n.certID = c.certID
    WHERE
		c.notAfter > NOW()
    GROUP BY n.name
    ORDER BY numIssued DESC) as nd
GROUP BY nd.numIssued;