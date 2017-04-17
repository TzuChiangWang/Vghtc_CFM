<%@ Page Title="" Language="C#" MasterPageFile="VGHTC_MSTPG.Master" AutoEventWireup="true"
    CodeFile="SW_EDU_A03_C01.aspx.cs" Inherits="SW_EDU_A03_C01" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHeader" runat="Server">
        
    <script type="text/javascript">
        $(document).ready(function () {
            
            var dataSource = new kendo.data.DataSource({
                transport: {
                    read: {
                        url: "../SERVICES/WS_EDU_A03_C01.ashx",
                        dataType: "json",
                        type: "POST",
                        complete: function (jqXhr, textStatus) {
                            var result = jQuery.parseJSON(jqXhr.responseText);
                            if (result.SRESULT == "FALSE") {
                                alert(result.SMESSAGE);
                            }
                        }
                    },
                    create: {
                        url: "../SERVICES/WS_EDU_A03_C01.ashx",
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
                        url: "../SERVICES/WS_EDU_A03_C01.ashx",
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
                        url: "../SERVICES/WS_EDU_A03_C01.ashx",
                        dataType: "json",
                        type: "POST",
                        complete: function (jqXhr, textStatus) {
                            var result = jQuery.parseJSON(jqXhr.responseText);                           
                            if (result.SRESULT == "TRUE") {
                                alert(result.SMESSAGE);
                                dataSource.read();
                            } else {
                                alert(result.SMESSAGE);
                                dataSource.read();
                            }
                        }
                    },
                    parameterMap: function (options, operation) {
                        if (operation == "read") {
                            return {
                                FCode: "R",
                                LEAVE_TYPE: $("#LEAVE_TYPE_DropDownList").val(),
                                StartDate: ($("#START_DatePicker").val() == "") ? "" : kendo.toString(new Date($("#START_DatePicker").val()), "yyyyMMdd"),
                                EndDate: ($("#END_DatePicker").val() == "") ? "" : kendo.toString(new Date($("#END_DatePicker").val()), "yyyyMMdd"),
                                TITLE_ID: $("#TITLE_ID_DropDownList").val(),
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
                                case "destroy": Fcode = "S";
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
                        id: "LEAVE_SEQ",
                        fields: {
                            INTERN_STUDENT_ID: { editable: true, type: "string", validation: { required: true } },
                            NIDNO: { editable: true, type: "string" },
                            ANNUAL_LEAVE: { editable: true, type: "string" },
                            MARRY_LEAVE: { editable: true, type: "string" },
                            MATERNITY_LEAVE: { editable: true, type: "string" },
                            PATERNITY_LEAVE: { editable: true, type: "string" },
                            PREMATERNITY_LEAVE: { editable: true, type: "string" },
                            INTERN_NAMEC: { editable: true, type: "string" },
                            LEAVE_SEQ: { editable: true, type: "string" },
                            LEAVE_TYPE: { editable: true, type: "string" },
                            LEAVE_TYPEC: { editable: true, type: "string" },
                            LEAVE_SDTTM: { editable: true, type: "string" },
                            LEAVE_EDTTM: { editable: true, type: "string" },
                            LEAVE_DAYS: { editable: true, type: "string" },
                            LEAVE_HOURS: { editable: true, type: "string" },
                            LEAVE_STATUS: { editable: true, type: "string" },
                            LEAVE_STATUSC: { editable: true, type: "string" },
                            INTERNSHIP_DEPT: { editable: true, type: "string" },
                            INTERNSHIP_DEPTC: { editable: true, type: "string" },
                            LEAVE_REASON: { editable: true, type: "string" },
                            AGENT_CARDNO: { editable: true, type: "string" },
                            AGENT_NAME: { editable: true, type: "string" },
                            AGENT_TEL: { editable: true, type: "string" },
                            INSPECT_CARDNO: { editable: true, type: "string" },
                            INSPECT_NAMEC: { editable: true, type: "string" },
                            INSPECT_DATE: { editable: true, type: "string" },
                            HIDDEN_FILENAME: { editable: true, type: "string" }  //所上傳之附件的檔名
                        }
                    }
                },
                pageSize: 10,
                serverPaging: true,//使用server端的分頁，點選分頁將會重新綁定DataSoure給Grid
                serverSorting: true//使用server端的排序，點選排序將會重新綁定DataSoure給Grid
            });

            $("#QueryButton").click(function () {
                dataSource.page(1);
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
			        { command: [{ name: "edit", text: "明細", click: condition }, { name: "destroy", text: "送出" }, { text: "下載", click: dwDetails }], width: 230 },
                    { field: "INTERN_STUDENT_ID", title: "本院實習生編號", width: 120 },
                    { field: "LEAVE_SEQ", title: "假單編號", width: 120 },
                    { field: "LEAVE_TYPE", hidden: true },
                    { field: "LEAVE_TYPEC", title: "假別", width: 80 },
                    { field: "LEAVE_SDTTM", title: "請假起", width: 150 },
                    { field: "LEAVE_EDTTM", title: "請假迄", width: 150 },
                    { field: "LEAVE_DAYS", title: "請假天數", width: 80 },
                    { field: "LEAVE_HOURS", title: "請假時數", width: 80 },
                    { field: "LEAVE_STATUS", hidden: true },
                    { field: "LEAVE_STATUSC", title: "請假單狀態", width: 100 },
                    { field: "INTERNSHIP_DEPT", hidden: true },
                    { field: "INTERNSHIP_DEPTC", title: "請假日之實習單位", width: 130 },
                    { field: "LEAVE_REASON", hidden: true },
                    { field: "AGENT_CARDNO", title: "代理人卡號", width: 100 },
                    { field: "AGENT_NAME", title: "代理人姓名", width: 100 },
                    { field: "AGENT_TEL", title: "代理人聯絡電話", width: 100 },
                    { field: "INSPECT_CARDNO", title: "教學組審核者卡號", width: 80 },
                    { field: "INSPECT_NAMEC", title: "教學組審核者姓名", width: 80 },
                    { field: "INSPECT_DATE", title: "教學組審核日期", width: 120 },
                    { field: "HIDDEN_FILENAME", hidden: true } //用來接所上傳之附件的檔名
                ],
                /*  
                    透過dataBound數據綁定來控制button是否可點選
                    →若審核通過，則將送出button鎖住
                */
                dataBound: function () {
                    var grid = this;
                    var model;
                    grid.tbody.find("tr[role='row']").each(function () {
                        model = grid.dataItem(this);  //綁定前台數據

                        if (model.LEAVE_STATUS>="20") {
                            /*
                                找到class=k-grid-delete的button(即為送出)，
                                加入kendoUI使button disabled的屬性→k-state-disabled
                            */                           
                            $(this).find(".k-grid-delete").addClass("k-state-disabled");
                            /*
                              但由於command預設的button，其本質為超連結而非典型button，
                              因此無法直接用disabled的屬性鎖住。因此我們設它click之後直接return false
                              其他什麼都不做。
                            */
                            $(this).find(".k-grid-delete").click(function () {
                                return false;
                            });
                        }
                        //送出和審核中才能列印單子 20161007
                        if(model.LEAVE_STATUS!="20" && model.LEAVE_STATUS!="30" )
                        {
                            $(this).find(".k-grid-下載").addClass("k-state-disabled");
                            $(this).find(".k-grid-下載").click(function () {
                                return false;
                            });
                        }
                    });
                },
                editable: {
                    mode: "popup", //使用Popup的模式編輯資料
                    update: true, //若設定為True,當按下Update即更新server資料
                    window: {
                        width: 900
                    },
                    template: kendo.template($("#popup-editor").html())
                },
                edit: function (e) {
                   
                    e.container.find('.k-edit-form-container').width('100%');
                    $("#LEAVE_HOURS").text(e.model.LEAVE_HOURS);
                    $("#LEAVE_DAYS").text(e.model.LEAVE_DAYS);
                    //var allFileName = "";  //設一個空字串(allFileName)來串接所有上傳的檔名

                    $("#files").kendoUpload({
                        multiple: true,
                        async: {
                        // 上傳檔案 儲存
                        saveUrl: "../SERVICES/WS_EDU_A03_C01.ashx?FCode=Upload",
                        autoUpload: false,
                        batch: true  //透過batch，一次傳多個檔案 (這樣"上傳成功"就不會跳多次)
                        },
                        select: function (e) {
                            var files = e.files;  //array
                            // 確認是否上傳pdf格式
                            $.each(files, function () {
                                switch (this.extension.toLowerCase()) {
                                    case ".pdf":
                                    case ".doc":
                                    case ".docx":
                                    case ".jpg":
                                    case ".odf":
                                    case ".txt":
                                        break;
                                    default:
                                        alert("請上傳pdf、word、txt、jpg檔");
                                        e.preventDefault(); //不觸發upload
                                        break;
                                }
                            });
                        },
                        success: function (e) {
                            if (e.response.SRESULT == "FALSE") {
                                alert(e.response.SMESSAGE);
                            }
                            else {
                                // 取得file_name
                                //$("#FILE_NAME").text(e.response.FILENAME);  //show出檔名那塊區域
                                /* 用hidden的label接住檔名，並隨著新增請假資料之確認button，傳到case C
                                   利用allFileName這個string接住多個檔名
                                */
                                //    allFileName = allFileName + "," + e.response.FILENAME; //多個檔名，透過","串接
                                $("#HIDDEN_FILENAME").val(e.response.FILENAME);
                              
                                var newUploadfiles = e.response.FILENAME.split("?");  // 切出原始檔名
                                var str="";
                                for (var i = 1; i < newUploadfiles.length; i++) {
                                    str = str + "<br>" + '<a href="../UploadFiles/EDU_A03C01/' + newUploadfiles[i] + '" target="_blank">'
                                                       + newUploadfiles[i]  + '</a>' + "&nbsp"
                                                       + '<button onclick="deleteFiles(\'newupload\',\'\',\'' + newUploadfiles[i] + '\');"'
                                                       + ' >'
                                                       + '刪除' + '</button>';
                                }
                                $("#newupload").html(str);
                                $('.k-file').remove();
                                $('.k-upload-files.k-reset').remove();
                                alert(e.response.SMESSAGE);  
                            }
                        },
                        localization: {
                            select: '請選擇上傳檔案',
                            remove: '移除檔案',
                            retry: '重新上傳',
                            uploadSelectedFiles: "上傳檔案",
                            headerStatusUploading: '檔案上傳中...',
                            headerStatusUploaded: ''
                        }
                    });

                    $("input[id$='DateTimePicker']").kendoDateTimePicker({
                        culture: "zh-TW",
                        //format: "yyyyMMdd HH:mm",
                        format: "yyyy/MM/dd HH:mm",
                        interval: 30,
                        timeFormat: "HH:mm", //24 hours format
                        enable: true,
                        //change: calLeaveHours
                    });

                    $("#LEAVE_TYPE").kendoDropDownList({
                        dataTextField: "HISSYSCODENM",
                        dataValueField: "HISSYSCODE",
                        optionLabel: "-- Please Select --",
                        change: checkType,
                        enable: true,
                        dataSource: {
                            transport: {
                                read: "../SERVICES/WS_EDU_A03_C01.ashx?FCode=LeaveTypeList",
                                dataType: "json"
                            },
                            schema: {
                                type: 'json',
                                data: 'DATA',
                                model: { HISSYSCODE: "HISSYSCODE", HISSYSCODENM: "HISSYSCODENM" }
                            }
                        }
                    }).closest("span").width(150);

                    $("#LEAVE_STATUS").kendoDropDownList({
                        dataTextField: "HISSYSCODENM",
                        dataValueField: "HISSYSCODE",
                        //optionLabel: "-- Please Select --",
                        dataSource: {
                            transport: {
                                read: "../SERVICES/WS_EDU_A03_C01.ashx?FCode=LeaveStatusList",
                                dataType: "json"
                            },
                            value: "10",
                            schema: {
                                type: 'json',
                                data: 'DATA',
                                model: { HISSYSCODE: "HISSYSCODE", HISSYSCODENM: "HISSYSCODENM" }
                            }
                        }
                    }).closest("span").width(150);



                    if (e.model.LEAVE_STATUS != "10" && e.model.LEAVE_STATUS != "") {
                        $("#LEAVE_TYPE").data("kendoDropDownList").enable(false);
                        $("#LEAVE_SDTTM_DateTimePicker").data("kendoDateTimePicker").enable(false);
                        $("#LEAVE_EDTTM_DateTimePicker").data("kendoDateTimePicker").enable(false);
                        $("#LEAVE_REASON").prop("disabled", true);
                        $("#AGENT_CARDNO").prop("disabled", true);
                        $("#AGENT_NAME").prop("disabled", true);
                        $("#AGENT_TEL").prop("disabled", true);
                        //$('.k-grid-update').prop("disabled", true);  //明細→更新button鎖住
                        
                    }

                    if ($("#PS_NIDNO_TEXT").val() == "") {
                        $("#ANNUAL_LEAVE").html("");
                        $("#MARRY_LEAVE").html("");
                        $("#MATERNITY_LEAVE").html("");
                        $("#PATERNITY_LEAVE").html("");
                        $("#PREMATERNITY_LEAVE").html("");
                    }

                    if (!e.model.isNew()) {
                        //編輯
                        //var numeric = e.container.find("input[name=INTERN_STUDENT_ID]").attr('readonly', 'true');
                        
                        $('.k-grid-update').text('更新');
                        $('.k-grid-cancel').text('返回');
                        $('.k-window-title').text('編輯');
                        //$("#tdFilename").hide();  //用以接上傳附件之檔名，隱藏!
                        //計算請假天數
                        calLeaveDays(e.model.NIDNO);
                    }
                    else {
                        //新增
                        $('.k-grid-update').text('確定');
                        $('.k-grid-cancel').text('取消');
                        $('.k-window-title').text('新增');
                        //$("#download").hide();  //新增視窗不顯示附件下載
                        //$("#downloadTitle").hide();
                        //$("#tdFilename").hide();  //用以接上傳附件之檔名，隱藏!
                        //查詢資料
                        dsPSBasic.fetch();

                        //20170301 add default value by isabella
                        var today = new Date();
                        $("#LEAVE_SDTTM_DateTimePicker").val(kendo.toString(new Date(today.getFullYear(), today.getMonth(), today.getDate(), 8, 0), 'yyyy/MM/dd HH:mm'));
                        $("#LEAVE_EDTTM_DateTimePicker").val(kendo.toString(new Date(today.getFullYear(), today.getMonth(), today.getDate(), 17, 30), 'yyyy/MM/dd HH:mm'));
                        e.model.LEAVE_SDTTM = kendo.toString(new Date($("#LEAVE_SDTTM_DateTimePicker").val()), 'yyyyMMddHHmm');
                        e.model.LEAVE_EDTTM = kendo.toString(new Date($("#LEAVE_EDTTM_DateTimePicker").val()), 'yyyyMMddHHmm');
                        var dropdownlist = $("#LEAVE_TYPE").data("kendoDropDownList");
                        dropdownlist.value("03");
                        e.model.LEAVE_TYPE = "03";
                        calLeaveHours();
                    }
                },
                save: function (e) {
                    e.model.dirty = true;   //強迫更新 for upload file
                    e.model.INTERN_STUDENT_ID = $("#INTERN_STUDENT_ID").text();
                    e.model.INTERNSHIP_DEPT = $("#INTERNSHIP_DEPT").text();
                    e.model.LEAVE_HOURS = $("#LEAVE_HOURS").text();
                    e.model.LEAVE_DAYS = $("#LEAVE_DAYS").text();
                    //e.model.LEAVE_STATUS = $("#LEAVE_STATUS").val();
                    e.model.HIDDEN_FILENAME = $("#HIDDEN_FILENAME").val();  //先把值丟給e.model，丟至後端

                    //判斷日期
                    if (isNaN(e.model.LEAVE_SDTTM)) {
                        e.model.LEAVE_SDTTM = kendo.toString(new Date(e.model.LEAVE_SDTTM), 'yyyyMMddHHmm');
                    }
                    if (isNaN(e.model.LEAVE_EDTTM)) {
                        e.model.LEAVE_EDTTM = kendo.toString(new Date(e.model.LEAVE_EDTTM), 'yyyyMMddHHmm');
                    }                   
                },
                
                toolbar: [
                        {
                            text: "新增請假資料",
                            name: "create",
                            iconClass: "k-icon k-add"
                        }
                ]
            });

            $("#LEAVE_TYPE_DropDownList").kendoDropDownList({
                dataTextField: "HISSYSCODENM",
                dataValueField: "HISSYSCODE",
                optionLabel: "-- Please Select --",
                dataSource: {
                    transport: {
                        read: "../SERVICES/WS_EDU_A03_C01.ashx?FCode=LeaveTypeList",
                        dataType: "json"
                    },
                    schema: {
                        type: 'json',
                        data: 'DATA',
                        model: { HISSYSCODE: "HISSYSCODE", HISSYSCODENM: "HISSYSCODENM" }
                    }
                }
            });

            $("#TITLE_ID_DropDownList").kendoDropDownList({
                dataTextField: "HISSYSCODENM",
                dataValueField: "HISSYSCODE",
                optionLabel: "-- Please Select --",
                dataSource: {
                    transport: {
                        read: "../SERVICES/WS_EDU_Shared.ashx?FCode=FacultyTypeList02",
                        dataType: "json"
                    },
                    schema: {
                        type: 'json',
                        data: 'DATA',
                        model: { HISSYSCODE: "HISSYSCODE", HISSYSCODENM: "HISSYSCODENM" }
                    }
                }
            });

            var today = new Date();
            $("input[id$='DatePicker']").kendoDatePicker({
                culture: "zh-TW",
                format: "yyyy/MM/dd"
            //    value: today
            });

          //  $("#START_DatePicker").val(kendo.toString(new Date(today.getFullYear(), today.getMonth(), 1), 'yyyyMMdd'));

        });



        var dsPSBasic = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "../SERVICES/WS_EDU_A03_C01.ashx",
                    dataType: "jsonp",
                    type: "POST",
                    complete: function (jqXhr, textStatus) {
                        var result = jQuery.parseJSON(jqXhr.responseText);
                        if (result.SRESULT == "FALSE") {
                            alert(result.SMESSAGE);
                            document.getElementById("INTERN_NAMEC").innerHTML = "";
                            document.getElementById("INTERN_STUDENT_ID").innerHTML = "";
                            document.getElementById("INTERNSHIP_DEPT").innerHTML = "";
                            document.getElementById("NIDNO").innerHTML = "";
                            //document.getElementById("SEX").innerHTML = "";                             
                        }
                        else {
                            document.getElementById("INTERN_NAMEC").innerHTML = result.DATA[0].INTERN_NAMEC;
                            document.getElementById("INTERN_STUDENT_ID").innerHTML = result.DATA[0].INTERN_STUDENT_ID;
                            document.getElementById("INTERNSHIP_DEPT").innerHTML = result.DATA[0].INTERNSHIP_DEPT;                           
                            document.getElementById("NIDNO").innerHTML = result.DATA[0].NIDNO;
                            //document.getElementById("SEX").innerHTML = result.DATA[0].SEX;
                            calLeaveDays(result.DATA[0].NIDNO);
                        }
                    }

                },
                parameterMap: function (options, operation) {
                    return {
                        FCode: "InternStudentBasic",
                        NIDNO: "<%=base.sUserID%>",
                        models: kendo.stringify(options)
                    }
                }
            },
        });

        function checkType() {
            $.ajax({
                url: "../SERVICES/WS_EDU_A03_C01.ashx?FCode=CheckLeaveType",
                type: "post",
                data: {
                    models: JSON.stringify({
                        NIDNO: $("#NIDNO").text(),
                        LEAVE_TYPEC: $("#LEAVE_TYPE").data("kendoDropDownList").dataItem().HISSYSCODE
                    })
                },
                dataType: 'json',
                success: function (resp) {
                    //var CheckErr = JSON.parse(resp.DATA);
                    //var CheckErr = JSON.parse(resp.SRESULT);
                    //var ErrMsg = resp.SMESSAGE

                    if (resp.SRESULT == "FALSE") {
                        alert(resp.SMESSAGE);
                        $("#LEAVE_TYPE").data("kendoDropDownList").select(0);
                    }
                }
            });
        };

        function calLeaveHours() {
            $.ajax({
                url: "../SERVICES/WS_EDU_A03_C01.ashx?FCode=CheckLeaveRules",
                type: "post",
                async: false,
                data: {
                    LeaveTime: JSON.stringify({
                        NIDNO: "<%=base.sUserID%>",
                        //LEAVE_TYPEC: $("#LEAVE_TYPE").data("kendoDropDownList").dataItem().HISSYSCODE,
                        LEAVE_SDTTM: kendo.toString(new Date($("#LEAVE_SDTTM_DateTimePicker").val()), 'yyyyMMddHHmm'),
                        LEAVE_EDTTM: kendo.toString(new Date($("#LEAVE_EDTTM_DateTimePicker").val()), 'yyyyMMddHHmm')
                    }),
                },
                dataType: 'json',
                success: function (resp) {
                    if (resp.SRESULT == "FALSE") {
                        alert(resp.SMESSAGE);
                    } else if (typeof (resp.DATA) == "undefined") {

                    } else {
                        var hours = resp.DATA;
                        document.getElementById("LEAVE_HOURS").innerHTML = hours % 8;
                        if (hours >= 8) {
                            document.getElementById("LEAVE_DAYS").innerHTML = Math.round(hours / 8);
                        } else {
                            document.getElementById("LEAVE_DAYS").innerHTML = 0;
                        }
                    }
                }
            });

            $.ajax({
                url: "../SERVICES/WS_EDU_A03_C01.ashx?FCode=getInternDEPT",
                type: "post",
                data: {
                    LeaveTime: JSON.stringify({
                        //LEAVE_TYPEC: $("#LEAVE_TYPE").data("kendoDropDownList").dataItem().HISSYSCODE,
                        LEAVE_TYPEC: $("#LEAVE_TYPE").val(),
                        LEAVE_SDTTM: kendo.toString(new Date($("#LEAVE_SDTTM_DateTimePicker").val()), 'yyyyMMddHHmm'),
                        LEAVE_EDTTM: kendo.toString(new Date($("#LEAVE_EDTTM_DateTimePicker").val()), 'yyyyMMddHHmm')
                    }),
                    tNIDNO: "<%=base.sUserID%>"
                },
                dataType: 'json',
                success: function (resp) {
                    //var ErrMsg = resp.SMESSAGE;
                    //console.log(resp.SMESSAGE);
                    //if (resp.SRESULT != "TRUE") {
                    //    //alert(ErrMsg);
                    //}

                    //if ($("#INTERNSHIP_DEPT").html() != "EDUM") {
                    //    document.getElementById("INTERNSHIP_DEPT").innerHTML;
                    //} else {
                        if (resp.SRESULT == "FALSE") {
                            alert(resp.SMESSAGE);
                            document.getElementById("INTERNSHIP_DEPT").innerHTML ="EDUM";
                        }
                        else {
                            document.getElementById("INTERNSHIP_DEPT").innerHTML = resp.DATA[0].INTERNSHIP_DEPT;
                        }
                    //}
                }
            });
        };

        //剩餘天數
        function calLeaveDays(sNIDNO) {
            $.ajax({
                url: "../SERVICES/WS_EDU_A03_C01.ashx?FCode=calLeaveDays",
                type: "post",
                data: {
                    sNIDNO:sNIDNO
                },
                dataType: 'json',
                success: function (resp) {           
                    var models = JSON.stringify(resp.DATA[0]);
                    var ANNUAL_LEAVE = JSON.parse(resp.DATA[0].ANNUAL_LEAVE);
                    var MARRY_LEAVE = JSON.parse(resp.DATA[0].MARRY_LEAVE);
                    var MATERNITY_LEAVE = JSON.parse(resp.DATA[0].MATERNITY_LEAVE);
                    var PATERNITY_LEAVE = JSON.parse(resp.DATA[0].PATERNITY_LEAVE);
                    var PREMATERNITY_LEAVE = JSON.parse(resp.DATA[0].PREMATERNITY_LEAVE);

                    $("#ANNUAL_LEAVE").html(ANNUAL_LEAVE / 8);
                    $("#MARRY_LEAVE").html(MARRY_LEAVE / 8);
                    $("#MATERNITY_LEAVE").html(MATERNITY_LEAVE / 8);
                    $("#PATERNITY_LEAVE").html(PATERNITY_LEAVE / 8);
                    $("#PREMATERNITY_LEAVE").html(PREMATERNITY_LEAVE / 8);
                }
            });
        };

        //判斷是否可下載檔案的條件
        function condition(e) {
            e.preventDefault();
            var gview = $("#ListGrid").data("kendoGrid");
            var model = gview.dataItem($(e.currentTarget).closest("tr"));

            $.ajax({
                url: "../SERVICES/WS_EDU_A03_C01.ashx?FCode=FileCheck",  //至後端判斷檔案是否存在
                type: "post",
                data: {
                    // 將點選的那筆假單編號傳至後端 ，用以判斷該筆假單編號之附件是否存在
                    dataID: model.LEAVE_SEQ,
                    // 把該筆請假資料的實習生ID傳至後端，檔案命名用
                    studentID: $("#INTERN_STUDENT_ID").text()
                },
                dataType: 'json',
                complete: function (jqXhr, textStatus) {
                    var result = jQuery.parseJSON(jqXhr.responseText);
                    var str = "";
                    if (result.FILECHECK == "FALSE") {  //若沒有此假單編號的檔案
                        // 把id=download區塊中的字串，改為"尚未上傳"
                        //document.getElementById("download").innerHTML = "尚未上傳";
                        //$("#download").html("尚未上傳");
                    }
                    else {  //若有此假單編號的檔案
                        for (var i = 0; i < result.DATA.length; i++)
                        {
                            //str = str + "<br>" + '<a href="../UploadFiles/EDU_A03C01/' + result.DATA[i].FILENAME_RENAME + '" target="_blank">'
                            //                   + result.DATA[i].FILENAME_ORIGIN + '</a>' + "&nbsp"
                            //                   + '<button onclick="deleteFiles(\'download\',\'' + result.DATA[i].FILE_SEQ + '\',\''+result.DATA[i].FILENAME_RENAME+ '\');" >'
                            //                   + '刪除' + '</button>';
                            str = str + "<br>" + '<button class="k-button k-button-icontext" onclick="deleteFiles(\'download\',\'' + result.DATA[i].FILE_SEQ + '\',\'' + result.DATA[i].FILENAME_RENAME + '\');" >'
                                               + '刪除' + '</button>' + "&nbsp" 
                                               + '<a href="../UploadFiles/EDU_A03C01/' + result.DATA[i].FILENAME_RENAME + '" download="' + result.DATA[i].FILENAME_ORIGIN + '">'
                                               + result.DATA[i].FILENAME_ORIGIN + '</a>';
                                                
                        }
                        $("#download").html(str);
                    }
                }
            });
        }

        //附件下載處，可刪除檔案
        function deleteFiles(deletefrom, fileSeq, fileName)  //接住的fileSeq即為點選刪除的那筆檔案名稱, ex.2016033_1.pdf
        {
            $.ajax({
                url: "../SERVICES/WS_EDU_A03_C01.ashx?FCode=DeleteFiles",
                type: "post",
                data: {
                    fileSeq: fileSeq,  //將該筆檔案名稱傳至後端，用以刪除此檔案 
                    leaveSeq: $("#LEAVE_SEQ").text(),
                    fileName: fileName,
                    newUploadFiles: $("#HIDDEN_FILENAME").val()
                },
                dataType: 'json',
                // success→只有成功時跳出訊息；complete→錯誤或成功，皆會跳出訊息
                complete: function (jqXhr, textStatus) {
                    var result = jQuery.parseJSON(jqXhr.responseText);
                    alert("結果：" + result.SRESULT + "\n訊息：" + result.SMESSAGE);
                    var str = "";
                    if (deletefrom == "newupload")
                   {
                        $("#HIDDEN_FILENAME").val(result.FILENAME);
                        var newUploadfiles = result.FILENAME.split("?");  // 切出原始檔名
                        var str = "";
                        for (var i = 1; i < newUploadfiles.length; i++)
                        {
                            str = str + "<br>" + '<a href="../UploadFiles/EDU_A03C01/' + newUploadfiles[i] + '" target="_blank">'
                                         + newUploadfiles[i] + '</a>' + "&nbsp"
                                         + '<button onclick="deleteFiles(\''+deletefrom+'\',\'\',\'' + newUploadfiles[i] + '\');" >'
                                         + '刪除' + '</button>';
                        }
                    }
                    else
                    {
                        for (var i = 0; i < result.DATA.length; i++) {
                            str = str + "<br>" + '<a href="../UploadFiles/EDU_A03C01/' + result.DATA[i].FILENAME_RENAME + '" target="_blank">'
                                          + result.DATA[i].FILENAME_ORIGIN + '</a>' + "&nbsp"
                                          + '<button onclick="deleteFiles(\'download\',\'' + result.DATA[i].FILE_SEQ + '\',\'' + result.DATA[i].FILENAME_RENAME + '\');" >'
                                          + '刪除' + '</button>';
                        }
                    }
                    $("#"+deletefrom).html(str);
                }
            });
        }

        function dwDetails(e) {

            e.preventDefault();
            var gview = $("#ListGrid").data("kendoGrid");

            var model = gview.dataItem($(e.currentTarget).closest("tr"));
            // currentTarget返回監聽器觸發事件的節點
            // closest() 從當前開始向上找，直到找到符合或最接近的為止
            // alert(model.LEAVE_SEQ);

            $.ajax({
                url: "../SERVICES/WS_EDU_A03_C01.ashx?FCode=CreatePDF",
                type: "post",
                data: {
                    dataID: model.LEAVE_SEQ,  //將點選的那筆假單編號傳至後端，用以查表+取檔名                
                },
                dataType: 'json',
                // success→只有成功時跳出訊息；complete→錯誤或成功，皆會跳出訊息
                complete: function (jqXhr, textStatus) {
                    var result = jQuery.parseJSON(jqXhr.responseText);
                    alert("結果：" + result.SRESULT + "\n訊息：" + result.SMESSAGE);
                    window.open(result.SHOWPDF);
                    // result.SHOWPDF 是由後端回傳的檔名，透過 window.open打開
                }
            });

        };

        
    </script>
        
    <script id="popup-editor" type="text/x-kendo-tmpl">

    <table class="edit-style" id="edittable">
<%--       <tr id="queryCondition">
            <td colspan="4">
                <div class="input-group col-lg-3 col-md-3 col-sm-3 pull-left">
                    <span class="input-group-addon">身分證字號</span>
                    <input class="form-control" id="PS_NIDNO_TEXT" type="text" />
                </div>
                <div class="input-group col-lg-3 col-md-3 col-sm-3 pull-left" style="left: 0px; top: 0px;
                    width: 122px; height: 25px; margin-top: 2px; margin-left: 10px;">
                    <button type="button" tabindex="0" class="k-primary  k-button k-button-icontext" onclick="calLeaveDays();">
                    <span class="k-sprite k-icon k-i-search"></span>查詢</button>
                </div>
            </td>
        </tr>--%>
        <tr>
            <td class="td-field-label">
                可休天數
            </td>
            <td class="td-field-edit">
                年休：<label id="ANNUAL_LEAVE">#= ANNUAL_LEAVE #</label>天；
                婚假：<label id="MARRY_LEAVE">#= MARRY_LEAVE #</label>天；
                產假：<label id="MATERNITY_LEAVE">#= MATERNITY_LEAVE #</label>天；
                陪產假：<label id="PATERNITY_LEAVE">#= PATERNITY_LEAVE #</label>天；
                產前假：<label id="PREMATERNITY_LEAVE">#= PREMATERNITY_LEAVE #</label>天
            </td>
            <td>假單編號</td>
            <td><label id="LEAVE_SEQ" >#= LEAVE_SEQ #</label></td>
        </tr>
        <tr>
            <td class="td-field-label">
                姓名
            </td>
            <td class="td-field-edit">
         <label id="INTERN_NAMEC" >#= INTERN_NAMEC #</label>
            </td>
            <td class="td-field-label">
                本院實習生編號
            </td>
            <td class="td-field-edit">
                <label id="INTERN_STUDENT_ID" >#= INTERN_STUDENT_ID #</label>
            </td>
        </tr>
        <tr>
            <td class="td-field-label">
                身分證字號
            </td>
            <td class="td-field-edit">
                <label id="NIDNO">#= NIDNO #</label>
            </td>
            <td class="td-field-label">
               實習單位
            </td>
            <td class="td-field-edit">
                <label id="INTERNSHIP_DEPT">#= INTERNSHIP_DEPT #</label>
            </td>
        </tr>
        <tr>          
            <td class="td-field-label">
                <span class="start">＊</span>假別
            </td>
            <td class="td-field-edit">
                <input id="LEAVE_TYPE" name="LEAVE_TYPE" data-bind="value:LEAVE_TYPE" />
            </td>
             <td class="td-field-label"></td>
             <td class="td-field-edit"></td>
        </tr>
        <tr>
            <td class="td-field-label">
                <span class="start">＊</span>請假起
            </td>
            <td class="td-field-edit">
                <input id="LEAVE_SDTTM_DateTimePicker" name="LEAVE_SDTTM" data-bind="value:LEAVE_SDTTM"
                    placeholder="yyyyMMdd HH:mm" onchange="calLeaveHours()" required validationMessage="請輸入請假起"/>
            </td>
            <td class="td-field-label">
                <span class="start">*</span>請假迄
            </td>
            <td class="td-field-edit">
                <input id="LEAVE_EDTTM_DateTimePicker" name="LEAVE_EDTTM" data-bind="value:LEAVE_EDTTM"
                    placeholder="yyyyMMdd HH:mm" onchange="calLeaveHours()" required validationMessage="請輸入請假迄"/>
            </td>
        </tr>
        <tr>
            <td  class="td-field-edit" colspan="4">
                <div style="text-align:center">【星期一至星期五上班時間為上午08:00~12:00、下午13:30~17:30，請勿填寫以外時間】</div>
            </td>
        </tr>
        <tr>
            <td class="td-field-label">
                <span class="start">＊</span>請假天數
            </td>
            <td class="td-field-edit" id="LEAVE_DAYS" data-bind="value:LEAVE_DAYS">
            </td>
            <td class="td-field-label">
                <span class="start">＊</span>請假時數
            </td>
            <td class="td-field-edit" id="LEAVE_HOURS" data-bind="value:LEAVE_HOURS">
            </td>
        </tr>
        <tr>
            <td class="td-field-label">
                事由
            </td>
            <td class="td-field-edit" colspan="3">
                <input id="LEAVE_REASON" name="LEAVE_REASON" class='k-textbox' data-bind="value:LEAVE_REASON" style="width: 100%" onblur="checkREASON(this)"/>
            </td>
        </tr>
        <tr>
            <td class="td-field-label">
                <span class="start">＊</span>代理人卡號
            </td>
            <td class="td-field-edit">
                <input id="AGENT_CARDNO" name="AGENT_CARDNO" class='k-textbox' data-bind="value:AGENT_CARDNO" 
                    required validationMessage="請輸入代理人卡號"/>
                    <input type="hidden" id="HIDDEN_FILENAME" name="HIDDEN_FILENAME" />
            </td>
            <td class="td-field-label"></td>
             <td class="td-field-edit"></td>
        </tr>
        <tr>
            <td class="td-field-label">
            <span class="start">＊</span>代理人姓名
            </td>
            <td class="td-field-edit">
                <input id="AGENT_NAME" name="AGENT_NAME" class='k-textbox' data-bind="value:AGENT_NAME" 
                    required validationMessage="請輸入代理人姓名"/>
            </td>
            <td class="td-field-label">
             <span class="start">＊</span>代理人聯絡電話
            </td>
            <td class="td-field-edit">
                <input id="AGENT_TEL" name="AGENT_TEL" class='k-textbox' data-bind="value:AGENT_TEL" 
                    required validationMessage="請輸入代理人聯絡電話"/>
            </td>
        </tr>
        <tr>
            <td class="td-field-label">
            附件上傳      
            </td>
            <td class="td-field-edit">
            <input name="files" id="files" type="file"/>           
            </td>  
            <td class="td-field-label" id="downloadTitle">
                附件下載
            </td>
            <td class="td-field-edit">
                <div id="download"></div>
                <div id="newupload"></div>  
               <%--      <a href="../UploadFiles/EDU_A03C01/#= LEAVE_SEQ #.pdf" target="_blank">
                        假單編號#= LEAVE_SEQ #_請假單.pdf     --%>
            </td> 
        </tr>
    </table>
    </script>



</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" runat="Server">
    <table class="table" style="width: 100%;">
        <tbody>
            <tr>
                <td style="border-top-width: 0px; border-top-style: none;">
                    <div class="input-group col-lg-3 col-md-3 col-sm-3 pull-left">
                        <span class="input-group-addon">假別</span>
                        <input id="LEAVE_TYPE_DropDownList" />
                    </div>
                    <div class="input-group col-lg-3 col-md-3 col-sm-3 pull-left">
                        <span class="input-group-addon">職類</span>
                        <input id="TITLE_ID_DropDownList" />
                    </div>
                </td>
            </tr>
            <tr>
                <td style="border-top-width: 0px; border-top-style: none;">
                    <div class="input-group  col-lg-3 col-md-3 col-sm-12 pull-left">
                        <span class="input-group-addon">查詢請假日期</span>
                        <input id="START_DatePicker" type="text" data-role='datepicker' placeholder="yyyy/MM/dd" data-type="date" required="required" />
                    </div>
                    <div class="input-group col-lg-4 col-md-4 col-sm-12 pull-left">
                        ~
                        <input id="END_DatePicker" type="text" data-role='datepicker' placeholder="yyyy/MM/dd" data-type="date" required="required" />
                    </div>
                    <div class="input-group  col-lg-4 col-md-4 col-sm-12 pull-left">
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
