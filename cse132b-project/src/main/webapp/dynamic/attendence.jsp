<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
	
	String page_title = "Attendence Record";
	String page_path = "attendence.jsp";
%>
<title><%= page_title %></title>
</head>

<body>
	<%@ page language="java" import="java.sql.*" %>
	<% 	try{
		String id = request.getParameter("student-id");
		if (id == null){
			throw new Exception("Invalid Student ID");
		}
		int studentID = Integer.parseInt(id);
	%>
	<jsp:include page="/static/navbar.html" />
	<h1><%= page_title %> For Account Number <%= studentID %></h1>
	<% 
			
			DriverManager.registerDriver(new org.postgresql.Driver());
	
			String GET_QUERY = "SELECT * FROM Attendence WHERE student_id = " + studentID;
			String INSERT_QUERY = "INSERT INTO Attendence(student_id, quarter) VALUES (?, ?)";
			String DEL_QUERY = "DELETE FROM Attendence WHERE student_id = " + studentID + " AND quarter = ?";
			Connection connection = DriverManager.getConnection("jdbc:postgresql:cse132b?user=mwin&password=password7117");
			Statement stmt = connection.createStatement();
		
			String action = request.getParameter("action");
			//Perform an Insert when insert button is pressed
			if (action != null && action.equals("insert")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);
				pstmt.setInt(1, studentID);
				pstmt.setString(2, request.getParameter("quarter"));
				pstmt.executeUpdate();
				connection.commit();
				connection.setAutoCommit(true);
			}
			
			
			//Perform a DELETE when delete is pressed
			if (action != null && action.equals("delete")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(DEL_QUERY);
				pstmt.setString(1, request.getParameter("quarter"));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
		
		
		%>
	<table>
		<!--  Headers -->
		<tr>
			<th>Student ID</th>
			<th>Quarter</th>
		</tr>
		<!-- Insert Tuple -->
		<tr>
			<form action=<%= page_path %> method="get">
				<input type="hidden" value="insert" name="action">	
				<input type="hidden" value="<%= studentID %>" name="student-id">
				<td></td>
				<td><input value="" name="quarter" ></td>
				<td><input type="submit" value="Insert"></td>
			</form>
		</tr>
	
	
	<%
		ResultSet rs = stmt.executeQuery(GET_QUERY);
		while (rs.next()){		
	%>
		<!-- Display Tuples -->
		<tr>
			<form action=<%= page_path %> method="get">
				<td><input value="<%= studentID %>" name="student-id" readonly></td>
				<td><input value="<%= rs.getString("quarter")%>" name="quarter"></td>
			</form>
			<form action=<%= page_path %> method="get">
				<input type="hidden" value="delete" name="action">
				<input type="hidden" value="<%= studentID %>" name="student-id">
				<input type="hidden" value="<%= rs.getString("quarter") %>" name="quarter">
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
		<a href="students.jsp">Back To Students Page</a>
	<%	
	}
	%>


</body>
</html>