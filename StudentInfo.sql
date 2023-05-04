create database if not exists StudentInfo;

use StudentInfo;

# 2.
create table if not exists StudentInfo.Class
(
    ClassID   int primary key auto_increment,
    ClassName varchar(255) not null,
    StartDate datetime     not null,
    Status    bit
);

create table if not exists StudentInfo.Student
(
    StudentID   int primary key auto_increment,
    StudentName varchar(30) not null,
    Address     varchar(50),
    Phone       varchar(20),
    Status      bit,
    ClassID     int         not null
);

create table if not exists StudentInfo.Subject
(
    SubID   int primary key auto_increment,
    SubName varchar(30) not null,
    Credit  tinyint default (1) check (Credit >= 1),
    Status  bit     default (1)
);

create table if not exists StudentInfo.Mark
(
    MarkID    int primary key auto_increment,
    SubID     int   not null,
    StudentID int   not null,
    unique (SubID, StudentID),
    Mark      float not null default (0) check (Mark >= 0 and Mark <= 100),
    ExamTimes tinyint        default (1)

);


# 3
alter table Student
    add constraint fk_ClassID foreign key (ClassID) references Class (ClassID);

alter table Class
    alter column StartDate set default (now());

alter table Student
    alter column Status set default (1);

alter table Mark
    add constraint fk_SubID foreign key (SubID) references Subject (SubID),
    add constraint fk_StudentID foreign key (StudentID) references Student (StudentID);

# 4
insert
    into Class (ClassID, ClassName, StartDate, Status)
    values (1, 'A1', '2008/12/20', 1),
           (2, 'A2', '2008/12/22', 1),
           (3, 'B3', curdate(), 0);

insert
    into Student (StudentID, StudentName, Address, Phone, Status, ClassID)
    values (1, 'Hung', 'Ha Noi', '0912113113', 1, 1),
           (2, 'Hoa', 'Hai Phong', null, 1, 1),
           (3, 'Manh', 'TP.HCM', '0123123123', 0, 2);

insert
    into Subject (SubID, SubName, Credit, Status)
    values (1, 'CF', 5, 1),
           (2, 'C', 6, 1),
           (3, 'HDJ', 5, 1),
           (4, 'RDBMS', 10, 1);

insert
    into Mark (MarkID, SubID, StudentID, Mark, ExamTimes)
    values (1, 1, 1, 8, 1),
           (2, 1, 2, 10, 2),
           (3, 2, 1, 12, 1);


# 5
update Student set ClassID = 2 where StudentName = 'Hung';

# 6
update Student set Phone = 'No Phone' where Phone is null;

# 7
delimiter
//
-- Create the Procedure called 'writeNewClass()'"
create procedure writeNewClass()
begin
    -- Content for Procedure 'writeNewClass()' in here
    update Class set ClassName = concat('New ', ClassName) where Status = 0;
end;
//
delimiter ;

call writeNewClass();

# 8

delimiter
//
-- Create the Procedure called 'writeOldClass()'"
create procedure writeOldClass()
begin
    -- Content for Procedure 'writeOldClass()' in here
    update Class set ClassName = replace(ClassName, 'New', 'Old') where ClassName like 'New%' and Status = 1;
end;
//
delimiter ;

call writeOldClass();

# 9.0
update Class set Status = 0 where ClassID not in (select ClassID from Student);

# 9.1
update Class
    left join StudentInfo.Student S on Class.ClassID = S.ClassID
set Class.Status = 0
    where StudentID is null;

# 10.0
update Subject set Status = 0 where SubID not in (select Mark.SubID from Mark);

# 10.1
update Subject
    left join StudentInfo.Mark M on Subject.SubID = M.SubID
set Subject.Status = 0
    where M.SubID is null;

# Show Information
select * from Student where StudentName like 'h%';

select * from Class where month(StartDate) = 12;

select max(Credit) from Subject;

select * from Subject where Credit = (select max(Credit) from Subject);

select * from Subject where Credit between 3 and 5;

select C.ClassID, C.ClassName, S.StudentName, S.Address
    from Class C
             join StudentInfo.Student S on C.ClassID = S.ClassID;

select * from Subject where SubID not in (select SubID from Mark);

select * from Subject where SubID = (select SubID from Mark where Mark = (select max(Mark) from Mark));

select S.*, avg(M.Mark) avg
    from Student S
             join StudentInfo.Mark M on S.StudentID = M.StudentID
    group by S.StudentID;

select S.*, avg(M.Mark) avg
    from Student S
             join StudentInfo.Mark M on S.StudentID = M.StudentID
    group by S.StudentID
    order by avg desc;

select S.*, avg(M.Mark) avg
    from Student S
             join StudentInfo.Mark M on S.StudentID = M.StudentID
    group by S.StudentID
    having avg > 10
    order by avg desc;

select ST.StudentName,
       S.SubName,
       M.Mark,
       rank() over ( order by M.Mark desc,
           ST.StudentName) as `Rank`
    from Student ST
             join StudentInfo.Mark M on ST.StudentID = M.StudentID
             join StudentInfo.Subject S on S.SubID = M.SubID;

# Delete information
delete from Class where Status = 0;

delete from Subject where SubID not in (select SubID from Mark);

alter table Mark
    drop column ExamTimes;

alter table Class
    rename column `Status` to ClassStatus;

alter table Mark rename to SubjectTest;