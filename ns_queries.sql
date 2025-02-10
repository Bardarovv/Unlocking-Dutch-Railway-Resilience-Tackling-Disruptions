select * from `ns 2022` ;

select  count(rdt_id) FROM `ns 2022`;

-- 5.1 SQL Query for Identifying Main causes for disruption --
SELECT 
    cause_group, 
    COUNT(*) AS total_disruptions
FROM `ns 2022`
GROUP BY cause_group
ORDER BY total_disruptions DESC;

-- 5.2 SQL Query for Identifying Disruptions per weekday--
SELECT 
    DATE_FORMAT(STR_TO_DATE(start_time, '%d-%m-%y %H:%i'), '%W') AS weekday,
    COUNT(*) AS total_disruptions
FROM `ns 2022`
GROUP BY weekday
ORDER BY FIELD(weekday, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

-- 5.3 SQL Query for Identifying Number of Disruptions and Total duration of all disruptions – measured in hours.--
SELECT 
    DATE_FORMAT(STR_TO_DATE(start_time, '%d-%m-%y %H:%i'), '%M') AS month_name,  -- Get full month name (e.g., January, February)
    COUNT(*) AS total_disruptions,
    ROUND(SUM(duration_minutes) / 60) AS total_duration_hours  -- Convert duration to hours and round it
FROM `ns 2022`
WHERE STR_TO_DATE(start_time, '%d-%m-%y %H:%i') BETWEEN '2022-01-01' AND '2022-12-31'
GROUP BY month_name
ORDER BY FIELD(month_name, 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December');


-- 5.4 SQL Query for Identifying Top 10 lines with Disruptions and Total duration  --
SELECT 
    ns_lines,  
    COUNT(*) AS total_disruptions,  
    CONCAT(
        FLOOR(SUM(duration_minutes) / 1440), ' days ', 
        FLOOR(SUM(duration_minutes) % 1440/60), ' hours'
    ) AS total_duration  
FROM `ns 2022`
GROUP BY ns_lines 
ORDER BY total_disruptions DESC 
LIMIT 10;  



-- 5.5 	SQL Query for Identifying Top 10 lines disruption causes with avg. diration in hour and minutes--
SELECT 
    cause_en AS disruption_cause,  
    COUNT(*) AS total_disruptions,  
    CONCAT(
        FLOOR(AVG(duration_minutes) / 60), ' hour(s) ', 
        FLOOR(AVG(duration_minutes) % 60), ' minute(s)'
    ) AS avg_duration  -- Format the average duration as hours and minutess
FROM `ns 2022`
GROUP BY cause_en  
ORDER BY total_disruptions DESC 
LIMIT 10;  











SELECT 
    ROUND(COUNT(*) / DATEDIFF('2022-12-31', '2022-01-01')) AS avg_disruptions_per_day
FROM `ns 2022`
WHERE STR_TO_DATE(start_time, '%d-%m-%y %H:%i') BETWEEN '2022-01-01' AND '2022-12-31';


SELECT 
    ns_lines, 
    COUNT(*) AS total_disruptions
FROM `ns 2022`
GROUP BY ns_lines
ORDER BY total_disruptions DESC
LIMIT 10;
