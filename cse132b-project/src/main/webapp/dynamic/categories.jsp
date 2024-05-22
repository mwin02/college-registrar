<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
	String page_title = "Category";
	String page_path = "categories.jsp";
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
	
			String GET_QUERY = "SELECT * FROM Category";
			String INSERT_QUERY = "INSERT INTO Category(category_name, units_required, grade_required) VALUES (?, ?, ?)";
			String DEL_QUERY = "DELETE FROM Category WHERE category_name = ?";
			Connection connection = DriverManager.getConnection("jdbc:postgresql:cse132b?user=mwin&password=password7117");
			Statement stmt = connection.createStatement();
			Statement stmt2 = connection.createStatement();
			
			String action = request.getParameter("action");
			//Perform an Insert when insert button is pressed
			if (action != null && action.equals("insert")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);
				pstmt.setString(1, request.getParameter("name"));
				pstmt.setInt(2, Integer.parseInt(request.getParameter("unit")));
				pstmt.setString(3, request.getParameter("grade"));
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
		
			String ADD_MEMBER_QUERY = "INSERT INTO CategoryCourses(category_name, course_id) VALUES (?, ?)";
			
			if (action != null && action.equals("add-member")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(ADD_MEMBER_QUERY);
				pstmt.setString(1, request.getParameter("name"));
				pstmt.setInt(2, Integer.parseInt(request.getParameter("id")));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
			
			String REMOVE_MEMBER_QUERY = "DELETE FROM CategoryCourses WHERE category_name = ? AND course_id = ?";
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
			<th>Category Name</th>
			<th>Units Required</th>
			<th>Grades Required</th>
			<th></th>
			<th>Courses</th>
		</tr>
		<!-- Insert Tuple -->
		<tr>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="insert" name="action">	
				<td><input value="" name="name"></td>
				<td><input value="" name="unit"></td>
				<td><input value="" name="grade"></td>
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
			<td><input value="<%= rs.getString("category_name") %>" name="name" ></td>
			<td><input value="<%= rs.getString("units_required") %>" name="unit" ></td>
			<td><input value="<%= rs.getString("grade_required") %>" name="grade" ></td>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="delete" name="action">
				<input type="hidden" value="<%= rs.getString("category_name") %>"
				name="name">
				<td><input type="submit" value="Delete"></td>
			</form>
				<form action=<%= page_path %> method="post">
				<input type="hidden" value="add-member" name="action">
				<input type="hidden" value="<%= rs.getString("category_name") %>"
				name="name">				
				<td><input value="" name="id" size="8"></td>
				<td><input type="submit" value="Add Course"></td>
			</form>
			<%
				ResultSet rs2 = stmt2.executeQuery("SELECT * FROM CategoryCourses WHERE category_name = \'" + rs.getString("category_name") + "'");
				while (rs2.next()){
			%>
				<form action=<%= page_path %> method="post">
					<input type="hidden" value="remove-member" name="action">
					<input type="hidden" value="<%= rs.getString("category_name") %>"
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