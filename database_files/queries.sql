SELECT c.*, e.grading_option, e.credits_earned FROM student s, class c, enrollment e WHERE s.ssn = '123456789' AND e.student_id = s.student_id AND c.section_id = e.section_id AND e.enrollment_status = 'ENROLLED'; 

SELECT s.*, e.grading_option, e.credits_earned FROM student s, class c, enrollment e WHERE c.section_id = 1 AND e.student_id = s.student_id AND e.section_id = c.section_id;

SELECT * FROM STUDENT s WHERE EXISTS (select e.student_id from enrollment e where e.student_id = s.student_id);

SELECT avg(g.NUMBER_GRADE) as gpa FROM student s, enrollment e, GRADE_CONVERSION g WHERE s.ssn = '123456789' AND e.student_id = s.student_id AND g.LETTER_GRADE = e.grade

SELECT c.quarter as quarter, avg(g.NUMBER_GRADE) as gpa FROM student s, class c, enrollment e, GRADE_CONVERSION g  WHERE s.ssn = '123456789' AND e.student_id = s.student_id AND c.section_id = e.section_id AND g.LETTER_GRADE = e.grade GROUP BY c.quarter ORDER BY c.quarter;

SELECT c.class_title, c.quarter, e.enrollment_status, e.grade, e.credits_earned FROM student s, class c, enrollment e WHERE s.ssn = '123456789' AND e.student_id = s.student_id AND c.section_id = e.section_id AND c.quarter = 'SPRING 2017' ORDER BY c.quarter;

SELECT s.*, u.* from student s, UndergraduateStudent u WHERE s.student_id = u.student_id AND EXISTS (select * from Attendence a where a.student_id = s.student_id);

SELECT degree_name from degree WHERE degree_level = 'BS';

SELECT s.*, e.*
FROM enrollment e, student s
WHERE s.ssn = '123456789' AND s.student_id = e.student_id 

-- GET TOTAL UNITS FOR STUDNET
SELECT sum(e.credits_earned) FROM enrollment e, student s WHERE s.ssn = '123456789' AND s.student_id = e.student_id AND e.enrollment_status = 'FINISHED' 

-- GET ALL THE CATEGORIES OF DEGREE
SELECT c.category_name FROM degree d, category c, DegreeCategoryReq req WHERE req.degree_name = d.degree_name AND req.degree_level = d.degree_level AND req.category_name = c.category_name;

-- UNITS FUFILLED FOR A CATEGORY
SELECT SUM(e.credits_earned) as total_units
FROM Student s, CategoryCourses courses, enrollment e, class class
WHERE s.ssn = '123456789' AND s.student_id = e.student_id AND courses.category_name = 'Database Principles' AND class.section_id = e.section_id AND class.course_id = courses.course_id AND e.enrollment_status = 'FINISHED';

SELECT c.concentration_name FROM concentration c, DegreeConcentrationReq req WHERE req.degree_name = 'Computer Science' AND req.degree_level = 'MS' AND req.concentration_name = c.concentration_name;

SELECT SUM(e.credits_earned) as total_units
FROM Student s, CategoryCourses courses, enrollment e, class class
WHERE s.ssn = '123456789' AND s.student_id = e.student_id AND courses.category_name = 'Database Principles' AND class.section_id = e.section_id AND class.course_id = courses.course_id AND e.enrollment_status = 'FINISHED';



SELECT s.first_name, s.last_name, class.class_title, e.*
FROM Student s, ConcentrationCourses courses, enrollment e, class class
WHERE s.ssn = '234567891' AND s.student_id = e.student_id AND courses.concentration_name = 'Research' AND class.section_id = e.section_id AND class.course_id = courses.course_id AND e.enrollment_status = 'FINISHED';


SELECT courses.course_id
FROM Student s, ConcentrationCourses courses, enrollment e, class class
WHERE s.ssn = '234567891' AND s.student_id = e.student_id AND courses.concentration_name = 'Research' AND class.section_id = e.section_id AND class.course_id = courses.course_id AND e.enrollment_status = 'FINISHED';


-- Get a concentrations units and gpa
SELECT SUM(e.credits_earned) as total_units, avg(g.NUMBER_GRADE) as gpa
FROM Student s, ConcentrationCourses courses, enrollment e, class class, GRADE_CONVERSION g
WHERE s.ssn = '234567891' AND s.student_id = e.student_id AND courses.concentration_name = 'Research' AND class.section_id = e.section_id AND class.course_id = courses.course_id AND e.enrollment_status = 'FINISHED' AND g.LETTER_GRADE = e.grade;

-- Get all courses not yet taken
WITH untaken_courses as (SELECT course_id FROM ConcentrationCourses c, DegreeConcentrationReq req WHERE req.degree_name = 'Computer Science' AND req.degree_level = 'MS' AND req.concentration_name = c.concentration_name EXCEPT SELECT c.course_id FROM Student s, enrollment e, Class c WHERE s.ssn = '234567891' AND s.student_id = e.student_id AND e.section_id = c.section_id AND e.enrollment_status = 'FINISHED'), earliest_courses as (SELECT c.course_id, min(qc.NUM) as NUM FROM untaken_courses uc, class c, QUARTER_CONVERSION qc WHERE uc.course_id = c.course_id AND qc.quarter = c.quarter AND qc.NUM > 9 GROUP BY c.course_id) SELECT ec.course_id, c.course_number, qc.quarter FROM earliest_courses ec, QUARTER_CONVERSION qc, Course c WHERE ec.NUM = qc.NUM AND c.course_id = ec.course_id


-- Given a course ID, find all the sections of that class and find all the enrollment in all the sections
SELECT gc.Letter, count(*) as count
FROM Class class, enrollment e, GRADE_CONVERSION gc
WHERE class.course_id = '1' AND class.section_id = e.section_id AND e.grade = gc.LETTER_GRADE AND class.quarter LIKE '%' AND class.faculty_name LIKE 'Alin Duetsh'
GROUP BY gc.LETTER
;

SELECT course_number FROM Course WHERE course_id = 1;

SELECT avg(gc.NUMBER_GRADE) as gpa
FROM Class class, enrollment e, GRADE_CONVERSION gc
WHERE class.course_id = 1 AND class.section_id = e.section_id AND e.grade = gc.LETTER_GRADE AND class.quarter LIKE '%' AND class.faculty_name LIKE 'Alin Duetsh';



WITH enrolledClassTimes as (SELECT c.section_id, c.class_title, c.course_id, m.day_of_week, m.start_hour, m.end_hour FROM student s, class c, enrollment e, meeting m WHERE s.ssn = '123456789' AND e.student_id = s.student_id AND c.section_id = e.section_id AND e.enrollment_status = 'ENROLLED' AND c.quarter = 'SPRING 2018' AND m.section_id = c.section_id), availableClassTimes as (SELECT class.section_id, class.class_title, class.course_id, m.day_of_week, m.start_hour, m.end_hour FROM class class, meeting m WHERE class.quarter = 'SPRING 2018' and m.section_id = class.section_id)
SELECT * FROM availableClassTimes ac WHERE ac.section_id NOT IN (SELECT section_id FROM enrolledClassTimes) AND EXISTS (select * from enrolledClassTimes ec where ec.day_of_week = ac.day_of_week AND (ec.start_hour BETWEEN ac.start_hour AND ac.end_hour OR ec.end_hour BETWEEN ac.start_hour AND ac.end_hour));



WITH enrolledClassTimes as (SELECT c.section_id, c.class_title, c.course_id, m.day_of_week, m.start_hour, m.end_hour FROM student s, class c, enrollment e, meeting m WHERE s.ssn = '123456789' AND e.student_id = s.student_id AND c.section_id = e.section_id AND e.enrollment_status = 'ENROLLED' AND c.quarter = 'SPRING 2018' AND m.section_id = c.section_id) SELECT class.section_id, class.class_title, class.course_id, ec.section_id as conflict_id, ec.class_title as conflict_title, ec.course_id as conflict_course FROM class class, meeting m, enrolledClassTimes ec WHERE class.quarter = 'SPRING 2018' and m.section_id = class.section_id AND class.section_id != ec.section_id AND m.day_of_week = ec.day_of_week AND (m.start_hour BETWEEN ec.start_hour AND ec.end_hour OR m.end_hour BETWEEN ec.start_hour AND ec.end_hour) GROUP BY class.section_id, class.class_title, class.course_id, ec.section_id, ec.class_title, ec.course_id


SELECT class.section_id, class.class_title, class.course_id, class.faculty_name FROM class class WHERE class.quarter = 'SPRING 2018';

SELECT class.*, course.course_number FROM class class, course course WHERE class.quarter = 'SPRING 2018' AND class.course_id=course.course_id;

WITH studentList as (SELECT s.student_id FROM student s, class c, enrollment e WHERE s.student_id = e.student_id AND e.section_id = c.section_id AND c.section_id = 16), sectionList as (SELECT distinct c.section_id FROM studentList s, class c, enrollment e WHERE s.student_id = e.student_id AND c.section_id = e.section_id), meetingTimes as (SELECT m.section_id, m.day_of_week, m.start_hour, m.end_hour FROM meeting m WHERE m.section_id in (SELECT section_id FROM sectionList)) SELECT rt.* FROM REVIEW_TIMES rt WHERE NOT EXISTS (SELECT * FROM meetingTimes mt WHERE rt.day_of_week = mt.day_of_week AND ((rt.start_hour >= mt.start_hour AND rt.start_hour < mt.end_hour) OR (rt.end_hour > mt.start_hour AND rt.end_hour <= mt.end_hour)));

-- Classes in Spring 2018

--  section_id |     class_title      | course_id 
-- ------------+----------------------+-----------
--           7 | Deep Neural Networks |         2
--           8 | Database Systems A   |         3
--           1 | Database Systems B   |         1
--          14 | Research Seminar 2   |         6
--          16 | Database Systems B   |         1
-- (5 rows)


-- class meetings for students taking class with section id 1
--  section_id | day_of_week | start_hour | end_hour 
-- ------------+-------------+------------+----------
--           4 | TUE         | 12:00:00   | 13:20:00
--           4 | THU         | 12:00:00   | 13:20:00
--           1 | TUE         | 11:00:00   | 12:20:00
--           1 | THU         | 11:00:00   | 12:20:00
--           7 | TUE         | 14:00:00   | 15:20:00
--           7 | THU         | 14:00:00   | 15:20:00


