window["datatable"] = $('#TravelFaresDataTable').DataTable(
    {
        ajax: "/Organisation/FetchTravelFares",
        ordering: false,
        columns: [
            { data: "srNo" },
            { data: "sector" },
            { data: "travelClass" },
            { data: "sDes" },
            { data: "des" },
            {
                data: function (row) {
                    var formattedFromDate = moment(row.fromDate).format(CommonSetting.DisplayDateFormat);
                    var formattedToDate = moment(row.toDate).format(CommonSetting.DisplayDateFormat);
                    return `${formattedFromDate} - ${formattedToDate}`;
                }
            },
            { data: "fare" },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-info" onclick="showTravelFareModal('${row.srNo}','${row.sectCd.trim()}','${row.classCd.trim()}')">
                                <i class="fas fa-pen"></i>
                            </button>                                                                          <button class="btn btn-sm btn-danger ml-2" onclick="deleteTravelFare('${row.srNo}','${row.sectCd.trim()}','${row.classCd.trim()}')">
                                <i class="fa fa-trash"></i>
                            </button>`
                }, "width": "80px"
            }
        ],
    }
);
function showTravelFareModal(cd, sectCd, classCd) {
    var url = `/Organisation/GetTravelFare?cd=${cd}&sectCd=${sectCd}&classCd=${classCd}`;
    $('#TravelFareModal').load(url, function () {
        parseDynamicForm();
        $('#DateRange').daterangepicker(dateRangePickerDefaultOptions);
        $("#TravelFareModal").modal("show");
    });
}
function deleteTravelFare(cd, sectCd, classCd) {
    Swal.fire({
        title: "Are you sure?",
        text: "You want to Delete?",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Yes!"
    }).then((result) => {
        if (result.isConfirmed) {
            deleteAjax(`/Organisation/DeleteTravelFare?cd=${cd}&sectCd=${sectCd}&classCd=${classCd}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveTravelFare(btn) {
    var frm = $("#travel-fare-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/Organisation/SaveTravelFare", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#TravelFareModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#TravelFareModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}