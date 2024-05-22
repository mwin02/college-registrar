<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
	String page_title = "Students";
	String page_path = "students.jsp";
%>
<title><%= page_title %></title>
</head>

<body>
	<%@ page language="java" import="java.sql.*" %>

	<jsp:include page="/static/navbar.html" />
	<h1><%= page_title %></h1>

	<%!
		public PreparedStatement insertIntoStudent(Connection connection, HttpServletRequest request) throws SQLException{
			String INSERT_QUERY = "INSERT INTO Student ( first_name, middle_name, last_name, ssn, residency) VALUES (?, ?, ?, ?, ?)";
			PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY, Statement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, request.getParameter("first_name"));
			pstmt.setString(2, request.getParameter("middle_name"));
			pstmt.setString(3, request.getParameter("last_name"));
			pstmt.setString(4, request.getParameter("ssn"));
			pstmt.setString(5, request.getParameter("residency"));
			return pstmt;
		}
	
		public void updateStudent(PreparedStatement pstmt, HttpServletRequest request) throws SQLException {
			pstmt.setString(1, request.getParameter("first_name"));
			pstmt.setString(2, request.getParameter("middle_name"));
			pstmt.setString(3, request.getParameter("last_name"));
			pstmt.setString(4, request.getParameter("ssn"));
			pstmt.setString(5, request.getParameter("residency"));
			pstmt.setInt(6, Integer.parseInt(request.getParameter("id")));
		}
		
		public int insertIntoGradStudent(Connection connection, HttpServletRequest request) throws SQLException {
			PreparedStatement pstmt = insertIntoStudent(connection, request);
			String G_INSERT_QUERY = "INSERT INTO GraduateStudent (student_id, department_id) VALUES (?,?)";
			PreparedStatement pstmt2 = connection.prepareStatement(G_INSERT_QUERY);
			int studentID = 0;
			int rowCount = pstmt.executeUpdate();
	        if (rowCount == 0) {
	            throw new SQLException("Creating Student failed. Student Might Already Exist.");
	        }
	        try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
	            if (generatedKeys.next()) {
	            	studentID = generatedKeys.getInt(1);
	                pstmt2.setInt(1, generatedKeys.getInt(1));
					pstmt2.setInt(2, Integer.parseInt(request.getParameter("department-id")));
					pstmt2.executeUpdate();
	            }
	            else {
	                throw new SQLException("Creating user failed, no ID obtained.");
	            }
	        }
			return studentID;
		}
		
		public int updateGradStudent(Connection connection, HttpServletRequest request) throws SQLException {
			String UPDATE_QUERY = "UPDATE Student SET first_name = ?, middle_name = ?," + 
					"last_name = ?, ssn = ?, residency = ? WHERE student_id = ?";
			String G_UPDATE_QUERY = "UPDATE GraduateStudent SET department_id = ? where student_id = ?";
			PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY);
			updateStudent(pstmt, request);
			int rowCount = pstmt.executeUpdate();
			pstmt = connection.prepareStatement(G_UPDATE_QUERY);
			pstmt.setInt(1, Integer.parseInt(request.getParameter("department-id")));
			pstmt.setInt(2, Integer.parseInt(request.getParameter("id")));
			rowCount += pstmt.executeUpdate();
			return rowCount;
		}
		
	%>

	<% 	
	Connection connection = null;
	Statement stmt = null;
	ResultSet rs = null;
	
	try{
	%>

	<% 
			

	
			DriverManager.registerDriver(new org.postgresql.Driver());
	
			
			
			String UPDATE_QUERY = "UPDATE Student SET first_name = ?, middle_name = ?," + 
			"last_name = ?, ssn = ?, residency = ? WHERE student_id = ?";
			String DEL_QUERY = "DELETE FROM Student WHERE student_id = ?";
			connection = DriverManager.getConnection("jdbc:postgresql:cse132b?user=mwin&password=password7117");
			stmt = connection.createStatement();
			
			String action = request.getParameter("action");
			
			
			
			//Global Student Delete
			if (action != null && action.equals("delete")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(DEL_QUERY);
				pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
				int rowCount = pstmt.executeUpdate();
		        connection.commit();
				connection.setAutoCommit(true);
			}
			
			//Undergraduate Student Handling
			
			//Undergraduate Insert
			String UG_INSERT_QUERY = "INSERT INTO UndergraduateStudent (student_id, college, major, minor, in_bs_ms_program) VALUES (?,?,?,?,?)";
			if (action != null && action.equals("insert-ug")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt1 = insertIntoStudent(connection, request);
				PreparedStatement pstmt2 = connection.prepareStatement(UG_INSERT_QUERY);

				int rowCount = pstmt1.executeUpdate();
		        if (rowCount == 0) {
		            throw new SQLException("Creating Student failed. Student Might Already Exist.");
		        }
		        try (ResultSet generatedKeys = pstmt1.getGeneratedKeys()) {
		            if (generatedKeys.next()) {
		                pstmt2.setInt(1, generatedKeys.getInt(1));
						pstmt2.setString(2, request.getParameter("college"));
						pstmt2.setString(3, request.getParameter("major"));
						pstmt2.setString(4, request.getParameter("minor"));
						pstmt2.setString(5, request.getParameter("bs-ms"));
		            }
		            else {
		                throw new SQLException("Creating user failed, no ID obtained.");
		            }
		        }
		        pstmt2.executeUpdate();
				connection.commit();
				connection.setAutoCommit(true);
			}
			
			//Undergraduate Update
			String UG_UPDATE_QUERY = "UPDATE UndergraduateStudent SET college = ?, major = ?, minor = ?, in_bs_ms_program = ? where student_id = ?";
			if (action != null && action.equals("update-ug")) {
				connection.setAutoCommit(false);
				PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY);
				updateStudent(pstmt, request);
				int rowCount = pstmt.executeUpdate();
				pstmt = connection.prepareStatement(UG_UPDATE_QUERY);
				pstmt.setString(1, request.getParameter("college"));
				pstmt.setString(2, request.getParameter("major"));
				pstmt.setString(3, request.getParameter("minor"));
				pstmt.setString(4, request.getParameter("bs-ms"));
				pstmt.setInt(5, Integer.parseInt(request.getParameter("id")));
				rowCount += pstmt.executeUpdate();
		        if (rowCount == 0) {
		            throw new SQLException("Updating Student Failed.");
		        }
				connection.commit();
				connection.setAutoCommit(true);
			}

			
			//Masters Student Handling
			//MasterStudent Insert
			String M_INSERT_QUERY = "INSERT INTO MasterStudent(grad_student_id, five_year_enrollment_status) VALUES (?, ?)";
			if (action != null && action.equals("insert-m")) {
				connection.setAutoCommit(false);
				int studentID = insertIntoGradStudent(connection, request);
				PreparedStatement pstmt2 = connection.prepareStatement(M_INSERT_QUERY);
                pstmt2.setInt(1, studentID);
				pstmt2.setString(2, request.getParameter("five-year"));
				pstmt2.executeUpdate();
				connection.commit();
				connection.setAutoCommit(true);
			}
			
			//MasterStudent Update
			String M_UPDATE_QUERY = "UPDATE MasterStudent set five_year_enrollment_status = ? where grad_student_id = ?";
			if (action != null && action.equals("update-m")) {
				connection.setAutoCommit(false);
				int rowCount = updateGradStudent(connection, request);
				PreparedStatement pstmt = connection.prepareStatement(M_UPDATE_QUERY);
				pstmt.setString(1, request.getParameter("five-year"));
				pstmt.setInt(2, Integer.parseInt(request.getParameter("id")));
				rowCount += pstmt.executeUpdate();
		        if (rowCount == 0) {
		            throw new SQLException("Updating Student Failed.");
		        }
				connection.commit();
				connection.setAutoCommit(true);
			}
			
			//PHD Student Handling
			
			//PreCandidancyStudent Insert
			String PHD_INSERT_QUERY = "INSERT INTO PHDStudent(grad_student_id) VALUES (?)";
			String PC_INSERT_QUERY = "INSERT INTO PreCandidancyStudent(phd_student_id) VALUES (?)";
			if (action != null && action.equals("insert-pc")) {
				connection.setAutoCommit(false);
				int studentID = insertIntoGradStudent(connection, request);
				PreparedStatement pstmt2 = connection.prepareStatement(PHD_INSERT_QUERY);
                pstmt2.setInt(1, studentID);
				pstmt2.executeUpdate();
				pstmt2 = connection.prepareStatement(PC_INSERT_QUERY);
                pstmt2.setInt(1, studentID);
				pstmt2.executeUpdate();
				connection.commit();
				connection.setAutoCommit(true);
			}
			
			//PreCandidancyStudent Update
			if (action != null && action.equals("update-pc")) {
				connection.setAutoCommit(false);
				int rowCount = updateGradStudent(connection, request);
		        if (rowCount == 0) {
		            throw new SQLException("Updating Student Failed.");
		        }
				connection.commit();
				connection.setAutoCommit(true);
			}
			
			//PHDCandidateStudent Insert
			String C_INSERT_QUERY = "INSERT INTO PHDCandidateStudent(phd_student_id, faculty_advisor_name) VALUES (?, ?)";
			if (action != null && action.equals("insert-c")) {
				connection.setAutoCommit(false);
				int studentID = insertIntoGradStudent(connection, request);
				PreparedStatement pstmt2 = connection.prepareStatement(PHD_INSERT_QUERY);
                pstmt2.setInt(1, studentID);
				pstmt2.executeUpdate();
				pstmt2 = connection.prepareStatement(C_INSERT_QUERY);
                pstmt2.setInt(1, studentID);
                pstmt2.setString(2, request.getParameter("faculty"));
				pstmt2.executeUpdate();
				connection.commit();
				connection.setAutoCommit(true);
			}
			
			//PHDCandidateStudent Update
			String C_UPDATE_QUERY = "UPDATE PHDCandidateStudent set faculty_advisor_name = ? where phd_student_id = ?";
			if (action != null && action.equals("update-c")) {
				connection.setAutoCommit(false);
				int rowCount = updateGradStudent(connection, request);
				PreparedStatement pstmt = connection.prepareStatement(C_UPDATE_QUERY);
				pstmt.setString(1, request.getParameter("faculty"));
				pstmt.setInt(2, Integer.parseInt(request.getParameter("id")));
				rowCount += pstmt.executeUpdate();
		        if (rowCount == 0) {
		            throw new SQLException("Updating Student Failed.");
		        }
				connection.commit();
				connection.setAutoCommit(true);
			}
			
		
		
		%>
	<section>
		<h1>Attendence Records</h1>
		<form action="attendence.jsp" method="get">
				<input value="" name="student-id">
				<input type="submit" value="Get Attendence Records">
		</form>
	</section>
	<section>
	<h1>Undergraduate Student</h1>
	<table>
		<tr>
			<th>Student ID</th>
			<th>First Name</th>
			<th>Middle Name</th>
			<th>Last Name</th>
			<th>SSN</th>
			<th>Residency</th>
			<th>College</th>
			<th>Major</th>
			<th>Minor</th>
			<th>BS/MS Program</th>
		</tr>
		<tr>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="insert-ug" name="action">	
				<td></td>
				<td><input value="" name="first_name"></td>
				<td><input value="" name="middle_name"></td>
				<td><input value="" name="last_name"></td>
				<td><input value="" name="ssn"></td>
				<td><input value="" name="residency"></td>
				<td><input value="" name="college"></td>
				<td><input value="" name="major"></td>
				<td><input value="" name="minor"></td>
				<td><input value="" name="bs-ms"></td>
				<td><input type="submit" value="Insert"></td>
			</form>
		</tr>
	
	
	<%
		String GET_QUERY = "select * from UndergraduateStudent natural inner join student order by first_name, last_name";
		rs = stmt.executeQuery(GET_QUERY);
		while (rs.next()){		
	%>
		<tr>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="update-ug" name="action">	
				<td><input value="<%= rs.getInt("student_id")%>" name="id" readonly></td>
				<td><input value="<%= rs.getString("first_name") %>" name="first_name"></td>
				<td><input value="<%= rs.getString("middle_name") %>" name="middle_name"></td>
				<td><input value="<%= rs.getString("last_name")%>" name="last_name"></td>
				<td><input value="<%= rs.getString("ssn")%>" name="ssn"></td>
				<td><input value="<%= rs.getString("residency")%>" name="residency"></td>
				<td><input value="<%= rs.getString("college")%>" name="college"></td>
				<td><input value="<%= rs.getString("major")%>" name="major"></td>
				<td><input value="<%= rs.getString("minor")%>" name="minor"></td>
				<td><input value="<%= rs.getString("in_bs_ms_program")%>" name="bs-ms"></td>
				<td><input type="submit" value="Update"></td>
			</form>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="delete" name="action">
				<input type="hidden" value="<%= rs.getInt("student_id") %>"
				name="id">
				<td><input type="submit" value="Delete"></td>
			</form>
		</tr>
	<%	} %>
	</table>
	</section>
	
	<h2>Graduate Student</h2>
	
	<section>
	<h3>Master Student</h3>
	<table>
		<tr>
			<th>Student ID</th>
			<th>First Name</th>
			<th>Middle Name</th>
			<th>Last Name</th>
			<th>SSN</th>
			<th>Residency</th>
			<th>Department ID</th>
			<th>Five-Year-Program</th>
		</tr>
		<tr>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="insert-m" name="action">	
				<td></td>
				<td><input value="" name="first_name"></td>
				<td><input value="" name="middle_name"></td>
				<td><input value="" name="last_name"></td>
				<td><input value="" name="ssn"></td>
				<td><input value="" name="residency"></td>
				<td><input value="" name="department-id"></td>
				<td><input value="" name="five-year"></td>
				<td><input type="submit" value="Insert"></td>
			</form>
		</tr>
	
	
	<%
		GET_QUERY = "select * from (select grad_student_id as student_id, five_year_enrollment_status from MasterStudent) s1 natural inner join (select * from GraduateStudent natural inner join student) s2 order by first_name, last_name";
		rs = stmt.executeQuery(GET_QUERY);
		while (rs.next()){		
	%>
		<tr>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="update-m" name="action">	
				<td><input value="<%= rs.getInt("student_id")%>" name="id"readonly></td>
				<td><input value="<%= rs.getString("first_name") %>" name="first_name"></td>
				<td><input value="<%= rs.getString("middle_name") %>" name="middle_name"></td>
				<td><input value="<%= rs.getString("last_name")%>" name="last_name"></td>
				<td><input value="<%= rs.getString("ssn")%>" name="ssn"></td>
				<td><input value="<%= rs.getString("residency")%>" name="residency"></td>
				<td><input value="<%= rs.getInt("department_id")%>" name="department-id"></td>
				<td><input value="<%= rs.getString("five_year_enrollment_status")%>" name="five-year"></td>
				<td><input type="submit" value="Update"></td>
			</form>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="delete" name="action">
				<input type="hidden" value="<%= rs.getInt("student_id") %>"
				name="id">
				<td><input type="submit" value="Delete"></td>
			</form>
		</tr>
	<%	} %>
	</table>
	</section>
	
	<h3>PHD Student</h3>
	<section>
	<h4>Pre-Candidancy Student</h4>
	<table>
		<tr>
			<th>Student ID</th>
			<th>First Name</th>
			<th>Middle Name</th>
			<th>Last Name</th>
			<th>SSN</th>
			<th>Residency</th>
			<th>Department ID </th>
		</tr>
		<tr>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="insert-pc" name="action">	
				<td></td>
				<td><input value="" name="first_name"></td>
				<td><input value="" name="middle_name"></td>
				<td><input value="" name="last_name"></td>
				<td><input value="" name="ssn"></td>
				<td><input value="" name="residency"></td>
				<td><input value="" name="department-id"></td>
				<td><input type="submit" value="Insert"></td>
			</form>
		</tr>
	
	
	<%
		GET_QUERY = "select * from (select phd_student_id as student_id from PreCandidancyStudent) s1 natural inner join (select * from GraduateStudent natural inner join student) s2 order by first_name, last_name";
		rs = stmt.executeQuery(GET_QUERY);
		while (rs.next()){		
	%>
		<tr>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="update-pc" name="action">	
				<td><input value="<%= rs.getInt("student_id")%>" name="id"readonly></td>
				<td><input value="<%= rs.getString("first_name") %>" name="first_name"></td>
				<td><input value="<%= rs.getString("middle_name") %>" name="middle_name"></td>
				<td><input value="<%= rs.getString("last_name")%>" name="last_name"></td>
				<td><input value="<%= rs.getString("ssn")%>" name="ssn"></td>
				<td><input value="<%= rs.getString("residency")%>" name="residency"></td>
				<td><input value="<%= rs.getInt("department_id")%>" name="department-id"></td>
				<td><input type="submit" value="Update"></td>
			</form>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="delete" name="action">
				<input type="hidden" value="<%= rs.getInt("student_id") %>"
				name="id">
				<td><input type="submit" value="Delete"></td>
			</form>
		</tr>
	<%	} %>
	</table>
	</section>
	
	<section>
	<h4>PHD Candidate Student</h4>
	<table>
		<tr>
			<th>Student ID</th>
			<th>First Name</th>
			<th>Middle Name</th>
			<th>Last Name</th>
			<th>SSN</th>
			<th>Residency</th>
			<th>Department ID </th>
			<th>Faculty Advisor </th>
		</tr>
		<tr>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="insert-c" name="action">	
				<td></td>
				<td><input value="" name="first_name"></td>
				<td><input value="" name="middle_name"></td>
				<td><input value="" name="last_name"></td>
				<td><input value="" name="ssn"></td>
				<td><input value="" name="residency"></td>
				<td><input value="" name="department-id"></td>
				<td><input value="" name="faculty"></td>
				<td><input type="submit" value="Insert"></td>
			</form>
		</tr>
	
	
	<%
		GET_QUERY = "select * from (select phd_student_id as student_id, faculty_advisor_name from PHDCandidateStudent) s1 natural inner join (select * from GraduateStudent natural inner join student) s2 order by first_name, last_name";
		rs = stmt.executeQuery(GET_QUERY);
		while (rs.next()){		
	%>
		<tr>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="update-c" name="action">	
				<td><input value="<%= rs.getInt("student_id")%>" name="id"readonly></td>
				<td><input value="<%= rs.getString("first_name") %>" name="first_name"></td>
				<td><input value="<%= rs.getString("middle_name") %>" name="middle_name"></td>
				<td><input value="<%= rs.getString("last_name")%>" name="last_name"></td>
				<td><input value="<%= rs.getString("ssn")%>" name="ssn"></td>
				<td><input value="<%= rs.getString("residency")%>" name="residency"></td>
				<td><input value="<%= rs.getInt("department_id")%>" name="department-id"></td>
				<td><input value="<%= rs.getString("faculty_advisor_name")%>" name="faculty"></td>
				<td><input type="submit" value="Update"></td>
			</form>
			<form action=<%= page_path %> method="post">
				<input type="hidden" value="delete" name="action">
				<input type="hidden" value="<%= rs.getInt("student_id") %>"
				name="id">
				<td><input type="submit" value="Delete"></td>
			</form>
		</tr>
	<%	} %>
	</table>
	</section>


	<%
	} catch (Exception e){
	%>
		<h1>Something Went Wrong</h1>
		<p> <%= e %> </p>]
		<a href="students.jsp">Back To Students Page</a>

	<%	
	} finally {
		if (rs != null) {
			rs.close();			
		}
		if (stmt != null) {
			stmt.close();
		}
		if (connection != null) {		
			connection.close();
		}
	}
	%>


</body>
</html>