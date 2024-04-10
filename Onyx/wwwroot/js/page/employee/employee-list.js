var hasAddPermission = $("#HasAddPermission").val();
if (!hasAddPermission)
    $("#btn-add-employee").remove();

function BindEmployeeGrid(page) {
    loadingPage();
    var frm = $("#employee-filter-frm").serialize();
    var name = $("#EmpCd").val();
    name = name ? name : searchText;
    var pageSize = $("#PageSize").val();
    page = page ? page : $(".active.page-item .page-link").text();
    var url = `/Employee/FetchEmployees?Name=${encodeURI(name)}&${frm}&page=${page}&pageSize=${pageSize}`;
    $('#EmployeeTableContainer').load(url, function () {
        unloadingPage();
    });
}
$(function () {
    bindEmployeeDropdown();
    BindEmployeeGrid();
})
$(document).on('click', '.pagination a', function (e) {
    e.preventDefault();
    var page = $(this).text();
    BindEmployeeGrid(page);
});
function filterEmployee(btn) {
    loadingButton(btn);
    BindEmployeeGrid();
    unloadingButton(btn);
    $("#EmployeeFilterModal").modal("hide");
}
function resetFilter() {
    var frm = $('#employee-filter-frm');
    frm.find("input").val("");
    frm.find(".filter-select-picker").val('').selectpicker('refresh');
    frm.find(".filter-select-picker").selectpicker('deselectAll');
}
$("#EmpCd").change(function () {
    BindEmployeeGrid();
})
function changeShowEntries() {
    BindEmployeeGrid();
}
var searchText = '';
$('#EmpCd').on('select2:open', function () {
    $('.select2-search__field').val(searchText.trim());
    $('.select2-search__field').on('input', function (e) {
        searchText = $(this).val();
        $(this).val(searchText.trim());
        BindEmployeeGrid();
    });
});