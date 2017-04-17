<%@ Page Title="" Language="C#" MasterPageFile="~/AP/VGHTC_MSTPG.Master" AutoEventWireup="true" CodeFile="SW_CFM_A01_C01.aspx.cs" Inherits="AP_SW_CFM_A01_C01" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHeader" runat="Server">
    <script>        
        $("APPLY_DEPTText").kendoDropDownList({
            dataTextField: "DEPTNO",
            dataValueField: "DEPTNO",
            optionLabel: "-- 請選擇 --",
            dataSource: {
                transport: {
                    read: "../SERVICES/WS_CFM_A01_C01.ashx?FCode=GET_DEPTNO",
                    dataType: "json"
                },
                schema: {
                    type: 'json',
                    data: 'DATA',
                    model: { DEPTNO: "DEPTNO"}
                }
            }
        });
        $("SENDBtn").kendoButton({
            spriteCssClass: "",
            click: function (e) {
                $("#BUDGET_Grid").data("kendoGrid").saveChanges();
                $.ajax({
                    type: "POST", //表單method
                    url: "../SERVICES/WS_RBM_A01_C01.ashx?FCode=C"
                });
            }
        });
        //$("#APPLY_DEPTText").kendotextbox({ });
        $(document).ready(function () {
            // create DatePicker from input HTML element
            $("#CREATE_DTTMText").kendoDateTimePicker({
                format: "yyyyMMdd",
                value: new Date()
            });

            $("#EXPECTION_DTText").kendoDatePicker({
                format: "yyyyMMdd",
                min: new Date()
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" runat="Server">
    <div>
        <table class="form" id="userform">
            <!--
                    置中+放大標題但跟想像的不一樣
                    -->
            <tr class="">
                <th class="td-field-label" style="text-align: center">電腦作業增改功能申請表
                </th>
            </tr>
            <tr class="tr-row">
                <th style="text-align: left; background-color: White;" colspan="4">增改功能描述                       
                </th>
            </tr>
            <tr class="tr-row">
                <th class="td-field-label">
                    <span class="start">＊</span>電腦作業或功能名稱：
                </th>
                <td class="td-field-edit">
                    <input id="FUNCTION_NAMEText" name="FUNCTION_NAMEText" style="width: 200px" class='k-textbox' maxlength="60" required  />
                </td>
                <th class="td-field-label">
                    <span class="start">＊</span>作業單位：
                </th>
                <td class="td-field-edit">
                    <input type="text" id="APPLY_DEPTText" name="APPLY_DEPTText" />
                </td>
            </tr>
            <tr class="tr-row">
                <th class="td-field-label">增改理由：
                </th>
                <td class="td-field-edit" colspan="3">
                    <textarea id="MODIFIED_REASONText" class="k-textbox" style="width: 600px;" cols="20" rows="2" maxlength="60" placeholder="至多60字"></textarea>
                </td>
            </tr>
            <tr class="tr-row">
                <th class="td-field-label">功能行為：
                </th>
                <td class="td-field-edit" colspan="3">
                    <textarea id="MODIFIED_CONTENTText" class="k-textbox" style="width: 600px;" cols="20" rows="5" maxlength="600" placeholder="至多600字"></textarea>
                </td>
            </tr>
            <tr class="tr-row">
                <th class="td-field-label">預期效益：
                </th>
                <td class="td-field-edit" colspan="3">
                    <textarea id="MODIFIED_BENEFITText" class="k-textbox" style="width: 600px;" cols="20" rows="5" maxlength="600" placeholder="至多600字"></textarea>
                </td>
            </tr>
            <tr class="tr-row">
                <th class="td-field-label">
                    <span class="start">＊</span>申請日期：
                </th>
                <td class="td-field-edit">
                    <input id="CREATE_DTTMText" name="CREATE_DTTMText" type="text" style="width: 200px;" placeholder="yyyyMMdd" onkeydown="return false;" required maxlength="8" />
                </td>
                <th class="td-field-label">
                    <span class="start">＊</span>希望使用日期：
                </th>
                <td class="td-field-edit">
                    <input id="EXPECTION_DTText" name="EXPECTION_DTText" type="text" style="width: 200px;" placeholder="yyyyMMdd" onkeydown="return false;" required maxlength="8" />
                </td>
            </tr>
            <tr class="tr-row">
                <th class="td-field-label">
                    <span class="start">＊</span>聯絡電話：
                </th>
                <td class="td-field-edit" colspan="3">
                    <input id="APPLY_TELText" name="APPLY_TELText" style="width: 25%" class='k-textbox' required placeholder="請輸入分機號碼或手機號碼" maxlength="14" />
                </td>
            </tr>
        </table>
        <div id="step1_div" style="text-align: center; margin-top: 20px;">
            <button id="TEMPBtn" class="k-primary" type="button">暫存</button>
            <button id="SENDBtn" class="k-primary" type="button">送出申請</button>
            <div id="dialog-confirm"></div>
        </div>
    </div>
</asp:Content>

