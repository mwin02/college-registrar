<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	<%@ page import="java.time.LocalTime" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
	
	String page_title = "Meetings";
	String page_path = "meeting.jsp";
%>
<title><%= page_title %></title>
</head>

<body>
	<%!
		public Time getTimeOf(String timeString){
			String[] timeArray = timeString.split("[:]", 0);
			LocalTime startTime = LocalTime.of( Integer.parseInt(timeArray[0]) , Integer.parseInt(timeArray[1]) );
			return Time.valueOf(startTime);
		}
	%>
	
	<%@ page language="java" import="java.sql.*" %>
	<% 	try{
		String id = request.getParameter("section-id");
		if (id == null){
			throw new Exception("Invalid Section ID");
		}
		int sectionID = Integer.parseInt(id);
	%>
	<jsp:include page="/static/navbar.html" />
	<h1><%= page_title %> Scheduled For Section With ID <%= sectionID %></h1>
	<% 
	
			

			DriverManager.registerDriver(new org.postgresql.Driver());
	
			String GET_QUERY = "SELECT * FROM Meeting WHERE section_id = " + sectionID + " order by building, room_number, day_of_week, start_hour";
			/* (building, room_number, day_of_week, start_hour, end_hour, quarter) */
			String INSERT_QUERY = "INSERT INTO Meeting(section_id, building, room_number, day_of_week, start_hour, end_hour, quarter, " 
			+ "meeting_type, is_mandatory) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
			String UPDATE_QUERY = "UPDATE Meeting SET meeting_type = ?, is_mandatory = ?, building = ?, " + 
			"room_number = ?, day_of_week = ?, start_hour = ?, end_hour = ?, quarter = ? WHERE meeting_id = ?";
			String DEL_QUERY = "DELETE FROM Meeting WHERE meeting_id = ?";
			Connection connection = DriverManager.getConnection("jdbc:postgresql:cse132b?user=mwin&password=password7117");
			Statement stmt = connection.createStatement();
		
			String action = request.getParameter("action");
			//Perform an Insert when insert button is pressed
			if (action != null && action.equals("insert")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);
				pstmt.setInt(1, sectionID);
				pstmt.setString(2, request.getParameter("building"));
				pstmt.setInt(3, Integer.parseInt(request.getParameter("room")));
				pstmt.setString(4, request.getParameter("day"));
				pstmt.setTime(5, getTimeOf(request.getParameter("start")));
				pstmt.setTime(6, getTimeOf(request.getParameter("end")));
				pstmt.setString(7, request.getParameter("quarter"));
				pstmt.setString(8, request.getParameter("type"));
				pstmt.setString(9, request.getParameter("mandatory"));
				pstmt.executeUpdate();
				connection.commit();
				connection.setAutoCommit(true);
			}
			
			//Perform an UPDATE when update is pressed
			if (action != null && action.equals("update")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY);
				pstmt.setString(1, request.getParameter("type"));
				pstmt.setString(2, request.getParameter("mandatory"));
				pstmt.setString(3, request.getParameter("building"));
				pstmt.setInt(4, Integer.parseInt(request.getParameter("room")));
				pstmt.setString(5, request.getParameter("day"));
				pstmt.setTime(6, getTimeOf(request.getParameter("start")));
				pstmt.setTime(7, getTimeOf(request.getParameter("end")));
				pstmt.setString(8, request.getParameter("quarter"));
				pstmt.setInt(9, Integer.parseInt(request.getParameter("meeting-id")));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
			
			//Perform a DELETE when delete is pressed
			if (action != null && action.equals("delete")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(DEL_QUERY);
				pstmt.setInt(1, Integer.parseInt(request.getParameter("meeting-id")));
				int rowCount = pstmt.executeUpdate();
				connection.setAutoCommit(false);
				connection.setAutoCommit(true);
			}
		
		
		%>
	<table>
		<!--  Headers -->
		<tr>
			<th>Section ID</th>
			<th>Meeting ID</th>
			<th>Building</th>
			<th>Room #</th>
			<th>Day</th>
			<th>Start Time</th>
			<th>End Time</th>
			<th>Quarter</th>
			<th>Meeting Type</th>
			<th>Mandatory</th>
			
		</tr>
		<!-- Insert Tuple -->
		<tr>
			<form action=<%= page_path %> method="get">
				<input type="hidden" value="insert" name="action">	
				<input type="hidden" value="<%= sectionID %>" name="section-id">
				<td></td>
				<td></td>
				<td><input value="" name="building" ></td>
				<td><input value="" name="room" ></td>
				<td><input value="" name="day" ></td>
				<td><input value="" name="start" ></td>
				<td><input value="" name="end" ></td>
				<td><input value="" name="quarter" ></td>
				<td><input value="" name="type" ></td>
				<td><input value="" name="mandatory" ></td>
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
				<td><input value="<%= sectionID %>" name="section-id" readonly></td>
				<td><input value="<%= rs.getInt("meeting_id") %>" name="meeting-id" readonly></td>
				<td><input value="<%= rs.getString("building") %>" name="building" ></td>
				<td><input value="<%= rs.getInt("room_number") %>" name="room" ></td>
				<td><input value="<%= rs.getString("day_of_week") %>" name="day" ></td>
				<td><input value="<%= rs.getTime("start_hour") %>" name="start" ></td>
				<td><input value="<%= rs.getTime("end_hour") %>" name="end" ></td>
				<td><input value="<%= rs.getString("quarter") %>" name="quarter" ></td>
				<td><input value="<%= rs.getString("meeting_type") %>" name="type" ></td>
				<td><input value="<%= rs.getString("is_mandatory") %>" name="mandatory" ></td>
				<td><input type="submit" value="Update"></td>
			</form>
			<form action=<%= page_path %> method="get">
				<input type="hidden" value="delete" name="action">
				<input type="hidden" value="<%= sectionID %>" name="section-id">
				<input type="hidden" value="<%= rs.getInt("meeting_id") %>" name="meeting-id">
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
		<a href="classes.jsp">Back To Classes Page</a>
	<%	
	}
	%>


</body>
</html>