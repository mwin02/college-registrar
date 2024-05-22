DROP TABLE REVIEW_TIMES;

create table REVIEW_TIMES(
  start_hour time without time zone,
  end_hour time without time zone,
  day_of_week CHAR(3)
);

insert into REVIEW_TIMES values('8:00', '9:00', 'MON');
insert into REVIEW_TIMES values('9:00', '10:00', 'MON');
insert into REVIEW_TIMES values('10:00', '11:00', 'MON');
insert into REVIEW_TIMES values('11:00', '12:00', 'MON');
insert into REVIEW_TIMES values('12:00', '13:00', 'MON');
insert into REVIEW_TIMES values('13:00', '14:00', 'MON');
insert into REVIEW_TIMES values('14:00', '15:00', 'MON');
insert into REVIEW_TIMES values('15:00', '16:00', 'MON');
insert into REVIEW_TIMES values('16:00', '17:00', 'MON');
insert into REVIEW_TIMES values('17:00', '18:00', 'MON');
insert into REVIEW_TIMES values('18:00', '19:00', 'MON');
insert into REVIEW_TIMES values('19:00', '20:00', 'MON');

insert into REVIEW_TIMES values('8:00', '9:00', 'TUE');
insert into REVIEW_TIMES values('9:00', '10:00', 'TUE');
insert into REVIEW_TIMES values('10:00', '11:00', 'TUE');
insert into REVIEW_TIMES values('11:00', '12:00', 'TUE');
insert into REVIEW_TIMES values('12:00', '13:00', 'TUE');
insert into REVIEW_TIMES values('13:00', '14:00', 'TUE');
insert into REVIEW_TIMES values('14:00', '15:00', 'TUE');
insert into REVIEW_TIMES values('15:00', '16:00', 'TUE');
insert into REVIEW_TIMES values('16:00', '17:00', 'TUE');
insert into REVIEW_TIMES values('17:00', '18:00', 'TUE');
insert into REVIEW_TIMES values('18:00', '19:00', 'TUE');
insert into REVIEW_TIMES values('19:00', '20:00', 'TUE');

insert into REVIEW_TIMES values('8:00', '9:00', 'WED');
insert into REVIEW_TIMES values('9:00', '10:00', 'WED');
insert into REVIEW_TIMES values('10:00', '11:00', 'WED');
insert into REVIEW_TIMES values('11:00', '12:00', 'WED');
insert into REVIEW_TIMES values('12:00', '13:00', 'WED');
insert into REVIEW_TIMES values('13:00', '14:00', 'WED');
insert into REVIEW_TIMES values('14:00', '15:00', 'WED');
insert into REVIEW_TIMES values('15:00', '16:00', 'WED');
insert into REVIEW_TIMES values('16:00', '17:00', 'WED');
insert into REVIEW_TIMES values('17:00', '18:00', 'WED');
insert into REVIEW_TIMES values('18:00', '19:00', 'WED');
insert into REVIEW_TIMES values('19:00', '20:00', 'WED');

insert into REVIEW_TIMES values('8:00', '9:00', 'THU');
insert into REVIEW_TIMES values('9:00', '10:00', 'THU');
insert into REVIEW_TIMES values('10:00', '11:00', 'THU');
insert into REVIEW_TIMES values('11:00', '12:00', 'THU');
insert into REVIEW_TIMES values('12:00', '13:00', 'THU');
insert into REVIEW_TIMES values('13:00', '14:00', 'THU');
insert into REVIEW_TIMES values('14:00', '15:00', 'THU');
insert into REVIEW_TIMES values('15:00', '16:00', 'THU');
insert into REVIEW_TIMES values('16:00', '17:00', 'THU');
insert into REVIEW_TIMES values('17:00', '18:00', 'THU');
insert into REVIEW_TIMES values('18:00', '19:00', 'THU');
insert into REVIEW_TIMES values('19:00', '20:00', 'THU');

insert into REVIEW_TIMES values('8:00', '9:00', 'FRI');
insert into REVIEW_TIMES values('9:00', '10:00', 'FRI');
insert into REVIEW_TIMES values('10:00', '11:00', 'FRI');
insert into REVIEW_TIMES values('11:00', '12:00', 'FRI');
insert into REVIEW_TIMES values('12:00', '13:00', 'FRI');
insert into REVIEW_TIMES values('13:00', '14:00', 'FRI');
insert into REVIEW_TIMES values('14:00', '15:00', 'FRI');
insert into REVIEW_TIMES values('15:00', '16:00', 'FRI');
insert into REVIEW_TIMES values('16:00', '17:00', 'FRI');
insert into REVIEW_TIMES values('17:00', '18:00', 'FRI');
insert into REVIEW_TIMES values('18:00', '19:00', 'FRI');
insert into REVIEW_TIMES values('19:00', '20:00', 'FRI');

insert into REVIEW_TIMES values('8:00', '9:00', 'SAT');
insert into REVIEW_TIMES values('9:00', '10:00', 'SAT');
insert into REVIEW_TIMES values('10:00', '11:00', 'SAT');
insert into REVIEW_TIMES values('11:00', '12:00', 'SAT');
insert into REVIEW_TIMES values('12:00', '13:00', 'SAT');
insert into REVIEW_TIMES values('13:00', '14:00', 'SAT');
insert into REVIEW_TIMES values('14:00', '15:00', 'SAT');
insert into REVIEW_TIMES values('15:00', '16:00', 'SAT');
insert into REVIEW_TIMES values('16:00', '17:00', 'SAT');
insert into REVIEW_TIMES values('17:00', '18:00', 'SAT');
insert into REVIEW_TIMES values('18:00', '19:00', 'SAT');
insert into REVIEW_TIMES values('19:00', '20:00', 'SAT');

insert into REVIEW_TIMES values('8:00', '9:00', 'SUN');
insert into REVIEW_TIMES values('9:00', '10:00', 'SUN');
insert into REVIEW_TIMES values('10:00', '11:00', 'SUN');
insert into REVIEW_TIMES values('11:00', '12:00', 'SUN');
insert into REVIEW_TIMES values('12:00', '13:00', 'SUN');
insert into REVIEW_TIMES values('13:00', '14:00', 'SUN');
insert into REVIEW_TIMES values('14:00', '15:00', 'SUN');
insert into REVIEW_TIMES values('15:00', '16:00', 'SUN');
insert into REVIEW_TIMES values('16:00', '17:00', 'SUN');
insert into REVIEW_TIMES values('17:00', '18:00', 'SUN');
insert into REVIEW_TIMES values('18:00', '19:00', 'SUN');
insert into REVIEW_TIMES values('19:00', '20:00', 'SUN');
