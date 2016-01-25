SELECT 
    certificate.serial, GROUP_CONCAT(name.name, " ") as names, certificate.notBefore
FROM
    name
        JOIN
    certificate ON name.serial = certificate.serial
WHERE
    name LIKE '%allthatnet.com' AND notBefore >= DATE_SUB(NOW(), INTERVAL 7 DAY)
GROUP BY serial
ORDER BY notBefore ASC;