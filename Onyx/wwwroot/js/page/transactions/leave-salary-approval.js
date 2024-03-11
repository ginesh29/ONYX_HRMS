window["datatable"] = $('#EmployeeLeavesSalaryApprovalDataTable').DataTable(
    {
        ajax: "/Transactions/FetchEmpLeaveSalaryApprovalData",
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            {
                data: function (row) {
                    return `${row.emp}(${row.empCd.trim()})`
                }
            },            
            { data: "lvSalary" },
            { data: "lvTicket" },
            //{
            //    data: function (row) {
            //        return `<button data-toggle="tooltip" data-original-title="Approve" class="btn btn-sm btn-info" onclick="showLeaveApprovalModal('${row.transNo.trim()}')">
            //                                                            <i class="fas fa-check"></i>
            //                                                        </button>
            //                                                        <button data-toggle="tooltip" data-original-title="Reject" class="btn btn-sm btn-danger ml-2" onclick="showLeaveApprovalModal('${row.transNo.trim()}',true)">
            //                                                            <i class="fa fa-times"></i>
            //                                                        </button>`;
            //    }, "width": "80px"
            //}
        ],
    }
);
//var isAdmin = $("#IsAdmin").val() == 1;
//if (isAdmin)
//    window["datatable"].column(8).visible(false);
//function showLeaveApprovalModal(transNo, reject) {
//    var url = `/Transactions/GetEmpLeaveApproval?transNo=${transNo}`;
//    $('#EmployeeLeaveApprovalModal').load(url, function () {
//        parseDynamicForm();
//        if (!reject) {
//            var startDate = $("#LvFrom").val();
//            var endDate = $("#LvTo").val();
//            $('#LvDateRange,#WopDateRange').daterangepicker({
//                minDate: startDate,
//                maxDate: endDate,
//                autoUpdateInput: false
//            });
//            $('#LvDateRange').on('apply.daterangepicker', function (ev, picker) {
//                var startDate = picker.startDate.format('MM/DD/YYYY');
//                var endDate = picker.endDate.format('MM/DD/YYYY');
//                var lvDays = picker.endDate.diff(picker.startDate, 'days');
//                $("#LvDays-txt").text(`(${lvDays} days)`);
//                $("#LvDays").val(lvDays)
//                $(this).val(startDate + ' - ' + endDate);
//                $("#LvFrom").val(startDate);
//                $("#LvTo").val(endDate);
//                UpdateTotalLeavesDays();
//            });
//            $('#WopDateRange').on('apply.daterangepicker', function (ev, picker) {
//                var startDate = picker.startDate.format('MM/DD/YYYY');
//                var endDate = picker.endDate.format('MM/DD/YYYY');
//                var WOPlvDays = picker.endDate.diff(picker.startDate, 'days');
//                $("#WopLvDays-txt").text(`(${WOPlvDays} days)`);
//                $("#WopLvDays").val(WOPlvDays)
//                $(this).val(startDate + ' - ' + endDate);
//                $("#WopFrom").val(startDate);
//                $("#WopTo").val(endDate);
//                UpdateTotalLeavesDays();
//            });
//            $('#LvDateRange,#WopDateRange').on('cancel.daterangepicker', function (ev, picker) {
//                $(this).val('');
//            });
//            $("#Status").val("Y");
//        }
//        else {
//            $("#approval-div").addClass("d-none");
//            $("#approval-div input").val("");
//            $("#btn-submit").text("Reject");
//            $("#btn-submit").removeClass("btn-info").addClass("btn-danger");
//            $("#Status").val("R");
//        }
//        $("#EmployeeLeaveApprovalModal").modal("show");
//    });
//}

//function UpdateTotalLeavesDays() {
//    var lvDays = $("#LvDays").val();
//    var WoplvDays = $("#WopLvDays").val();
//    $("#totalLvDays").text(Number(lvDays) + Number(WoplvDays));
//}
//function saveLeaveApproval(btn) {
//    var frm = $("#leave-approval-frm");
//    if (frm.valid()) {
//        loadingButton(btn);
//        postAjax("/Transactions/SaveLeaveApproval", frm.serialize(), function (response) {
//            if (response.success) {
//                showSuccessToastr(response.message);
//                $("#EmployeeLeaveApprovalModal").modal("hide");
//                reloadDatatable();
//            }
//            else {
//                showErrorToastr(response.message);
//            }
//            unloadingButton(btn);
//        });
//    }
//}