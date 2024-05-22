<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Courses</title>
</head>
<%
	String page_title = "Degrees";
	String page_path = "courses.jsp";
%>
<body>
	<%@ page language="java" import="java.sql.*" %>
	<% 	try{
	%>
	<jsp:include page="/static/navbar.html" />
	<h1>Courses</h1>
	<% 
			//Course Params(course_id, course_number, min_units, max_units, lab_work_req, grading_options_allowed, department_id)
			DriverManager.registerDriver(new org.postgresql.Driver());
			String GET_QUERY = "select * from Course order by course_number, department_id";
			String INSERT_QUERY = "insert into Course (course_number, min_units, max_units," 
			+ " lab_work_req, grading_options_allowed, department_id) VALUES (?, ?, ?, ?, ?, ?)";
			String UPDATE_QUERY = "UPDATE Course SET course_number = ?, min_units = ?," + 
			"max_units = ?, lab_work_req = ?, grading_options_allowed = ?, department_id = ? WHERE course_id = ?";
			String DEL_QUERY = "DELETE FROM Course WHERE course_id = ?";
			Connection connection = DriverManager.getConnection("jdbc:postgresql:cse132b?user=mwin&password=password7117");
			Statement stmt = connection.createStatement();
			Statement stmt2 = connection.createStatement();
			
			String action = request.getParameter("action");
			if (action != null && action.equals("insert")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);
				
				pstmt.setString(1, request.getParameter("number"));
				pstmt.setInt(2, Integer.parseInt(request.getParameter("min-unit")));
				pstmt.setInt(3, Integer.parseInt(request.getParameter("max-unit")));
				pstmt.setString(4, request.getParameter("lab-work"));
				pstmt.setString(5, request.getParameter("grading")); 
				pstmt.setInt(6, Integer.parseInt(request.getParameter("department-id"))); 
				pstmt.executeUpdate();
				connection.commit();
				connection.setAutoCommit(true);
			}
			
			if (action != null && action.equals("update")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY);
				pstmt.setString(1, request.getParameter("number"));
				pstmt.setInt(2, Integer.parseInt(request.getParameter("min-unit")));
				pstmt.setInt(3, Integer.parseInt(request.getParameter("max-unit")));
				pstmt.setString(4, request.getParameter("lab-work"));
				pstmt.setString(5, request.getParameter("grading")); 
				pstmt.setInt(6, Integer.parseInt(request.getParameter("department-id"))); 
				pstmt.setInt(7, Integer.parseInt(request.getParameter("course-id")));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
			
			if (action != null && action.equals("delete")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(DEL_QUERY);
 				pstmt.setInt(1, Integer.parseInt(request.getParameter("id"))); 
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
		
			String ADD_MEMBER_QUERY = "INSERT INTO Prerequisites(course_id, prereq_course_id) VALUES (?, ?)";
			if (action != null && action.equals("add-member")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(ADD_MEMBER_QUERY);
				pstmt.setInt(1, Integer.parseInt(request.getParameter("course-id")));
				pstmt.setInt(2, Integer.parseInt(request.getParameter("prereq-id")));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
			
			String REMOVE_MEMBER_QUERY = "DELETE FROM Prerequisites WHERE course_id = ? AND prereq_course_id = ?";
			if (action != null && action.equals("remove-member")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(REMOVE_MEMBER_QUERY);
				pstmt.setInt(1, Integer.parseInt(request.getParameter("course-id")));
				pstmt.setInt(2, Integer.parseInt(request.getParameter("prereq-id")));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
		%>
	<table>
		<tr>
		<!--  Headers -->
			<th>Course ID</th>
			<th>Course Number</th>
			<th>Minimum Units</th>
			<th>Maximum Units</th>
			<th>Lab Work Requirement</th>
			<th>Grading Options</th>
			<th>Department ID</th>
		</tr>
		<tr>
			<!-- Insert Tuple -->
			<form action="<%= page_path %>" method="post">
				<input type="hidden" value="insert" name="action">	
				<td></td>
				<td><input value="" name="number"></td>
				<td><input value="" name="min-unit"></td>
				<td><input value="" name="max-unit"></td>
				<td><input value="" name="lab-work"></td>
				<td><input value="" name="grading" ></td>
				<td><input value="" name="department-id" ></td>
				<td><input type="submit" value="Insert"></td>
			</form>
		</tr>
	
	
	<%
		ResultSet rs = stmt.executeQuery(GET_QUERY);
		while (rs.next()){		
	%>
		<tr>
			<!-- Display Tuples -->
			<form action="<%= page_path %>" method="post">
				<input type="hidden" value="update" name="action">	
				<td><input value="<%= rs.getInt("course_id")%>" name="course-id" size="10" readonly></td>
				<td><input value="<%= rs.getString("course_number") %>" name="number" ></td>
				<td><input value="<%= rs.getString("min_units") %>" name="min-unit" ></td>
				<td><input value="<%= rs.getString("max_units")%>" name="max-unit" ></td>
				<td><input value="<%= rs.getString("lab_work_req")%>" name="lab-work" ></td>
				<td><input value="<%= rs.getString("grading_options_allowed")%>" name="grading"></td>
				<td><input value="<%= rs.getString("department_id")%>" name="department-id" ></td>
				<td><input type="submit" value="Update"></td>
			</form>
			<form action="<%= page_path %>" method="post">
				<input type="hidden" value="delete" name="action">
				<input type="hidden" value="<%= rs.getInt("course_id") %>"
				name="id">
				<td><input type="submit" value="Delete"></td>
			</form>
		</tr>
		<tr>
			<td></td>
			</form>
				<form action=<%= page_path %> method="post">
				<input type="hidden" value="add-member" name="action">
				<input type="hidden" value="<%= rs.getInt("course_id") %>"
				name="course-id">				
				<td><input value="" name="prereq-id" placeholder="Prerequisite"></td>
				<td><input type="submit" value="Add Prereq Course"></td>
			</form>
			<%
				ResultSet rs2 = stmt2.executeQuery("SELECT * FROM Prerequisites WHERE course_id = " + rs.getInt("course_id"));
				while (rs2.next()){
			%>
				<form action=<%= page_path %> method="post">
					<input type="hidden" value="remove-member" name="action">
					<input type="hidden" value="<%= rs.getInt("course_id") %>"
				name="course-id">				
					<td><input value="<%= rs2.getInt("prereq_course_id")%>" name="prereq-id"></td>
					<td><input type="submit" value="Remove"></td>
				</form>
			<%				
				}
			%>	
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
		<a href="<%= page_path %>">Back To Courses Page</a>
	<%	
	}
	%>


</body>
</html>