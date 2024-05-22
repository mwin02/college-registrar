create table GRADE_CONVERSION(
  LETTER_GRADE CHAR(2) NOT NULL,
  NUMBER_GRADE DECIMAL(2,1),
  LETTER CHAR(1)
);

create table QUARTER_CONVERSION(
  QUARTER VARCHAR(50) NOT NULL,
  NUM INT
);

create table REVIEW_TIMES(
  start_hour time without time zone,
  end_hour time without time zone,
  day_of_week CHAR(3)
);


insert into grade_conversion values('A+', 4.3, 'A');
insert into grade_conversion values('A', 4, 'A');
insert into grade_conversion values('A-', 3.7, 'A');
insert into grade_conversion values('B+', 3.4, 'B');
insert into grade_conversion values('B', 3.1, 'B');
insert into grade_conversion values('B-', 2.8, 'B');
insert into grade_conversion values('C+', 2.5, 'C');
insert into grade_conversion values('C', 2.2, 'C');
insert into grade_conversion values('C-', 1.9, 'C');
insert into grade_conversion values('D', 1.6, 'D');
insert into grade_conversion values('P', null, 'O');


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





insert into QUARTER_CONVERSION values('SPRING 2017', 0);
insert into QUARTER_CONVERSION values('FALL 2017', 1);
insert into QUARTER_CONVERSION values('WINTER 2017', 2);
insert into QUARTER_CONVERSION values('SPRING 2018', 3);
insert into QUARTER_CONVERSION values('FALL 2018', 4);
insert into QUARTER_CONVERSION values('WINTER 2018', 5);
insert into QUARTER_CONVERSION values('SPRING 2019', 6);
insert into QUARTER_CONVERSION values('FALL 2019', 7);
insert into QUARTER_CONVERSION values('WINTER 2019', 8);
insert into QUARTER_CONVERSION values('SPRING 2020', 9);
insert into QUARTER_CONVERSION values('FALL 2020', 10);
insert into QUARTER_CONVERSION values('WINTER 2020', 11);
insert into QUARTER_CONVERSION values('SPRING 2021', 12);
insert into QUARTER_CONVERSION values('FALL 2021', 13);
insert into QUARTER_CONVERSION values('WINTER 2021', 14);
insert into QUARTER_CONVERSION values('SPRING 2022', 15);
insert into QUARTER_CONVERSION values('FALL 2022', 16);
insert into QUARTER_CONVERSION values('WINTER 2022', 17);
insert into QUARTER_CONVERSION values('SPRING 2023', 18);
insert into QUARTER_CONVERSION values('FALL 2023', 19);
insert into QUARTER_CONVERSION values('WINTER 2023', 20);
insert into QUARTER_CONVERSION values('SPRING 2024', 21);
insert into QUARTER_CONVERSION values('FALL 2024', 22);
insert into QUARTER_CONVERSION values('WINTER 2024', 23);
insert into QUARTER_CONVERSION values('SPRING 2025', 24);