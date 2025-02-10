# Unlocking Dutch Railway Resilience: Tackling Disruptions

#	Problem Statement
Pervasive train disruptions at Nederlandse Spoorwegen (NS) - propelled by infrastructure decay, operational blind spots, and environmental volatility - cripple service reliability and erode commuter confidence. Trapped in crisis-driven mitigation, NS’s current strategies lack precision, neglecting systemic vulnerabilities and perpetuating delays and resource misallocation. This analysis dissects disruption data to expose root-cause hierarchies, quantify cascading operational fallout, and architect preemptive protocols, transforming fragmented responses into a resilience blueprint for operational excellence. 

# Objective
This analysis aims to:
-	Assess the frequency and duration of disruptions across different months, weekdays, and years.
-	Identify the predominant causes of disruptions and their associated durations.
-	Evaluate which train lines are most susceptible to disruptions.
-	Generate actionable insights and propose recommendations to reduce the frequency and severity of disruptions, thereby improving operational efficiency and customer satisfaction.
#	Data Overview
-	Data Source: NS disruption data for the year 2022.
-	Data Volume: The dataset contains 5484 disruption records for the year 2022.
-	Key Metrics:
rdt_id,  ns_lines, rdt_lines, rdt_lines_id, rdt_station_names, rdt_station_codes, cause_nl, cause_en, statistical_cause_nl, statistical_cause_en, cause_groupstart_time, end_time, duration_minutes.

# Methodology
This analysis was conducted using MySQL for data extraction and Power BI for visualization.
-	SQL Queries: Used to retrieve disruption records, categorize causes, and calculate key metrics such as the number of disruptions per day, month, and train line.
-	Power BI: Used to create visualizations, including trend analyses, disruption frequency charts, and breakdowns by cause and location.
#	SQL Queries
The following SQL queries were used to extract and aggregate data from the database:
##	SQL Query for Identifying Main causes for disruption:
```sql
SELECT 
    cause_group, 
    COUNT(*) AS total_disruptions
FROM `ns 2022`
GROUP BY cause_group
ORDER BY total_disruptions DESC; 
````
![image](https://github.com/user-attachments/assets/a6aa747c-4bef-48ef-a6ac-4b2b0461f06f)

##	SQL Query for Identifying Disruptions per weekday
 ```sql
SELECT 
    DATE_FORMAT(STR_TO_DATE(start_time, '%d-%m-%y %H:%i'), '%W') AS weekday,
    COUNT(*) AS total_disruptions
FROM `ns 2022`
GROUP BY weekday
ORDER BY FIELD(weekday, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');
````
![image](https://github.com/user-attachments/assets/1296f48b-ee1f-467d-acfd-7560cba9eb00)

##	SQL Query for Identifying Number of Disruptions and Total duration of all disruptions – measured in hours
 ```sql
SELECT 
    DATE_FORMAT(STR_TO_DATE(start_time, '%d-%m-%y %H:%i'), '%M') AS month_name,  -- Get full month name
    COUNT(*) AS total_disruptions,
    ROUND(SUM(duration_minutes) / 60) AS total_duration_hours  -- Convert duration to hours and round it
FROM `ns 2022`
WHERE STR_TO_DATE(start_time, '%d-%m-%y %H:%i') BETWEEN '2022-01-01' AND '2022-12-31'
GROUP BY month_name
ORDER BY FIELD(month_name, 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December');
````
![image](https://github.com/user-attachments/assets/a7c3c0ea-f765-4cb1-973d-4b25e4760a7c)

##	SQL Query for Identifying Top 10 lines with Disruptions and Total duration 
```sql
 SELECT 
    ns_lines,  
    COUNT(*) AS total_disruptions,  
    CONCAT(
        FLOOR(SUM(duration_minutes) / 1440), ' days ', -- 1 day = 1400 minutes
        FLOOR(SUM(duration_minutes) % 1440/60), ' hours'
    ) AS total_duration  
FROM `ns 2022`
GROUP BY ns_lines 
ORDER BY total_disruptions DESC 
LIMIT 10; 
 ````
![image](https://github.com/user-attachments/assets/59e70457-fbf9-4b5f-9398-63363ed5f381)

##	SQL Query for Identifying Top 10 lines disruption causes with avg. diration in hour and minutes
```sql
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
````
![image](https://github.com/user-attachments/assets/d6d45548-ee0f-4bc3-9e61-448b3dc1e50d)

#	Findings
Frequent Disruptions: Broken down trains were the most frequent cause, but generally had shorter disruptions.
Longer Disruptions: Infrastructure issues like damaged overhead wires and logistical limitations caused longer delays.
Weekly Disruption Trends: The start of the week sees more disruptions, possibly due to increased traffic or post-weekend maintenance.

 ![image](https://github.com/user-attachments/assets/a49e513f-7117-47ad-a6d7-78f143211cef)
 
Top Disrupted Lines: Rotterdam-Breda and  Amsterdam-Schiphol-Rotterdam had the most frequent disruptions, while Hengelo-Bielefeld had the longest disruption durations.

 ![image](https://github.com/user-attachments/assets/f9266824-d36e-4c24-a609-12464c413024)

Monthly Trends: The peak disruption month was May, with high disruption frequency and duration.

 ![image](https://github.com/user-attachments/assets/392f7dc1-c34c-4437-b03b-93372d3eb301)
#	 Recommendations
##	Enhance Predictive Maintenance & Early Disruption Detection
Improving predictive maintenance systems is crucial for minimizing disruptions. By integrating advanced analytics, we can detect issues at the earliest stages of potential failures, allowing for proactive interventions and reducing unplanned downtime. Additionally, investing in emergency preparedness ensures critical spare parts, such as those for overhead wire repairs and signaling systems, are readily available, enabling faster recovery during disruptions.
##	Quick Response & Resource Optimization
Deploying quick-response teams is essential for addressing urgent issues rapidly, minimizing downtime, and ensuring service continuity during peak periods. These teams should be equipped to handle frequent disruptions, particularly on high-traffic routes. Furthermore, optimizing resource allocation during peak disruption days (e.g., Mondays and Tuesdays) will help mitigate delays by adjusting crew schedules and reallocating staff to critical areas, improving operational efficiency.
##	Communication & Coordination
Effective communication is crucial during disruptions to ensure passenger satisfaction. Implementing pre-established, dynamic procedures will provide real-time, tailored updates, reducing uncertainty and frustration. Strengthening inter-departmental coordination among technical teams, customer service, and operations will streamline response processes, ensuring rapid resolution and minimizing downtime.
##	Service Continuity & Backup Systems
Strategically deploying backup trains during peak periods or major disruptions will alleviate overcrowding and maintain service continuity. This ensures that there are contingency plans in place to handle unexpected incidents or high demand. Additionally, enhancing and regularly updating emergency response protocols will ensure a swift, efficient response to severe disruptions, reducing recovery times and minimizing the impact on passengers
#	Conclusion
This analysis highlights key patterns in NS disruptions, pinpointing frequent causes, high-impact lines, and recurring timeframes. While challenges exist, the findings present actionable opportunities to strategically address root causes through predictive maintenance, resource optimization, and enhanced communication. By leveraging data-driven insights, NS can significantly enhance operational efficiency, minimize delays, and improve passenger satisfaction. Proactive implementation of these recommendations underscores NS’s commitment to continuous improvement, paving the way for a more reliable and resilient rail network in the Netherlands.
