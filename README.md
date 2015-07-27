# Bench-Rest-Test

Getting Started
Welcome to the Bench Rest Test. The purpose of this exercise is to demonstrate your ability to reason about rudimentary APIs and data transformation. You can use any language you feel comfortable with, but we're most familiar with Scala, Go, and Node.

We would like you to write an app that connects to an API, downloads all the data, and has a function that will calculate the total balance. You can also complete the Additional Features for extra credit.

To submit your work, create a git repository on Github and send us the link in an email

API Docs
The API is extremely simple. All pages are in JSON format.

The API is located at http://resttest.bench.co/transactions/ and follows this convention

http://resttest.bench.co/transactions/:page.json
where :page is a number starting at 1.
Transactions

GET /transactions/:page

Returns a list of transactions as well as a totalBalance, totalCount, and page number. The totalCount tells you the total number of transactions.
Additional Features
After building the app your can create extra functionality based on the following stories:

As a user, I need vendor names to be easily readable. Make the vendor names more readable, remove garbage from names.
As a user, I do not want to have any duplicated transactions in the list. Use the data provided to detect and identify duplicate transactions.
As a user, I need to get a list expense categories. For each category I need a list of transactions, and the total expenses for that category.
As a user, I need to calculate daily calculated balances. A running total for each day. For example, if I have 3 transactions for the 5th 6th 7th, each for $5, then the daily balance on the 6th would be $10.
