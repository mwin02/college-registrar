<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
	String page_title = "Enrollment";
	String page_path = "enrollment.jsp";
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
	
			String GET_QUERY = "SELECT * FROM ENROLLMENT order by section_id, student_id";
			String INSERT_QUERY = "INSERT INTO ENROLLMENT(student_id, section_id, enrollment_status, grading_option, grade, credits_earned)" + 
			"VALUES(?, ?, ?, ?, ?, ?)";
			String UPDATE_QUERY = "UPDATE ENROLLMENT SET student_id = ?, section_id = ?, enrollment_status = ?, grading_option = ?, " + 
			" grade = ?, credits_earned = ? WHERE student_id = ? AND section_id = ?";
			String DEL_QUERY = "DELETE FROM ENROLLMENT WHERE student_id = ? AND section_id = ?";
			Connection connection = DriverManager.getConnection("jdbc:postgresql:cse132b?user=mwin&password=password7117");
			Statement stmt = connection.createStatement();
		
			String action = request.getParameter("action");
			//Perform an Insert when insert button is pressed
			if (action != null && action.equals("insert")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);
				pstmt.setInt(1, Integer.parseInt(request.getParameter("student-id")));
				pstmt.setInt(2, Integer.parseInt(request.getParameter("section-id")));
				pstmt.setString(3, request.getParameter("status"));
				pstmt.setString(4, request.getParameter("grade-option"));
				pstmt.setString(5, request.getParameter("grade-acheived"));
				pstmt.setInt(6, Integer.parseInt(request.getParameter("credits")));
				pstmt.executeUpdate();
				connection.commit();
				connection.setAutoCommit(true);
			}
			
			//Perform an UPDATE when update is pressed
			if (action != null && action.equals("update")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY);
				pstmt.setInt(1, Integer.parseInt(request.getParameter("student-id")));
				pstmt.setInt(2, Integer.parseInt(request.getParameter("section-id")));
				pstmt.setString(3, request.getParameter("status"));
				pstmt.setString(4, request.getParameter("grade-option"));
				pstmt.setString(5, request.getParameter("grade-acheived"));
				pstmt.setInt(6, Integer.parseInt(request.getParameter("credits")));
				pstmt.setInt(7, Integer.parseInt(request.getParameter("a-student-id")));
				pstmt.setInt(8, Integer.parseInt(request.getParameter("a-section-id")));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
			
			//Perform a DELETE when delete is pressed
			if (action != null && action.equals("delete")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(DEL_QUERY);
				pstmt.setInt(1, Integer.parseInt(request.getParameter("student-id")));
				pstmt.setInt(2, Integer.parseInt(request.getParameter("section-id")));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
		
		
		%>
	<table>
		<!--  Headers -->
		<tr>
			<th>Student ID</th>
			<th>Section ID</th>
			<th>Enrollment Status</th>
			<th>Grading Option</th>
			<th>Grade Achieved</th>
			<th>Credits Earned</th>
		</tr>
		<!-- Insert Tuple -->
		<tr>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="insert" name="action">	
				<td><input value="" name="student-id" ></td>
				<td><input value="" name="section-id"></td>
				<td><input value="" name="status" ></td>
				<td><input value="" name="grade-option" ></td>
				<td><input value="" name="grade-acheived" ></td>
				<td><input value="" name="credits" ></td>
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
				<input type="hidden" value="<%= rs.getInt("student_id") %>"
				name="a-student-id">
				<input type="hidden" value="<%= rs.getInt("section_id") %>"
				name="a-section-id">
				<td><input value="<%= rs.getInt("student_id")%>" name="student-id" readonly></td>
				<td><input value="<%= rs.getInt("section_id") %>" name="section-id" ></td>
				<td><input value="<%= rs.getString("enrollment_status") %>" name="status" ></td>
				<td><input value="<%= rs.getString("grading_option")%>" name="grade-option" ></td>
				<td><input value="<%= rs.getString("grade")%>" name="grade-acheived" ></td>
				<td><input value="<%= rs.getInt("credits_earned")%>" name="credits" ></td>
				<td><input type="submit" value="Update"></td>
			</form>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="delete" name="action">
				<input type="hidden" value="<%= rs.getInt("student_id") %>"
				name="student-id">
				<input type="hidden" value="<%= rs.getInt("section_id") %>"
				name="section-id">
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