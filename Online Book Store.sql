Create table Books(
	Book_ID Serial Primary key,
	Title Varchar(100),
	Author Varchar(100),
	Genre Varchar(50),
	Published_Year Int,
	Price Numeric(10,2),
	Stock Int
);

Create table Customers(
	Customer_ID Serial Primary Key,
	Name Varchar(100),
	Email Varchar(100),
	Phone Varchar(10),
	City Varchar(50),
	Country Varchar(150)
);

Create table Orders(
	Order_ID Serial Primary Key,
	Customer_ID Int references Customers(Customer_ID),
	Book_ID Int references Books(Book_ID),
	Order_Date Date,
	Quantity Int,
	Total_Amount Numeric(10,2)	
);

Select * from Books;
Select * from Customers;
Select * from Orders;

copy Books(Book_ID,Title,Author,Genre,Published_Year,Price,Stock)
from 'D:\Std\SQL Cer\Books.csv'
Csv Header;

copy Customers(Customer_ID,Name,Email,Phone,City,Country)
from 'D:\Std\SQL Cer\Customers.csv'
csv header;

copy Orders(Order_ID,Customer_ID,Book_ID,Order_Date,Quantity,Total_Amount)
from 'D:\Std\SQL Cer\Orders.csv'
csv header;

--Retrieve all books in the "Fiction" genre
Select * from books
where genre='Fiction';

--Find books published after the year 1950
select * from books
where Published_Year>1950;

--List all customers from the Canada
select * from Customers
where country='Canada';

--Show orders placed in November 2023
Select * from orders
where order_date between '2023-11-01' and '2023-11-30';

--Retrieve the total stock of books available
select sum(stock) as Total_stock
from Books;

--Find the details of the most expensive book
select * from Books
order by price desc
limit 1;

--Show all customers who ordered more than 1 quantity of a book
Select * from orders 
where quantity>1;

--Retrieve all orders where the total amount exceeds $20
select * from orders
where total_amount>20;

--List all genres available in the Books table
select distinct genre from Books;

--Find the book with the lowest stock
select * from books
order by stock
limit 1;

--Calculate the total revenue generated from all orders
select sum(total_amount) as revenue from orders;


--Advance Quesions.

--Retrieve the total number of books sold for each genre
select b.genre, sum(o.quantity) as total_books_sold
from orders o
join books b 
on b.book_id=o.book_id
group by b.genre;

--Find the average price of books in the "Fantasy" genre
select avg(price) as Average_Price
from Books
where Genre='Fantasy';

--List customers who have placed at least 2 orders
select customer_id, count(order_id) as order_count
from orders
group by customer_id
having count(order_id)>=2;


select o.customer_id,c.name, count(o.order_id) as order_count
from orders o
join customers c 
on o.customer_id=c.customer_id
group by o.customer_id, c.name
having count(order_id)>=2;

--Find the most frequently ordered book
select o.Book_id,b.title,count(o.order_id) as order_count
from orders o
join books b
on o.book_id=b.book_id
group by o.book_id, title
order by order_count desc limit 1;

--Show the top 3 most expensive books of 'Fantasy' Genre
select * from books
where genre='Fantasy'
order by price desc limit 3;

--Retrieve the total quantity of books sold by each author
select b.author,sum(o.quantity) as Total_Books_Sold
from Orders o
join books b on o.book_id=b.book_id
group by b.author;

--List the cities where customers who spent over $30 are located
select distinct c.city,total_amount
from orders o
join customers c
on o.customer_id=c.customer_id
where o.total_amount>300;

--Find the customer who spent the most on orders
select c.customer_id,c.name,Sum(o.total_amount) as Total_spent
from orders o 
join customers c
on o.customer_id=c.customer_id
group by c.customer_id, c.name
order by total_spent desc limit 1;

--Calculate the stock remaining after fulfilling all orders
select b.book_id, b.title,b.stock,Coalesce(sum(quantity),0) as order_quantity,
	b.stock - coalesce(sum(o.quantity),0) as remaining_quantity
from books b
left join orders o
on b.book_id=o.book_id
group by b.book_id order by b.book_id;
