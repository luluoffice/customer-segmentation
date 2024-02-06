# customer-segmentation
POSTGRESQL personal project

SQL project link - https://www.projectpro.io/article/sql-database-projects-for-data-analysis-to-practice/565


Data set gotten from: https://archive.ics.uci.edu/dataset/352/online+retail

Questions I plan to answer from this dataset: 

- What is the distribution of order values across all customers in the dataset?
- How many unique products have each customer purchased?
- Which customers have only made a single purchase from the company?
- Which products are most commonly purchased together by customers in the dataset?


Variables Table of the dataset

| Variable Name | Role   | Type       | Demographic | Description                                        | Units   | Missing Values |
|---------------|--------|------------|-------------|----------------------------------------------------|---------|-----------------|
| InvoiceNo     | ID     | Categorical | | a 6-digit integral number uniquely assigned to each transaction. If this code starts with letter 'c', it indicates a cancellation | |no      |                 |
| StockCode     | ID     | Categorical | |a 5-digit integral number uniquely assigned to each distinct product| | no      |              
| Description   | Feature | Categorical | |product name                                      | | no      |                 
| Quantity      | Feature | Integer     | |the quantities of each product (item) per transaction| | no      |      
| InvoiceDate   | Feature | Date        | |the day and time when each transaction was generated| | no      |        
| UnitPrice     | Feature | Continuous  | |product price per unit                           |  sterling |   no     
| CustomerID    | Feature | Categorical | |a 5-digit integral number uniquely assigned to each customer| | no     
| Country       | Feature | Categorical | |the name of the country where each customer resides| | no      |       




