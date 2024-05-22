DROP TABLE CPQG;
DROP TABLE CPG;
-- Build a view, named CPQG, that has one tuple for every course id X, professor Y, quarter Z, and grade W, where W is one of “A”, “B”, “C”, “D”, and “other”. The tuple contains the count of grade W’s that professor Y gave at quarter Z to the students taking course X. This view is supposed to facilitate the decision support query (3.a.2). All the explanations applicable to (3.a.2) apply to the view as well.

CREATE TABLE CPQG(
  course_id int,
  faculty varchar(255),
  quarter varchar(50),
  grade varchar(5),
  grade_regex varchar(50),
  grade_count int
);

-- Build a view, named CPG, that has one tuple for every course id X, professor Y and grade Z. The tuple contains the count of the specific grade Z that professor Y has given, when teaching course X. This view facilitates the decision support query (3.a.3).

CREATE TABLE CPG (
  course_id int,
  faculty varchar(255),
  grade varchar(5),
  grade_regex varchar(50),
  grade_count int
);

CREATE OR REPLACE FUNCTION init_CPG() RETURNS TRIGGER AS $initCPG$
    BEGIN        
        IF (TG_OP = 'INSERT' AND (SELECT count(*) FROM CPG WHERE course_id = new.course_id AND faculty = new.faculty_name) = 0) THEN
            INSERT INTO CPG (course_id, faculty, grade, grade_regex, grade_count) VALUES (new.course_id, new.faculty_name, 'A', 'A,A+,A-', 0);
            INSERT INTO CPG (course_id, faculty, grade, grade_regex, grade_count) VALUES (new.course_id, new.faculty_name, 'B', 'B,B+,B-', 0);
            INSERT INTO CPG (course_id, faculty, grade, grade_regex, grade_count) VALUES (new.course_id, new.faculty_name, 'C', 'C,C+,C-', 0);
            INSERT INTO CPG (course_id, faculty, grade, grade_regex, grade_count) VALUES (new.course_id, new.faculty_name, 'D', 'D,D+,D-', 0);
            INSERT INTO CPG (course_id, faculty, grade, grade_regex, grade_count) VALUES (new.course_id, new.faculty_name, 'OTHER', 'F,P', 0);
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
$initCPG$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_CPG() RETURNS TRIGGER AS $updateCPG$
    DECLARE
        new_course_id          integer;
    BEGIN        
        new_course_id = (SELECT c.course_id FROM class c WHERE new.section_id = c.section_id);
        IF (TG_OP = 'INSERT' AND new.enrollment_status = 'FINISHED') THEN
            UPDATE CPG SET grade_count = grade_count + 1 WHERE course_id = new_course_id AND grade_regex LIKE '%' || new.grade || '%';
        ELSIF (TG_OP = 'DELETE' AND old.enrollment_status = 'FINISHED') THEN
            new_course_id = (SELECT c.course_id FROM class c WHERE old.section_id = c.section_id);
            UPDATE CPG SET grade_count = grade_count - 1 WHERE course_id = new_course_id AND grade_regex LIKE '%' || old.grade || '%';
        ELSIF (TG_OP = 'UPDATE') THEN
            UPDATE CPG SET grade_count = grade_count - 1 WHERE course_id = new_course_id AND grade_regex LIKE '%' || old.grade || '%';
            UPDATE CPG SET grade_count = grade_count + 1 WHERE course_id = new_course_id AND grade_regex LIKE '%' || new.grade || '%';
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
$updateCPG$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION init_CPQG() RETURNS TRIGGER AS $initCPQG$
    BEGIN        
        IF (TG_OP = 'INSERT' AND (SELECT count(*) FROM CPQG WHERE course_id = new.course_id AND quarter = new.quarter AND faculty = new.faculty_name) = 0) THEN
            INSERT INTO CPQG (course_id, faculty, quarter, grade, grade_regex, grade_count) VALUES (new.course_id, new.faculty_name, new.quarter, 'A', 'A,A+,A-', 0);
            INSERT INTO CPQG (course_id, faculty, quarter, grade, grade_regex, grade_count) VALUES (new.course_id, new.faculty_name,  new.quarter, 'B', 'B,B+,B-', 0);
            INSERT INTO CPQG (course_id, faculty, quarter, grade, grade_regex, grade_count) VALUES (new.course_id, new.faculty_name, new.quarter, 'C', 'C,C+,C-', 0);
            INSERT INTO CPQG (course_id, faculty, quarter, grade, grade_regex, grade_count) VALUES (new.course_id, new.faculty_name, new.quarter, 'D', 'D,D+,D-', 0);
            INSERT INTO CPQG (course_id, faculty, quarter, grade, grade_regex, grade_count) VALUES (new.course_id, new.faculty_name, new.quarter, 'OTHER', 'F,P', 0);
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
$initCPQG$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_CPQG() RETURNS TRIGGER AS $updateCPQG$
    DECLARE
        new_course_id          integer;
        new_quarter            varchar(50);
    BEGIN        
        new_course_id = (SELECT c.course_id FROM class c WHERE new.section_id = c.section_id);
        new_quarter = (SELECT c.quarter FROM class c WHERE new.section_id = c.section_id);
        IF (TG_OP = 'INSERT' AND new.enrollment_status = 'FINISHED') THEN
            UPDATE CPQG SET grade_count = grade_count + 1 WHERE course_id = new_course_id AND quarter = new_quarter AND grade_regex LIKE '%' || new.grade || '%';
        ELSIF (TG_OP = 'DELETE' AND old.enrollment_status = 'FINISHED') THEN
            new_course_id = (SELECT c.course_id FROM class c WHERE old.section_id = c.section_id);
            new_quarter = (SELECT c.quarter FROM class c WHERE old.section_id = c.section_id);
            UPDATE CPQG SET grade_count = grade_count - 1 WHERE course_id = new_course_id AND quarter = new_quarter AND grade_regex LIKE '%' || old.grade || '%';
        ELSIF (TG_OP = 'UPDATE') THEN
            UPDATE CPQG SET grade_count = grade_count - 1 WHERE course_id = new_course_id AND quarter = new_quarter AND grade_regex LIKE '%' || old.grade || '%';
            UPDATE CPQG SET grade_count = grade_count + 1 WHERE course_id = new_course_id AND quarter = new_quarter AND grade_regex LIKE '%' || new.grade || '%';
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
$updateCPQG$ LANGUAGE plpgsql;

CREATE TRIGGER update_CPQG
  AFTER INSERT OR UPDATE OR DELETE ON enrollment
  FOR EACH ROW
    EXECUTE FUNCTION update_CPQG();

CREATE TRIGGER init_CPQG
  AFTER INSERT OR UPDATE OR DELETE ON class
  FOR EACH ROW
    EXECUTE FUNCTION init_CPQG();  

CREATE TRIGGER update_CPG
  AFTER INSERT OR UPDATE OR DELETE ON enrollment
  FOR EACH ROW
    EXECUTE FUNCTION update_CPG();

CREATE TRIGGER init_CPG
  AFTER INSERT OR UPDATE OR DELETE ON class
  FOR EACH ROW
    EXECUTE FUNCTION init_CPG();  
