<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
	String page_title = "Review";
	String page_path = "review.jsp";
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
	
			String GET_QUERY = "SELECT * FROM ReviewSessions";
			String INSERT_QUERY = "INSERT INTO ReviewSessions (section_id, session_date, start_time, end_time) VALUES (?,?,?,?)";
			String DEL_QUERY = "DELETE FROM ReviewSessions where section_id = ? AND session_date = ? AND start_time = ?";
			Connection connection = DriverManager.getConnection("jdbc:postgresql:cse132b?user=mwin&password=password7117");
			Statement stmt = connection.createStatement();
		
			String action = request.getParameter("action");
			//Perform an Insert when insert button is pressed
			if (action != null && action.equals("insert")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);
				pstmt.setInt(1, Integer.parseInt(request.getParameter("section-id")));
				pstmt.setString(2, request.getParameter("date"));
				pstmt.setString(3, request.getParameter("start"));
				pstmt.setString(4, request.getParameter("end"));
				pstmt.executeUpdate();
				connection.commit();
				connection.setAutoCommit(true);
			}
			
			
			//Perform a DELETE when delete is pressed
			if (action != null && action.equals("delete")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(DEL_QUERY);
				pstmt.setInt(1, Integer.parseInt(request.getParameter("section-id")));
				pstmt.setString(2, request.getParameter("date"));
				pstmt.setString(3, request.getParameter("start"));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
		
		
		%>
	<table>
		<!--  Headers -->
		<tr>
			<th>Section ID</th>
			<th>Session Date</th>
			<th>Start Time</th>
			<th>End Time</th>
		</tr>
		<!-- Insert Tuple -->
		<tr>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="insert" name="action">	
				<td><input value="" name="section-id" ></td>
				<td><input value="" name="date" ></td>
				<td><input value="" name="start" ></td>
				<td><input value="" name="end" ></td>
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
				<td><input value="<%= rs.getInt("section_id")%>" name="section-id" readonly ></td>
				<td><input value="<%= rs.getString("session_date")%>" name="date" ></td>
				<td><input value="<%= rs.getString("start_time")%>" name="start" ></td>
				<td><input value="<%= rs.getString("end_time")%>" name="end" ></td>
			</form>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="delete" name="action">
				<input type="hidden" value="<%= rs.getInt("section_id") %>" name="section-id">
				<input type="hidden" value="<%= rs.getString("session_date") %>" name="date">
				<input type="hidden" value="<%= rs.getString("start_time") %>" name="start">
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