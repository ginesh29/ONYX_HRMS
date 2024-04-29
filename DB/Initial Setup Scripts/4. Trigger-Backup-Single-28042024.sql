CREATE OR ALTER Trigger [dbo].[Trigger_Veh_DocIssueRcpt] on [dbo].[VehDocIssueRcpt] for insert,update
as --drop  Trigger [dbo].[Trigger_Veh_DocIssueRcpt]
begin 

	
			
declare @ApprBy	char(10)
declare @Stat	char(1)
--declare @VehCd	char(10)
--declare @DocTyp	Char(10)
--declare @SrNo	numeric(5,0)

--declare @Flag int 

--declare @recipients varchar(MAX) 
--declare @body varchar(MAX) 
--declare @ProfileName varchar(100)  
 
--		CREATE table #Temp(
--		 EmailId varchar(40) ,
--		 Body varchar(500) ,
--		 SNo int )
		 
-----Assigning Values--------------
--select @Flag=1
--select @ApprBy=ApprBy from inserted
--select @Stat=Stat from inserted
--select @VehCd=VehCd from inserted
--select @DocTyp=DocTyp from inserted
--select @SrNo=SrNo from inserted

--set @ProfileName = ( select Val from Parameters where Cd='EMAIL_PROFILE       ' and AppCd='HR' and CoCd='#')
---------Updating------------------


--if @Stat='A'
--	BEGIN
	 
--			if((select Top 1 Docstat from VehDocIssueRcpt where VehCd=@VehCd and DocTyp=@DocTyp and SrNo=@SrNo) ='HDS0003')
--			begin
--				insert into VehDocuments(VehCd,DocTyp,SrNo,DocNo,OthRefNo,IssueDt,IssuePlace,ExpDt,EntryBy,EntryDt)
--					values(
--						@VehCd
--					,	@DocTyp
--					,	(select Top 1 SrNo+1 from VehDocuments where VehCd=@VehCd and DocTyp=@DocTyp order by SrNo desc) 
--					,	(select Top 1 DocNo from VehDocIssueRcpt where VehCd=@VehCd and DocTyp=@DocTyp and SrNo=@SrNo)
--					,	(select Top 1 OthRefNo from VehDocuments where VehCd=@VehCd and DocTyp=@DocTyp order by SrNo desc) 
--					,	(select Top 1 IssueDt from VehDocIssueRcpt where VehCd=@VehCd and DocTyp=@DocTyp and SrNo=@SrNo)
--					,	(select Top 1 IssuePlace from VehDocIssueRcpt where VehCd=@VehCd and DocTyp=@DocTyp and SrNo=@SrNo)
--					,	(select Top 1 ExpDt from VehDocIssueRcpt where VehCd=@VehCd and DocTyp=@DocTyp and SrNo=@SrNo)
--					,	@ApprBy
--					,	getdate())
--			End
	
--			insert into #Temp
--			select distinct VehA.Email,
--				('The '+ C.Des +' which you '
--				+ case when Vehl.DocStat='HDS0002' then 'issue from 'else ' return to ' end
--				+ 'company for ' +Vehl.Narr
--					+' on '+ CONVERT(varchar(20),Vehl.TrnDt,103)
--					+' is approved.'),
--					@Flag
--			from VehDocIssueRcpt as Vehl
--			inner join Codes as c on C.Cd=Vehl.DocTyp and C.Typ='HDTYP'
--			--inner join VehAddress as VehA on Vehl.VehCd=VehA.VehCd and VehA.AddTyp='HADD0001'
--			--inner join Vehloyee as Veh on Veh.Cd=Vehl.VehCd
--			where Vehl.VehCd=@VehCd and DocTyp=@DocTyp and SrNo=@SrNo
--			set @Flag=@Flag+1
			
			
--	END

	
--else if @Stat='R'
--	BEGIN
--			insert into #Temp
--			select distinct VehA.Email,
--				('The '+ C.Des +' which you '
--				+ case when Vehl.DocStat='HDS0002' then 'issue from 'else ' return to ' end
--				+ 'company for ' +Vehl.Narr
--					+' on '+ CONVERT(varchar(20),Vehl.TrnDt,103)
--					+' is rejected.'),
--					@Flag
--			from VehDocIssueRcpt as Vehl
--			inner join Codes as c on C.Cd=Vehl.DocTyp and C.Typ='HDTYP'
--			inner join VehAddress as VehA on Vehl.VehCd=VehA.VehCd and VehA.AddTyp='HADD0001'
--			inner join Vehloyee as Veh on Veh.Cd=Vehl.VehCd
--			where Vehl.VehCd=@VehCd and DocTyp=@DocTyp and SrNo=@SrNo
--			set @Flag=@Flag+1
--	END		

			
--else if @Stat='N' and @ApprBy is null
--	BEGIN
--			insert into #Temp
--			select (select Email from VehAddress where VehCd=(select VehCd From CompanyProcessApprovalDetail as CPAD
--			where CPAD.ProcessId='HRPT8' 
--			and CPAD.Div=(select Div from Vehloyee where Cd=Vehl.VehCd)
--			and CPAD.Dept=(select Dept from Vehloyee where Cd=Vehl.VehCd)
--			and SrNo='1') and AddTyp='HADD0001')
--			,((select Veh.Fname+Veh.Mname+Veh.Lname from Vehloyee as Veh where Veh.Cd=Vehl.VehCd)
--				+ ' applied to ' +
--				+ case when Vehl.DocStat='HDS0002' then ' issue 'else ' return ' end
--				+ case when (select Veh.Sex from Vehloyee where Cd=Vehl.VehCd)='M' then ' his 'else ' her ' end 
--				+ C.Des 
--				+ case when Vehl.DocStat='HDS0002' then ' from 'else ' to ' end
--				+ 'company for ' +Vehl.Narr
--					+' on '+ CONVERT(varchar(20),Vehl.TrnDt,103)
--					+' is waiting for an approval from you.'),
--					@Flag
--				from VehDocIssueRcpt as Vehl
--			inner join Codes as c on C.Cd=Vehl.DocTyp and C.Typ='HDTYP'
--			inner join VehAddress as VehA on Vehl.VehCd=VehA.VehCd and VehA.AddTyp='HADD0001'
--			inner join Vehloyee as Veh on Veh.Cd=Vehl.VehCd	
--			where Vehl.VehCd=@VehCd and DocTyp=@DocTyp and SrNo=@SrNo
--			set @Flag=@Flag+1
			
			
--			insert into #Temp
--			select VehA.Email,
--					('The application to '
--					+ case when Vehl.DocStat='HDS0002' then 'issue 'else ' return ' end
--					+ ' your ' + C.Des 
--					+ case when Vehl.DocStat='HDS0002' then ' from 'else ' to ' end
--					+'company wants to be approved by '
--					+ (select Veh.Fname+Veh.Mname+Veh.Lname from Vehloyee as Veh where Veh.Cd=
--						(select CPAD.VehCd From CompanyProcessApprovalDetail as CPAD
--						where CPAD.ProcessId='HRPT8' 
--						and CPAD.Div=(select Div from Vehloyee where Cd=Vehl.VehCd)
--						and CPAD.Dept=(select Dept from Vehloyee where Cd=Vehl.VehCd)
--						and CPAD.SrNo='1'))),
--					@Flag
--				from VehDocIssueRcpt as Vehl 
--			inner join Codes as c on C.Cd=Vehl.DocTyp and C.Typ='HDTYP'
--			inner join VehAddress as VehA on Vehl.VehCd=VehA.VehCd and VehA.AddTyp='HADD0001'
--			inner join Vehloyee as Veh on Veh.Cd=Vehl.VehCd	
--			where Vehl.VehCd=@VehCd and DocTyp=@DocTyp and SrNo=@SrNo
--			set @Flag=@Flag+1
--	END		
			
--else if @Stat='N' and @ApprBy is not null	
--	BEGIN
--			insert into #Temp
--			select (select Email from VehAddress where VehCd=(select VehCd From CompanyProcessApprovalDetail as CPAD
--			where CPAD.ProcessId='HRPT8' 
--			and CPAD.Div=(select Div from Vehloyee where Cd=Vehl.VehCd)
--			and CPAD.Dept=(select Dept from Vehloyee where Cd=Vehl.VehCd)
--			and SrNo=((select ApprLvl from VehDocIssueRcptAppr where VehCd=Vehl.VehCd and DocTyp=Vehl.DocTyp and SrNo=Vehl.SrNo )+1) 
--				and AddTyp='HADD0001'))
--			,((select Veh.Fname+Veh.Mname+Veh.Lname from Vehloyee as Veh where Veh.Cd=Vehl.VehCd)
--				+ ' applied to ' +
--				+ case when Vehl.DocStat='HDS0002' then ' issue 'else ' return ' end
--				+ case when (select Veh.Sex from Vehloyee where Cd=Vehl.VehCd)='M' then ' his 'else ' her ' end 
--				+ C.Des 
--				+ case when Vehl.DocStat='HDS0002' then ' from 'else ' to ' end
--				+ 'company for ' +Vehl.Narr
--					+' on '+ CONVERT(varchar(20),Vehl.TrnDt,103)
--					+' is waiting for an approval from you.'),
--					@Flag
--				from VehDocIssueRcpt as Vehl
--			inner join Codes as c on C.Cd=Vehl.DocTyp and C.Typ='HDTYP'
--			inner join VehAddress as VehA on Vehl.VehCd=VehA.VehCd and VehA.AddTyp='HADD0001'
--			inner join Vehloyee as Veh on Veh.Cd=Vehl.VehCd	
--			where Vehl.VehCd=@VehCd and DocTyp=@DocTyp and SrNo=@SrNo
--			set @Flag=@Flag+1
			
--			insert into #Temp
--			select VehA.Email,
--					('The application to '
--					+ case when Vehl.DocStat='HDS0002' then 'issue 'else ' return ' end
--					+ ' your ' + C.Des 
--					+ case when Vehl.DocStat='HDS0002' then ' from 'else ' to ' end
--					+'company wants to be approved by '
--					+ (select Veh.Fname+Veh.Mname+Veh.Lname from Vehloyee as Veh where Veh.Cd=
--						(select CPAD.VehCd From CompanyProcessApprovalDetail as CPAD
--						where CPAD.ProcessId='HRPT8' 
--						and CPAD.Div=(select Div from Vehloyee where Cd=Vehl.VehCd)
--						and CPAD.Dept=(select Dept from Vehloyee where Cd=Vehl.VehCd)
--						and CPAD.SrNo=(select ApprLvl+1 from VehDocIssueRcptAppr where VehCd=Vehl.VehCd and DocTyp=Vehl.DocTyp and SrNo=Vehl.SrNo )))),
--					@Flag
--				from VehDocIssueRcpt as Vehl
--			inner join Codes as c on C.Cd=Vehl.DocTyp and C.Typ='HDTYP'
--			inner join VehAddress as VehA on Vehl.VehCd=VehA.VehCd and VehA.AddTyp='HADD0001'
--			inner join Vehloyee as Veh on Veh.Cd=Vehl.VehCd	
--			where Vehl.VehCd=@VehCd and DocTyp=@DocTyp and SrNo=@SrNo	
--			set @Flag=@Flag+1
--	END		

--		declare @Count numeric(3,0)
--		declare @RowNo numeric(3,0)
--		set @RowNo=1
--		set @Count=(select COUNT(EmailId) from #Temp)
--		while(@RowNo<=@Count)
--		begin
		
--			set @recipients=(select EmailId from #Temp where SNo=@RowNo)
--			set @body=(select Body from #Temp where SNo=@RowNo )
--			if @recipients !=''
--				BEGIN
--					EXEC msdb.dbo.sp_send_dbmail 
--					@profile_name =@ProfileName,
--					@recipients = @recipients,
--					@subject ='HRMS Document Issue',
--					@body = @body, 
--					@body_format = 'TEXT';
--				END
--			set @RowNo=@RowNo+1
--		end
--		Drop table #Temp
		
	

	end
 
 Go 
CREATE OR ALTER Trigger [dbo].[Trigger_Emp_ProgressionHead] on [dbo].[EmpProgressionHead] for insert,update
as --drop  Trigger [dbo].[Trigger_Emp_ProgressionHead]
begin 
	
			
declare @ApprBy		char(10)
declare @Stat		char(1)
declare @TransNo	char(10)
declare @Typ		char(10)

declare @Flag int 

declare @recipients varchar(MAX) 
declare @body varchar(MAX) 
declare @ProfileName varchar(100)  
 
		CREATE table #Temp(
		 EmailId varchar(40) ,
		 Body varchar(500) ,
		 SNo int )
		 
---Assigning Values--------------
select @Flag=1
select @ApprBy=ApprBy from inserted
select @Stat=Status from inserted
select @TransNo=TransNo from inserted 
select @Typ=Typ from inserted
set @ProfileName = ( select Val from Parameters where Cd='EMAIL_PROFILE       ' and AppCd='HR' and CoCd='#')
-------Updating------------------


if @Stat='A'
	BEGIN
			insert into #Temp
			select distinct EmpA.Email,
				('The application for '
				+ (select Des from SysCodes where Typ='HREP' and Cd=Empl.Typ)
				+ ' with changing ' 
				+(select Des from CompanyEarnDed where Cd=EmpD.EdCd and Typ=EmpD.EdTyp)
				+' from '+ CAST(val AS VARCHAR(100))+' to '+ CAST(ApprVal AS VARCHAR(100))
					+' is approved.'),
					@Flag
			from EmpProgressionHead as Empl
			inner join EmpProgressionDetail as EmpD on EmpD.TransNo=Empl.TransNo
			inner join EmpAddress as EmpA on Empl.EmpCd=EmpA.EmpCd and EmpA.AddTyp='HADD0001'
			inner join Employee as Emp on Emp.Cd=Empl.EmpCd
			where Empl.TransNo=@TransNo
			set @Flag=@Flag+1
	END

	
else if @Stat='R'
	BEGIN
			insert into #Temp
			select distinct EmpA.Email,
				('The application for '
				+ (select Des from SysCodes where Typ='HREP' and Cd=Empl.Typ)
				+ ' with changing ' 
				+(select Des from CompanyEarnDed where Cd=EmpD.EdCd and Typ=EmpD.EdTyp)
				+' from '+ CAST(val AS VARCHAR(100))+' to '+ CAST(ApprVal AS VARCHAR(100))
					+' is rejected.'),
					@Flag
			from EmpProgressionHead as Empl
			inner join EmpProgressionDetail as EmpD on EmpD.TransNo=Empl.TransNo
			inner join EmpAddress as EmpA on Empl.EmpCd=EmpA.EmpCd and EmpA.AddTyp='HADD0001'
			inner join Employee as Emp on Emp.Cd=Empl.EmpCd
			where Empl.TransNo=@TransNo
			set @Flag=@Flag+1
	END		

			
else if @Stat='E' and @ApprBy is null
	BEGIN
			insert into #Temp
			select (select Email from EmpAddress where EmpCd=(select EmpCd From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPT8' 
			and CPAD.ApplTyp=@Typ
			and CPAD.Div=(select Div from Employee where Cd=Empl.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=Empl.EmpCd)
			and SrNo='1') and AddTyp='HADD0001')
			,((select Emp.Fname+Emp.Mname+Emp.Lname from Employee as Emp where Emp.Cd=Empl.EmpCd)
				+ ' applied to ' +
				+ (select Des from SysCodes where Typ='HREP' and Cd=Empl.Typ)
				+ ' with changing ' 
				+(select Des from CompanyEarnDed where Cd=EmpD.EdCd and Typ=EmpD.EdTyp)
				+' from '+ CAST(val AS VARCHAR(100))+' to '+ CAST(ApprVal AS VARCHAR(100))
					+' is waiting for an approval from you.'),
					@Flag
				from EmpProgressionHead as Empl
			inner join EmpProgressionDetail as EmpD on EmpD.TransNo=Empl.TransNo
			inner join EmpAddress as EmpA on Empl.EmpCd=EmpA.EmpCd and EmpA.AddTyp='HADD0001'
			inner join Employee as Emp on Emp.Cd=Empl.EmpCd	
			where Empl.TransNo=@TransNo
			set @Flag=@Flag+1
			
			
			insert into #Temp
			select EmpA.Email,
					('Your application to '
					+ (select Des from SysCodes where Typ='HREP' and Cd=Empl.Typ)
				+ ' with changing ' 
				+(select Des from CompanyEarnDed where Cd=EmpD.EdCd and Typ=EmpD.EdTyp)
				+' from '+ CAST(val AS VARCHAR(100))+' to '+ CAST(ApprVal AS VARCHAR(100))
					+' wants to be approved by '
					+ (select Emp.Fname+Emp.Mname+Emp.Lname from Employee as Emp where Emp.Cd=
						(select CPAD.EmpCd From CompanyProcessApprovalDetail as CPAD
						where CPAD.ProcessId='HRPT8'  
						and CPAD.ApplTyp=@Typ
						and CPAD.Div=(select Div from Employee where Cd=Empl.EmpCd)
						and CPAD.Dept=(select Dept from Employee where Cd=Empl.EmpCd)
						and CPAD.SrNo='1'))),
					@Flag
				from EmpProgressionHead as Empl 
			inner join EmpProgressionDetail as EmpD on EmpD.TransNo=Empl.TransNo
			inner join EmpAddress as EmpA on Empl.EmpCd=EmpA.EmpCd and EmpA.AddTyp='HADD0001'
			inner join Employee as Emp on Emp.Cd=Empl.EmpCd	
			where Empl.TransNo=@TransNo
			set @Flag=@Flag+1
	END		
			
else if @Stat='E' and @ApprBy is not null	
	BEGIN
			insert into #Temp
			select (select Email from EmpAddress where EmpCd=(select EmpCd From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPT8'  
			and CPAD.ApplTyp=@Typ
			and CPAD.Div=(select Div from Employee where Cd=Empl.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=Empl.EmpCd)
			and SrNo=((select Top 1 ApprLvl from EmpProgressionAppr where TransNo=Empl.TransNo order by ApprLvl Desc)+1) 
				and AddTyp='HADD0001'))
			,((select Emp.Fname+Emp.Mname+Emp.Lname from Employee as Emp where Emp.Cd=Empl.EmpCd)
				+ ' applied to ' +
				+ (select Des from SysCodes where Typ='HREP' and Cd=Empl.Typ)
				+ ' with changing ' 
				+(select Des from CompanyEarnDed where Cd=EmpD.EdCd and Typ=EmpD.EdTyp)
				+' from '+ CAST(val AS VARCHAR(100))+' to '+ CAST(ApprVal AS VARCHAR(100))
					+' is waiting for an approval from you.'),
					@Flag
				from EmpProgressionHead as Empl
			inner join EmpProgressionDetail as EmpD on EmpD.TransNo=Empl.TransNo
			inner join EmpAddress as EmpA on Empl.EmpCd=EmpA.EmpCd and EmpA.AddTyp='HADD0001'
			inner join Employee as Emp on Emp.Cd=Empl.EmpCd	
			where Empl.TransNo=@TransNo
			set @Flag=@Flag+1
			
			insert into #Temp
			select EmpA.Email,
					('Your application to '
				+ (select Des from SysCodes where Typ='HREP' and Cd=Empl.Typ)
				+ ' with changing ' 
				+(select Des from CompanyEarnDed where Cd=EmpD.EdCd and Typ=EmpD.EdTyp)
				+' from '+ CAST(val AS VARCHAR(100))+' to '+ CAST(ApprVal AS VARCHAR(100))
					+' wants to be approved by '
					+ (select Emp.Fname+Emp.Mname+Emp.Lname from Employee as Emp where Emp.Cd=
						(select CPAD.EmpCd From CompanyProcessApprovalDetail as CPAD
						where CPAD.ProcessId='HRPT8'  
						and CPAD.ApplTyp=@Typ
						and CPAD.Div=(select Div from Employee where Cd=Empl.EmpCd)
						and CPAD.Dept=(select Dept from Employee where Cd=Empl.EmpCd)
						and CPAD.SrNo=((select Top 1 ApprLvl from EmpProgressionAppr where TransNo=Empl.TransNo order by ApprLvl Desc)+1 )))),
					@Flag
				from EmpProgressionHead as Empl
			inner join EmpProgressionDetail as EmpD on EmpD.TransNo=Empl.TransNo
			inner join EmpAddress as EmpA on Empl.EmpCd=EmpA.EmpCd and EmpA.AddTyp='HADD0001'
			inner join Employee as Emp on Emp.Cd=Empl.EmpCd		
			where Empl.TransNo=@TransNo
			set @Flag=@Flag+1
	END		

		--declare @Count numeric(3,0)
		--declare @RowNo numeric(3,0)
		--set @RowNo=1
		--set @Count=(select COUNT(EmailId) from #Temp)
		--while(@RowNo<=@Count)
		--begin
		
		--	set @recipients=(select EmailId from #Temp where SNo=@RowNo)
		--	set @body=(select Body from #Temp where SNo=@RowNo )
		--	if @recipients !=''
		--		BEGIN
		--			EXEC msdb.dbo.sp_send_dbmail 
		--			@profile_name =@ProfileName,
		--			@recipients = @recipients,
		--			@subject ='HRMS Employee Progression',
		--			@body = @body, 
		--			@body_format = 'TEXT';
		--		END
		--	set @RowNo=@RowNo+1
		--end
		Drop table #Temp
	end


 
 Go 
