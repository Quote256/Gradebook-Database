/*initialize tables */
create table student
    (student_id int,
    first_name varchar(20),
    last_name varchar(20),
    major varchar(20),
    primary key (student_id));
create table enrollment (
    student_id int, 
    course_id int,
    primary key (student_id, course_id));
create table courses (
    course_id int,
    department varchar(20),
    course_no int,
    course_name varchar(20),
    year int,
    semester varchar(15),
    primary key (course_id)
    );
create table gradebook ( 
    student_id int, 
    assignment_id int, 
    points int default 0, 
    primary key (student_id, assignment_id));
create table assignment (
    assignment_id int,
    distribution_id int,
    intstance int,
    possible_points int,
    primary key (assignment_id)
    );
create table distribution (
    distribution_id int,
    course_id int,
    category varchar(20),
    dis_percentage int,
    primary key (distribution_id));

/*added values to tables*/
insert into student(student_id, first_name, last_name, major)
    values
    (1001, 'Bradon', 'Thymes', 'Computer Science'),
    (1002, 'Bob', 'Jones', 'Humanities'),
    (1003, 'Abigail', 'Mantle', 'Religion');
insert into enrollment(student_id, course_id)
    values
    (1001, 1), 
    (1001, 2),
    (1002, 1),
    (1002, 3),
    (1003, 2),
    (1003,3);

insert into courses (course_id, department, course_no, course_name, year, semester)
    values
    (1, 'Computer Science', 200, 'Data Science', 2021, 'Fall'),
    (2, 'Humanities', 650, 'Philosophy', 2021, 'Fall'),
    (3, 'Religion', 130, 'Bible Study', 2021, 'Fall');

insert into distribution (distribution_id, course_id, category, dis_percentage)
    values
    (1, 1, 'Participation', 10),
    (2, 1, 'Homework', 20),
    (3, 1, 'Test', 40),
    (4, 1, 'Project', 30);

insert into assignment (assignment_id, distribution_id, intstance, possible_points) 
    values 
    (1, 1, 1, 75), 
    (2, 2, 1, 25), 
    (3, 2, 2, 100), 
    (4, 3, 1, 100), 
    (5, 4, 2, 50);

insert into gradebook (student_id, assignment_id, points)
    values
    (1001, 1, 75),
    (1001, 2, 25),
    (1001, 3, 100),
    (1001, 4, 95),
    (1001, 5, 45),
    (1002, 1, 40),
    (1002, 2, 10),
    (1002, 3, 70),
    (1002, 4, 85),
    (1002, 5, 30),
    (1003, 1, 72),
    (1003, 2, 20),
    (1003, 3, 95),
    (1003, 4, 90),
    (1003, 5, 45);

/*show contents of the table*/
select * from student;
select * from enrollment;
select * from courses;
select * from distribution;
select * from assignment;
select * from gradebook;

/*average, highest and lowest score of assignment 1*/
select avg(points) from gradebook where assignment_id = '1';
select max(points) from gradebook where assignment_id = '1';
select min(points) from gradebook where assignment_id = '1';

/*listing all students in a specific course (data science)*/
SELECT FIRST_NAME, LAST_NAME FROM STUDENT WHERE STUDENT_ID IN ( SELECT STUDENT_ID
FROM ENROLLMENT WHERE COURSE_ID = ( SELECT COURSE_ID FROM COURSES WHERE COURSE_NAME = "DATA SCIENCE" ) );

/*list students in a course and their scores on every assignment*/
select s.student_id, s.first_name, s.last_name, e.course_id, g.assignment_id, g.points
    from student s, enrollment e, gradebook g
    where s.student_id = g.student_id and g.student_id = e.student_id and e.course_id = 1;

/*added an assignment to a course*/
insert into assignment (assignment_id, distribution_id, intstance, possible_points)
    values
    (6,3,1,30);

/*changed perecentage of Test*/
update distribution set dis_percentage = 35 where category = 'Test';

/*added 2 points to score for each student*/
update gradebook set points = points + 2 where assignment_id = 2;

/*added two points to students whose last name has a Q*/
update gradebook
    set points = points + 2
    where gradebook.student_id = (select student_id from student where gradebook.student_id = student.student_id and student.last_name like '%Q%');

/*Compute total grade for a student*/
select sum((g.points) * (d.dis_percentage/c.counter)/possible_points) as overall_grade from gradebook g
    left join assignment a on g.assignment_id = a.assignment_id
    join distribution d on d.distribution_id = a.distribution_id
    join (select d.distribution_id, count(*) as counter from gradebook g
        left join assignment a on g.assignment_id = a.assignment_id
        join distribution d on d.distribution_id = a.distribution_id
        where course_id=1 and student_id = 1001 group by d.distribution_id)
        c on c.distribution_id = d.distribution_id
    where course_id = 1
    and student_id = 1001;
    
/*Compute overall grade and remove lowest score*/
select sum((g.points) * (d.dis_percentage/c.counter)/possible_points) as final_grade from gradebook g
    left join assignment a on g.assignment_id = a.assignment_id
    join distribution d on d.distribution_id = a.distribution_id
    join (select d.distribution_id, count(*) as counter from gradebook g
        left join assignment a on g.assignment_id = a.assignment_id
        join distribution d on d.distribution_id = a.distribution_id
        where course_id=1 and student_id = 1001 group by d.distribution_id)
        c on c.distribution_id = d.distribution_id
    join (select d.distribution_id, count(*) as counter from gradebook g
        left join assignment a on g.assignment_id = a.assignment_id
        join distribution d on d.distribution_id = a.distribution_id
        where course_id = 1 and student_id = 1001 group by d.distribution_id)
        z on z.distribution_id = d.distribution_id
    where course_id = 1
    and student_id = 1001;
