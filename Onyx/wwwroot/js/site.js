setActiveMenu();
const decimalMaskOptions = {
    alias: 'numeric',
    radixPoint: '.',
    autoGroup: true,
    digits: 2,
    digitsOptional: false,
    placeholder: '0',
}
const percentageMaskOptions = {
    alias: "percentage",
    suffix: ' %',
    autoGroup: true,
    autoUnmask: true,
    digits: 2,
}
const amountMaskOptions = {
    alias: 'numeric',
    radixPoint: '.',
    autoGroup: true,
    allowMinus: false,
    digits: 2,
    digitsOptional: false,
    groupSeparator: ',',
}
const intMaskOptions = {
    alias: 'numeric',
    radixPoint: '.',
    autoGroup: true,
    digits: 0,
    digitsOptional: false,
    placeholder: '0',
}
const dataTableDefaultOptions = {
    "pagingType": "simple",
    "ordering": false
}
function loadingButton(btn) {
    var $this = $(btn);
    if (!$this.find(".fa-spinner").length) {
        var spinnerHtml = "<i class='fas fa-spinner fa-spin ml-2'></i>";
        $this.append(spinnerHtml);
    }
    else
        $this.find(".fa-spinner").removeClass("d-none");
    $("#page-loader").removeClass("d-none");
    $this.prop("disabled", true);
}
function unloadingButton(btn) {
    var $this = $(btn);
    setTimeout(function () {
        $this.prop("disabled", false);
        $($this).find("i").removeClass("d-none");
        $this.find(".fa-spinner").addClass("d-none");
        $("#page-loader").addClass("d-none");
    }, 1000);
}
function showSuccessToastr(msg) {
    toastr.clear()
    toastr.success(msg);
}
function showWarningToastr(msg) {
    toastr.clear()
    toastr.warning(msg);
}
function showErrorToastr(msg) {
    toastr.clear()
    toastr.error(msg);
}

function logOut(btn) {
    loadingButton(btn);
    setTimeout(function () {
        window.location.href = "/account/logout";
    }, 1000);
}
function getAjax(url, callback) {
    $.get(url, callback);
}
function postAjax(url, formdata, callback) {
    $.post(url, formdata, callback);
}
function filePostAjax(url, formData, callback) {
    $.ajax({
        url: url,
        type: 'POST',
        data: new FormData(formData),
        processData: false,
        contentType: false,
        success: function (response) {
            callback(response);
        },
    });
}
var deleteAjax = function (url, callback) {
    $.ajax({
        url: url,
        type: 'DELETE',
        success: callback,
    })
}
function setActiveMenu() {
    var activeurl = window.location.pathname;
    var el = $('a[href="' + activeurl + '"]');
    el.addClass('active');
    el.parent('li').parent('ul').parent().find(".nav-link").eq(0).addClass('active');
    el.parent('li').parent('ul').parent().addClass('menu-open');
}
function formatDate(date) {
    return (date.getMonth() + 1).toString().padStart(2, '0') + '/' +
        date.getDate().toString().padStart(2, '0') + '/' +
        date.getFullYear();
}
function reloadPageAfterSometime() {
    setTimeout(function () {
        window.location.reload();
    }, 2000)
}
function parseDynamicForm() {
    $("form").removeData("validator");
    $("form").removeData("unobtrusiveValidation");
    $.validator.unobtrusive.parse("form");
}
function removeBackdrop() {
    $('body').removeClass('modal-open');
    $('.modal-backdrop').remove();
}
function exportExcel(table, filePrefix) {
    var header = [table.columns().header().map(d => d.textContent).toArray()];
    var data = table.data().toArray();
    var dataWithHeader = header.concat(data);
    var wb = XLSX.utils.book_new();
    var ws = XLSX.utils.aoa_to_sheet(dataWithHeader);
    XLSX.utils.book_append_sheet(wb, ws, 'Sheet1');
    var filename = `${filePrefix}.xlsx`;
    XLSX.writeFile(wb, filename);
}