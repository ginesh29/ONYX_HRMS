
CREATE OR ALTER Procedure [dbo].[EmpLeave_GetRow]  
@v_Param varchar(30),  
@v_Typ  char(1),  
@v_CoCd  Char(5)  
as  --Drop Procedure [dbo].[EmpLeave_GetRow]'90','4','100'  
 select  
  TransNo[TransNo]  
 , TransDt[Trans Dt.]  
 , el.EmpCd[Employee Code]  
 , rtrim(E.FName)+' '+rtrim(E.MName)+' '+rtrim(E.LName)[Employee Name]  
 , c.SDes[Leave Type]  
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
 , el.SubStitute[Subtitute Code]  
 , (select  
   rtrim(FName)+' '+rtrim(MName)+' '+rtrim(LName)  
  from  
   Employee Emp  
  where  
   Emp.cd=el.SubStitute  
  )[Substitute Name]  
 , el.Reason  
 , el.Narr  
 , el.LvApprBy  
 , case el.LvStatus  
   when 'Y' then 'Yes'  
   else 'No'  
  end[LvStatus]  
 , el.LvInter [Leave.Type]  
 , Typ  
 , DATEDIFF(dd,el.FromDt,GETDATE())[Joining days]
 , DATEDIFF(dd,el.ToDt,GETDATE())[Returning days]
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
 --order by 
 
 order by case when @v_Typ='3' then el.FromDt 
			   when @v_Typ='4' then el.ToDt 
			   else TransNo end
  
 -- TransNo  
  
   
 Go 
