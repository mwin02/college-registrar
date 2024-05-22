<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
	String page_title = "Probations";
	String page_path = "probations.jsp";
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
	
			String GET_QUERY = "SELECT * FROM Probation";
			String INSERT_QUERY = "INSERT INTO Probation(student_id, start_quarter, end_quarter, reason) VALUES (?, ?, ?, ?)";
			String UPDATE_QUERY = "Update Probation Set student_id = ?, start_quarter = ?, end_quarter = ?, reason = ? WHERE case_id = ?";
			String DEL_QUERY = "DELETE FROM Probation WHERE case_id = ?";
			Connection connection = DriverManager.getConnection("jdbc:postgresql:cse132b?user=mwin&password=password7117");
			Statement stmt = connection.createStatement();
		
			String action = request.getParameter("action");
			//Perform an Insert when insert button is pressed
			if (action != null && action.equals("insert")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);
				pstmt.setInt(1, Integer.parseInt(request.getParameter("student-id")));
				pstmt.setString(2, request.getParameter("start"));
				pstmt.setString(3, request.getParameter("end"));
				pstmt.setString(4, request.getParameter("reason"));
				pstmt.executeUpdate();
				connection.commit();
				connection.setAutoCommit(true);
			}
			
			//Perform an UPDATE when update is pressed
			if (action != null && action.equals("update")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY);
				pstmt.setInt(1, Integer.parseInt(request.getParameter("student-id")));
				pstmt.setString(2, request.getParameter("start"));
				pstmt.setString(3, request.getParameter("end"));
				pstmt.setString(4, request.getParameter("reason"));
				pstmt.setInt(5, Integer.parseInt(request.getParameter("case-id")));
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
			<th>Case ID</th>
			<th>Student ID</th>
			<th>Start Quarter</th>
			<th>End Quarter</th>
			<th>Reason</th>
		</tr>
		<!-- Insert Tuple -->
		<tr>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="insert" name="action">	
				<td></td>
				<td><input value="" name="student-id" ></td>
				<td><input value="" name="start" ></td>
				<td><input value="" name="end" ></td>
				<td><input value="" name="reason" ></td>
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
				<td><input value="<%= rs.getInt("case_id")%>" name="case-id"  readonly></td>
				<td><input value="<%= rs.getInt("student_id") %>" name="student-id"></td>
				<td><input value="<%= rs.getString("start_quarter") %>" name="start" ></td>
				<td><input value="<%= rs.getString("end_quarter")%>" name="end"></td>
				<td><input value="<%= rs.getString("reason")%>" name="reason"></td>
				<td><input type="submit" value="Update"></td>
			</form>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="delete" name="action">
				<input type="hidden" value="<%= rs.getInt("case_id") %>"
				name="id">
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