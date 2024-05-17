USE [LSHRMS_Telal_Live]
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'1         ', N'0         ', N'Settings', CAST(1 AS Numeric(5, 0)), N'O', N'', N'Y', NULL, N'HRPS')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'11        ', N'1         ', N'Admin', CAST(2 AS Numeric(5, 0)), N'M', N'#', N'Y', N'Branch    ', N'HRPS1')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'112       ', N'11        ', N'Branches', CAST(4 AS Numeric(5, 0)), N'O', N'/Settings/Branches', N'Y', NULL, N'HRPS12')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'113       ', N'11        ', N'Users', CAST(5 AS Numeric(5, 0)), N'O', N'/Settings/Users', N'Y', NULL, N'HRPS13')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'12        ', N'1         ', N'Departments', CAST(8 AS Numeric(5, 0)), N'O', N'/Settings/Departments', N'Y', NULL, N'HRPS2')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'13        ', N'1         ', N'Codes', CAST(9 AS Numeric(5, 0)), N'O', N'/Settings/Codes', N'Y', NULL, N'HRPS3')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'14        ', N'1         ', N'Countries', CAST(10 AS Numeric(5, 0)), N'O', N'/Settings/Countries', N'Y', NULL, N'HRPS4')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'15        ', N'1         ', N'Currencies', CAST(11 AS Numeric(5, 0)), N'O', N'/Settings/Currencies', N'Y', NULL, N'HRPS5')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'2         ', N'0         ', N'Organisation', CAST(14 AS Numeric(5, 0)), N'O', N'#', N'Y', NULL, N'HRPO')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'21        ', N'2         ', N'Payroll', CAST(14 AS Numeric(5, 0)), N'O', N'#', N'Y', NULL, N'HRPO1')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'211       ', N'21        ', N'Components', CAST(15 AS Numeric(5, 0)), N'O', N'/Organisation/Components', N'Y', NULL, N'HRPO11')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'212       ', N'21        ', N'Loan Types', CAST(16 AS Numeric(5, 0)), N'O', N'/Organisation/LoanTypes', N'Y', NULL, N'HRPO12')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'213       ', N'21        ', N'Working Hrs/Shift', CAST(17 AS Numeric(5, 0)), N'O', N'/Organisation/WorkingHours', N'Y', NULL, N'HRPO13')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'214       ', N'21        ', N'Overtime Rates', CAST(18 AS Numeric(5, 0)), N'O', N'/Organisation/OvertimeRates', N'Y', NULL, N'HRPO14')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'22        ', N'2         ', N'Non Payroll', CAST(19 AS Numeric(5, 0)), N'O', N'#', N'Y', NULL, N'HRPO2')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'221       ', N'22        ', N'Calendar', CAST(20 AS Numeric(5, 0)), N'O', N'/Organisation/Calendar', N'Y', NULL, N'HRPO21')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'2210      ', N'22        ', N'Notifications', CAST(21 AS Numeric(5, 0)), N'O', N'/Organisation/Notifications', N'Y', NULL, N'HRPO210')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'2211      ', N'22        ', N'Approval Processes', CAST(22 AS Numeric(5, 0)), N'O', N'/Organisation/ApprovalProcesses', N'Y', N'NULL      ', N'HRPO211')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'222       ', N'22        ', N'Banks', CAST(24 AS Numeric(5, 0)), N'O', N'/Organisation/Banks', N'Y', NULL, N'HRPO22')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'223       ', N'22        ', N'Documents', CAST(25 AS Numeric(5, 0)), N'O', N'/Organisation/Documents', N'Y', NULL, N'HRPO23')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'224       ', N'22        ', N'Vehicles', CAST(26 AS Numeric(5, 0)), N'O', N'/Organisation/Vehicles', N'Y', NULL, N'HRPO24')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'225       ', N'22        ', N'Designations', CAST(27 AS Numeric(5, 0)), N'O', N'/Organisation/Designations', N'Y', NULL, N'HRPO26')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'226       ', N'22        ', N'Leave Types', CAST(28 AS Numeric(5, 0)), N'O', N'/Organisation/LeaveTypes', N'Y', NULL, N'HRPO27')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'227       ', N'22        ', N'Leave Pay Comp.', CAST(29 AS Numeric(5, 0)), N'O', N'/Organisation/LeavePayComponents', N'Y', NULL, N'HRPO25')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'228       ', N'22        ', N'Travel Fares', CAST(30 AS Numeric(5, 0)), N'O', N'/Organisation/TravelFares', N'Y', NULL, N'HRPO28')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'3         ', N'0         ', N'Employee', CAST(32 AS Numeric(5, 0)), N'O', N'#', N'Y', NULL, N'HRPE')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'31        ', N'3         ', N'Emp. Profiles', CAST(33 AS Numeric(5, 0)), N'O', N'/Employee/Profiles', N'Y', NULL, N'HRPE1')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'32        ', N'3         ', N'Emp. Documents', CAST(34 AS Numeric(5, 0)), N'O', N'/Employee/Documents', N'Y', NULL, N'HRPE2')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'33        ', N'3         ', N'Emp. Bank Account', CAST(35 AS Numeric(5, 0)), N'O', N'/Employee/BankAccounts', N'Y', NULL, N'HRPE3')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'34        ', N'3         ', N'Emp. Pay  Components', CAST(36 AS Numeric(5, 0)), N'O', N'/Employee/Components', N'Y', NULL, N'HRPE4')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'36        ', N'3         ', N'Emp. Calendar', CAST(111 AS Numeric(5, 0)), N'O', N'/Employee/Calendar', N'Y', NULL, N'HRPE6')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'4         ', N'0         ', N'Transactions', CAST(38 AS Numeric(5, 0)), N'O', N'#', N'Y', NULL, N'HRPT')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'41        ', N'4         ', N'Leave', CAST(39 AS Numeric(5, 0)), N'O', N'#', N'Y', NULL, N'HRPT1')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'411       ', N'41        ', N'Approvals', CAST(41 AS Numeric(5, 0)), N'O', N'/Transactions/EmpLeaveApprovals', N'Y', NULL, N'HRPT11')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'412       ', N'41        ', N'Confirm/Revise/Cancel', CAST(42 AS Numeric(5, 0)), N'O', N'/Transactions/EmpLeaveConfirmReviseCancel', N'Y', NULL, N'HRPT12')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'413       ', N'41        ', N'Duty Resumption', CAST(43 AS Numeric(5, 0)), N'O', N'/Transactions/EmpDutyResumption', N'Y', NULL, N'HRPT13')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'42        ', N'4         ', N'Leave Salary/Ticket', CAST(44 AS Numeric(5, 0)), N'O', N'#', N'Y', NULL, N'HRPT10')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'421       ', N'42        ', N'Approval', CAST(45 AS Numeric(5, 0)), N'O', N'/Transactions/EmpLeaveSalaryApproval', N'Y', NULL, N'HRPT101')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'422       ', N'42        ', N'Disburse', CAST(46 AS Numeric(5, 0)), N'O', N'/Transactions/EmpLeaveSalaryDisburse', N'Y', NULL, N'HRPT102')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'43        ', N'4         ', N'Loan', CAST(47 AS Numeric(5, 0)), N'O', N'#', N'Y', NULL, N'HRPT2')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'431       ', N'43        ', N'Approvals', CAST(48 AS Numeric(5, 0)), N'O', N'/Transactions/EmpLoanApproval', N'Y', NULL, N'HRPT21')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'432       ', N'43        ', N'Disbursement', CAST(49 AS Numeric(5, 0)), N'O', N'/Transactions/EmpLoanDisbursement', N'Y', NULL, N'HRPT22')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'433       ', N'43        ', N'Adjustment/Closing', CAST(50 AS Numeric(5, 0)), N'O', N'/Transactions/EmpLoanAdjustment', N'Y', NULL, N'HRPT23')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'435       ', N'43        ', N'Receipt Voucher', CAST(51 AS Numeric(5, 0)), N'O', N'/Transactions/ReceiptVoucher', N'Y', N'NULL      ', N'HRPT25')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'44        ', N'4         ', N'Attendance', CAST(52 AS Numeric(5, 0)), N'O', N'#', N'Y', NULL, N'HRPT3')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'441       ', N'44        ', N'Attendance By Month', CAST(53 AS Numeric(5, 0)), N'O', N'/Transactions/EmpMonthlyAttendance', N'Y', NULL, N'HRPT31')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'45        ', N'4         ', N'Payroll Process', CAST(55 AS Numeric(5, 0)), N'O', N'#', N'Y', NULL, N'HRPT4')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'451       ', N'45        ', N'WPS Process', CAST(56 AS Numeric(5, 0)), N'O', N'/Transactions/WPSProcess', N'Y', NULL, N'HRPT41')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'452       ', N'45        ', N'Pre Payroll Process', CAST(57 AS Numeric(5, 0)), N'O', N'/Transactions/PrePayrollProcess', N'Y', NULL, N'HRPT42')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'453       ', N'45        ', N'Post Payroll Process', CAST(58 AS Numeric(5, 0)), N'O', N'/Transactions/PostPayrollProcess', N'Y', NULL, N'HRPT43')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'454       ', N'45        ', N'Single Payroll', CAST(110 AS Numeric(5, 0)), N'O', N'/Transactions/Singlepayroll', N'Y', NULL, N'HRPT44')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'46        ', N'4         ', N'Var. Pay/Deduction', CAST(59 AS Numeric(5, 0)), N'O', N'/Transactions/VariablePayDedComponents', N'Y', NULL, N'HRPT5')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'47        ', N'4         ', N'Emp. Progression', CAST(60 AS Numeric(5, 0)), N'O', N'/Transactions/EmployeeProgression', N'Y', NULL, N'HRPT6')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'48        ', N'4         ', N'Employee Seperation', CAST(61 AS Numeric(5, 0)), N'O', N'/Transactions/OrgGratuity', N'Y', NULL, N'HRPT7')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'49        ', N'4         ', N'Document Renewal', CAST(62 AS Numeric(5, 0)), N'O', N'/Transactions/DocumentRenewal', N'Y', NULL, N'HRPT8')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'491       ', N'4         ', N'Employee Transfer', CAST(40 AS Numeric(5, 0)), N'O', N'/Transactions/EmpTransfer', N'Y', N'NULL      ', N'HRPT9')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'492       ', N'4         ', N'Provision Adj.', CAST(40 AS Numeric(5, 0)), N'O', N'/Transactions/EmpProvisionAdj', N'Y', N'NULL      ', N'HRPT14')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'5         ', N'0         ', N'Reports', CAST(63 AS Numeric(5, 0)), N'O', N'#', N'Y', NULL, N'HRPR')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'51        ', N'5         ', N'Master Listing', CAST(64 AS Numeric(5, 0)), N'O', N'#', N'Y', NULL, N'HRPR1')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'511       ', N'51        ', N'Branch List', CAST(65 AS Numeric(5, 0)), N'O', N'/Reports/BranchList', N'Y', NULL, N'HRPR11')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'5110      ', N'51        ', N'User List', CAST(66 AS Numeric(5, 0)), N'O', N'/Reports/UserList', N'Y', NULL, N'HRPR110')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'5111      ', N'51        ', N'Vehicle List', CAST(67 AS Numeric(5, 0)), N'O', N'/Reports/VehicleList', N'Y', NULL, N'HRPR111')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'512       ', N'51        ', N'Code List', CAST(68 AS Numeric(5, 0)), N'O', N'/Reports/CodeList', N'Y', NULL, N'HRPR12')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'513       ', N'51        ', N'Company Document', CAST(69 AS Numeric(5, 0)), N'O', N'/Reports/CompanyDocument', N'Y', NULL, N'HRPR13')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'514       ', N'51        ', N'Company Loan', CAST(70 AS Numeric(5, 0)), N'O', N'/Reports/CompanyLoan', N'Y', NULL, N'HRPR14')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'515       ', N'51        ', N'Country', CAST(71 AS Numeric(5, 0)), N'O', N'/Reports/Country', N'Y', NULL, N'HRPR15')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'516       ', N'51        ', N'Currency List', CAST(72 AS Numeric(5, 0)), N'O', N'/Reports/CurrencyList', N'Y', NULL, N'HRPR16')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'517       ', N'51        ', N'Department List', CAST(73 AS Numeric(5, 0)), N'O', N'/Reports/DepartmentList', N'Y', NULL, N'HRPR17')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'518       ', N'51        ', N'User Group Rights', CAST(74 AS Numeric(5, 0)), N'O', N'/Reports/UserGroupRights', N'Y', NULL, N'HRPR18')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'519       ', N'51        ', N'User Group List', CAST(75 AS Numeric(5, 0)), N'O', N'/Reports/UserGroupList', N'Y', NULL, N'HRPR19')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'52        ', N'5         ', N'Personal', CAST(76 AS Numeric(5, 0)), N'O', N'#', N'Y', NULL, N'HRPR2')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'521       ', N'52        ', N'Employee Short List', CAST(77 AS Numeric(5, 0)), N'O', N'/Reports/EmpShortList', N'Y', NULL, N'HRPR21')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'5210      ', N'52        ', N'Balance', CAST(50 AS Numeric(5, 0)), N'O', N'/Reports/Balance', N'Y', N'NULL      ', N'HRPR210')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'5211      ', N'52        ', N'Employee History', CAST(106 AS Numeric(5, 0)), N'0', N'/Reports/EmpHistory', N'Y', NULL, N'HRPR211')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'5212      ', N'52        ', N'Employee Transfer', CAST(107 AS Numeric(5, 0)), N'O', N'/Reports/EmpTransfer', N'Y', N'          ', N'HRPR212')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'522       ', N'52        ', N'Employee Analysis', CAST(82 AS Numeric(5, 0)), N'O', N'/Reports/EmpAnalysis', N'Y', NULL, N'HRPR22')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'523       ', N'52        ', N'Document Expired', CAST(83 AS Numeric(5, 0)), N'O', N'/Reports/DocExpired', N'Y', NULL, N'HRPR23')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'524       ', N'52        ', N'Leave Master', CAST(84 AS Numeric(5, 0)), N'O', N'/Reports/LeaveMaster', N'Y', NULL, N'HRPR24')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'525       ', N'52        ', N'Leave Analysis', CAST(85 AS Numeric(5, 0)), N'O', N'/Reports/LeaveAnalysis', N'Y', NULL, N'HRPR25')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'526       ', N'52        ', N'Annual Leave Due', CAST(86 AS Numeric(5, 0)), N'O', N'/Reports/AnnualLeaveDue', N'Y', NULL, N'HRPR26')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'527       ', N'52        ', N'Employee Transaction', CAST(78 AS Numeric(5, 0)), N'O', N'/Reports/EmpTransactions', N'Y', N'NULL      ', N'HRPR27')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'528       ', N'52        ', N'Single Monthly Details', CAST(79 AS Numeric(5, 0)), N'O', N'/Reports/SingleMonthlyDetails', N'Y', N'NULL      ', N'HRPR28')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'53        ', N'5         ', N'Payroll', CAST(90 AS Numeric(5, 0)), N'O', N'#', N'Y', NULL, N'HRPR3')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'531       ', N'53        ', N'Pay Slip', CAST(91 AS Numeric(5, 0)), N'O', N'/Reports/PaySlip', N'Y', NULL, N'HRPR31')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'532       ', N'53        ', N'Pay Register', CAST(92 AS Numeric(5, 0)), N'O', N'/Reports/PayRegister', N'Y', NULL, N'HRPR32')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'533       ', N'53        ', N'Employee Fixed Payroll', CAST(93 AS Numeric(5, 0)), N'O', N'/Reports/EmployeeFixedPayroll', N'Y', NULL, N'HRPR33')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'534       ', N'53        ', N'Pay Analysis', CAST(94 AS Numeric(5, 0)), N'O', N'/Reports/PayAnalysis', N'Y', NULL, N'HRPR34')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'535       ', N'53        ', N'Loan Waiting For Approval', CAST(87 AS Numeric(5, 0)), N'O', N'/Reports/LoanWaitingForApproval', N'Y', NULL, N'HRPR35')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'536       ', N'53        ', N'Loan Waiting For Disbursal', CAST(88 AS Numeric(5, 0)), N'O', N'/Reports/LoanWaitingForDisbursal', N'Y', NULL, N'HRPR36')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'537       ', N'53        ', N'Loan Due List', CAST(89 AS Numeric(5, 0)), N'O', N'/Reports/LoanDueList', N'Y', NULL, N'HRPR37')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'538       ', N'53        ', N'Loan Closed', CAST(81 AS Numeric(5, 0)), N'O', N'/Reports/LoanClosed', N'Y', NULL, N'HRPR38')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'539       ', N'53        ', N'Loan Analysis', CAST(81 AS Numeric(5, 0)), N'O', N'/Reports/LoanAnalysis', N'Y', NULL, N'HRPR39')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'55        ', N'5         ', N'Provisions', CAST(97 AS Numeric(5, 0)), N'O', N'#', N'Y', N'NULL      ', N'HRPR5')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'551       ', N'55        ', N'Provisions', CAST(98 AS Numeric(5, 0)), N'O', N'/Reports/Provisions', N'Y', N'NULL      ', N'HRPR51')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'56        ', N'4         ', N'Employee Savings', CAST(112 AS Numeric(5, 0)), N'O', N'#', N'Y', NULL, N'HREFM')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'561       ', N'56        ', N'Approval', CAST(113 AS Numeric(5, 0)), N'O', N'/Transactions/EmpFundApproval', N'Y', NULL, N'HREFA')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'562       ', N'56        ', N'Disburse', CAST(114 AS Numeric(5, 0)), N'O', N'/Transactions/EmpFundDisburse', N'Y', NULL, N'HREFD')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'6         ', N'0         ', N'House Keeping', CAST(99 AS Numeric(5, 0)), N'O', N'#', N'Y', NULL, N'HRPHK')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'61        ', N'6         ', N'Month End Process', CAST(100 AS Numeric(5, 0)), N'O', N'/HouseKeeping/MonthEndProcess', N'Y', NULL, N'HRPHK1')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'7         ', N'0         ', N'Self Services', CAST(101 AS Numeric(5, 0)), N'O', N'#', N'Y', NULL, N'HRPSS')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'71        ', N'7         ', N'Loan Application', CAST(102 AS Numeric(5, 0)), N'O', N'/SelfService/LoanApplication', N'Y', NULL, N'HRPSS1')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'72        ', N'7         ', N'Leave Application', CAST(103 AS Numeric(5, 0)), N'O', N'/SelfService/LeaveApplication', N'Y', NULL, N'HRPSS2')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'73        ', N'7         ', N'Leave Salary/Ticket Appl.', CAST(104 AS Numeric(5, 0)), N'O', N'/SelfService/LeaveSalaryApplication', N'Y', NULL, N'HRPSS3')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'74        ', N'7         ', N'Fund Request', CAST(105 AS Numeric(5, 0)), N'O', N'/SelfService/FundRequestApplication', N'Y', NULL, N'HRPSS4')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'9         ', N'0         ', N'Incentives', CAST(200 AS Numeric(5, 0)), N'O', N'#', N'Y', NULL, N'HRPI')
GO
INSERT [dbo].[MenuCtrl_N] ([AppCd], [MenuId], [Prnt], [Caption], [MenuOrder], [Typ], [Frm], [Active], [Abbr], [ProcessId]) VALUES (N'H    ', N'91        ', N'9         ', N'Emp. Incentives', CAST(100 AS Numeric(5, 0)), N'O', N'/INCENTIVES/EmpIncentives', N'Y', NULL, N'HREMPI')
GO
insert into MenuCtrl_N values('H','114','11','Company',6,'O','/Settings/Company','Y',NULL,'HRPS14')
insert into MenuCtrl_N values('H','115','11','UserAudt',7,'O','/Settings/Useraudit','Y',NULL,'HRPS15')
