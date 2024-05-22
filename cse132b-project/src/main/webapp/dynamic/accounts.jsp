<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
	String page_title = "Student Accounts";
	String page_path = "accounts.jsp";
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
	
			String GET_QUERY = "SELECT * FROM StudentAccount order by student_id";
			String INSERT_QUERY = "INSERT INTO StudentAccount(balance, student_id) VALUES (?, ?)";
			String UPDATE_QUERY = "UPDATE StudentAccount set balance = ?, student_id = ? WHERE account_id = ?";
			String DEL_QUERY = "DELETE FROM StudentAccount WHERE account_id = ?";
			Connection connection = DriverManager.getConnection("jdbc:postgresql:cse132b?user=mwin&password=password7117");
			Statement stmt = connection.createStatement();
			Statement stmt2 = connection.createStatement();
			
			String action = request.getParameter("action");
			//Perform an Insert when insert button is pressed
			if (action != null && action.equals("insert")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);
				pstmt.setFloat(1, Float.parseFloat(request.getParameter("balance")));
				pstmt.setInt(2, Integer.parseInt(request.getParameter("student-id")));
				pstmt.executeUpdate();
				connection.commit();
				connection.setAutoCommit(true);
			}
			
			//Perform an Update
			if (action != null && action.equals("update")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY);
				pstmt.setFloat(1, Float.parseFloat(request.getParameter("balance")));
				pstmt.setInt(2, Integer.parseInt(request.getParameter("student-id")));
				pstmt.setInt(3, Integer.parseInt(request.getParameter("acc-id")));
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
			
			String ADD_MEMBER_QUERY = "INSERT INTO StudentAccountPayers(account_id, payer_name, payer_address) VALUES (?, ?, ?)";
			if (action != null && action.equals("add-member")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(ADD_MEMBER_QUERY);
				pstmt.setInt(1, Integer.parseInt(request.getParameter("acc-id")));
				pstmt.setString(2, request.getParameter("name"));
				pstmt.setString(3, request.getParameter("address"));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
			
			String REMOVE_MEMBER_QUERY = "DELETE FROM StudentAccountPayers WHERE payer_name = ? AND account_id = ?";
			if (action != null && action.equals("remove-member")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(REMOVE_MEMBER_QUERY);
				pstmt.setString(1, request.getParameter("name"));
				pstmt.setInt(2, Integer.parseInt(request.getParameter("acc-id")));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			} 
		
		%>
	<table>
		<!--  Headers -->
		<tr>
			<th>Account ID</th>
			<th>Student ID</th>
			<th>Balance</th>
		</tr>
		<!-- Insert Tuple -->
		<tr>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="insert" name="action">	
				<td></td>
				<td><input value="" name="student-id"></td>
				<td><input value="" name="balance"></td>
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
				<td><input value="<%= rs.getInt("account_id") %>" name="acc-id" readonly></td>
				<td><input value="<%= rs.getInt("student_id") %>" name="student-id"></td>
				<td><input value="<%= rs.getFloat("balance") %>" name="balance"></td>
				<td><input type="submit" value="Update"></td>
			</form>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="delete" name="action">
				<input type="hidden" value="<%= rs.getInt("account_id") %>" name="id">
				<td><input type="submit" value="Delete"></td>
			</form>
			<form action="transactions.jsp" method="get">
				<input type="hidden" value="<%= rs.getInt("account_id") %>" name="acc-id">
				<td><input type="submit" value="Transactions"></td>
			</form>
		</tr>
		<tr>
			<td></td>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="add-member" name="action">
				<input type="hidden" value="<%= rs.getInt("account_id") %>"
				name="acc-id">				
				<td><input value="" name="name" placeholder="Name"></td>
				<td><input value="" name="address" placeholder="Address"></td>
				<td><input type="submit" value="Add Payer"></td>
			</form>
			<%
				ResultSet rs2 = stmt2.executeQuery("SELECT * FROM StudentAccountPayers WHERE account_id = " + rs.getInt("account_id"));
				while (rs2.next()){
			%>
				<form action=<%= page_path %> method="post">
					<input type="hidden" value="remove-member" name="action">
					<input type="hidden" value="<%= rs.getInt("account_id") %>"
				name="acc-id">				
					<td><input value="<%= rs2.getString("payer_name")%>" name="name" placeholder="Name"></td>
				<td><input value="<%= rs2.getString("payer_address")%>" name="address" placeholder="Address"></td>
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