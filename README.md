# College Registrar (CSE 132B - Database System Applications Course Project)


Registration Software for a college with functionalities such as registering students, registering college faculty and departments, registering courses, course times, sections, enrolling students into classes, scheduling student classes and checking for conflicts, keeping track of a student's academic history, reporting a student's grades and many more. All the data input into the software is linked to an underlying PostgresSQL database.

The site is built using JSP and JDBC is used to connect to a underlying PostgresSQL server. The site was developed in Eclipse and Apache Tomcat is used to run the page. The work of retrieving student data and creating or updating data is done through SQL Queries which are created based on user input and ran on the PostgresSQL using JDBC's Statements. SQL Triggers are also used to maintain data integrity and to ensure that some restrictions are met, for example, two classes not being able to be held at the same time and location.

The Schema for the PostgresSQL is derived from an Entity-Relationship Model that was designed based on customer requirements for the registration software. The Entity-Relationship Model and the resulting Schema is in Third Normal Form to reduce data redundancies and to maintain data integrity when performing updates to the database.
