<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
	String page_title = "Teaching Schedule";
	String page_path = "schedule.jsp";
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
	
			String GET_QUERY = "SELECT * FROM TeachingSchedule order by faculty_name";
			String INSERT_QUERY = "INSERT INTO TeachingSchedule (faculty_name, course_id, quarter, consent_required) VALUES (?,?,?,?)";
			String UPDATE_QUERY = "UPDATE TeachingSchedule SET consent_required = ? WHERE faculty_name = ? AND course_id = ? AND quarter = ?";
			String DEL_QUERY = "DELETE FROM TeachingSchedule where faculty_name = ? AND course_id = ? AND quarter = ?";
			Connection connection = DriverManager.getConnection("jdbc:postgresql:cse132b?user=mwin&password=password7117");
			Statement stmt = connection.createStatement();
		
			String action = request.getParameter("action");
			//Perform an Insert when insert button is pressed
			if (action != null && action.equals("insert")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);
				pstmt.setString(1, request.getParameter("faculty"));
				pstmt.setInt(2, Integer.parseInt(request.getParameter("course-id")));
				pstmt.setString(3, request.getParameter("quarter"));
				pstmt.setString(4, request.getParameter("consent"));
				pstmt.executeUpdate();
				connection.commit();
				connection.setAutoCommit(true);
			}
			
			if (action != null && action.equals("update")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY);
				pstmt.setString(1, request.getParameter("consent"));
				pstmt.setString(2, request.getParameter("faculty"));
				pstmt.setInt(3, Integer.parseInt(request.getParameter("course-id")));
				pstmt.setString(4, request.getParameter("quarter"));
				pstmt.executeUpdate();
				connection.commit();
				connection.setAutoCommit(true);
			}
			
			
			//Perform a DELETE when delete is pressed
			if (action != null && action.equals("delete")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(DEL_QUERY);
				pstmt.setString(1, request.getParameter("faculty"));
				pstmt.setInt(2, Integer.parseInt(request.getParameter("course-id")));
				pstmt.setString(3, request.getParameter("quarter"));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
		
		
		%>
	<table>
		<!--  Headers -->
		<tr>
			<th>Instructor Name</th>
			<th>Course ID</th>
			<th>Quarter</th>
			<th>Consent Required</th>
		</tr>
		<!-- Insert Tuple -->
		<tr>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="insert" name="action">	
				<td><input value="" name="faculty" ></td>
				<td><input value="" name="course-id" ></td>
				<td><input value="" name="quarter" ></td>
				<td><input value="" name="consent" ></td>
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
				<td><input value="<%= rs.getString("faculty_name")%>" name="faculty" readonly></td>
				<td><input value="<%= rs.getInt("course_id")%>" name="course-id" readonly></td>
				<td><input value="<%= rs.getString("quarter")%>" name="quarter" readonly></td>
				<td><input value="<%= rs.getString("consent_required")%>" name="consent" ></td>
				<td><input type="submit" value="Update"></td>
			</form>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="delete" name="action">
				<input type="hidden" value="<%= rs.getString("faculty_name")%>" name="faculty" >
				<input type="hidden" value="<%= rs.getInt("course_id")%>" name="course-id" >
				<input type="hidden" value="<%= rs.getString("quarter")%>" name="quarter" >
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