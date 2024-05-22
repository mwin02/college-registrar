<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Queries : Reports 1</title>
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
	<h1>Reports One</h1>
	<% 
			String currentQuarter = "SPRING 2018";
	
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection("jdbc:postgresql:cse132b?user=mwin&password=password7117");
			stmt = connection.createStatement();
			stmt2 = connection.createStatement();
			
			//report 1a
			String curStudentSSN = "";
			
			//report 1b
			String curClassTitle = "";
			String curClassQuarter = "";
			
			//report 1c
			String curGradeReportSSN = "";
			
			//report 1d
			String curDegreeSSN = "";
			String curDegreeName = "";
			String curDegreeLevel = "";
			
			//report 1e
			String curMDegreeSSN = "";
			String curMDegreeName = "";
			String curMDegreeLevel = "";
			
		
			String action = request.getParameter("action");
			
			
			if (action != null && action.equals("class")) {
				curStudentSSN = request.getParameter("student-ssn");
			}
			if (action != null && action.equals("roster")) {
				String[] classString = request.getParameter("class").split("[,]", 0);
				curClassTitle = classString[0];
				curClassQuarter = classString[1];
			}
			if (action != null && action.equals("grade")) {
				curGradeReportSSN = request.getParameter("student-ssn");
			}
			if (action != null && action.equals("degree")) {
				curDegreeSSN = request.getParameter("student-ssn");
				String[] degreeString = request.getParameter("degree").split("[,]", 0);
				curDegreeName = degreeString[0];
				curDegreeLevel = degreeString[1];
			}
			if (action != null && action.equals("degree-2")) {
				curMDegreeSSN = request.getParameter("student-ssn");
				String[] degreeString = request.getParameter("degree").split("[,]", 0);
				curMDegreeName = degreeString[0];
				curMDegreeLevel = degreeString[1];
			}
			
			String CUR_STUDENT_QUERY = "SELECT s.* FROM Student s, Attendence a WHERE s.student_id = a.student_id AND a.quarter = 'SPRING 2018' ";
			String GET_CLASS_QUERY = "SELECT c.*, e.grading_option, e.credits_earned FROM student s, class c, enrollment e WHERE s.ssn = '" + curStudentSSN
					+ "' AND e.student_id = s.student_id AND c.section_id = e.section_id AND e.enrollment_status = 'ENROLLED' AND c.quarter = 'SPRING 2018'";
			
			String CLASSES_QUERY = "SELECT c.class_title, q.quarter FROM Class c, QUARTER_CONVERSION q WHERE c.quarter = q.quarter" + 
			" GROUP BY c.class_title, q.quarter, q.num ORDER BY c.class_title, q.num ";
			String CLASS_ROSTER_QUERY = "SELECT s.*, e.grading_option, e.credits_earned FROM student s, class c, enrollment e WHERE c.class_title ='" + curClassTitle     
					+ "' AND c.quarter = '" + curClassQuarter + "' AND e.student_id = s.student_id AND e.section_id = c.section_id";
		
			
			String STUDENTS_QUERY = "SELECT * FROM STUDENT s WHERE EXISTS (select * from attendence a where a.student_id = s.student_id)";
			String CUMULUTAIVE_GPA_QUERY = "SELECT avg(g.NUMBER_GRADE) as gpa FROM student s, enrollment e, GRADE_CONVERSION g WHERE " 
			+ " s.ssn = '" + curGradeReportSSN + "' AND e.student_id = s.student_id AND g.LETTER_GRADE = e.grade";
			String STUDENT_QUARTER_QUERY = "SELECT c.quarter as quarter, avg(g.NUMBER_GRADE) as gpa FROM student s, class c, enrollment e, GRADE_CONVERSION g, QUARTER_CONVERSION qc " + 
			"WHERE s.ssn = '" + curGradeReportSSN +"' AND e.student_id = s.student_id AND c.section_id = e.section_id AND g.LETTER_GRADE = e.grade AND qc.quarter = c.quarter GROUP BY " + 
			" c.quarter, qc.num ORDER BY qc.num";
	%>
	
	<section>
		<h2>Student's Enrolled Classes</h2>
		<form action="reports1.jsp" method="post">
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
			<h3>Student SSN: <%= curStudentSSN %></h3>
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
			} %>
		</table>
	</section>

	<section>
		<h2>Class Rosters</h2>
		<form action="reports1.jsp" method="post">
			<label for="section-id">Class:</label>
			<input type="hidden" value="roster" name="action">
			<select name="class">
				<option value="none" selected disabled hidden>Select an Class</option>
			<%
				
				rs = stmt.executeQuery(CLASSES_QUERY);
				while (rs.next()) {
			%>
				<option value="<%= rs.getString("class_title")%>,<%= rs.getString("quarter") %>" ><%= rs.getString("class_title") %> | <%= rs.getString("quarter") %> </option>
			<%
				}
			%>
			</select>
			<input type="submit" value="Get Roster">
		</form>
		
	
		<%
			if (curClassTitle != "" && curClassQuarter != ""){
				
		%>
			<h3>Class: <%= curClassTitle %> &emsp; Quarter: <%= curClassQuarter %></h3>
			<table>
			<!--  Headers -->
			<tr>
				<th>Student ID</th>
				<th>First Name</th>
				<th>Middle Name</th>
				<th>Last Name</th>
				<th>SSN</th>
				<th>Residency</th>
				<th>Grading Options</th>
				<th>Units</th>
			</tr>
		
		<%
				rs.close();
				System.out.println(CLASS_ROSTER_QUERY);
				rs = stmt.executeQuery(CLASS_ROSTER_QUERY);
				while (rs.next()){		
		%>
			<!-- Display Tuples -->
			<tr>
				<td><%= rs.getInt("student_id")%></td>
				<td><%= rs.getString("first_name")%></td>
				<td><%= rs.getString("middle_name")%></td>
				<td><%= rs.getString("last_name")%></td>
				<td><%= rs.getString("ssn")%></td>
				<td><%= rs.getString("residency")%></td>
				<td><%= rs.getString("grading_option")%></td>
				<td><%= rs.getInt("credits_earned")%></td>
			</tr>
		<%		}
			} %>
		</table>
	</section>
	
	<section>
		<h2>Grade Report</h2>
		<form action="reports1.jsp" method="post">
			<label for="student-ssn">Student:</label>
			<input type="hidden" value="grade" name="action">
			<select name="student-ssn">
				<option value="none" selected disabled hidden>Select an Student</option>
			<%
				rs.close();
				rs = stmt.executeQuery(STUDENTS_QUERY);
				while (rs.next()) {
			%>
				<option value="<%= rs.getString("ssn")%>"> <%= rs.getString("ssn") %> | <%= rs.getString("first_name") %> 
				<%= rs.getString("middle_name") %> <%= rs.getString("last_name") %>
				</option>
			<%
				}
			%>
			</select>
			<input type="submit" value="Get Grade Report">
		</form>
		
	
		<%
			if (curGradeReportSSN != ""){
				rs.close();
				rs = stmt.executeQuery(CUMULUTAIVE_GPA_QUERY);
				rs.next();
				float cumGpa = rs.getFloat("gpa");
				rs.close();
				rs = stmt.executeQuery("SELECT * from student where ssn = '" + curGradeReportSSN + "' ");
				rs.next();
		%>
			<h3>Student: <%= rs.getString("first_name") %> <%= rs.getString("middle_name") %> <%= rs.getString("last_name") %>
				GPA:  <%= cumGpa %> 
			</h3>
		<%
				rs.close();
				rs = stmt.executeQuery(STUDENT_QUARTER_QUERY);
				while (rs.next()) {
		%>
			<h4><%= rs.getString("quarter") %> GPA: <%= rs.getFloat("gpa") %></h4> 
			<table>
			<!--  Headers -->
			<tr>
				<th>Class Title</th>
				<th>enrollment_status</th>
				<th>grade</th>
				<th>credits_earned</th>
			</tr>
		<%
					String QUARTER_CLASS_QUERY = "SELECT s.first_name, c.class_title, c.quarter, e.enrollment_status, e.grade," +
					"e.credits_earned FROM student s, class c, enrollment e WHERE s.ssn = '" + curGradeReportSSN + "' " +
					" AND e.student_id = s.student_id AND c.section_id = e.section_id AND c.quarter = '" + rs.getString("quarter") 
					+ "' ORDER BY c.quarter";
					rs2 = stmt2.executeQuery(QUARTER_CLASS_QUERY);
					while (rs2.next()){
						
		%>

			<!-- Display Tuples -->
			<tr>
				<td><%= rs2.getString("class_title")%></td>
				<td><%= rs2.getString("enrollment_status")%></td>
				<td><%= rs2.getString("grade")%></td>
				<td><%= rs2.getString("credits_earned")%></td>
			</tr>
		<%
					}
		%>
		</table>
		<%			
				
				}
			}
		%>
			
			
	</section>
	
	<section>
		<h2>Undergraduate Degree Requirements</h2>
		<form action="reports1.jsp" method="post">
			<label for="student-ssn">Student:</label>
			<input type="hidden" value="degree" name="action">
			<select name="student-ssn">
				<option value="none" selected disabled hidden>Select an Student</option>
			<%
				String UNDERGRAD_ENROLLED_STUDENTS_QUERY = "SELECT s.*, u.* from student s, UndergraduateStudent u " +
				"WHERE s.student_id = u.student_id AND EXISTS (select * from Attendence a where a.student_id = s.student_id);";
				rs = stmt.executeQuery(UNDERGRAD_ENROLLED_STUDENTS_QUERY);
				while (rs.next()) {
			%>
				<option value="<%= rs.getString("ssn")%>" ><%= rs.getString("ssn") %> | <%= rs.getString("first_name") %> 
				 <%= rs.getString("middle_name") %> <%= rs.getString("last_name") %>
				</option>
			<%
				}
			%>
			</select>
			<label for="degree">Degree:</label>
			<select name="degree">
				<option value="none" selected disabled hidden>Select an Degree</option>
			<%
				String UNDERGRAD_DEGREE_QUERY = "SELECT degree_name, degree_level from degree WHERE degree_level = 'BS'";
				rs = stmt.executeQuery(UNDERGRAD_DEGREE_QUERY);
				while (rs.next()) {
			%>
				<option value="<%= rs.getString("degree_name")%>,<%=rs.getString("degree_level") %>" > <%= rs.getString("degree_name")%> <%= rs.getString("degree_level") %> </option>
			<%
				}
			%>
			</select>
			<input type="submit" value="Get Roster">
		</form>
		
	
		<%
			if (curDegreeSSN != "" && curDegreeName != "" && curDegreeLevel != ""){
				rs.close();
				String UNITS_EARNED_QUERY = "SELECT sum(e.credits_earned) as units_earned FROM enrollment e, student s WHERE "
						 + " s.ssn = '" + curDegreeSSN + "' AND s.student_id = e.student_id AND e.enrollment_status = 'FINISHED'";
				rs = stmt.executeQuery(UNITS_EARNED_QUERY);
				rs.next();
				int unitEarned = rs.getInt("units_earned");
				
				rs.close();
				String GET_DEGREE_QUERY= "SELECT * from degree where degree_name = '" + curDegreeName
						+ "' AND degree_level = '"  + curDegreeLevel+ "'";
				rs = stmt.executeQuery(GET_DEGREE_QUERY);
				rs.next();
				int reqUnits = rs.getInt("total_units");

		%>
			<h3>Student SSN: <%= curDegreeSSN %> &emsp; Degree: <%= rs.getString("degree_name") %> <%= rs.getString("degree_level") %> &emsp;
			Required Units: <%= reqUnits %> &emsp; Units Achieved: <%= unitEarned %> &emsp; Units Remaining: <%= reqUnits - unitEarned %></h3>
			<h3>Degree Required Categories</h3>
			<table>
				<tr>
					<th>Category Name</th>
					<th>Units Required</th>
					<th>Units Earned</th>
					<th>Units Remaining</th>
				</tr>
		<%
			rs.close();
			String GET_CATEGORY_QUERY = "SELECT c.category_name as name, c.units_required FROM category c, DegreeCategoryReq req " + 
			"WHERE req.degree_name = '" + curDegreeName+ "' AND req.degree_level = '" + curDegreeLevel + "' AND req.category_name = c.category_name";
			rs = stmt.executeQuery(GET_CATEGORY_QUERY);

			
			while (rs.next()){
				int categoryUnits = rs.getInt("units_required");
		%>
			
		<%
			String UNITS_REQ_QUERY = "SELECT SUM(e.credits_earned) as total_units " +
					"FROM Student s, CategoryCourses courses, enrollment e, class class " +
					"WHERE s.ssn = '" +curDegreeSSN+ "' AND s.student_id = e.student_id AND courses.category_name = '"+ rs.getString("name")+ 
					"' AND class.section_id = e.section_id AND class.course_id = courses.course_id AND e.enrollment_status = 'FINISHED'";
			rs2 = stmt2.executeQuery(UNITS_REQ_QUERY);
			rs2.next();
			int unitsTaken = rs2.getInt("total_units");
			int unitsRemaining = Math.max(0, categoryUnits - unitsTaken);
		%>
				<tr>
					<td><%= rs.getString("name") %></td>
					<td><%= categoryUnits %></td>
					<td><%= unitsTaken %></td>
					<td><%= unitsRemaining %></td>
				</tr>
	<%
		}
	%>
	
	</table>
	
		<%
		} 
		%>

	</section>
	
	<section>
		<h2>Masters Student Degree Requirements</h2>
		<form action="reports1.jsp" method="post">
			<label for="student-ssn">Student:</label>
			<input type="hidden" value="degree-2" name="action">
			<select name="student-ssn">
				<option value="none" selected disabled hidden>Select a Student</option>
			<%
				rs.close();
				String MASTER_ENROLLED_STUDENTS_QUERY = "SELECT s.*, m.* from student s, MasterStudent m " +
				"WHERE s.student_id = m.grad_student_id AND EXISTS (select * from Attendence a where a.student_id = s.student_id);";
				rs = stmt.executeQuery(MASTER_ENROLLED_STUDENTS_QUERY);
				while (rs.next()) {
			%>
				<option value="<%= rs.getString("ssn")%>" ><%= rs.getString("ssn") %> | <%= rs.getString("first_name") %> 
				 <%= rs.getString("middle_name") %> <%= rs.getString("last_name") %>
				</option>
			<%
				}
			%>
			</select>
			<label for="degree">Degree:</label>
			<select name="degree">
				<option value="none" selected disabled hidden>Select an Degree</option>
			<%
				String MASTER_DEGREE_QUERY = "SELECT degree_name, degree_level from degree WHERE degree_level = 'MS'";
				rs = stmt.executeQuery(MASTER_DEGREE_QUERY);
				while (rs.next()) {
			%>
				<option value="<%= rs.getString("degree_name")%>,<%=rs.getString("degree_level") %>" > <%= rs.getString("degree_name")%> <%= rs.getString("degree_level") %> </option>
			<%
				}
			%>
			</select>
			<input type="submit" value="Get Roster">
		</form>
		
	
		<%
			if (curMDegreeSSN != "" && curMDegreeName != "" && curMDegreeLevel != ""){
				rs.close();
				String UNITS_EARNED_QUERY = "SELECT sum(e.credits_earned) as units_earned FROM enrollment e, student s WHERE "
						 + " s.ssn = '" + curMDegreeSSN + "' AND s.student_id = e.student_id AND e.enrollment_status = 'FINISHED'";
				rs = stmt.executeQuery(UNITS_EARNED_QUERY);
				rs.next();
				int unitEarned = rs.getInt("units_earned");
				
				rs.close();
				String GET_DEGREE_QUERY= "SELECT * from degree where degree_name = '" + curMDegreeName
						+ "' AND degree_level = '"  + curMDegreeLevel+ "'";
				rs = stmt.executeQuery(GET_DEGREE_QUERY);
				rs.next();
				int reqUnits = rs.getInt("total_units");

		%>
			<h3>Student SSN: <%= curMDegreeSSN %> &emsp; Degree: <%= rs.getString("degree_name") %> <%= rs.getString("degree_level") %> &emsp;
			Required Units: <%= reqUnits %> &emsp; Units Achieved: <%= unitEarned %> &emsp; Units Remaining: <%= reqUnits - unitEarned %></h3>
			<h3>Degree Required Categories</h3>
			<table>
				<tr>
					<th>Category Name</th>
					<th>Units Required</th>
					<th>Units Earned</th>
					<th>Units Remaining</th>
			</tr>
		<%
			rs.close();
			String GET_CATEGORY_QUERY = "SELECT c.category_name as name, c.units_required FROM category c, DegreeCategoryReq req " + 
			"WHERE req.degree_name = '" + curMDegreeName+ "' AND req.degree_level = '" + curMDegreeLevel + "' AND req.category_name = c.category_name";
			rs = stmt.executeQuery(GET_CATEGORY_QUERY);

			
			while (rs.next()){
				int categoryUnits = rs.getInt("units_required");
		%>
				<%
					String UNITS_REQ_QUERY = "SELECT SUM(e.credits_earned) as total_units " +
							"FROM Student s, CategoryCourses courses, enrollment e, class class " +
							"WHERE s.ssn = '" +curMDegreeSSN+ "' AND s.student_id = e.student_id AND courses.category_name = '"+ rs.getString("name")+ 
							"' AND class.section_id = e.section_id AND class.course_id = courses.course_id AND e.enrollment_status = 'FINISHED'";
					rs2 = stmt2.executeQuery(UNITS_REQ_QUERY);
					rs2.next();
					int unitsTaken = rs2.getInt("total_units");
					int unitsRemaining = Math.max(0, categoryUnits - unitsTaken);
				%>
				<tr>
					<td><%= rs.getString("name") %></td>
					<td><%= categoryUnits %></td>
					<td><%= unitsTaken %></td>
					<td><%= unitsRemaining %></td>
				</tr>
		<%
			}
			rs.close();
			String GET_CONCENTRATION_QUERY = "SELECT c.concentration_name, c.units_required, c.gpa_required FROM concentration c, DegreeConcentrationReq req WHERE " 
			+ "req.degree_name = '" + curMDegreeName + "' AND req.degree_level = '" + curMDegreeLevel +"' AND req.concentration_name = c.concentration_name";
			rs = stmt.executeQuery(GET_CONCENTRATION_QUERY);
		%>
			</table>
			<h3>Degree Required Concentrations</h3>
		<%
			while (rs.next()) {
				String concentrationName = rs.getString("concentration_name");
				int unitsRequired = rs.getInt("units_required");
				float gpaRequired = rs.getFloat("gpa_required");
				String CONCENTRATION_MET_INFO_QUERY = "SELECT SUM(e.credits_earned) as total_units, avg(g.NUMBER_GRADE) as gpa " +
						"FROM Student s, ConcentrationCourses courses, enrollment e, class class, GRADE_CONVERSION g " +
						"WHERE s.ssn = '"+curMDegreeSSN+"' AND s.student_id = e.student_id AND courses.concentration_name = '"+concentrationName+"' " + 
						"AND class.section_id = e.section_id AND class.course_id = courses.course_id AND e.enrollment_status = 'FINISHED' " +
						"AND e.grade != 'IN' AND (g.LETTER_GRADE = e.grade)";
				System.out.println(CONCENTRATION_MET_INFO_QUERY);
				rs2.close();
				rs2 = stmt2.executeQuery(CONCENTRATION_MET_INFO_QUERY);
				rs2.next();
				int unitsEarned = rs2.getInt("total_units");
				float gpaEarned = rs2.getFloat("gpa");
				boolean completed = (unitsEarned >= unitsRequired) && (gpaEarned >= gpaRequired);
				
		%>
				<p> <b><%= concentrationName %></b> &emsp; <%= (completed) ? "Complete" : "Incomplete" %> </p>
				<p> Units Required : <%= unitsRequired %> &emsp; GPA Required : <%= gpaRequired %> &emsp; 
				Units Achieved : <%= unitsEarned %> &emsp; GPA Achieved : <%= gpaEarned %> &emsp;</p>
		<%
				
			}
		%>
			<h3>Courses to Complete</h3>
			<table>
				<tr>
					<th>Course ID</th>
					<th>Course Number</th>
					<th>Upcoming Quarter</th>
				</tr>
				
				
		<%
			String INCOMPLETE_COURSES_QUERY = "WITH untaken_courses as (SELECT course_id FROM ConcentrationCourses c, DegreeConcentrationReq req WHERE req.degree_name = '" + curMDegreeName + 
			"' AND req.degree_level = '" + curMDegreeLevel + "' AND req.concentration_name = c.concentration_name EXCEPT SELECT c.course_id FROM Student s, enrollment e, " +
			" Class c WHERE s.ssn = '" + curMDegreeSSN +"' AND s.student_id = e.student_id AND e.section_id = c.section_id AND e.enrollment_status = 'FINISHED'), earliest_courses " + 
			"as (SELECT c.course_id, min(qc.NUM) as NUM FROM untaken_courses uc, class c, QUARTER_CONVERSION qc WHERE uc.course_id = c.course_id AND qc.quarter = c.quarter " + 
			" AND qc.NUM > 3 GROUP BY c.course_id) SELECT ec.course_id, c.course_number, qc.quarter FROM earliest_courses ec, QUARTER_CONVERSION qc, Course c WHERE ec.NUM = qc.NUM " + 
			"AND c.course_id = ec.course_id";
			System.out.println(INCOMPLETE_COURSES_QUERY);
			rs.close();
			rs = stmt.executeQuery(INCOMPLETE_COURSES_QUERY);
			while (rs.next()){
		%>
			<tr>
				<td><%=rs.getInt("course_id") %></td>
				<td><%=rs.getString("course_number") %></td>
				<td><%=rs.getString("quarter") %></td>
			</tr>
		<%
				
			}
		%>
			</table>
		
		<%
		
			
			
			} %> 

	</section>
	
	
	<%
	}  catch (Exception e){
	%>
		<h1>Something Went Wrong</h1>
		<p> <%= e %> </p>]
		<a href="reports1.jsp">Back To Reports Page</a>
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