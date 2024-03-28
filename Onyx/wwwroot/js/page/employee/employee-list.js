﻿function BindEmployeeGrid(url) {
    $("#page-loader").removeClass("d-none");
    $('#EmployeeTableContainer').load(url, function () {
        $("#page-loader").addClass("d-none");
    });
}
bindEmployeeDropdown();
var url = `/Employee/FetchEmployees`;
BindEmployeeGrid(url);
$(document).on('click', '.pagination a', function (e) {
    e.preventDefault();
    var url = $(this).attr("href");
    BindEmployeeGrid(url);
});
function filterEmployee(btn) {
    loadingButton(btn);
    var frm = $("#employee-filter-frm").serialize();
    var url = `/Employee/FetchEmployees?${frm}`;
    BindEmployeeGrid(url);
    unloadingButton(btn);
    $("#EmployeeFilterModal").modal("hide");
}
function resetFilter() {
    var frm = $('#employee-filter-frm');
    frm.find("input").val("");
    frm.find(".filter-select-picker").val('').selectpicker('refresh');
    frm.find(".filter-select-picker").selectpicker('deselectAll');
}
function bindEmployeeDropdown() {
    $("#EmpCd").empty();
    getAjax(`/Employee/FetchEmployeeItems`, function (response) {
        var html = '';
        $.each(response, function (i, item) {
            html += `<option value='${item.cd.trim()}'>${item.name}(${item.cd.trim()})</option>`
        })
        $("#EmpCd").html(html);
        $('.select-picker').selectpicker('refresh');
    });
}
$("#EmpCd").change(function (e) {
    var url = `/Employee/FetchEmployees?Name=${encodeURI(e.target.value)}`;
    BindEmployeeGrid(url);
})
function changeShowEntries(curr) {
    var frm = $("#employee-filter-frm").serialize();
    var name = $("#EmpCd").val();
    var url = `/Employee/FetchEmployees?Name=${encodeURI(name)}&${frm}&pageSize=${curr.value}`;
    BindEmployeeGrid(url);
}