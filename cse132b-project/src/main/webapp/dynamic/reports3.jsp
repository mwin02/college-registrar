<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Queries : Reports 3</title>
<style>
table, th, td {
  border: 1px solid black;
  border-collapse: collapse;
  padding-left: 10px;
  padding-right:10px;
}
</style>
</head>

<body>
	<%@ page language="java" import="java.sql.*" %>
	<% 	
	Connection connection = null;
	Statement stmt = null;
	Statement stmt2 = null;
	ResultSet rs = null;
	ResultSet rs2 = null;
	
	try{
	%>
	<jsp:include page="/static/navbar.html" />
	<h1>Reports Three</h1>
	<% 
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection("jdbc:postgresql:cse132b?user=mwin&password=password7117");
			stmt = connection.createStatement();
			stmt2 = connection.createStatement();
			
			
			int curCourseID = -1;
			String curQuarter = "";
			String curFaculty = "";
		
			String action = request.getParameter("action");
			
			
			if (action != null && action.equals("report")) {
				curCourseID = Integer.parseInt(request.getParameter("course-id"));
				curQuarter = (request.getParameter("quarter") == null) ? "%" : request.getParameter("quarter");
				curFaculty = (request.getParameter("faculty") == null) ? "%" : request.getParameter("faculty");
				
			}
			
			String GET_COURSES_QUERY = "SELECT * FROM course ORDER BY course_id";
			String GET_QUARTERS_QUERY = "SELECT * FROM QUARTER_CONVERSION ORDER BY NUM";
			String GET_INSTRUCTORS_QUERY = "SELECT * FROM Faculty ORDER BY faculty_name";
			String REPORT_QUERY = "SELECT gc.Letter, count(*) FROM Class class, enrollment e, GRADE_CONVERSION gc " +
					" WHERE class.course_id = " + curCourseID + " AND class.section_id = e.section_id AND e.grade = gc.LETTER_GRADE " +
					" AND class.quarter LIKE '" + curQuarter + "' AND class.faculty_name LIKE '" + curFaculty + "' GROUP BY gc.LETTER";
			String GPA_REPORT_QUERY = "SELECT avg(gc.NUMBER_GRADE) as gpa FROM Class class, enrollment e, GRADE_CONVERSION gc " +
					" WHERE class.course_id = " + curCourseID + " AND class.section_id = e.section_id AND e.grade = gc.LETTER_GRADE " +
					" AND class.quarter LIKE '" + curQuarter + "' AND class.faculty_name LIKE '" + curFaculty + "'";
			
	%>
	
	<section>
		<h2>Grade Distribution Report</h2>
		<form action="reports3.jsp" method="post">
			<label for="student-ssn">Course ID:</label>
			<input type="hidden" value="report" name="action">
			<select name="course-id">
				<option value="none" selected disabled hidden>Select a Course</option>
			<%
				
				rs = stmt.executeQuery(GET_COURSES_QUERY);
				while (rs.next()) {
			%>
				<option value="<%= rs.getInt("course_id")%>" > <%= rs.getInt("course_id")%> | <%= rs.getString("course_number")%>
				</option>
			<%
				}
			%>
			</select>
			<select name="quarter">
				<option value="none" selected disabled hidden>Select a Quarter</option>
			<%
				rs.close();
				rs = stmt.executeQuery(GET_QUARTERS_QUERY);
				while (rs.next()) {
			%>
				<option value="<%= rs.getString("QUARTER")%>" > <%= rs.getString("QUARTER")%>
				</option>
			<%
				}
			%>
			</select>
			<select name="faculty">
				<option value="none" selected disabled hidden>Select an Instructor</option>
			<%
				rs.close();
				rs = stmt.executeQuery(GET_INSTRUCTORS_QUERY);
				while (rs.next()) {
			%>
				<option value="<%= rs.getString("faculty_name")%>" > <%= rs.getString("faculty_name")%> | <%= rs.getString("title")%>
				</option>
			<%
				}
			%>
			</select>
			<input type="submit" value="Find Classes">
		</form>

		<%
			if (curCourseID != -1) {
				rs.close();
				rs = stmt.executeQuery(GPA_REPORT_QUERY);
				rs.next();
				
		%> 
		<h3>Course ID: <%= curCourseID %> &emsp; Quarter: <%= (curQuarter.equals("%")) ? "Any" : curQuarter%>&emsp;
			Faculty: <%= (curFaculty.equals("%")) ? "Any" : curFaculty %> &emsp; Average Grade: <%= rs.getFloat("gpa") %>
		</h3>
		<table>
			<tr>
				<th> Letter </th>
				<th> Count </th>
			</tr>
		<%
			rs.close();
			rs = stmt.executeQuery(REPORT_QUERY);
				while (rs.next()) {
		%>
			<tr>
				<td><%= rs.getString("Letter") %></td>
				<td><%= rs.getInt("count") %></td>
			</tr>
		<%
					
					
				}
				
				
			}
		
		%>
		</table>
	
	</section>
	
	
	<%
	}  catch (Exception e){
	%>
		<h1>Something Went Wrong</h1>
		<p> <%= e %> </p>]
		<a href="reports3.jsp">Back To Reports Page</a>
	<% 
	} finally {
		if (rs != null) {
			rs.close();			
		}
		if (rs2 != null) {
			rs2.close();			
		}
		if (stmt != null) {
			stmt.close();
		}
		if (stmt2 != null) {
			stmt.close();
		}
		if (connection != null) {		
			connection.close();
		}
		
	}
	
	%>




</body>
</html>