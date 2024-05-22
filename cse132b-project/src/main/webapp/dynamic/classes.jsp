<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
	String page_title = "Classes";
	String page_path = "classes.jsp";
%>
<title><%= page_title %></title>
</head>

<body>
	<%@ page language="java" import="java.sql.*" %>
	<% 	try{
	%>
	<jsp:include page="/static/navbar.html" />
	<h1><%= page_title %></h1>
	<% 
			
			DriverManager.registerDriver(new org.postgresql.Driver());
	
			String GET_QUERY = "select * from class c, QUARTER_CONVERSION qc WHERE c.quarter = qc.quarter order by qc.num, course_id, class_title, c.quarter";
			String INSERT_QUERY = "insert into Class(course_id, class_title, quarter, enrollment_limit, faculty_name)" +
			"VALUES (?, ?, ?, ?, ?)";
			String UPDATE_QUERY = "UPDATE Class SET course_id = ?, class_title = ?," + 
					"quarter = ?, enrollment_limit = ?, faculty_name = ? WHERE section_id = ?";
			String DEL_QUERY = "DELETE FROM Class WHERE section_id = ?";
			Connection connection = DriverManager.getConnection("jdbc:postgresql:cse132b?user=mwin&password=password7117");
			Statement stmt = connection.createStatement();
		
			String action = request.getParameter("action");
			//Perform an Insert when insert button is pressed
			if (action != null && action.equals("insert")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);
				pstmt.setInt(1, Integer.parseInt(request.getParameter("course-id")));
				pstmt.setString(2, request.getParameter("class-title"));
				pstmt.setString(3, request.getParameter("quarter"));
				pstmt.setInt(4, Integer.parseInt(request.getParameter("limit")));
				pstmt.setString(5, request.getParameter("faculty-name"));
				pstmt.executeUpdate();
				connection.commit();
				connection.setAutoCommit(true);
			}
			
			//Perform an UPDATE when update is pressed
			if (action != null && action.equals("update")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY);
				pstmt.setInt(1, Integer.parseInt(request.getParameter("course-id")));
				pstmt.setString(2, request.getParameter("class-title"));
				pstmt.setString(3, request.getParameter("quarter"));
				pstmt.setInt(4, Integer.parseInt(request.getParameter("limit")));
				pstmt.setString(5, request.getParameter("faculty-name"));
				pstmt.setInt(6, Integer.parseInt(request.getParameter("section-id")));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
			
			//Perform a DELETE when delete is pressed
			if (action != null && action.equals("delete")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(DEL_QUERY);
				pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
		
		
		%>
	<table>
		<!--  Headers -->
		<tr>
			<th>Section ID</th>
			<th>Course ID</th>
			<th>Class Title</th>
			<th>Quarter</th>
			<th>Enrollment Limit</th>
			<th>Faculty Name</th>
		</tr>
		<!-- Insert Tuple -->
		<tr>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="insert" name="action">	
				<td></td>
				<td><input value="" name="course-id"></td>
				<td><input value="" name="class-title"></td>
				<td><input value="" name="quarter" ></td>
				<td><input value="" name="limit"></td>
				<td><input value="" name="faculty-name"></td>
				<td><input type="submit" value="Insert"></td>
			</form>
		</tr>
	
	
	<%
		ResultSet rs = stmt.executeQuery(GET_QUERY);
		while (rs.next()){		
	%>
		<!-- Display Tuples -->
		<tr>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="update" name="action">	
				<td><input value="<%= rs.getInt("section_id") %>" name="section-id" readonly></td>
				<td><input value="<%= rs.getInt("course_id")%>" name="course-id"></td>
				<td><input value="<%= rs.getString("class_title")%>" name="class-title" ></td>
				<td><input value="<%= rs.getString("quarter") %>" name="quarter"></td>
				<td><input value="<%= rs.getInt("enrollment_limit")%>" name="limit"></td>
				<td><input value="<%= rs.getString("faculty_name")%>" name="faculty-name"></td>
				<td><input type="submit" value="Update"></td>
			</form>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="delete" name="action">
				<input type="hidden" value="<%= rs.getInt("section_id") %>" name="id">
				<td><input type="submit" value="Delete"></td>
			</form>
			<form action="meeting.jsp" method="get">
				<input type="hidden" value="<%= rs.getInt("section_id") %>" name="section-id">
				<td><input type="submit" value="Meetings"></td>
			</form>
		</tr>
	<%	} %>
	</table>
	<% 
	rs.close();
	stmt.close();
	connection.close();
	
	%>
	<%
	} catch (Exception e){
	%>
		<h1>Something Went Wrong</h1>
		<p> <%= e %> </p>]
		<a href=<%= page_path %>>Back To <%= page_title %> Page</a>
	<%	
	}
	%>


</body>
</html>