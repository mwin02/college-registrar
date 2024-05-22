CREATE TABLE ClassEnrollmentCount(
  section_id int,
  currently_enrolled int,
  enrollment_limit int
)

CREATE OR REPLACE FUNCTION updated_count() RETURNS TRIGGER AS $updateCount$
    BEGIN        
        IF (TG_OP = 'DELETE' AND old.enrollment_status = 'ENROLLED') THEN
            UPDATE ClassEnrollmentCount SET currently_enrolled = currently_enrolled - 1 WHERE section_id = old.section_id;
        ELSIF (TG_OP = 'UPDATE' AND new.enrollment_status = 'ENROLLED' AND old.enrollment_status != 'ENROLLED') THEN
            UPDATE ClassEnrollmentCount SET currently_enrolled = currently_enrolled + 1 WHERE section_id = old.section_id;
        ELSIF (TG_OP = 'UPDATE' AND old.enrollment_status = 'ENROLLED' AND new.enrollment_status != 'ENROLLED') THEN
            UPDATE ClassEnrollmentCount SET currently_enrolled = currently_enrolled - 1 WHERE section_id = old.section_id;
        ELSIF (TG_OP = 'INSERT' AND new.enrollment_status = 'ENROLLED') THEN
            UPDATE ClassEnrollmentCount SET currently_enrolled = currently_enrolled + 1 WHERE section_id = new.section_id;
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
$updateCount$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_section() RETURNS TRIGGER AS $addSection$
    BEGIN
        IF (TG_OP = 'DELETE') THEN
            DELETE FROM ClassEnrollmentCount WHERE section_id = new.section_id;
        ELSIF (TG_OP = 'UPDATE') THEN
            UPDATE ClassEnrollmentCount SET enrollment_limit = new.enrollment_limit WHERE section_id = new.section_id;
        ELSIF (TG_OP = 'INSERT') THEN
            INSERT INTO ClassEnrollmentCount(section_id, currently_enrolled, enrollment_limit) VALUES(new.section_id, 0, new.enrollment_limit);
        END IF;
        
        RETURN NULL;
    END;
$addSection$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_limit() RETURNS TRIGGER AS $checkLimit$
    BEGIN        
        IF (new.currently_enrolled > new.enrollment_limit) THEN
            RAISE EXCEPTION 'Enrollment Limit Reached';
        END IF;
        RETURN NULL;
    END;
$checkLimit$ LANGUAGE plpgsql;

CREATE TRIGGER sections_count_init
  AFTER INSERT OR UPDATE OR DELETE ON class
  FOR EACH ROW
    EXECUTE FUNCTION add_section();

CREATE TRIGGER enrollment_count 
   AFTER INSERT OR UPDATE OR DELETE ON enrollment
   FOR EACH ROW 
      EXECUTE FUNCTION updated_count();

CREATE TRIGGER check_enrollment_limit
  AFTER INSERT OR UPDATE ON ClassEnrollmentCount
  FOR EACH ROW
    EXECUTE FUNCTION check_limit();

