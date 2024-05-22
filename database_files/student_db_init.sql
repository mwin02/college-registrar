

-- Student(student_id , student_ssn, residency, first_name, middle_name, last_name)
create table Student(
  student_id SERIAL,
  ssn char(9) not null Unique,
  residency varchar(255),
  first_name varchar(35) not null,
  middle_name varchar(35),
  last_name varchar(35) not null,
  -- enrolled char(1),
  primary key (student_id)
);

-- Department( department_id , department_name)
create table Department(
  department_id SERIAL, 
  department_name varchar(255),
  primary key (department_id)
);

-- Faculty( name, title)
create table Faculty(
  faculty_name varchar(50),
  title varchar(255),
  primary key (faculty_name)
);

-- Course(course_id, course_number, min_units, max_units, lab_work_req, grading_options_allowed, department_id (FK))
create table Course(
  course_id SERIAL,
  course_number varchar(10),
  min_units int,
  max_units int,
  lab_work_req char(1),
  grading_options_allowed char(255),
  department_id int,
  primary key (course_id),
  foreign key (department_id) references Department(department_id)
);

-- Prerequisites( course_id (FK) , prereq_course_id (FK) )
create table Prerequisites(
  course_id int,
  prereq_course_id int,
  primary key (course_id, prereq_course_id),
  foreign key (course_id) references Course(course_id),
  foreign key (prereq_course_id) references Course(course_id)
);


-- Class( course_id (FK), section_id, quarter, class_title, enrollment_limit, faculty_name (FK) )
create table Class(
  course_id int,
  section_id SERIAL Unique,
  quarter varchar(255),
  class_title varchar(255),
  enrollment_limit int,
  faculty_name varchar(50),
  primary key (course_id, section_id),
  foreign key (course_id) references Course(course_id),
  foreign key (faculty_name) references Faculty(faculty_name)
);





-- AttendingPeriods(student_id (FK), start_quarter, end_quarter)
create table Attendence(
  student_id int,
  quarter varchar(255),
  primary key (student_id, quarter),
  foreign key (student_id) references Student(student_id)
);

-- Probation(student_id (FK), case_id, start_quarter, end_quarter, reason)
create table Probation(
  student_id int,
  case_id SERIAL,
  start_quarter varchar(255),
  end_quarter varchar(255),
  reason varchar(500),
  primary key (case_id),
  foreign key (student_id) references Student(student_id)
);

-- ClassEnrollment(student_id (FK), section_id (FK), enrollment_status, grading_option, grade, credits_earned)
create table Enrollment(
  student_id int,
  section_id int,
  enrollment_status varchar(255),
  grading_option varchar(255),
  grade char(5),
  credits_earned int,
  primary key (student_id, section_id),
  foreign key (student_id) references Student(student_id),
  foreign key (section_id) references Class(section_id)
);

-- StudentAccount( account_id, balance, student_id (FK))
create table StudentAccount(
  account_id SERIAL,
  balance float,
  student_id int,
  primary key (account_id),
  foreign key (student_id) references Student(student_id)
);

-- StudentAccountPayers( account_id (FK), payer_name, payer_address)
create table StudentAccountPayers(
  account_id int,
  payer_name varchar(35),
  payer_address varchar(255),
  primary key (account_id, payer_name),
  foreign key (account_id) references StudentAccount(account_id)
);

-- AccountTransactions( account_id (FK), transaction_id, amount, message)
create table AccountTransactions(
  account_id int,
  transaction_id SERIAL,
  amount float,
  message varchar(255),
  primary key (account_id, transaction_id),
  foreign key (account_id) references StudentAccount(account_id)
);

-- UndergraduateStudent( student_id (FK), college, major, minor, in_bs_ms_program )
create table UndergraduateStudent(
  student_id int,
  college varchar(255),
  major varchar(255),
  minor varchar(255),
  in_bs_ms_program char(1),
  primary key (student_id),
  foreign key (student_id) references Student(student_id) ON DELETE CASCADE
);

-- GraduateStudent( student_id (FK), department_id (FK))
create table GraduateStudent(
  student_id int,
  department_id int,
  primary key (student_id),
  foreign key (student_id) references Student(student_id) ON DELETE CASCADE,
  foreign key (department_id) references Department(department_id)
);

-- MasterStudent( grad_student_id (FK), five_year_enrollment_status)
create table MasterStudent(
  grad_student_id int,
  five_year_enrollment_status char(1),
  primary key (grad_student_id),
  foreign key (grad_student_id) references GraduateStudent(student_id) ON DELETE CASCADE
);

-- PHDStudent( grad_student_id (FK))
create table PHDStudent(
  grad_student_id int,
  primary key (grad_student_id),
  foreign key (grad_student_id) references GraduateStudent(student_id) ON DELETE CASCADE
);


-- Pre-CandidancyStudent( phd_student_id (FK), faculty_advisor_name (FK))
create table PHDCandidateStudent(
  phd_student_id int,
  faculty_advisor_name varchar(50),
  primary key (phd_student_id),
  foreign key (phd_student_id) references PHDStudent(grad_student_id) ON DELETE CASCADE,
  foreign key (faculty_advisor_name) references Faculty(faculty_name)
);

-- PHDCandidateStudent( phd_student_id (FK))
create table PreCandidancyStudent(
  phd_student_id int,
  primary key (phd_student_id),
  foreign key (phd_student_id) references PHDStudent(grad_student_id) ON DELETE CASCADE
);

-- ReviewSessions( section_id (FK), date, start_time, end_time)
create table ReviewSessions(
  section_id int,
  session_date char(20),
  start_time char(10),
  end_time char(10),
  primary key(section_id, session_date, start_time),
  foreign key(section_id) references Class(section_id)
);

-- Meeting( building, room_number, day_of_week, start_hour, end_hour, quarter, meeting_type, is_mandatory, section_id (FK) )
create table Meeting(
  meeting_id SERIAL,
  building varchar(255),
  room_number int,
  day_of_week char(3),
  start_hour time without time zone,
  end_hour time without time zone,
  quarter varchar(255),
  meeting_type varchar(50),
  is_mandatory char(1),
  section_id int,
  primary key (meeting_id),
  Unique (building, room_number, day_of_week, start_hour, end_hour, quarter),
  foreign key (section_id) references Class(section_id)
);

-- FutureTeachingSchedule( faculty_name (FK), course_id (FK), quarter, consent_required)
create table TeachingSchedule(
  faculty_name varchar(50),
  course_id int,
  quarter varchar(255),
  consent_required char(1),
  primary key (faculty_name, course_id, quarter),
  foreign key (faculty_name) references Faculty (faculty_name),
  foreign key (course_id) references Course (course_id)
);

-- ThesisCommittee( committee_id ,  grad_student_id (FK))
create table ThesisCommittee(
  committee_id SERIAL,
  grad_student_id int,
  primary key (committee_id),
  foreign key (grad_student_id) references GraduateStudent(student_id)
);

-- ThesisCommitteeMembers( committee_id (FK), facutly_name (FK))
create table ThesisCommitteeMembers(
  committee_id int,
  faculty_name varchar(50),
  primary key (committee_id, faculty_name),
  foreign key (committee_id) references ThesisCommittee(committee_id),
  foreign key (faculty_name) references Faculty(faculty_name)
);

-- Concentration( concentration_name )
create table Concentration(
  concentration_name varchar(255),
  units_required int,
  gpa_required float,
  primary key (concentration_name)
);

-- ConcentrationCourses( course_id (FK), concentration_name (FK))
create table ConcentrationCourses(
  course_id int,
  concentration_name varchar(255),
  primary key (course_id, concentration_name),
  foreign key (course_id) references Course(course_id),
  foreign key (concentration_name) references Concentration(concentration_name)
);

-- Category( category_name , units_required, grade_required)
create table Category(
  category_name varchar(255),
  units_required int,
  grade_required varchar(10),
  primary key (category_name)
);

-- CategoryCourses( course_id (FK), category_name (FK))
create table CategoryCourses(
  course_id int,
  category_name varchar(255),
  primary key (course_id, category_name),
  foreign key (course_id) references Course(course_id),
  foreign key (category_name) references Category(category_name)
);

-- Degree( degree_name, degree_level, total_units, department_id(FK))
create table Degree(
  degree_name varchar(255),
  degree_level varchar(255),
  total_units int,
  department_id int,
  primary key (degree_name, degree_level),
  foreign key (department_id) references Department(department_id)
);

-- DegreeCategoryReq( degree_name (FK), degree_level (FK), category_name (FK))
create table DegreeCategoryReq(
  degree_name varchar(255),
  degree_level varchar(255),
  category_name varchar(255),
  primary key (degree_name, degree_level, category_name),
  foreign key (degree_name, degree_level) references Degree (degree_name, degree_level),
  foreign key (category_name) references Category(category_name)
);

-- DegreeConcentrationReq( degree_name (FK), degree_level (FK), concentration_name (FK))
create table DegreeConcentrationReq(
  degree_name varchar(255),
  degree_level varchar(255),
  concentration_name varchar(255),
  primary key (degree_name, degree_level, concentration_name),
  foreign key (degree_name, degree_level) references Degree (degree_name, degree_level),
  foreign key (concentration_name) references Concentration(concentration_name)
);

-- ObtainedDegrees( student_id (FK), degree_name (FK), degree_level (FK), university_of_degree)
create table ObtainedDegrees(
  student_id int,
  degree_name varchar(255),
  degree_level varchar(255),
  university_of_degree varchar(255),
  primary key (student_id, degree_name, degree_level),
  foreign key (student_id) references Student(student_id),
  foreign key (degree_name, degree_level) references Degree(degree_name, degree_level)
);