## D. Outside The Box Questions

### The following are open ended questions which might be asked during a technical interview for this case study - there are no right or wrong answers, but answers that make sense from both a technical and a business perspective make an amazing impression!

### 1. How would you calculate the rate of growth for Foodie-Fi?

* Rate of growth can be calculated by comparing the money Foodie-Fi made each month and comparing that with previous month or quaterly or every six months.

* Let's take an example of monthly revenue growth for the year of 2020.

```SQL
WITH monthly_revenue2020 AS (

  SELECT 
      DATE_PART('month', start_date) AS month, 
      SUM(price) AS revenue
  FROM 
      payments_table
  GROUP BY 
      DATE_PART('month', start_date)
  ORDER BY 
      DATE_PART('month', start_date)
)

SELECT 
    month,
    revenue,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY month))/revenue, 2) AS revenue_growth
FROM 
    monthly_revenue2020
```

Result:

<pre>
 month | revenue  | revenue_growth 
-------+----------+----------------
     1 |  1272.10 |               
     2 |  2762.80 |           0.54
     3 |  4104.40 |           0.33
     4 |  5685.20 |           0.28
     5 |  6848.20 |           0.17
     6 |  8180.30 |           0.16
     7 |  9603.00 |           0.15
     8 | 11254.10 |           0.15
     9 | 12228.80 |           0.08
    10 | 14050.10 |           0.13
    11 | 12068.90 |          -0.16
    12 | 12635.80 |           0.04
</pre>

* We can see that, the highest increase was in the month of february with one and only decline in month of november. 


### 2. What key metrics would you recommend Foodie-Fi management to track over time to assess performance of their overall business?

* **Monthly Revenue Growth:** What is the monthly trend of Foodie-Fi's revenue? Are there any months where the number of customers increased significantly?

* **Customer Growth:** How many new customers are added each month? What is the growth rate (e.g., 1.5x, 2x) after each month?

* **Conversion Rate:** How many customers continue using Foodie-Fi after the trial period? What is the conversion rate (e.g., 1.5x, 2x) after each month? This also includes not only rate of upgrades but also downgrades in plans. 

* **Churn Rate:** How many customers cancel their subscriptions each month? Which plans were they using before they churned? Possibly the reason(s) why they left?


### 3. What are some key customer journeys or experiences that you would analyse further to improve customer retention?

* Track the number of customers who downgraded their subscription plan.

* Monitor the number of customers who upgraded from a basic monthly plan to either a pro monthly or pro annual plan.

* Record the number of customers who cancelled their subscriptions.

### 4. If the Foodie-Fi team were to create an exit survey shown to customers who wish to cancel their subscription, what questions would you include in the survey?

* **Primary Reason for Cancellation:** Identify the main reason for subscription cancellation. Possible reasons include:

	* Price
	* Technical issues
	* Customer support
	* Found an alternative
	* Others (please specify)

* **Overall Satisfaction with the Subscription:** Measure overall satisfaction with the subscription on a Likert scale ranging from "Very Satisfied" to "Very Unsatisfied."

* **Likelihood of Future Use:** Gauge the likelihood of customers considering using the services again in the future on a Likert scale from "Very Satisfied" to "Very Unsatisfied."

* **Willingness to Recommend the Company:** Assess how likely customers are to recommend the company to a colleague, friend, or family member on a Likert scale from "Very Satisfied" to "Very Unsatisfied."

### 5. What business levers could the Foodie-Fi team use to reduce the customer churn rate? How would you validate the effectiveness of your ideas?

* **Analyze Exit Survey Responses**: Identify the most common reasons for subscription cancellations. Possible actions include:

  * **Price**: Consider increasing the number of discounts during certain seasons, extending the trial period, or adding more benefits for customers.
  * **Service Quality**: Collaborate with the relevant department to address and fix service quality issues.
  * **Found an Alternative**: Conduct a competitor analysis to identify their competitive advantages over Foodie-Fi.

* **Validate the Effectiveness of These Actions**: Monitor the following metrics to assess the impact of the implemented ideas:
  * Churn rate
  * Conversion rate