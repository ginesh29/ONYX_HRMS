window["datatable"] = $('#UsersDataTable').DataTable(
    {
        ajax: "/Settings/FetchUsers",
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            { data: "code" },
            { data: "loginId" },
            { data: "abbr" },
            { data: "username" },
            {
                data: function (row) {
                    var formattedDate = moment(row.expiryDt).format(CommonSetting.DisplayDateFormat);
                    return formattedDate;
                },
            },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-info" onclick="showUserModal('${row.code}')" ${editEnable}>
                                <i class="fas fa-pen"></i>
                            </button>
                            <button class="btn btn-sm btn-danger ml-2" onclick="deleteUser('${row.code}')" ${deleteEnable}>
                                <i class="fa fa-trash"></i>
                            </button>`
                }, "width": "80px"
            }
        ],
    }
);
function showUserModal(cd) {
    var url = `/Settings/GetUser?cd=${cd}`;
    $('#UserModal').load(url, function () {
        parseDynamicForm();
        $("#UserModal").modal("show");
        var initJsTree = true;
        $('#tree-view').jstree({
            "checkbox": {
                "keep_selected_style": false,
                "whole_node": false,
                "tie_selection": false
            },
            "plugins": ["checkbox"]
        }).on("open_node.jstree close_node.jstree check_node.jstree uncheck_node.jstree", function (e, data) {
            var treeInstance = $('#tree-view').jstree(true);
            var allNodes = treeInstance.get_json('#', { flat: true });
            var checkedNodes = treeInstance.get_checked();
            var uncheckedNodes = allNodes.filter(node => !checkedNodes.includes(node.id)).map(node => node.id);
            $.each(checkedNodes, function (i, item) {
                console.log(initJsTree)
                if (!initJsTree) {
                    $(`#permission_checkbox_Add_${item}`).prop("checked", true);
                    $(`#permission_checkbox_Edit_${item}`).prop("checked", true);
                    $(`#permission_checkbox_Delete_${item}`).prop("checked", true);
                    $(`#permission_checkbox_View_${item}`).prop("checked", true);
                    $(`#permission_checkbox_Print_${item}`).prop("checked", true);
                }
                expandAllParents($('#tree-view'), item);
            });
            $.each(uncheckedNodes, function (i, item) {
                $(`#permission_checkbox_Add_${item}`).prop("checked", false);
                $(`#permission_checkbox_Edit_${item}`).prop("checked", false);
                $(`#permission_checkbox_Delete_${item}`).prop("checked", false);
                $(`#permission_checkbox_View_${item}`).prop("checked", false);
                $(`#permission_checkbox_Print_${item}`).prop("checked", false);
            });

            $("#MenuIds").val(checkedNodes.toString());
        }).on('ready.jstree', function () {
            initJsTree = false;
        });
    });
}
function expandAllParents(treeInstance, nodeId) {
    var currentNode = treeInstance.jstree(true).get_node(nodeId);
    if (currentNode && currentNode.parent !== '#') {
        treeInstance.jstree('open_node', currentNode.parent);
        expandAllParents(treeInstance, currentNode.parent);
    }
}
function deleteUser(cd) {
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
            deleteAjax(`/settings/DeleteUser?cd=${cd}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveUser(btn) {
    var frm = $("#user-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/settings/SaveUser", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#UserModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#UserModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}
function changePermission(e) {
    var id = $(e).attr("data-id");
    var checked = $(`#permission_${id}`).is(":checked");
    $(`#permission_${id}`).prop("checked", !checked);
}