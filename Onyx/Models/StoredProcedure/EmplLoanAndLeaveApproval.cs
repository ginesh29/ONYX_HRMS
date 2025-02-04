﻿using Onyx.Models.ViewModels;

namespace Onyx.Models.StoredProcedure
{
    public class EmplLoanAndLeaveApproval
    {
        public IEnumerable<HeadCountModel> HeadCounts { get; set; }
        public string CurrentMonth { get; set; }
        public string LastMonth { get; set; }
        public int OnLeave { get; set; }
        public int LeaveApplied { get; set; }
        public int Working { get; set; }
        public IEnumerable<SalaryDetailModel> SalaryDetails { get; set; }
        public IEnumerable<SalaryDetailModel> UserSalaryDetails { get; set; }
    }
}
