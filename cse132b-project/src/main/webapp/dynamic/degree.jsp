<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
	String page_title = "Degrees";
	String page_path = "degree.jsp";
%>
<title><%= page_title %></title>
<style>

</style>
</head>

<body>
	<%@ page language="java" import="java.sql.*" %>
	<% 	try{
	%>
	<jsp:include page="/static/navbar.html" />
	<h1><%= page_title %></h1>
	<% 
			
			DriverManager.registerDriver(new org.postgresql.Driver());
	
			String GET_QUERY = "SELECT * FROM Degree order by department_id, degree_name, total_units";
			String INSERT_QUERY = "INSERT INTO Degree(degree_name, degree_level, total_units, department_id) VALUES (?, ?, ?, ?)";
			String UPDATE_QUERY = "UPDATE Degree Set degree_name = ?, degree_level = ?, total_units = ?, department_id = ? WHERE degree_name = ? AND degree_level = ?";
			String DEL_QUERY = "DELETE FROM Degree WHERE degree_name = ? AND degree_level = ?";
			Connection connection = DriverManager.getConnection("jdbc:postgresql:cse132b?user=mwin&password=password7117");
			Statement stmt = connection.createStatement();
			Statement stmt2 = connection.createStatement();
			String action = request.getParameter("action");
			//Perform an Insert when insert button is pressed
			if (action != null && action.equals("insert")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);
				pstmt.setString(1, request.getParameter("name"));
				pstmt.setString(2, request.getParameter("level"));
				pstmt.setInt(3, Integer.parseInt(request.getParameter("units")));
				pstmt.setInt(4, Integer.parseInt(request.getParameter("department-id")));
				pstmt.executeUpdate();
				connection.commit();
				connection.setAutoCommit(true);
			}
			
			//Perform an UPDATE when update is pressed
			if (action != null && action.equals("update")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY);
				pstmt.setString(1, request.getParameter("name"));
				pstmt.setString(2, request.getParameter("level"));
				pstmt.setInt(3, Integer.parseInt(request.getParameter("units")));
				pstmt.setInt(4, Integer.parseInt(request.getParameter("department-id")));
				pstmt.setString(5, request.getParameter("a-name"));
				pstmt.setString(6, request.getParameter("a-level"));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
			
			//Perform a DELETE when delete is pressed
			if (action != null && action.equals("delete")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(DEL_QUERY);
				pstmt.setString(1, request.getParameter("name"));
				pstmt.setString(2, request.getParameter("level"));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
		
			String ADD_MEMBER_QUERY = "INSERT INTO DegreeCategoryReq(degree_name, degree_level, category_name) VALUES (?, ?, ?)";
			if (action != null && action.equals("add-member")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(ADD_MEMBER_QUERY);
				pstmt.setString(1, request.getParameter("name"));
				pstmt.setString(2, request.getParameter("level"));
				pstmt.setString(3, request.getParameter("category"));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
			
			String REMOVE_MEMBER_QUERY = "DELETE FROM DegreeCategoryReq WHERE degree_name = ? AND degree_level = ? AND category_name = ?";
			if (action != null && action.equals("remove-member")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(REMOVE_MEMBER_QUERY);
				pstmt.setString(1, request.getParameter("name"));
				pstmt.setString(2, request.getParameter("level"));
				pstmt.setString(3, request.getParameter("category"));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
			
			String ADD_MEMBER_QUERY_2 = "INSERT INTO DegreeConcentrationReq(degree_name, degree_level, concentration_name) VALUES (?, ?, ?)";
			if (action != null && action.equals("add-member-2")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(ADD_MEMBER_QUERY_2);
				pstmt.setString(1, request.getParameter("name"));
				pstmt.setString(2, request.getParameter("level"));
				pstmt.setString(3, request.getParameter("concentration"));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
			
			String REMOVE_MEMBER_QUERY_2 = "DELETE FROM DegreeConcentrationReq WHERE degree_name = ? AND degree_level = ? AND concentration_name = ?";
			if (action != null && action.equals("remove-member-2")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(REMOVE_MEMBER_QUERY_2);
				pstmt.setString(1, request.getParameter("name"));
				pstmt.setString(2, request.getParameter("level"));
				pstmt.setString(3, request.getParameter("concentration"));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
		%>
	<table>
		<!--  Headers -->
		<tr>
			<th>Degree Name</th>
			<th>Degree Level</th>
			<th>Units Required</th>
			<th>Department ID</th>

		</tr>
		<!-- Insert Tuple -->
		<tr>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="insert" name="action">	
				<td><input value="" name="name" ></td>
				<td><input value="" name="level" ></td>
				<td><input value="" name="units" ></td>
				<td><input value="" name="department-id" ></td>
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
				<input type="hidden" value="<%= rs.getString("degree_name") %>" name="a-name" >
				<input type="hidden" value="<%= rs.getString("degree_level") %>" name="a-level" >
				<td><input value="<%= rs.getString("degree_name") %>" name="name" ></td>
				<td><input value="<%= rs.getString("degree_level") %>" name="level" ></td>
				<td><input value="<%= rs.getInt("total_units")%>" name="units" ></td>
				<td><input value="<%= rs.getInt("department_id")%>" name="department-id" ></td>
				<td><input type="submit" value="Update"></td>
			</form>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="delete" name="action">
				<input hidden value="<%= rs.getString("degree_name") %>" name="name" >
				<input hidden value="<%= rs.getString("degree_level") %>" name="level" >
				<td><input type="submit" value="Delete"></td>
			</form>
		</tr>
		<tr>
			<td></td>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="add-member" name="action">
				<input type="hidden" value="<%= rs.getString("degree_name") %>"
				name="name">
				<input type="hidden" value="<%= rs.getString("degree_level") %>"
					name="level">					
				<td><input value="" name="category"></td>
				<td><input type="submit" value="Add Category"></td>
			</form>
			<%
				ResultSet rs2 = stmt2.executeQuery("SELECT * FROM DegreeCategoryReq WHERE degree_name = \'" 
			+ rs.getString("degree_name") + "' AND degree_level = '" + rs.getString("degree_level") + "'" );
				while (rs2.next()){
			%>
				<form action=<%= page_path %> method="post">
					<input type="hidden" value="remove-member" name="action">
					<input type="hidden" value="<%= rs.getString("degree_name") %>"
				name="name">	
					<input type="hidden" value="<%= rs.getString("degree_level") %>"
					name="level">				
					<td><input value="<%= rs2.getString("category_name")%>" name="category"></td>
					<td><input type="submit" value="Remove"></td>
				</form>
			<%				
				}
			%>	

		</tr>
		<tr>
			<td></td>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="add-member-2" name="action">
				<input type="hidden" value="<%= rs.getString("degree_name") %>"
				name="name">
				<input type="hidden" value="<%= rs.getString("degree_level") %>"
					name="level">					
				<td><input value="" name="concentration"></td>
				<td><input type="submit" value="Add Concentration"></td>
			</form>
			<%
				rs2 = stmt2.executeQuery("SELECT * FROM DegreeConcentrationReq WHERE degree_name = \'" 
			+ rs.getString("degree_name") + "' AND degree_level = '" + rs.getString("degree_level") + "'" );
				while (rs2.next()){
			%>
				<form action=<%= page_path %> method="post">
					<input type="hidden" value="remove-member-2" name="action">
					<input type="hidden" value="<%= rs.getString("degree_name") %>"
				name="name">	
					<input type="hidden" value="<%= rs.getString("degree_level") %>"
					name="level">				
					<td><input value="<%= rs2.getString("concentration_name")%>" name="concentration"></td>
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