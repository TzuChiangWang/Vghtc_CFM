<%@ Page Title="" Language="C#" MasterPageFile="~/AP/VGHTC_MSTPG.Master" AutoEventWireup="true"
    CodeFile="SW_CFM_A01_Q01.aspx.cs" Inherits="AP_SW_CFM_A01_Q01" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHeader" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            var dataSource = new kendo.data.DataSource({
                transport: {
                    read: {
                        url: "../SERVICES/WS_CFM_A01_Q01.ashx",
                        dataType: "json",
                        type: "POST"
                    },
                    create: {
                        url: "../SERVICES/WS_CFM_A01_Q01.ashx",
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
                        url: "../SERVICES/WS_CFM_A01_Q01.ashx",
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
                        url: "../SERVICES/WS_CFM_A01_Q01.ashx",
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
                                CreateUserID: $("#CREATE_USER_ID_TEXT").val(),
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
                        id: "UNIQUE_ID",
                        fields: {
                            FORM_ID: { editable: false, type: "string" },
                            UNIQUE_ID: { editable: false, type: "string" },
                            APPLY_SEQ: { editable: false, type: "string" },
                            APPLY_STATUS: { editable: false, type: "string" },
                            APPLY_YYYY: { editable: false, type: "string" },
                            STATUS_DESCRIPTION: { editable: false, type: "string" },
                            FUNCTION_NAME: { editable: true, type: "string", validation: { required: true } },
                            MODIFIED_REASONS: { editable: true, type: "string", validation: { required: true } },
                            MODIFIED_CONTENTS: { editable: true, type: "string", validation: { required: true } },
                            MODIFIED_BENEFITS: { editable: true, type: "string", validation: { required: true } },
                            CREATE_DTTM: { editable: false, type: "string" },
                            EXPECTATION_DT: { editable: true, type: "string" },
                            CREATE_USER_ID: { editable: false, type: "string" },
                            CREATE_NAMEC: { editable: false, type: "string" },
                            APPLY_TEL: { editable: true, type: "string", validation: { required: true } },
                            APPLY_DEPT: { editable: true, type: "string", validation: { required: true } },
                            DEPTNM: { editable: true, type: "string" },
                            FILESNM: { editable: true, type: "string" }
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
                height: 550,
                selectable: true,
                resizable: true,
                scrollable: true,
                sortable: {
                    mode: "multiple",
                    allowUnsort: false
                },
                pageable: {
                    pageSizes: true,
                    buttonCount: 5
                },
                columns: [
			        {
			            command: [{ name: "edit", text: "修改", click: condition },
                                  { name: "destroy", text: "刪除" },
                                  { name: "sent", text: "送出", click: sentRequest },
                                  { name: "download", text: "下載", click: dwDetails }],
			                        width: 170, locked: true },
                    { field: "FORM_ID", title: "表單名稱", width: 100, hidden: true },
                    { field: "UNIQUE_ID", title: "表單序號", width: 100, locked: true },
                    { field: "APPLY_SEQ", title: "表單序號", width: 100, hidden: true },
                    { field: "APPLY_YYYY", title: "申請年度", width: 100, hidden: true },
                    { field: "APPLY_STATUS", title: "目前狀態", width: 100, hidden: true },
			        { field: "STATUS_DESCRIPTION", title: "目前狀態", width: 100, locked: true },
			        { field: "FUNCTION_NAME", title: "功能名稱", width: 300 },
			        { field: "MODIFIED_REASONS", title: "增改理由", width: 300, hidden: true },
                    { field: "MODIFIED_CONTENTS", title: "修改內容", width: 300, hidden: true },
                    { field: "MODIFIED_BENEFITS", title: "預期效益", width: 300, hidden: true },
                    { field: "CREATE_DTTM", title: "申請時間", width: 100 },
                    { field: "EXPECTATION_DT", title: "希望使用日期", width: 140 },
                    { field: "CREATE_USER_ID", title: "申請人ID", width: 100 },
                    { field: "CREATE_NAMEC", title: "申請人姓名", width: 100 },
                    { field: "APPLY_TEL", title: "聯絡電話", width: 100 },
                    { field: "APPLY_DEPT", title: "作業單位", width: 100, hidden: true },
                    { field: "DEPTNM", title: "作業單位", width: 100 },
                    { field: "FILESNM", title: "檔案名稱", width: 100, hidden: true }
                ],
                dataBound: function () {
                    var grid = this;
                    var model;
                    // grid.lockedContent v.s. grid.tbody
                    // 因為命令列有lock屬性 grid.tbody只會找到沒有lock屬性的column
                    grid.lockedContent.find("tr[role='row']").each(function () {
                        model = grid.dataItem(this);  //綁定前台數據

                        // 暫存(00)狀態跟送單後修改(11)狀態才能送單
                        if (model.APPLY_STATUS != "00") {
                            /*
                                找到class=k-grid-sent的button(即為送出)，
                                加入kendoUI使button disabled的屬性→k-state-disabled
                            */
                            $(this).find(".k-grid-sent").addClass("k-state-disabled");
                            /*
                              但由於command預設的button，其本質為超連結而非典型button，
                              因此無法直接用disabled的屬性鎖住。因此我們設它click之後直接return false
                              其他什麼都不做。
                            */
                            $(this).find(".k-grid-sent").click(function () {
                                return false;
                            });
                        }
                        
                        // 只有暫存(00)狀態不能列印單子
                        if (model.APPLY_STATUS == "00") {
                            $(this).find(".k-grid-download").addClass("k-state-disabled");
                            $(this).find(".k-grid-download").click(function () {
                                return false;
                            });
                        }

                        // 送出(01)的申請無法刪除
                        if (model.APPLY_STATUS == "01") {
                            $(this).find(".k-grid-delete").addClass("k-state-disabled");
                            $(this).find(".k-grid-delete").click(function () {
                                return false;
                            });
                        }
                    });
                },
                editable: {
                    mode: "popup", //使用Popup的模式編輯資料
                    update: true, // 若設定為True,當按下Update即更新server資料
                    confirmation: "確認刪除此筆資料 ?",
                    window: {
                        width: 850
                    },
                    template: kendo.template($("#popup-editor").html())
                },
                edit: function (e) {
                    e.container.find('.k-edit-form-container').width('100%');
                    if (!e.model.isNew()) {
                        //編輯
                        e.container.find("input[name=APPLY_DEPTText]").attr('readonly', 'true');

                        $('.k-grid-update').text('更新');
                        $('.k-grid-cancel').text('返回');
                        $('.k-window-title').text('編輯');
                    }
                    else {
                        //新增
                        $('.k-grid-update').text('確定');
                        $('.k-grid-cancel').text('取消');
                        $('.k-window-title').text('新增');

                        //初始化數值減少輸入時間
                        e.container.find("input[name=APPLY_DEPTText]").attr('disabled', 'true');
                        e.container.find("input[name=APPLY_DEPTText]").val('<% =base.sDeptNM %>');
                        e.container.find("input[name=APPLY_TELText]").val('<% =base.sUserTel %>');
                    }

                    //For EXPECTATION_DT設定DatePicker的config
                    $("#EXPECTATION_DTText").kendoDatePicker({
                        format: "yyyyMMdd",
                        min: new Date()
                    });
                    //For EXPECTATION_DT設定open on focus
                    $("#EXPECTATION_DTText").bind("focus", function () {
                        $(this).data("kendoDatePicker").open();
                    });

                    //For APPLY_TEL確保使用者輸入的合理性
                    $("#APPLY_TELText").keydown(function (e) {
                        // Allow: backspace, delete, tab, escape, enter and .
                        if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
                            // Allow: Ctrl/cmd+A
                            (e.keyCode == 65 && (e.ctrlKey === true || e.metaKey === true)) ||
                            // Allow: Ctrl/cmd+C
                            (e.keyCode == 67 && (e.ctrlKey === true || e.metaKey === true)) ||
                            // Allow: Ctrl/cmd+X
                            (e.keyCode == 88 && (e.ctrlKey === true || e.metaKey === true)) ||
                            // Allow: home, end, left, right
                            (e.keyCode >= 35 && e.keyCode <= 39)) {
                            // let it happen, don't do anything
                            return;
                        }
                        // Ensure that it is a number and stop the keypress
                        if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                            e.preventDefault();
                        }
                    });

                    //kendo格式驗證未正常運作原因不明, 改以jquery驗證副檔名                    
                    $("#files").kendoUpload({
                        async: {
                            saveUrl: "../SERVICES/WS_CFM_A01_Q01.ashx?FCode=Upload",
                            autoUpload: false,
                            batch: true
                            // async.batch only applies to files selected at the same time
                        },
                        //未正常運作 在onUpload事件驗證資料
                        //validation: {
                        //    allowedExtensions: [".gif", ".jpg", ".png"]
                        //},
                        localization: {
                            select: "選擇檔案",
                            remove: "刪除",
                            retry: "重新上傳",
                            cancel: "取消",
                            dropFilesHere: "將檔案拉到這裡上傳",
                            invalidMaxFileSize: "檔案過大",
                            uploadSelectedFiles: "上傳檔案"
                        },
                        multiple: true,
                        upload: function (e) {
                            //在這可以確認上傳的檔案是不是有主人, 簡化上傳附件流程可用
                            e.data = { uniqueId: $("#UNIQUE_ID").text() };
                        },
                        select: function (e) {
                            var maxFiles = 3;
                            var files = e.files;

                            //if ($('#files').parent().children('input[type=file]:not(#files)').length >= maxFiles) {
                            //    e.preventDefault();
                            //    alert("最多僅可上傳" + maxFiles + "個檔案");
                            //}
                            if (e.files.length > 1) {
                                e.preventDefault();
                                alert("請勿選擇多個檔案");
                            }

                            $.each(files, function () {
                                var fileExtension = ['.jpeg', '.jpg', '.png', '.gif', '.bmp', '.pdf'];
                                if ($.inArray(this.extension.toLowerCase(), fileExtension) == -1) {
                                    alert("僅可上傳圖片檔");
                                    e.preventDefault();
                                }
                                if (this.size / 1024 / 1024 > 10) {
                                    alert("檔案需小於10MB")
                                    e.preventDefault();
                                }
                            });
                        },
                        success: function (e) {
                            if (e.response.SRESULT == "TRUE") {
                                $('#fileNM').each(function () { this.value += e.response.FILENAME; });
                                var newUploadfiles = $('#fileNM').val().split("?");  // 切出原始檔名
                                var str = "";
                                for (var i = 1; i < newUploadfiles.length; i++) {
                                    str = str + "<br>" + '<button class="k-button k-button-icontext" onclick="if(confirm(\'確認刪除 ?\')) deleteFiles(\'newupload\',\'\',\'' + newUploadfiles[i] + '\');"'
                                                       + ' >' + '刪除' + '</button>' + "&nbsp"
                                                       + '<a href="../UploadFiles/CFM_A01Q01/' + newUploadfiles[i] + '" download >'
                                                       + newUploadfiles[i] + '</a>';
                                }
                                $("#newupload").html(str);
                                //$('.k-file').remove();
                                //$('.k-upload-files.k-reset').remove();
                                alert(e.response.SMESSAGE);
                            }
                            else {
                                alert(e.response.SMESSAGE);
                            }
                        }
                    });
                },
                save: function (e) {
                    // 只上傳檔案沒有修改資料的話不會觸發update event
                    e.model.dirty = true;
                    //model.EXPECTATION_DT的值是DateTime格式轉換為Date格式 
                    //NaN (Not a Number)                    
                    if (isNaN(e.model.EXPECTATION_DT)) {
                        e.model.EXPECTATION_DT = kendo.toString(new Date(e.model.EXPECTATION_DT), 'yyyyMMdd');
                    }
                    e.model.FILESNM = $("#fileNM").val();
                    e.model.APPLY_TEL = $("#APPLY_TELText").val();
                    e.model.APPLY_STATUS = "00";
                },
                cancel: function (e) {
                    //在這可以刪除那些無主的檔案
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

        //下載資料的pdf檔
        function dwDetails(e) {
            e.preventDefault();
            var gview = $("#ListGrid").data("kendoGrid");
            var model = gview.dataItem($(e.currentTarget).closest("tr"));
            // currentTarget返回監聽器觸發事件的節點
            // closest() 從當前開始向上找，直到找到符合或最接近的為止

            $.ajax({
                url: "../SERVICES/WS_CFM_A01_Q01.ashx?FCode=CreatePDF",
                type: "post",
                data: {
                    dataID: model.UNIQUE_ID  //將點選的那筆申請單編號傳至後端               
                },
                dataType: 'json',
                // success→只有成功時跳出訊息；complete→錯誤或成功，皆會跳出訊息
                complete: function (jqXhr, textStatus) {
                    var result = jQuery.parseJSON(jqXhr.responseText);
                    alert("結果：" + result.SRESULT + "\n訊息：" + result.SMESSAGE);
                    window.open(result.SHOWPDF);
                    // 20170411 TzuChiang, 直接跳下載取代跳出新視窗
                    //var link = document.createElement('a');
                    //link.href = result.SHOWPDF;
                    ////link.download = result.FILENM;
                    //link.dispatchEvent(new MouseEvent('click'));
                }
            });
        };

        // 送出功能修改的申請單, 也就是把狀態改成已送單
        function sentRequest(e) {
            e.preventDefault();
            var gview = $("#ListGrid").data("kendoGrid");
            var model = gview.dataItem($(e.currentTarget).closest("tr"));
            // currentTarget返回監聽器觸發事件的節點
            // closest() 從當前開始向上找，直到找到符合或最接近的為止

            $.ajax({
                url: "../SERVICES/WS_CFM_A01_Q01.ashx?FCode=sentRequest",
                type: "post",
                data: {//將點選的那筆假單編號傳至後端，用以查表+取檔名 
                    model: kendo.stringify(model)
                },
                dataType: 'json',
                // success→只有成功時跳出訊息；complete→錯誤或成功，皆會跳出訊息
                complete: function (jqXhr, textStatus) {
                    // 執行完畢後自動刷新資料
                    $('#ListGrid').data('kendoGrid').dataSource.read();
                    var result = jQuery.parseJSON(jqXhr.responseText);
                    alert("訊息：" + result.SMESSAGE);
                }
            });
        };

        //判斷是否可下載檔案的條件
        function condition(e) {
            e.preventDefault();
            var gview = $("#ListGrid").data("kendoGrid");
            var model = gview.dataItem($(e.currentTarget).closest("tr"));

            $.ajax({
                url: "../SERVICES/WS_CFM_A01_Q01.ashx?FCode=FileCheck",  //至後端判斷檔案是否存在
                type: "post",
                data: {
                    // 將點選的那筆假單編號傳至後端，用以判斷該筆申請單編號之附件是否存在
                    formID: model.UNIQUE_ID
                },
                dataType: 'json',
                complete: function (jqXhr, textStatus) {
                    var result = jQuery.parseJSON(jqXhr.responseText);
                    var str = "";
                    if (result.FILECHECK == "FALSE") {  //若沒有此假單編號的檔案
                        // 把id=download區塊中的字串，改為"尚未上傳"
                        // $("#download").html("尚未上傳");
                    }
                    else {  //若有此假單編號的檔案
                        for (var i = 0; i < result.DATA.length; i++) {
                            str = str + "<br>" + '<button class="k-button k-button-icontext" onclick="if(confirm(\'確認刪除 ?\')) deleteFiles(\'download\',\'' + result.DATA[i].FILE_SEQ + '\',\'' + result.DATA[i].FILENAME_RENAME + '\');" >'
                                               + '刪除' + '</button>' + "&nbsp"
                                               + '<a href="../UploadFiles/CFM_A01Q01/' + result.DATA[i].FILENAME_RENAME + '" download="' + result.DATA[i].FILENAME_ORIGIN + '">'
                                               + result.DATA[i].FILENAME_ORIGIN + '</a>';
                        }
                        $("#download").html(str);
                    }
                }
            });
        }

        /// <summary>
        /// 附件下載處, 刪除檔案
        /// case 1, deletefrom == newupload 
        ///         fileSeq 必為 NULL, 
        ///         fileName 為要被刪除的檔案名稱
        /// case 2, deletefrom == download
        ///         fileSeq 為 COMMON.CFM_FILEUPLOAD.FILE_SEQ, 
        ///         fileName 為 COMMON.CFM_FILEUPLOAD.FILENAME_RENAME
        /// </summary>
        function deleteFiles(deletefrom, fileSeq, fileName)
        {
            $.ajax({
                url: "../SERVICES/WS_CFM_A01_Q01.ashx?FCode=DeleteFiles",
                type: "post",
                data: {
                    fileSeq: fileSeq,  //將該筆檔案名稱傳至後端，用以刪除此檔案 
                    fileName: fileName,
                    uniqueId: $("#UNIQUE_ID").text(),
                    newUploadFiles: $("#fileNM").val()
                },
                dataType: 'json',
                // success→只有成功時跳出訊息；complete→錯誤或成功，皆會跳出訊息
                complete: function (jqXhr, textStatus) {
                    var result = jQuery.parseJSON(jqXhr.responseText);
                    alert("結果：" + result.SRESULT + "\n訊息：" + result.SMESSAGE);
                    var str = "";
                    if (deletefrom == "newupload") {
                        $("#fileNM").val(result.FILENAME);
                        var newUploadfiles = result.FILENAME.split("?");  // 切出原始檔名
                        var str = "";
                        for (var i = 1; i < newUploadfiles.length; i++) {
                            str = str + "<br>" + '<button class="k-button k-button-icontext" onclick="if(confirm(\'確認刪除 ?\')) deleteFiles(\'' + deletefrom + '\',\'\',\'' + newUploadfiles[i] + '\');" >'
                                               + '刪除' + '</button>' + "&nbsp"
                                               + '<a href="../UploadFiles/CFM_A01Q01/' + newUploadfiles[i] + '">'
                                               + newUploadfiles[i] + '</a>' ;
                        }
                    }
                    else {
                        for (var i = 0; i < result.DATA.length; i++) {
                            str = str + "<br>" + '<button class="k-button k-button-icontext" onclick="if(confirm(\'確認刪除 ?\')) deleteFiles(\'download\',\'' + result.DATA[i].FILE_SEQ + '\',\'' + result.DATA[i].FILENAME_RENAME + '\');" >'
                                               + '刪除' + '</button>' + "&nbsp"
                                               + '<a href="../UploadFiles/CFM_A01Q01/' + result.DATA[i].FILENAME_RENAME + '" download="' + result.DATA[i].FILENAME_ORIGIN + '">'
                                               + result.DATA[i].FILENAME_ORIGIN + '</a>';                           
                        }
                    }
                    $("#" + deletefrom).html(str);
                }
            });
        }
    </script>

    <script id="popup-editor" type="text/x-kendo-tmpl">        
    <table>
            <tr>
                <td style="text-align: center; background-color: white;" colspan="4">
                    增改功能描述                       
                </td>
            </tr>
            <tr>            
                <td class="td-field-label" >
                    表單序號：
                </td>
                <td class="td-field-label" style="text-align: left;">
                    <label id="UNIQUE_ID" >#= UNIQUE_ID #</label>
                </td>
                <td class="td-field-label" >
                </td>
                <td class="td-field-label" style="text-align: left;">
                </td>
            </tr>
            <tr>
                <td class="td-field-label">
                    <span class="start">＊</span>電腦作業或功能名稱：
                </td>
                <td class="td-field-edit">
                    <input id="FUNCTION_NAMEText" name="FUNCTION_NAMEText" data-bind="value:FUNCTION_NAME" style="width: 200px" class='k-textbox' maxlength="60" required validationMessage="請輸入功能名稱" />
                </td>
                <td class="td-field-label">
                    <span class="start">＊</span>作業單位：
                </td>
                <td class="td-field-edit">
                    <input type="text" id="APPLY_DEPTText" name="APPLY_DEPTText" data-bind="value:DEPTNM" maxlength="4" class='k-textbox' placeholder="單位名稱英文縮寫" required validationMessage="請輸入單位名稱"/>
                </td>
            </tr>
            <tr>
                <td class="td-field-label">
                    增改理由：
                </td>
                <td class="td-field-edit" colspan="3">
                    <textarea id="MODIFIED_REASONText" data-bind="value:MODIFIED_REASONS" class="k-textbox" style="width: 600px;" cols="20" rows="2" maxlength="600" ></textarea>
                </td>
            </tr>
            <tr>
                <td class="td-field-label">
                    功能行為：
                </td>
                <td class="td-field-edit" colspan="3">
                    <textarea id="MODIFIED_CONTENTText" data-bind="value:MODIFIED_CONTENTS" class="k-textbox" style="width: 600px;" cols="20" rows="5" maxlength="600"></textarea>
                </td>
            </tr>
            <tr>
                <td class="td-field-label">
                    預期效益：
                </td>
                <td class="td-field-edit" colspan="3">
                    <textarea id="MODIFIED_BENEFITText" data-bind="value:MODIFIED_BENEFITS" class="k-textbox" style="width: 600px;" cols="20" rows="5" maxlength="600"></textarea>
                </td>
            </tr>
            <tr>
                <td class="td-field-label" >
                    <span class="start">＊</span>希望使用日期：
                </td>
                <td class="td-field-edit" colspan="3">
                    <input id="EXPECTATION_DTText" data-bind="value:EXPECTATION_DT" type="text" style="width: 200px;" placeholder="yyyyMMdd" onkeydown="return false;" required validationMessage="請選擇日期" />
                </td>
            </tr>
            <tr>
                <td class="td-field-label">
                    <span class="start">＊</span>聯絡電話：
                </td>
                <td class="td-field-edit" colspan="3">
                    <input id="APPLY_TELText" name="APPLY_TELText" data-bind="value:APPLY_TEL" style="width: 30%" class='k-textbox' required validationMessage="請輸入分機號碼或手機號碼" placeholder="請輸入分機號碼或手機號碼" maxlength="14" />
                </td>
            </tr>
            <tr>
                <td class="td-field-label">
                    附加檔案：
                </td>
                <td class="td-field-edit">
                    <input id="files" name="file1" type="file"/>
                    <input id="fileNM" name="fileNM" type="hidden" data-bind="value:FILESNM">
                </td>
                <td class="td-field-label" id="downloadTitle">
                    附件下載：
                </td>
                <td class="td-field-edit">
                    <div id="download"></div>
                    <div id="newupload"></div>  
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
                        <span class="input-group-addon">申請人ID</span>
                        <input class="form-control" id="CREATE_USER_ID_TEXT" type="text" />
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

