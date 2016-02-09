--
-- This query determines the most often re-issued names, and
-- how often they are reissued
--
SELECT 
    nd.name,
    COUNT(1) AS ct,
    VAR_POP(c.notBefore) AS var,
    GROUP_CONCAT(c.notBefore
        SEPARATOR ', ')
FROM
    (SELECT 
        n.name, COUNT(1) AS numIssued
    FROM
        `ctdb`.name AS n
    JOIN `ctdb`.le_certificate AS c ON n.certID = c.certID
	WHERE
		c.notBefore > DATE_SUB(NOW(), INTERVAL 180 DAY)
    GROUP BY n.name
    ORDER BY numIssued DESC) AS nd
        JOIN
    `ctdb`.name AS n ON n.name = nd.name
        JOIN
    `ctdb`.le_certificate AS c ON n.certID = c.certID
WHERE
    nd.numIssued > 25
GROUP BY name
ORDER BY var ASC , ct DESC
;