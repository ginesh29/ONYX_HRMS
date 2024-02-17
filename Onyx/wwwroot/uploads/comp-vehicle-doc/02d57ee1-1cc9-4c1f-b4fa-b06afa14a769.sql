ALTER TABLE [Admin].[UserLogin]
  ADD [IsAdmin] [BIT]

UPDATE [Admin].[UserLogin]
SET [IsAdmin] = 0

ALTER TABLE [Admin].[UserLogin]
ALTER COLUMN IsAdmin BIT NOT NULL


select * from [Admin].[UserLogin]
where id = 1

UPDATE [Admin].[UserLogin]
SET [IsAdmin] = 1
where id = 1


select IsDeleted,* from [Admin].[UserLogin]