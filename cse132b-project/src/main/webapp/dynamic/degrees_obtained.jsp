<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
	String page_title = "Student Obatined Degrees";
	String page_path = "degrees_obtained.jsp";
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
	
			String GET_QUERY = "SELECT * FROM ObtainedDegrees order by student_id";
			String INSERT_QUERY = "INSERT INTO ObtainedDegrees (student_id, degree_name, degree_level, university_of_degree) VALUES (?,?,?,?)";
			String DEL_QUERY = "DELETE FROM ObtainedDegrees where student_id = ? AND degree_name = ? AND degree_level = ?";
			Connection connection = DriverManager.getConnection("jdbc:postgresql:cse132b?user=mwin&password=password7117");
			Statement stmt = connection.createStatement();
		
			String action = request.getParameter("action");
			//Perform an Insert when insert button is pressed
			if (action != null && action.equals("insert")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);
				pstmt.setInt(1, Integer.parseInt(request.getParameter("student-id")));
				pstmt.setString(2, request.getParameter("degree-name"));
				pstmt.setString(3, request.getParameter("degree-level"));
				pstmt.setString(4, request.getParameter("university"));
				pstmt.executeUpdate();
				connection.commit();
				connection.setAutoCommit(true);
			}
			
			//Perform a DELETE when delete is pressed
			if (action != null && action.equals("delete")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(DEL_QUERY);
				pstmt.setInt(1, Integer.parseInt(request.getParameter("student-id")));
				pstmt.setString(2, request.getParameter("degree-name"));
				pstmt.setString(3, request.getParameter("degree-level"));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
		
		
		%>
	<table>
		<!--  Headers -->
		<tr>
			<th>Student ID</th>
			<th>Degree Name</th>
			<th>Degree Level</th>
			<th>University Granting Degree</th>
		</tr>
		<!-- Insert Tuple -->
		<tr>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="insert" name="action">	
				<td><input value="" name="student-id" ></td>
				<td><input value="" name="degree-name" ></td>
				<td><input value="" name="degree-level" ></td>
				<td><input value="" name="university" ></td>
				<td><input type="submit" value="Insert"></td>
			</form>
		</tr>
	
	
	<%
		ResultSet rs = stmt.executeQuery(GET_QUERY);
		while (rs.next()){		
	%>
		<!-- Display Tuples -->
		<tr>

			<td><%= rs.getInt("student_id")%></td>
			<td><%= rs.getString("degree_name")%></td>
			<td><%= rs.getString("degree_level")%></td>
			<td><%= rs.getString("university_of_degree")%></td>

			<form action=<%= page_path %> method="post">
				<input type="hidden" value="delete" name="action">
				<input type="hidden" value="<%= rs.getInt("student_id")%>" name="student-id"  >
				<input type="hidden" value="<%= rs.getString("degree_name")%>" name="degree-name" >
				<input type="hidden" value="<%= rs.getString("degree_level")%>" name="degree-level" >
				<td><input type="submit" value="Delete"></td>
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