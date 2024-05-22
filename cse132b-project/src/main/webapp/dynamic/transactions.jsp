<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
	
	String page_title = "Transactions";
	String page_path = "transactions.jsp";
%>
<title><%= page_title %></title>
</head>

<body>
	<%@ page language="java" import="java.sql.*" %>
	<% 	try{
		String id = request.getParameter("acc-id");
		if (id == null){
			throw new Exception("Invalid Account ID");
		}
		int accId = Integer.parseInt(id);
	%>
	<jsp:include page="/static/navbar.html" />
	<h1><%= page_title %> For Account Number <%= accId %></h1>
	<% 
			
			DriverManager.registerDriver(new org.postgresql.Driver());
	
			String GET_QUERY = "SELECT * FROM AccountTransactions WHERE account_id = " + accId;
			String INSERT_QUERY = "INSERT INTO AccountTransactions(account_id, amount, message) VALUES (?, ?, ?)";
			String UPDATE_QUERY = "UPDATE AccountTransactions SET amount = ?, message = ? WHERE account_id = ? AND transaction_id = ?";
			String DEL_QUERY = "DELETE FROM AccountTransactions WHERE account_id = ? AND transaction_id = ?";
			Connection connection = DriverManager.getConnection("jdbc:postgresql:cse132b?user=mwin&password=password7117");
			Statement stmt = connection.createStatement();
		
			String action = request.getParameter("action");
			//Perform an Insert when insert button is pressed
			if (action != null && action.equals("insert")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);
				pstmt.setInt(1, accId);
				pstmt.setFloat(2, Float.parseFloat(request.getParameter("amount")));
				pstmt.setString(3, request.getParameter("message"));
				pstmt.executeUpdate();
				connection.commit();
				connection.setAutoCommit(true);
			}
			
			//Perform an UPDATE when update is pressed
			if (action != null && action.equals("update")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY);
				pstmt.setFloat(1, Float.parseFloat(request.getParameter("amount")));
				pstmt.setString(2, request.getParameter("message"));
				pstmt.setInt(3, accId);
				pstmt.setInt(4, Integer.parseInt(request.getParameter("t-id")));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
			
			//Perform a DELETE when delete is pressed
			if (action != null && action.equals("delete")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(DEL_QUERY);
				pstmt.setInt(1, accId);
				pstmt.setInt(2, Integer.parseInt(request.getParameter("t-id")));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
		
		
		%>
	<table>
		<!--  Headers -->
		<tr>
			<th>Account ID</th>
			<th>Transaction ID</th>
			<th>Amount</th>
			<th>Message</th>
		</tr>
		<!-- Insert Tuple -->
		<tr>
			<form action=<%= page_path %> method="get">
				<input type="hidden" value="insert" name="action">	
				<input type="hidden" value="<%= accId %>" name="acc-id">
				<td></td>
				<td></td>
				<td><input value="" name="amount" ></td>
				<td><input value="" name="message" ></td>
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
				<input type="hidden" value="update" name="action">	
				<td><input value="<%= accId %>" name="acc-id" readonly></td>
				<td><input value="<%= rs.getInt("transaction_id") %>" name="t-id" readonly></td>
				<td><input value="<%= rs.getFloat("amount")%>" name="amount"></td>
				<td><input value="<%= rs.getString("message") %>" name="message"></td>
				<td><input type="submit" value="Update"></td>
			</form>
			<form action=<%= page_path %> method="get">
				<input type="hidden" value="delete" name="action">
				<input type="hidden" value="<%= accId %>" name="acc-id">
				<input type="hidden" value="<%= rs.getInt("transaction_id") %>"
				name="t-id">
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
		<a href="accounts.jsp">Back To Accounts Page</a>
	<%	
	}
	%>


</body>
</html>