create database if not exists TicketPhim;
use TicketPhim;

create table if not exists tblPhim
(
    PhimID    int primary key auto_increment,
    Ten_Phim  varchar(30) not null,
    Loai_Phim varchar(25) not null,
    Thoi_Gian int         not null
);

create table if not exists tblPhong
(
    PhongID    int primary key auto_increment,
    Ten_Phong  varchar(20) not null,
    Trang_Thai tinyint     not null
);

create table if not exists tblGhe
(
    GheID   int primary key auto_increment,
    PhongID int         not null,
    So_Ghe  varchar(10) not null,
    constraint fk_PhongID foreign key (PhongID) references tblPhong (PhongID)
);

create table if not exists tblVe
(
    PhimID     int         not null,
    GheID      int         not null,
    Ngay_Chieu datetime    not null,
    Trang_Thai varchar(20) not null,
    constraint fk_PhimID foreign key (PhimID) references tblPhim (PhimID),
    constraint fk_GheID foreign key (GheID) references tblGhe (GheID)
);

# 1
insert
    into tblPhim
    values (1, 'Em bé Hà Nội', 'Tâm lý', 90),
           (2, 'Nhiệm vụ bất khả thi', 'Hành Động', 100),
           (3, 'Dị Nhân', 'Viễn Tưởng', 90),
           (4, 'Cuốn theo chiều gió', 'Tình Cảm', 120);

insert
    into tblPhong
    values (1, 'Phòng chiếu 1', 1),
           (2, 'Phòng chiếu 2', 1),
           (3, 'Phòng chiếu 3', 0);

insert
    into tblGhe
    values (1, 1, 'A3'),
           (2, 1, 'B5'),
           (3, 2, 'A7'),
           (4, 2, 'D1'),
           (5, 3, 'T2');

insert
    into tblVe
    values (1, 1, '2008-10-20', 'Đã bán'),
           (1, 3, '2008-11-20', 'Đã bán'),
           (1, 4, '2008-12-23', 'Đã bán'),
           (2, 1, '2009-02-14', 'Đã bán'),
           (3, 1, '2009-02-14', 'Đã bán'),
           (2, 5, '2009-03-08', 'Chưa bán'),
           (2, 3, '2009-03-08', 'Chưa bán');

# 2 
select * from tblPhim order by Thoi_Gian asc;

# 3
select Ten_Phim from tblPhim where Thoi_Gian = (select max(Thoi_Gian) from tblPhim);

# 4
select Ten_Phim from tblPhim where Thoi_Gian = (select min(Thoi_Gian) from tblPhim);

# 5
select So_Ghe from tblGhe where So_Ghe like 'A%';

# 6
alter table tblPhong
    modify column Trang_Thai varchar(25);

# 7
delimiter
//
-- Create the Procedure called 'changeStatus1()''
create procedure changeStatus1()
begin
    -- Content for Procedure 'ProcedureName()' in here
    update tblPhong set Trang_Thai = if(Trang_Thai = 0, 'Dang sua', if(Trang_Thai = 1, 'Dang su dung', 'Unknown'));
    select * from tblPhong;
end;
//
delimiter ;

call changeStatus1();

# 7.1

delimiter
//
-- Create the Procedure called 'changeStatus2()''
create procedure changeStatus2()
begin
    -- Content for Procedure 'changeStatus2()' in here
    update tblPhong
    set Trang_Thai = case
                         when Trang_Thai = 0
                             then 'Dang sua'
                         when Trang_Thai = 1
                             then 'Dang su dung'
                         when Trang_Thai is null
                             then 'Unknown'
        end;
end;
//
delimiter ;

call changeStatus2();

# 8

select * from tblPhim where length(Ten_Phim) > 15 and length(Ten_Phim) < 25;

# 9
select concat(Ten_Phong, '    ', Trang_Thai) as 'Trang thai phong chieu' from tblPhong;
# 10
create view tblRank as
    select row_number() over (order by ten_phim) as STT, ten_phim, thoi_gian from tblPhim;
# 11
alter table tblPhim
    add Mo_ta nvarchar(255);
update tblPhim set Mo_ta = concat('Đây là bộ phim thể loại ', loai_phim);
select * from tblPhim;
update tblPhim set Mo_ta = replace(Mo_ta, 'bộ phim', 'film');
select * from tblPhim;

# 12
alter table tblghe
    drop foreign key fk_PhongID;
alter table tblve
    drop foreign key fk_PhimID;
alter table tblve
    drop foreign key fk_GheID;

# 13
delete from tblGhe;

# 14
select ngay_chieu, addtime(time(ngay_chieu), '83:20:00') as 'Giờ chiếu'
    from tblve;