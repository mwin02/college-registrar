CREATE OR REPLACE FUNCTION check_conflict() RETURNS TRIGGER AS $checkConflict$
    DECLARE
        conflict_meeting          integer;
    BEGIN
        conflict_meeting = (SELECT count(*) FROM Meeting WHERE meeting_id != new.meeting_id AND section_id = new.section_id AND new.day_of_week = day_of_week AND ( start_hour BETWEEN new.start_hour AND new.end_hour OR end_hour BETWEEN new.start_hour AND new.end_hour));
        IF (conflict_meeting > 0) THEN
          RAISE EXCEPTION 'There is a Conflicting Meeting Scheduled For This Class';
        END IF;
        RETURN NEW;
    END;
$checkConflict$ LANGUAGE plpgsql;

CREATE TRIGGER conflict_checker
  AFTER INSERT OR UPDATE ON Meeting
  FOR EACH ROW
    EXECUTE FUNCTION check_conflict();

