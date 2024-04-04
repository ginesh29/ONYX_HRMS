
CREATE Procedure [dbo].[EmpLeave_GetRow_N]  
@v_Param varchar(30),  
@v_Typ  char(1),  
@v_CoCd  Char(5)  ,
 @v_UserCd		char(10)='001'
as  --Drop Procedure [dbo].[EmpLeave_GetRow_N]'90','4','100'  
 select  
  TransNo[TransNo]  
 , TransDt[TransDt]  
 , el.EmpCd[EmployeeCode]  
 , rtrim(E.FName)+' '+rtrim(E.MName)+' '+rtrim(E.LName)[EmployeeName]  
 , c.SDes[LeaveType]  
 , el.FromDt
 , CONVERT(varchar(10), el.FromDt,103) [FormatedFromDt] 
 , el.ToDt  
 , CONVERT(varchar(10), el.ToDt,103) [FormatedToDt] 
 , el.LvTaken   
 , el.DocRef  
 , Case el.DocDt  
   When '01/01/1900' Then ''  
   Else el.DocDt  
  end[docDt]  
 , el.SubStitute[SubtituteCode]  
 , (select  
   rtrim(FName)+' '+rtrim(MName)+' '+rtrim(LName)  
  from  
   Employee Emp  
  where  
   Emp.cd=el.SubStitute  
  )[SubstituteName]  
 , el.Reason  
 , el.Narr  
 , el.LvApprBy  
 , case el.LvStatus  
   when 'Y' then 'Yes'  
   else 'No'  
  end[LvStatus]  
 , el.LvInter [LeaveType]  
 , Typ  
 , DATEDIFF(dd,el.FromDt,GETDATE())[Joiningdays]
 , DATEDIFF(dd,el.ToDt,GETDATE())[Returningdays]
 from  
  EmpLeave el  
 , CompanyLeave  c  
 , Employee e  
 where  
  C.cd=el.LvTyp  
 and e.cd=el.EmpCd  
 and (el.JoinDt is null or Typ='S')  
 and e.CoCd =@v_CoCd  
 and (
  (@v_Typ='0' and ltrim(str(month(TransDt)))=@v_Param and LvStatus <> 'C' ) or  
  (@v_Typ='1' and TransNo=@v_Param and LvStatus <> 'C' ) or  
  (@v_Typ='2' and el.empcd=@v_Param and LvStatus <> 'C' ) or  
  (@v_Typ='3' and el.FromDt between convert (date,getdate()) and  convert (date,DATEADD(DD,cast(@v_Param as int),getdate())) and el.LvStatus='Y') or
  (@v_Typ='4' and el.ToDt between convert (date,getdate()) and convert (date,DATEADD(DD,cast(@v_Param as int),getdate())) and el.LvStatus='F')
  ) 
 and  (el.HrDiv in (select div from UserBranch where UserCd=@v_UserCd or @v_UserCd='001'))
 --order by 
 
 order by case when @v_Typ='3' then el.FromDt 
			   when @v_Typ='4' then el.ToDt 
			   else TransNo end
  
 -- TransNo  
  
  