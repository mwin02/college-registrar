DROP TABLE GRADE_CONVERSION;

create table GRADE_CONVERSION(
  LETTER_GRADE CHAR(2) NOT NULL,
  NUMBER_GRADE DECIMAL(2,1),
  LETTER CHAR(1)
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