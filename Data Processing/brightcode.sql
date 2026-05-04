--The product generate the most revenue
SELECT product_category, SUM(unit_price * transaction_qty) AS Total_Revenue
FROM casestudypart1.default.bright_coffee_shop_analysis_case_study_1
GROUP BY product_category
ORDER BY Total_Revenue DESC;

--The time of day the store performs best 
SELECT EXTRACT(HOUR FROM transaction_time) AS Hour, SUM(unit_price * transaction_qty) AS Total_Revenue
FROM casestudypart1.default.bright_coffee_shop_analysis_case_study_1
GROUP BY Hour
ORDER BY Total_Revenue DESC;

--Sales trends across products and time intervals 
SELECT transaction_date, product_category, SUM(unit_price * transaction_qty) AS Total_Revenue
FROM casestudypart1.default.bright_coffee_shop_analysis_case_study_1
GROUP BY transaction_date, product_category
ORDER BY transaction_date, Total_Revenue DESC;


--High-performing and low-performing products 
SELECT MAX(product_category) AS High_Performing_Product, MIN(product_category) AS Low_Performing_Product
  FROM casestudypart1.default.bright_coffee_shop_analysis_case_study_1;

  -- Total revenue calculations 
SELECT SUM(unit_price * transaction_qty) AS Total_Revenue
FROM casestudypart1.default.bright_coffee_shop_analysis_case_study_1;

--All columns
SELECT *
FROM casestudypart1.default.bright_coffee_shop_analysis_case_study_1;

--CASE Column
SELECT store_location,
       SUM(transaction_qty * unit_price) AS Total_Price,
       CASE
           WHEN HOUR(transaction_time) BETWEEN 6 AND 10 THEN 'Morning Rush'
           WHEN HOUR(transaction_time) BETWEEN 10 AND 12 THEN 'Mid-Morning'
           WHEN HOUR(transaction_time) BETWEEN 12 AND 14 THEN 'Lunch'
           WHEN HOUR(transaction_time) BETWEEN 15 AND 17 THEN 'Afternoon'
           WHEN HOUR(transaction_time) >= 17 THEN 'Evening'
           ELSE 'Other'
       END AS Coffee_Time_Intervals
FROM casestudypart1.default.bright_coffee_shop_analysis_case_study_1
GROUP BY store_location,
         CASE
           WHEN HOUR(transaction_time) BETWEEN 6 AND 10 THEN 'Morning Rush'
           WHEN HOUR(transaction_time) BETWEEN 10 AND 12 THEN 'Mid-Morning'
           WHEN HOUR(transaction_time) BETWEEN 12 AND 14 THEN 'Lunch'
           WHEN HOUR(transaction_time) BETWEEN 15 AND 17 THEN 'Afternoon'
           WHEN HOUR(transaction_time) >= 17 THEN 'Evening'
           ELSE 'Other'
       END;

       --Operating Hour
       SELECT MIN(transaction_time) AS Start_Time, MAX(transaction_time) AS End_Time
       FROM casestudypart1.default.bright_coffee_shop_analysis_case_study_1;

 --Traffic hours
       SELECT product_category, 
          CASE 
              WHEN HOUR(transaction_time) BETWEEN 6 AND 9 THEN 'PEAK_TIME'
              WHEN HOUR(transaction_time) BETWEEN 9 AND 11 THEN 'SLOW _PEAK'
              WHEN HOUR(transaction_time) BETWEEN 12 AND 15 THEN 'RUSH_HOUR'
              ELSE 'SLOW'
              END AS Traffic_Hours
       FROM casestudypart1.default.bright_coffee_shop_analysis_case_study_1
       GROUP BY product_category,
                CASE 
                    WHEN HOUR(transaction_time) BETWEEN 6 AND 9 THEN 'PEAK_TIME'
                    WHEN HOUR(transaction_time) BETWEEN 9 AND 11 THEN 'SLOW _PEAK'
                    WHEN HOUR(transaction_time) BETWEEN 12 AND 15 THEN 'RUSH_HOUR'
                    ELSE 'SLOW'
                END;

                --Time spefcific 
               SELECT HOUR(transaction_time) AS Hour
               FROM casestudypart1.default.bright_coffee_shop_analysis_case_study_1
               GROUP BY Hour;



--Peak_Time
SELECT 
    EXTRACT(HOUR FROM transaction_time) AS hour,
    COUNT(*) AS Peak_Time
FROM casestudypart1.default.bright_coffee_shop_analysis_case_study_1
WHERE EXTRACT(HOUR FROM transaction_time) BETWEEN 6 AND 9
GROUP BY hour
ORDER BY Peak_Time DESC;

--Slow_Peak
SELECT transaction_time AS Slow_Peak
FROM casestudypart1.default.bright_coffee_shop_analysis_case_study_1
ORDER BY Slow_Peak DESC;


--Adding columns for Insight
SELECT *,
      --Column 1
      dayname(transaction_date) AS DayName,
      --Column 2
      monthname(transaction_date) AS MonthName,
      --Column 3
      day(transaction_date) AS DayOfMonth,
      --Column 4
      CASE
          WHEN dayname(transaction_date) IN ('Sat', 'Sun') THEN 'Weekend'
          ELSE 'Weekday'
      END AS Day_Classification,

      --Adding time buckets: Column 5
      CASE 
      WHEN date_format(transaction_time, 'HH,MM,SS') BETWEEN '06:00:00' AND '08:59:59' THEN 'Rush_Hour'
           WHEN date_format(transaction_time, 'HH,MM,SS') BETWEEN '09:00:00' AND '11:59:59' THEN 'Mid-Morning'
           WHEN date_format(transaction_time, 'HH,MM,SS') BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
           WHEN date_format(transaction_time, 'HH,MM,SS') BETWEEN '16:00:00' AND '18:59:59' THEN 'Rush_Hour'
           ELSE 'Night'
           END AS Time_Classification,

         -- Adding Spend buckets: Column 6

      CASE 
           WHEN (unit_price * transaction_qty) BETWEEN 0 AND 2 THEN 'Low'
           WHEN (unit_price * transaction_qty) BETWEEN 2 AND 5 THEN 'Medium'
           WHEN (unit_price * transaction_qty) BETWEEN 5 AND 10 THEN 'High'
           WHEN (unit_price * transaction_qty) BETWEEN 10 AND 20 THEN 'Very High'
           ELSE 'Blesser'
           END AS Spend_Bucket,

           --Adding Revenue:Column 7
                   Transaction_qty*unit_price AS Total_Revenue
           FROM casestudypart1.default.bright_coffee_shop_analysis_case_study_1;
      
