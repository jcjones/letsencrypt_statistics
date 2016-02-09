SELECT 
    c.serial, GROUP_CONCAT(n.name, " ") as names, c.notBefore
FROM
    name as n
        JOIN 
    le_certificate as c ON n.certID = c.certID
WHERE
    name LIKE '%bin.coffee' AND notBefore >= DATE_SUB(NOW(), INTERVAL 7 DAY)
GROUP BY serial
ORDER BY notBefore ASC;