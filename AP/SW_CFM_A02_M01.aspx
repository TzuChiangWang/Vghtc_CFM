<%@ Page Title="" Language="C#" MasterPageFile="~/AP/VGHTC_MSTPG.Master" AutoEventWireup="true" CodeFile="SW_CFM_A02_M01.aspx.cs" Inherits="AP_SW_CFM_A02_M01" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHeader" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {

            var dataSource = new kendo.data.DataSource({
                transport: {
                    read: {
                        url: "../SERVICES/WS_CFM_A02_M01.ashx",
                        dataType: "json",
                        type: "POST"
                    },
                    create: {
                        url: "../SERVICES/WS_CFM_A02_M01.ashx",
                        dataType: "json",
                        type: "POST",
                        complete: function (jqXhr, textStatus) {
                            var result = jQuery.parseJSON(jqXhr.responseText);
                            alert(result.SMESSAGE);
                            if (result.SRESULT == "TRUE") {
                                dataSource.read();
                            }
                        }
                    },
                    update: {
                        url: "../SERVICES/WS_CFM_A02_M01.ashx",
                        dataType: "json",
                        type: "POST",
                        complete: function (jqXhr, textStatus) {
                            var result = jQuery.parseJSON(jqXhr.responseText);
                            alert(result.SMESSAGE);
                            if (result.SRESULT == "TRUE") {
                                dataSource.read();
                            }
                        }
                    },
                    destroy: {
                        url: "../SERVICES/WS_CFM_A02_M01.ashx",
                        dataType: "json",
                        type: "POST",
                        complete: function (jqXhr, textStatus) {
                            var result = jQuery.parseJSON(jqXhr.responseText);
                            alert(result.SMESSAGE);
                            if (result.SRESULT == "TRUE") {
                                dataSource.read();
                            }
                        }
                    },
                    parameterMap: function (options, operation) {
                        if (operation == "read") {
                            return {
                                FCode: "R",
                                StatusID: $("#STATUS_ID_TEXT").val(),
                                models: kendo.stringify(options)
                            }
                        }
                        else {
                            var Fcode;
                            switch (operation) {
                                case "update": Fcode = "U";
                                    break;
                                case "create": Fcode = "C";
                                    break;
                                case "destroy": Fcode = "D";
                                    break;
                            }
                            return {
                                FCode: Fcode,
                                models: kendo.stringify(options)
                            }
                        }
                    }
                },
                schema: {
                    type: 'json',
                    data: 'DATA',
                    total: function (d) { return d.TOTALCOUNT; },
                    model: {
                        id: "APPLY_STATUS",
                        fields: {
                            APPLY_STATUS: {
                                editable: true, type: "string",
                                validation: {
                                    required: true,
                                    statusidvalidation: function (input) {
                                        if (input.is("[name='APPLY_STATUS']") && input.val() != "") {
                                            input.attr("data-statusidvalidation-msg", "狀態代碼僅可輸入數字");
                                            return /^[0-9]+$/.test(input.val());
                                        }
                                        return true;
                                    },
                                    statuslengthvalidation: function (input) {
                                        //console.log("Inside validation", input.val(),input.val().length <= 2);
                                        if (input.is("[name='APPLY_STATUS']") && input.val() != "") {
                                            input.attr("data-statuslengthvalidation-msg", "錯誤代碼必為兩位數字");
                                            return input.val().length == 2;
                                        }
                                        return true;
                                    }
                                }
                            },
                            STATUS_DESCRIPTION: {
                                editable: true, type: "string",
                                validation: { required: true }
                            },
                            LAST_EDIT_DTTM: { editable: false, type: "string"},
                            LAST_EDIT_USER_ID: { editable: false, type: "string" },
                            LAST_EDIT_USER_NAMEC: { editable: false, type: "string" }
                        }
                    }
                },
                pageSize: 10,
                serverPaging: true,//使用server端的分頁，點選分頁將會重新綁定DataSoure給Grid
                serverSorting: true//使用server端的排序，點選排序將會重新綁定DataSoure給Grid
            });

            $("#QueryButton").click(function () {
                dataSource.read();
            });            

            $("#ListGrid").kendoGrid({
                dataSource: dataSource,
                height: 520,
                selectable: true,
                resizable: true,
                sortable: {
                    mode: "multiple",
                    allowUnsort: false
                },
                pageable: {
                    pageSizes: true,
                    buttonCount: 5
                },
                columns: [
			        { command: [{ name: "edit", text: "修改" } ,{ name: "destroy", text: "刪除" }], width: 60 },
			        { field: "APPLY_STATUS", title: "狀態代碼", width: 40 },
			        { field: "STATUS_DESCRIPTION", title: "狀態描述", width: 70 },
                    { field: "LAST_EDIT_DTTM", title: "修改時間", width:50 },
                    { field: "LAST_EDIT_USER_ID", title: "修改人ID", width:50 },
                    { field: "LAST_EDIT_USER_NAMEC", title: "修改人姓名", width:50 }
                ],
                editable: {
                    mode: "popup", //使用Popup的模式編輯資料
                    update: true, // 若設定為True,當按下Update即更新server資料
                    confirmation: "確定刪除？",
                    window: {
                        width: 600
                    }
                },
                edit: function (e) {
                    e.container.find('.k-edit-form-container').width('100%');
                    if (!e.model.isNew()) {
                        // 編輯
                        e.container.find("input[name=APPLY_STATUS]").attr('disable', true);

                        $('.k-grid-update').text('更新');
                        $('.k-grid-cancel').text('返回');
                        $('.k-window-title').text('編輯');
                    }
                    else {
                        // 新增
                        // set constraints to the input
                        e.container.find("input[name=STATUS_DESCRIPTION]").attr('maxlength', 17);
                        // hide edit information column
                        e.container.find('.k-edit-label:nth-child(5)').hide();
                        e.container.find('.k-edit-field:nth-child(6)').hide();
                        e.container.find('.k-edit-label:nth-child(7)').hide();
                        e.container.find('.k-edit-field:nth-child(8)').hide();
                        e.container.find('.k-edit-label:nth-child(9)').hide();
                        e.container.find('.k-edit-field:nth-child(10)').hide();

                        $('.k-grid-update').text('確定');
                        $('.k-grid-cancel').text('取消');
                        $('.k-window-title').text('新增');
                    }
                },
                toolbar: [
                        {
                            text: "新增資料",
                            name: "create",
                            iconClass: "k-icon k-add"
                        }
                ]
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" Runat="Server">
    <table class="table" style="width: 100%;">
        <tbody>
            <tr>
                <td style="border-top-width: 0px; border-top-style: none;">
                    <div class="input-group col-lg-3 col-md-3 col-sm-3 pull-left">
                        <span class="input-group-addon">狀態代碼</span>
                        <input class="form-control" id="STATUS_ID_TEXT" type="text" placeholder="e.g. 00|01|11"/>
                    </div>
                    <div class="input-group col-lg-3 col-md-3 col-sm-3 pull-left" style="left: 0px; top: 0px; width: 122px; height: 25px; margin-top: 2px; margin-left: 10px;">
                        <button type="button" tabindex="0" class="k-primary  k-button k-button-icontext"
                            id="QueryButton">
                            <span class="k-sprite k-icon k-i-search"></span>確定</button>
                    </div>
                </td>
            </tr>
        </tbody>
    </table>
    <div style="width: 100%">
        <div id="ListGrid">
        </div>
    </div>
</asp:Content>

