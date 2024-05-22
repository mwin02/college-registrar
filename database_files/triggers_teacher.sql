CREATE OR REPLACE FUNCTION check_conflict_faculty() RETURNS TRIGGER AS $checkConflictFaculty$
    DECLARE
        conflict_meeting          integer;
        cur_faculty              varchar(50);
    BEGIN
        cur_faculty = (SELECT faculty_name FROM Class WHERE section_id = new.section_id);
        conflict_meeting = (WITH curMeeting as (SELECT m.* FROM Class c, Meeting m WHERE c.section_id = m.section_id AND faculty_name = cur_faculty) SELECT count(*) FROM curMeeting WHERE meeting_id != new.meeting_id AND quarter = new.quarter AND new.day_of_week = day_of_week AND ( start_hour BETWEEN new.start_hour AND new.end_hour OR end_hour BETWEEN new.start_hour AND new.end_hour));
        IF (conflict_meeting > 0) THEN
          RAISE EXCEPTION 'There is a Conflicting Meeting Scheduled For This Instructor';
        END IF;
        RETURN NEW;
    END;
$checkConflictFaculty$ LANGUAGE plpgsql;

CREATE TRIGGER faculty_conflict_checker
  AFTER INSERT OR UPDATE ON Meeting
  FOR EACH ROW
    EXECUTE FUNCTION check_conflict_faculty();