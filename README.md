#  ShopCart - E-Commerce Web Application
# Title
ShopCart - A Complete Online Shopping Platform Built with Java JSP, Servlets, and MySQL

# Summary
ShopCart is a fully functional e-commerce web application that allows customers to browse products, add items to a shopping cart, and place orders with simulated payment options. The system also includes a comprehensive Admin Panel for managing products, users, and orders. Built using MVC architecture with JSP, Servlets, and JDBC, this project demonstrates core concepts of web development in Java, including session management, database integration, and role-based access control.

# Features
# 👤 Customer Features
#	Feature	Description
1	🔐 User Registration	 > Create new account with username, password, and security question

2	🔑 User Login	         > Secure authentication with session management

3	🛍️ Product Browsing    > View all products with real-time search functionality

4	🛒 Shopping Cart	     > Add, update quantity, and remove items from cart

5	📦 Checkout Process   >Enter shipping details (name, address, phone, pincode)

6	💳 Payment Simulation >Support for Credit Card, UPI, and Cash on Delivery

7	✅ Order Confirmation	 >View order summary after successful placement

8	📋 Order History	      >Track all past orders with status

9	🔍 Order Details	      >View detailed information of each order

10	👤 Profile Management >	View and manage profile information

11	🔒 Password Recovery	>Reset password using security questions

12	🚪 Logout	Secure       >session termination


# 👑 Admin Features
#	Feature	Description
1	👑 Admin Login	Secure login with hardcoded credentials (Admin/Admin123)

2	📊 Dashboard	View statistics (total products, users, orders, revenue)

3	➕ Product Management	Add new products with image upload

4	✏️ Edit Product	Update existing product details and images

5	❌ Delete Product	Remove products (with foreign key constraint handling)

6	👥 User Management	View all registered users

7	🚫 Block/Unblock User	Prevent blocked users from logging in

8	📦 Order Management	View all customer orders

9	🔄 Update Order Status	Change status (Pending → Processing → Shipped → Delivered)


# 🛠️ Technical Features
Feature	Implementation

🏗️ MVC Architecture	Clean separation of concerns (Model: Java Beans, View: JSP, Controller: Servlets)

🔐 Session Management	HttpSession for user/authentication state

💾 Cart Persistence	Cart saved to database; restored after login/logout

🗄️ JDBC Connectivity	Database operations via DAO pattern

🛡️ SQL Injection Prevention	PreparedStatement for all database queries

🎨 Responsive Design	CSS Media Queries for mobile/tablet/desktop

🖼️ File Upload	Product image upload with @MultipartConfig

🔍 Real-time Search	JavaScript-based product filtering

📱 Mobile Friendly	Fully responsive layout

🔗 Foreign Key Constraints	Data integrity maintained




# 📖 Description
Project Overview
ShopCart is a complete e-commerce solution that simulates an online shopping experience. The application consists of two main modules:

1. Customer Module
Customers can register, log in, browse products, add items to their cart, and complete purchases. The system includes a persistent shopping cart that remembers items even after logout. When a user logs back in, their cart is automatically restored from the database.

2. Admin Module
Administrators can manage the entire system through a dedicated dashboard. They can add/edit/delete products, view all registered users, block/unblock users, and manage orders by updating their status throughout the fulfillment process.

Key Functionality
Shopping Cart Logic
Cart is stored in HttpSession using HashMap<Integer, CartItem>

Each cart item contains product details and quantity

Subtotal, shipping (free above ₹500), and tax (5%) are calculated automatically

Cart is synchronized with database to prevent data loss

Order Processing
After checkout, order details are saved to orders and order_items tables

Cart is cleared from both session and database

Product stock is updated automatically

Admin Dashboard
Real-time statistics: total products, users, orders, and revenue

Quick access to all management functions


# 🛠️ Tech Stack with Versions

# Backend Technologies
Technology	Version	Purpose

Java	JDK 17 or higher	Core programming language

Jakarta Servlets	6.0	Request handling and controller logic

Jakarta Server Pages (JSP)	3.0	Dynamic view rendering

JSTL	3.0	JSP Standard Tag Library (optional)

# Database
Technology	Version	Purpose

MySQL	8.0+	Relational database

MySQL Connector/J	8.0.33	JDBC driver for Java-MySQL connection
Server

Apache Tomcat	10.1.x	Servlet and JSP container


# Frontend Technologies

HTML5	-	Page structure

CSS3	-	Styling and responsive design

JavaScript	ES6	Client-side validation and search


# Development Tools
Eclipse IDE	2024-09+	Development environment

Git	Latest	Version control

Required JAR Files

JAR File	Location	Purpose

mysql-connector-j-8.0.33.jar	/WEB-INF/lib/	MySQL JDBC connectivity


## 🎬 Project Demonstration


<video src="https://drive.google.com/file/d/1-Zmz61CmS0OH6u1I9x9PhxEp4Du0Usmv/view?usp=sharing" controls width="700"></video>







# 📥 How to Clone Repository
Prerequisites
Before cloning, ensure you have:

Git installed on your system

JDK 17+ installed

Apache Tomcat 10.1+ installed

MySQL 8.0+ installed and running

Step 1: Clone the Repository
bash
# Clone the project
git clone https://github.com/yourusername/ShopCartProjectDemo.git

# Navigate to project directory
cd ShopCartProjectDemo
Step 2: Import into Eclipse
bash
# Open Eclipse IDE
# File → Import → Existing Projects into Workspace
# Select the project folder
# Click Finish
Step 3: Configure Database
sql
-- Create database (run in MySQL)
CREATE DATABASE shopcart;
USE shopcart;

-- Copy and run all table creation scripts from the project
-- (Tables: user, product, orders, order_items, cart)
Step 4: Update Database Credentials
Edit web.xml (located in WebContent/WEB-INF/):

xml
<context-param>
    <param-name>username</param-name>
    <param-value>your_mysql_username</param-value>
</context-param>
<context-param>
    <param-name>password</param-name>
    <param-value>your_mysql_password</param-value>
</context-param>
Step 5: Add MySQL Connector JAR
bash
# Download mysql-connector-j-8.0.33.jar
# Copy to WebContent/WEB-INF/lib/
# Right-click project → Build Path → Configure Build Path → Add JARs
Step 6: Configure Tomcat Server
bash
# In Eclipse: Window → Preferences → Server → Runtime Environments
# Add → Apache Tomcat 10.1
# Point to Tomcat installation directory
# Finish
Step 7: Run the Application
bash
# Right-click on project → Run As → Run on Server
# Select Tomcat server
# Access at: http://localhost:8080/ShopCartProjectDemo/signIn.jsp
Default Credentials
Role	Username	Password
Admin	Admin	Admin123
Customer	(Register new)	(Set during registration)



👨‍💻 Author
Your Name

Email: yashodeepbadge190@gmail.com

GitHub: @yashodeep003

# Happy Shopping with ShopCart! 🛍️

