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
        `ct`.name AS n
    JOIN `ct`.certificate AS c ON n.issuer = c.issuer
        AND n.serial = c.serial
	WHERE
		c.notBefore > DATE_SUB(NOW(), INTERVAL 180 DAY)
    GROUP BY n.name
    ORDER BY numIssued DESC) AS nd
        JOIN
    `ct`.name AS n ON n.name = nd.name
        JOIN
    `ct`.certificate AS c ON n.issuer = c.issuer
        AND n.serial = c.serial
WHERE
    nd.numIssued > 25
GROUP BY name
ORDER BY var ASC , ct DESC
;