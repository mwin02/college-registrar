<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Locale"%>
<%@page import="java.time.format.TextStyle"%>
<%@page import="java.time.DayOfWeek"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.util.Arrays"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Queries : Reports 2</title>
<style>
table, th, td {
  border: 1px solid black;
  border-collapse: collapse;
  padding-left: 10px;
  padding-right:10px;
}
</style>
</head>

<body>
	<%@ page language="java" import="java.sql.*" %>
	<% 	
	Connection connection = null;
	Statement stmt = null;
	Statement stmt2 = null;
	ResultSet rs = null;
	ResultSet rs2 = null;
	
	try{
	%>
	<jsp:include page="/static/navbar.html" />
	<h1>Reports Two</h1>
	<% 
			String currentQuarter = "SPRING 2018";
	
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection("jdbc:postgresql:cse132b?user=mwin&password=password7117");
			stmt = connection.createStatement();
			stmt2 = connection.createStatement();
			
			String curStudentSSN = "";

			int curSectionID = -1;
			LocalDate startDate; 
			LocalDate endDate; 
			ArrayList<String> weekdays = new ArrayList<String>();
			ArrayList<String> dates = new ArrayList<String>();
		
			String action = request.getParameter("action");
			
			
			if (action != null && action.equals("class")) {
				curStudentSSN = request.getParameter("student-ssn");
			}
			if (action != null && action.equals("review")) {
				curSectionID = Integer.parseInt(request.getParameter("section-id"));
				startDate = LocalDate.parse(request.getParameter("start-date"));
				endDate = LocalDate.parse(request.getParameter("end-date"));
				
				while (startDate.isBefore(endDate)) {
					DayOfWeek day = startDate.getDayOfWeek();
					String dow = day.getDisplayName(TextStyle.SHORT, Locale.ENGLISH);
					dow = dow.toUpperCase();
					weekdays.add(dow);
					dates.add(startDate.toString());
					startDate = startDate.plusDays(1);
				}
				System.out.println(weekdays);
				System.out.println(dates);
			}
			
			
			String CUR_STUDENT_QUERY = "SELECT s.* FROM Student s, Attendence a WHERE s.student_id = a.student_id AND a.quarter = 'SPRING 2018' ";
			String GET_CLASS_QUERY = "SELECT c.*, e.grading_option, e.credits_earned FROM student s, class c, enrollment e WHERE s.ssn = '" + curStudentSSN
					+ "' AND e.student_id = s.student_id AND c.section_id = e.section_id AND e.enrollment_status = 'ENROLLED' AND c.quarter = 'SPRING 2018'";
			String AVAILABLE_CLASS_QUERY = "SELECT class.section_id, class.class_title, class.course_id, class.faculty_name FROM class class WHERE class.quarter = 'SPRING 2018'";
			String CONFLICT_CLASS_QUERY = "WITH enrolledClassTimes as (SELECT c.section_id, c.class_title, c.course_id, m.day_of_week, m.start_hour, m.end_hour FROM student s, class c, enrollment e, meeting m WHERE s.ssn = '" + 
			curStudentSSN + "' AND e.student_id = s.student_id AND c.section_id = e.section_id AND e.enrollment_status = 'ENROLLED' AND c.quarter = 'SPRING 2018' AND m.section_id = c.section_id) SELECT class.section_id, class.class_title, class.course_id, ec.section_id as conflict_id, ec.class_title as conflict_title, ec.course_id as conflict_course FROM class class, meeting m, enrolledClassTimes ec WHERE class.quarter = 'SPRING 2018' and m.section_id = class.section_id AND class.section_id != ec.section_id AND m.day_of_week = ec.day_of_week AND (m.start_hour BETWEEN ec.start_hour AND ec.end_hour OR m.end_hour BETWEEN ec.start_hour AND ec.end_hour) GROUP BY class.section_id, class.class_title, class.course_id, ec.section_id, ec.class_title, ec.course_id";
	
			String SECTIONS_QUERY = "SELECT class.*, course.course_number FROM class class, course course WHERE class.quarter = 'SPRING 2018' AND class.course_id=course.course_id";
			String FREE_REVIEW_TIMES = "WITH studentList as (SELECT s.student_id FROM student s, class c, enrollment e WHERE s.student_id = e.student_id AND e.section_id = c.section_id AND c.section_id = " + curSectionID + "), sectionList as (SELECT distinct c.section_id FROM studentList s, class c, enrollment e WHERE s.student_id = e.student_id AND c.section_id = e.section_id), meetingTimes as (SELECT m.section_id, m.day_of_week, m.start_hour, m.end_hour FROM meeting m WHERE m.section_id in (SELECT section_id FROM sectionList)) SELECT rt.* FROM REVIEW_TIMES rt WHERE NOT EXISTS (SELECT * FROM meetingTimes mt WHERE rt.day_of_week = mt.day_of_week AND ((rt.start_hour >= mt.start_hour AND rt.start_hour < mt.end_hour) OR (rt.end_hour > mt.start_hour AND rt.end_hour <= mt.end_hour)))";
	
	%>
	
	<section>
		<h2>Student's Course Registration </h2>
		<form action="reports2.jsp" method="post">
			<label for="student-ssn">Enrolled Students:</label>
			<input type="hidden" value="class" name="action">
			<select name="student-ssn">
				<option value="none" selected disabled hidden>Select a Student</option>
			<%
				rs = stmt.executeQuery(CUR_STUDENT_QUERY);
				while (rs.next()) {
			%>
				<option value="<%= rs.getString("ssn")%>" ><%= rs.getString("ssn") %> | <%= rs.getString("first_name") %> 
				 <%= rs.getString("middle_name") %> <%= rs.getString("last_name") %>
				</option>
			<%
				}
			%>
			</select>
			<input type="submit" value="Find Classes">
		</form>
		
	
		<%
			if (curStudentSSN != ""){
		%>
		<h2>Student SSN: <%=curStudentSSN %></h2>
		<h3>Currently Enrolled Classes</h3>
		<table>
			<!--  Headers -->
			<tr>
				<th>Course ID</th>
				<th>Session ID</th>
				<th>Quarter</th>
				<th>Class Title</th>
				<th>Enrollment Limit</th>
				<th>Instructor</th>
				<th>Grading Options</th>
				<th>Units</th>
			</tr>
		
		<%
				rs.close();
				rs = stmt.executeQuery(GET_CLASS_QUERY);
				while (rs.next()){	
					
		%>
			<!-- Display Tuples -->
			<tr>
				<td><%= rs.getInt("course_id")%></td>
				<td><%= rs.getInt("section_id")%></td>
				<td><%= rs.getString("quarter")%></td>
				<td><%= rs.getString("class_title")%></td>
				<td><%= rs.getInt("enrollment_limit")%></td>
				<td><%= rs.getString("faculty_name")%></td>
				<td><%= rs.getString("grading_option")%></td>
				<td><%= rs.getInt("credits_earned")%></td>
			</tr>

		<%		}
				
		%>
		</table>
		<h3>Courses Offered</h3>
		<table>
			<tr>
				<th>Course ID</th>
				<th>Section ID</th>
				<th>Class Title</th>
				<th>Instructor</th>
			</tr>
			
		<%
			rs.close();
			rs = stmt.executeQuery(AVAILABLE_CLASS_QUERY);
			while (rs.next())  {
		%>
			<tr>
				<td><%= rs.getInt("course_id") %></td>
				<td><%= rs.getInt("section_id") %></td>
				<td><%= rs.getString("class_title") %></td>
				<td><%= rs.getString("faculty_name") %></td>
			</tr>
		<%						
			}
		%>
		</table>
		<h3>Courses With Conflict</h3>
		<table>
			<tr>
				<th>Section ID</th>
				<th>Course ID</th>
				<th>Class Title</th>
				<th>Conflicting Section ID</th>
				<th>Conflicting Course ID</th>
				<th>Conflicting Class Title</th>
			</tr>
			
		<%
			rs.close();
			rs = stmt.executeQuery(CONFLICT_CLASS_QUERY);
			while (rs.next())  {
		%>
			<tr>
				<td><%= rs.getInt("section_id") %></td>
				<td><%= rs.getInt("course_id") %></td>
				<td><%= rs.getString("class_title") %></td>
				<td><%= rs.getInt("conflict_id") %></td>
				<td><%= rs.getInt("conflict_course") %></td>
				<td><%= rs.getString("conflict_title") %></td>
			</tr>
		<%						
			}
		%>
		</table>
		
			
		<%
		} %>
	</section>
	
	<section>
		<h2>Review Session Scheduler</h2>
		<form action="reports2.jsp" method="post">
			<label for="student-ssn">Sections:</label>
			<input type="hidden" value="review" name="action">
			<select name="section-id">
				<option value="none" selected disabled hidden>Select a Section</option>
			<%
				rs = stmt.executeQuery(SECTIONS_QUERY);
				while (rs.next()) {
			%>
				<option value="<%= rs.getInt("section_id")%>" ><%= rs.getInt("section_id") %> | <%= rs.getString("course_number") %> 
				</option>
			<%
				}
			%>
			</select>
			<label for="start-date">Starting Date:</label>
			<input value="" name="start-date" />
			<label for="end-date">Ending Date:</label>
			<input value="" name="end-date" />
			<input type="submit" value="Find Classes">
		</form>

		<%
			if (curSectionID != -1) {
		%>
		<h3>Section: <%= curSectionID %></h3>
		<h3>Available Times For Review</h3>
		<table>
		<tr>
			<th>Date</th>
			<th>Available Times</th>
		</tr>
		<%
				rs.close();
				rs = stmt.executeQuery(FREE_REVIEW_TIMES);
				HashMap<String, ArrayList<String>> times = new HashMap<String, ArrayList<String>>();
				while (rs.next()){
					String dayOfWeek = rs.getString("day_of_week");
					String parsedTime = rs.getTime("start_hour") + " - " + rs.getTime("end_hour");
					if (times.get(dayOfWeek) == null){
						ArrayList<String> temp = new ArrayList<String>();
						temp.add(parsedTime);
						times.put(dayOfWeek, temp);
					} else {
						times.get(dayOfWeek).add(parsedTime);
					}
				}
				for (int i = 0; i < weekdays.size(); i ++) {
					
		%>
			<tr>
				<td><%= dates.get(i) %>, <%= weekdays.get(i) %></td>
				<%
					ArrayList<String> timeSlots = times.get(weekdays.get(i));
					for (String slot : timeSlots) {
				%>
					<td><%= slot %></td>
				<%
						
					}
				%>
				
			</tr>
		<% 			
		
				}
			}
		%>
		</table>
	</section>
	
	<%
	}  catch (Exception e){
	%>
		<h1>Something Went Wrong</h1>
		<p> <%= e %> </p>]
		<a href="reports2.jsp">Back To Reports Page</a>
	<% 
	} finally {
		if (rs != null) {
			rs.close();			
		}
		if (rs2 != null) {
			rs2.close();			
		}
		if (stmt != null) {
			stmt.close();
		}
		if (stmt2 != null) {
			stmt.close();
		}
		if (connection != null) {		
			connection.close();
		}
		
	}
	
	%>




</body>
</html>