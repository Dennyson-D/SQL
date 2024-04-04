DECLARE @x1 INT = 10, @x2 INT = 7, @x3 INT = 4;
SELECT MAX(c) FROM (VALUES (@x1),(@x2),(@x3)) t(c)