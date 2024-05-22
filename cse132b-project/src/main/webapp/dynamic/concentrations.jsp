<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
	String page_title = "Concentrations";
	String page_path = "concentrations.jsp";
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
	
			String GET_QUERY = "SELECT * FROM Concentration";
			String INSERT_QUERY = "INSERT INTO Concentration(concentration_name, units_required, gpa_required) VALUES (?, ?, ?)";
			String DEL_QUERY = "DELETE FROM Concentration WHERE concentration_name = ?";
			Connection connection = DriverManager.getConnection("jdbc:postgresql:cse132b?user=mwin&password=password7117");
			Statement stmt = connection.createStatement();
			Statement stmt2 = connection.createStatement();
			
			String action = request.getParameter("action");
			//Perform an Insert when insert button is pressed
			if (action != null && action.equals("insert")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);
				pstmt.setString(1, request.getParameter("name"));
				pstmt.setInt(2, Integer.parseInt(request.getParameter("units")));
				pstmt.setFloat(3, Float.parseFloat(request.getParameter("gpa")));
				pstmt.executeUpdate();
				connection.commit();
				connection.setAutoCommit(true);
			}
			
			
			//Perform a DELETE when delete is pressed
			if (action != null && action.equals("delete")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(DEL_QUERY);
				pstmt.setString(1, request.getParameter("name"));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
		
			String ADD_MEMBER_QUERY = "INSERT INTO ConcentrationCourses(concentration_name, course_id) VALUES (?, ?)";
			
			if (action != null && action.equals("add-member")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(ADD_MEMBER_QUERY);
				pstmt.setString(1, request.getParameter("name"));
				pstmt.setInt(2, Integer.parseInt(request.getParameter("id")));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
			
			String REMOVE_MEMBER_QUERY = "DELETE FROM ConcentrationCourses WHERE concentration_name = ? AND course_id = ?";
			if (action != null && action.equals("remove-member")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(REMOVE_MEMBER_QUERY);
				pstmt.setString(1, request.getParameter("name"));
				pstmt.setInt(2, Integer.parseInt(request.getParameter("id")));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
		
		%>
	<table>
		<!--  Headers -->
		<tr>
			<th>Concentration Name</th>
			<th>Total Units Required</th>
			<th>Minimum GPA Required</th>
			<th></th>
			<th>Courses</th>
		</tr>
		<!-- Insert Tuple -->
		<tr>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="insert" name="action">	
				<td><input value="" name="name"></td>
				<td><input value="" name="units"></td>
				<td><input value="" name="gpa"></td>
				<td><input type="submit" value="Insert"></td>
			</form>
		</tr>
	
	
	<%
		ResultSet rs = stmt.executeQuery(GET_QUERY);
		while (rs.next()){		
	%>
		<!-- Display Tuples -->
		<tr>
			<input type="hidden" value="update" name="action">	
			<td><input value="<%= rs.getString("concentration_name") %>" name="name" ></td>
			<td><input value="<%= rs.getInt("units_required") %>" name="units" ></td>
			<td><input value="<%= rs.getFloat("gpa_required") %>" name="gpa" ></td>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="delete" name="action">
				<input type="hidden" value="<%= rs.getString("concentration_name") %>"
				name="name">
				<td><input type="submit" value="Delete"></td>
			</form>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="add-member" name="action">
				<input type="hidden" value="<%= rs.getString("concentration_name") %>"
				name="name">				
				<td><input value="" name="id" size="8"></td>
				<td><input type="submit" value="Add Course"></td>
			</form>
			<%
				ResultSet rs2 = stmt2.executeQuery("SELECT * FROM ConcentrationCourses WHERE concentration_name = \'" + rs.getString("concentration_name") + "'");
				while (rs2.next()){
			%>
				<form action=<%= page_path %> method="post">
					<input type="hidden" value="remove-member" name="action">
					<input type="hidden" value="<%= rs.getString("concentration_name") %>"
				name="name">				
					<td><input value="<%= rs2.getInt("course_id")%>" name="id" size="5"></td>
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
		<a href=<%= page_path %>>Back To <%= page_title %> Page</a>
	<%	
	}
	%>


</body>
</html>