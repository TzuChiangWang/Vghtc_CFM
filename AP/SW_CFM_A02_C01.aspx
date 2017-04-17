<%@ Page Title="" Language="C#" MasterPageFile="VGHTC_MSTPG.Master" AutoEventWireup="true"
    CodeFile="SW_CFM_A02_C01.aspx.cs" Inherits="SW_CFM_A02_C01" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHeader" runat="Server">

    <script type="text/javascript">
       $(document).ready(function () {
       
           var dataSource = new kendo.data.DataSource({
                transport: {
					    read: {
						    url: "../SERVICES/WS_CFM_A02_C01.ashx",
                            dataType: "json",
						    type: "POST",
						    complete: function(jqXhr, textStatus) {
                                var result = jQuery.parseJSON(jqXhr.responseText);
                                if(result.SRESULT=="FALSE")
                                {
                                    alert(result.SMESSAGE);
                                }
    		                }
                        },
					    create: {
						    url: "../SERVICES/WS_CFM_A02_C01.ashx",
						    dataType: "json",
						    type: "POST",
						    complete: function(jqXhr, textStatus) {
                                var result = jQuery.parseJSON(jqXhr.responseText);
                                alert(result.SMESSAGE);
                                if(result.SRESULT=="TRUE")
                                {
                                    dataSource.read(); 
                                }
    		                }

					    },
					    update: {
						    url: "../SERVICES/WS_CFM_A02_C01.ashx",
						    dataType: "json",
						    type: "POST",
    						complete: function(jqXhr, textStatus) {
                                var result = jQuery.parseJSON(jqXhr.responseText);
                                alert(result.SMESSAGE);
                                if(result.SRESULT=="TRUE")
                                {
                                    dataSource.read(); 
                                }
    		                }
					    },
					    destroy: {
					        url: "../SERVICES/WS_CFM_A02_C01.ashx",
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
							        FCode:"R",
							        NIDNO:$("#NIDNO_TEXT").val(),
							        INTERN_NAMEC:$("#INTERN_NAMEC_TEXT").val(),
							        SCHOOL_ID:$("#SCHOOL_ID_DropDownList").val(),
							        TITLE_ID:$("#TITLE_ID_DropDownList").val(),
							        INTERNSHIP_DEPT_I:$("#INTERNSHIP_DEPT_I_DropDownList").val(),
							        INTERNSHIP_DEPT_II:$("#INTERNSHIP_DEPT_II_DropDownList").val(),
							        models: kendo.stringify(options)
							    }
							}
							else
							{
							    var Fcode;
							    switch (operation)
							    {
							        case "update": Fcode="U";
							            break;
							        case "create": Fcode="C";
							            break;
							        case "destroy": Fcode = "D";
							            break;
							    }
							    return { 
							        FCode:Fcode,
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
					        id: "INTERN_STUDENT_ID",
						    fields: {                             
							    INTERN_STUDENT_ID: { editable: true, type: "string", validation: { required: true }  },
                                TITLE_ID: { editable: true, type: "string" },
                                TITLE_NAME: { editable: true, type: "string" },
                                SCHOOL_ID: { editable: true, type: "string" },
                                STUDENT_NAME: { editable: true, type: "string" },
                                STUDENT_ID: { editable: true, type: "string" },
                                SCHOOL_DEPT: { editable: true, type: "string" },
                                SCHOOL_SYSTEM: { editable: true, type: "string" },
                                SCHOOL_GRADE: { editable: true, type: "string" },
                                INTERN_NAMEC: { editable: true, type: "string" },
                                INTERN_NAME: { editable: true, type: "string" },
                                NIDNO: { editable: true, type: "string" },
                                SEX: { editable: true, type: "string" },
                                BIRTHDAY: { editable: true, type: "string" },
                                ADDRESS: { editable: true, type: "string" },
                                EMAIL: { editable: true, type: "string" },
                                CARDNO: { editable: true, type: "string" },
                                INTERNSHIP_DEPT: { editable: true, type: "string" },
                                INTERNSHIP_DEPT_P:{ editable: true, type: "string" },
                                PRIVATE_PHONE: { editable: true, type: "string" },
                                CHECK_IN_DATE: { editable: true, type: "string", validation: { required: true } },
                                CHECK_OUT_DATE: { editable: true, type: "string", validation: { required: true } },
                                INTERN_DAYS: { editable: true, type: "string" },
                                INTERN_HOURS: { editable: true, type: "string" },
                                PRACTICE_ITEMS: { editable: true, type: "string" },
                                EMERGENCY_CONTACT: { editable: true, type: "string" },
                                EMERGENCY_PHONE: { editable: true, type: "string" },
                                EMERGENCY_RELATIONSHIP: { editable: true, type: "string" },
                                MEMORY: { editable: true, type: "string" },
							    PROCDATETIME: { editable: false, type: "string" },
							    PROCID: { editable: false, type: "string" },
							    PROCNMC: { editable: false, type: "string" }
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
			        { command: [{ name: "edit", text: "明細" }, { name: "destroy", text: "刪除" }], width: 160},
                    { field: "INTERN_STUDENT_ID", title: "本院實習生編號", width: 120 },
                    { field: "TITLE_ID", title: "職類代碼", width: 80, hidden: true },
                    { field: "TITLE_NAME", title: "職類", width: 80 },
                    { field: "SCHOOL_ID", title: "學校代碼", width: 80},
                    { field: "SCHOOL_NAME", title: "學校", width: 80},
                    { field: "STUDENT_ID", title: "在校學號", width: 80, hidden: true },
                    { field: "SCHOOL_DEPT", title: "科系別", width: 80 },
                    { field: "SCHOOL_SYSTEM", title: "學制", width: 80, hidden: true },
                    { field: "SCHOOL_GRADE", title: "年級", width: 80, hidden: true },
                    { field: "INTERN_NAMEC", title: "姓名", width: 80 },
                    { field: "INTERN_NAME", title: "英文姓名", width: 80, hidden: true },
                    { field: "NIDNO", title: "身份証字號", width: 100 },
                    { field: "SEX", title: "性別", width: 80, hidden: true },
                    { field: "BIRTHDAY", title: "出生年月日", width: 80, hidden: true },
                    { field: "ADDRESS", title: "戶籍地址", width: 80, hidden: true },
                    { field: "EMAIL", title: "E-MAIL", width: 80, hidden: true },
                    { field: "CARDNO", title: "卡號", width: 100 },
                    { field: "INTERNSHIP_DEPT", title: "實習單位", width: 100 },
                    { field: "INTERNSHIP_DEPT_P", title: "實習單位P", width: 100, hidden: true  },
                    { field: "PRIVATE_PHONE", title: "私人手機號碼", width: 80, hidden: true },
                    { field: "CHECK_IN_DATE", title: "報到日", width: 85 },
                    { field: "CHECK_OUT_DATE", title: "離院日", width: 85 },
                    { field: "INTERN_DAYS", title: "實習天數", width: 80, hidden: true },
                    { field: "INTERN_HOURS", title: "實習總時數", width: 80, hidden: true },
                    { field: "PRACTICE_ITEMS", title: "實習項目(護理)", width: 80, hidden: true },
                    { field: "EMERGENCY_CONTACT", title: "緊急聯絡人", width: 80, hidden: true },
                    { field: "EMERGENCY_PHONE", title: "緊急聯絡人電話", width: 80, hidden: true },
                    { field: "EMERGENCY_RELATIONSHIP", title: "緊急聯絡人關係", width: 80, hidden: true },
                    { field: "MEMORY", title: "備註", width: 80, hidden: true },
                    { field: "PROCDATETIME", title: "處理時間", width: 100 },
                    { field: "PROCID", title: "處理人ID", width: 80 },
                    { field: "PROCNMC", title: "處理人姓名", width: 80 }
		        ],
		        editable: {
                        mode: "popup", //使用Popup的模式編輯資料
                        update: true, // 若設定為True,當按下Update即更新server資料
                            window :{
                                width:900
                           },
                        template: kendo.template($("#popup-editor").html())    
                    },
                edit: function (e) {
                     e.container.find('.k-edit-form-container').width('100%');
                     $("#SCHOOL_ID").text(e.model.SCHOOL_ID);
                     $("#INTERN_DAYS").text(e.model.INTERN_DAYS);
                     $("#TITLE_ID").kendoDropDownList({
                            dataTextField: "HISSYSCODENM",
                            dataValueField: "HISSYSCODE",
                            optionLabel: "-- Please Select --",
                            dataSource: {
                                transport: {
                                    read: "../SERVICES/WS_CFM_A02_C01.ashx?FCode=TitleList",
                                    dataType: "json"
                                },
                                schema: {
                                    type: 'json',
                                    data: 'DATA',
                                    model: { HISSYSCODE: "HISSYSCODE", HISSYSCODENM: "HISSYSCODENM" }
                                }
                            }
                        }).closest("span").width(150); 
                        
                    $("#EMERGENCY_RELATIONSHIP").kendoDropDownList({
                            dataTextField: "HISSYSCODENM",
                            dataValueField: "HISSYSCODE",
                            optionLabel: "-- Please Select --",
                            dataSource: {
                                transport: {
                                    read: "../SERVICES/WS_CFM_A02_C01.ashx?FCode=EmergencyRelationship",
                                    dataType: "json"
                                },
                                schema: {
                                    type: 'json',
                                    data: 'DATA',
                                    model: { HISSYSCODE: "HISSYSCODE", HISSYSCODENM: "HISSYSCODENM" }
                                }
                            }
                        }).closest("span").width(150); 
                        
                    $("input[id$='DatePicker']").kendoDatePicker({
                        culture: "zh-TW",
                        format: "yyyy/MM/dd"
                    });
                        
                    $("#SCHOOL_NAME").kendoDropDownList({
                        dataValueField: "HISSYSCODE",
                        dataTextField: "HISSYSCODENM",
                        optionLabel: "-- Please Select --",
                        filter: "contains",
                        minLength: 1,
                        dataSource: {
                            type: "json",
                            transport: {
                                read: "../SERVICES/WS_CFM_A02_C01.ashx?FCode=SchoolList"
                            },
                            schema: {
                                type: 'json',
                                data: 'DATA',
                                model: { HISSYSCODE: "HISSYSCODE", HISSYSCODENM: "HISSYSCODENM" }
                            }
                        },
                        select: function(e){
                            $("#SCHOOL_ID").text("");
                        },
                        close: function(e){
                            $("#SCHOOL_ID").text(this.value());
                        }
                    });
                    
                    
                    $("#INTERNSHIP_DEPT_I").kendoDropDownList({
			            dataTextField: "HISSYSCODENM",
			            dataValueField: "HISSYSCODE",
			            optionLabel: "-- Please Select --",
			            dataSource: {
				            transport: {
					            read: "../SERVICES/WS_CFM_A02_C01.ashx?FCode=GetDeptI",
					            dataType: "json"
				            },
				            schema: {
					            type: 'json',
					            data: 'DATA',
					            model: { HISSYSCODE: "HISSYSCODE", HISSYSCODENM: "HISSYSCODENM" }
				            }
			            }
		            }).closest("span").width(150); 
		            $("#INTERNSHIP_DEPT_I").data('kendoDropDownList').value(e.model.INTERNSHIP_DEPT_P);        
            		
		            $("#INTERNSHIP_DEPT_II").kendoDropDownList({
			            valuePrimitive: true,
			            autoBind: false,
			            cascadeFrom: "INTERNSHIP_DEPT_I",
			            cascadeFromField: "HISSYSCODE",
			            dataTextField: "HISSYSCODENM_II",
			            dataValueField: "HISSYSCODE_II",                
			            optionLabel: "-- Please Select --",
			            dataSource: {
				            transport: {
					            read: "../SERVICES/WS_CFM_A02_C01.ashx?FCode=GetDeptII",
					            dataType: "json"
				            },
				            schema: {
					            type: 'json',
					            data: 'DATA',
					            model: { HISSYSCODE_II:"HISSYSCODE_II", HISSYSCODENM_II:"HISSYSCODENM_II", HISSYSCODE: "HISSYSCODE" }
				            }
			            }
		            }).closest("span").width(150); 
		            $("#INTERNSHIP_DEPT_II").data('kendoDropDownList').value(e.model.INTERNSHIP_DEPT);
                    
                    if (!e.model.isNew()) {
                     //編輯
                        var numeric = e.container.find("input[name=INTERN_STUDENT_ID]").attr('readonly','true');
                        
                        $('.k-grid-update').text('更新');
			            $('.k-grid-cancel').text('返回');
			            $('.k-window-title').text('編輯'); 
                    }
                    else
                    {
                     //新增
                     // hide name column
                       //新增
                        $("input[name='SEX'][value='U']").prop("checked",true);
			            $('.k-grid-update').text('確定');
			            $('.k-grid-cancel').text('取消');
			            $('.k-window-title').text('新增'); 
                    }
                   },
                save:function (e) {
                    
                    e.model.SEX = $('input:radio[name=SEX]:checked').val();
                    e.model.SCHOOL_ID = $("#SCHOOL_ID").text();
                    e.model.INTERN_DAYS = $("#INTERN_DAYS").text();
                    //判斷日期
                    if (isNaN(e.model.BIRTHDAY))
                    {
                        e.model.BIRTHDAY = kendo.toString(new Date(e.model.BIRTHDAY), 'yyyyMMdd');
                    }
                    if (isNaN(e.model.CHECK_IN_DATE))
                    {
                        e.model.CHECK_IN_DATE = kendo.toString(new Date(e.model.CHECK_IN_DATE), 'yyyyMMdd');
                    }
                    if (isNaN(e.model.CHECK_OUT_DATE))
                    {
                        e.model.CHECK_OUT_DATE = kendo.toString(new Date(e.model.CHECK_OUT_DATE), 'yyyyMMdd');
                    }
                    
                    if($('#INTERNSHIP_DEPT_II').val()=="")
                        e.model.INTERNSHIP_DEPT = $('#INTERNSHIP_DEPT_I').val()
                    else
                        e.model.INTERNSHIP_DEPT = $('#INTERNSHIP_DEPT_II').val();
                },
                toolbar: [ 
                        {
                            text : "新增資料", 
                            name: "create", 
                            iconClass: "k-icon k-add"
                        }
                    ]
	        });
	        
	    $("#TITLE_ID_DropDownList").kendoDropDownList({
            dataTextField: "HISSYSCODENM",
            dataValueField: "HISSYSCODE",
            optionLabel: "-- Please Select --",
            dataSource: {
                transport: {
                    read: "../SERVICES/WS_CFM_A02_C01.ashx?FCode=TitleList",
                    dataType: "json"
                },
                schema: {
                    type: 'json',
                    data: 'DATA',
                    model: { HISSYSCODE: "HISSYSCODE", HISSYSCODENM: "HISSYSCODENM" }
                }
            }
        }); 
		
		$("#INTERNSHIP_DEPT_I_DropDownList").kendoDropDownList({
            dataTextField: "HISSYSCODENM",
            dataValueField: "HISSYSCODE",
            optionLabel: "-- Please Select --",
            dataSource: {
	            transport: {
		            read: "../SERVICES/WS_CFM_A02_C01.ashx?FCode=GetDeptI",
		            dataType: "json"
	            },
	            schema: {
		            type: 'json',
		            data: 'DATA',
		            model: { HISSYSCODE: "HISSYSCODE", HISSYSCODENM: "HISSYSCODENM" }
	            }
            }
        }); 
        
         $("#INTERNSHIP_DEPT_II_DropDownList").kendoDropDownList({
            valuePrimitive: true,
            autoBind: false,
            cascadeFrom: "INTERNSHIP_DEPT_I_DropDownList",
            cascadeFromField: "HISSYSCODE",
            dataTextField: "HISSYSCODENM_II",
            dataValueField: "HISSYSCODE_II",                
            optionLabel: "-- Please Select --",
            dataSource: {
	            transport: {
		            read: "../SERVICES/WS_CFM_A02_C01.ashx?FCode=GetDeptII",
		            dataType: "json"
	            },
	            schema: {
		            type: 'json',
		            data: 'DATA',
		            model: { HISSYSCODE_II:"HISSYSCODE_II", HISSYSCODENM_II:"HISSYSCODENM_II", HISSYSCODE: "HISSYSCODE" }
	            }
            }
        });
        
        $("#SCHOOL_ID_DropDownList").kendoDropDownList({
            dataValueField: "HISSYSCODE",
            dataTextField: "HISSYSCODENM",
            optionLabel: "-- Please Select --",
            filter: "contains",
            minLength: 1,
            dataSource: {
                type: "json",
                transport: {
                    read: "../SERVICES/WS_CFM_A02_C01.ashx?FCode=SchoolList"
                },
                schema: {
                    type: 'json',
                    data: 'DATA',
                    model: { HISSYSCODE: "HISSYSCODE", HISSYSCODENM: "HISSYSCODENM" }
                }
            }
        }); 

		});

		function autoSEX()
		{
		    var sNIDNO = $("#NIDNO").val();
		    
		    if(sNIDNO.substr(1,1)=="1")
		        $("input[name='SEX'][value='M']").prop("checked",true);
		    else if(sNIDNO.substr(1,1)=="2")
		        $("input[name='SEX'][value='F']").prop("checked",true);
		    else
		        $("input[name='SEX'][value='U']").prop("checked",true);
		}
		
		function calInternDays()
		{
		    
		    if($("#CHECK_IN_DATE_DatePicker").val()!="" && $("#CHECK_OUT_DATE_DatePicker").val()!= "")
		    {
		        var sCheckInDate = new Date($("#CHECK_IN_DATE_DatePicker").val());
		        var sCheckOutDate = new Date($("#CHECK_OUT_DATE_DatePicker").val());
		        var iInternDays =((sCheckOutDate-sCheckInDate+1)/(24*60*60*1000)).toFixed(0);
		        if(iInternDays<0)
		        {
		            alert("報到日不可大於離院日。");
		        }
		        else
		            $("#INTERN_DAYS").text(iInternDays);
		    }
		}
    </script>

    <script id="popup-editor" type="text/x-kendo-tmpl">
    <table class="form">
        <tr>
            <td class="td-field-label">
                <span class="start">＊</span>本院實習生編號
            </td>
            <td class="td-field-edit">
                #= INTERN_STUDENT_ID #
            </td>
            <td class="td-field-label">
                <span class="start">＊</span>職類
            </td>
            <td class="td-field-edit">
                <input id="TITLE_ID" name="TITLE_ID" data-bind="value:TITLE_ID" required validationMessage="請輸入職類"/>
            </td>
        </tr>        
        <tr>
            <td class="td-field-label">
                <span class="start">＊</span>學校
            </td>
            <td class="td-field-edit">
                <div id="SCHOOL_ID">
                </div>
                <input id="SCHOOL_NAME" name="SCHOOL_NAME" data-bind="value:SCHOOL_ID" required validationMessage="請輸入學校"/>
            </td>
            <td class="td-field-label">
                學制
            </td>
            <td class="td-field-edit">
                <input id="SCHOOL_SYSTEM" name="SCHOOL_SYSTEM" data-bind="value:SCHOOL_SYSTEM" class='k-textbox' />
            </td>
        </tr>
        <tr>
            <td class="td-field-label">
                在校學號
            </td>
            <td class="td-field-edit">
                <input id="STUDENT_ID" name="STUDENT_ID" class='k-textbox' data-bind="value:STUDENT_ID" />
            </td>
            <td class="td-field-label">
                <span class="start">＊</span>科系別
            </td>
            <td class="td-field-edit">
                <input id="SCHOOL_DEPT" name="SCHOOL_DEPT" class='k-textbox' data-bind="value:SCHOOL_DEPT" required validationMessage="請輸入科系別"/>
            </td>
        </tr>
        <tr>
            <td class="td-field-label">
                年級
            </td>
            <td class="td-field-edit">
                <input id="SCHOOL_GRADE" name="SCHOOL_GRADE" class='k-textbox' data-bind="value:SCHOOL_GRADE" />
            </td>
            <td class="td-field-label">
                出生年月日
            </td>
            <td class="td-field-edit">
                <input id="BIRTHDAY_DatePicker" name="BIRTHDAY" data-bind="value:BIRTHDAY" placeholder="yyyy/MM/dd" />
            </td>
        </tr>
        <tr>
            <td class="td-field-label">
                <span class="start">＊</span>姓名
            </td>
            <td class="td-field-edit">
                <input id="INTERN_NAMEC" name="INTERN_NAMEC" class='k-textbox' data-bind="value:INTERN_NAMEC" required validationMessage="請輸入性名"/>
            </td>
            <td class="td-field-label">
                <span class="start">＊</span>身份證字號
            </td>
            <td class="td-field-edit">
                <input id="NIDNO" name="NIDNO" class='k-textbox' data-bind="value:NIDNO" onblur="autoSEX()" required validationMessage="請輸入身分證字號"/>
            </td>
        </tr>
        <tr>
            <td class="td-field-label">
                英文姓名
            </td>
            <td class="td-field-edit">
                <input id="INTERN_NAME" name="INTERN_NAME" class='k-textbox' data-bind="value:INTERN_NAME" />
            </td>
            <td class="td-field-label">
                私人手機號碼
            </td>
            <td class="td-field-edit">
                <input id="PRIVATE_PHONE" name="PRIVATE_PHONE" class='k-textbox' data-bind="value:PRIVATE_PHONE" />
            </td>
        </tr>
        <tr>
            <td class="td-field-label">
                性別
            </td>
            <td class="td-field-edit">
            <!--
                <input type="radio" id="SEXM" name="SEX" value="M" data-bind="value:SEX" />男
                <input type="radio" id="SEXF" name="SEX" value="F" data-bind="value:SEX" />女
                <input type="radio" id="SEXU" name="SEX" value="U" data-bind="value:SEX" />不詳-->
                <input type="radio" name="SEX" value="M" #= SEX=="M" ? checked="checked" : "" # />男
                <input type="radio" name="SEX" value="F" #= SEX=="F" ? checked="checked" : "" # />女
                <input type="radio" name="SEX" value="U" #= SEX=="U" ? checked="checked" : "" # />不詳
            </td>
            <td class="td-field-label">
                卡號
            </td>
            <td class="td-field-edit">
                <input id="CARDNO" name="CARDNO" class='k-textbox' data-bind="value:CARDNO" />
            </td>
        </tr>
        <tr>
            <td class="td-field-label">
                <span class="start">＊</span>實習單位
            </td>
            <td class="td-field-edit" colspan="3">
                <input id="INTERNSHIP_DEPT_I" name="INTERNSHIP_DEPT_I" required validationMessage="請輸入實習單位"/>
                <input id="INTERNSHIP_DEPT_II" name="INTERNSHIP_DEPT_II" />
            </td>
        </tr>
        <tr>
            <td class="td-field-label">
                實習項目(護理)
            </td>
            <td class="td-field-edit" colspan="3">
                <input id="PRACTICE_ITEMS" name="PRACTICE_ITEMS" class='k-textbox' data-bind="value:PRACTICE_ITEMS" style="width: 90%" />
            </td>
        </tr>
        <tr>
            <td class="td-field-label">
                E-mail
            </td>
            <td class="td-field-edit" colspan="3">
                <input id="EMAIL" name="EMAIL" class='k-textbox' data-bind="value:EMAIL" style="width: 90%" />
            </td>
        </tr>
        <tr>
            <td class="td-field-label">
                戶籍地址
            </td>
            <td class="td-field-edit" colspan="3">
                <input id="ADDRESS" name="ADDRESS" class='k-textbox' data-bind="value:ADDRESS" style="width: 90%" />
            </td>
        </tr>
        <tr>
            <td class="td-field-label">
                <span class="start">＊</span>報到日
            </td>
            <td class="td-field-edit">
                <input id="CHECK_IN_DATE_DatePicker" name="CHECK_IN_DATE" data-bind="value:CHECK_IN_DATE"
                    placeholder="yyyy/MM/dd" onchange="calInternDays()" required validationMessage="請輸入報到日"/>
            </td>
            <td class="td-field-label">
                <span class="start">＊</span>離院日
            </td>
            <td class="td-field-edit">
                <input id="CHECK_OUT_DATE_DatePicker" name="CHECK_OUT_DATE" data-bind="value:CHECK_OUT_DATE"
                    placeholder="yyyy/MM/dd" onchange="calInternDays()" required validationMessage="請輸入離院日" />
            </td>
        </tr>
        <tr>
            <td class="td-field-label">
                <span class="start">＊</span>實習天數
            </td>
            <td class="td-field-edit" id="INTERN_DAYS">
            </td>
            <td class="td-field-label">
                <span class="start">＊</span>實習總時數
            </td>
            <td class="td-field-edit">
                <input id="INTERN_HOURS" name="INTERN_HOURS" class='k-textbox' data-bind="value:INTERN_HOURS"/>
            </td>
        </tr>
        <tr>
            <td class="td-field-label">
                <span class="start">＊</span>緊急聯絡人
            </td>
            <td class="td-field-edit">
                <input id="EMERGENCY_CONTACT" name="EMERGENCY_CONTACT" class='k-textbox' data-bind="value:EMERGENCY_CONTACT" required validationMessage="請輸入緊急聯絡人"/>
            </td>
            <td class="td-field-label">
                <span class="start">＊</span>緊急聯絡人電話
            </td>
            <td class="td-field-edit">
                <input id="EMERGENCY_PHONE" name="EMERGENCY_PHONE" class='k-textbox' data-bind="value:EMERGENCY_PHONE" required validationMessage="請輸入緊急聯絡人電話" />
            </td>
        </tr>
        <tr>
            <td class="td-field-label">
                緊急聯絡人關係
            </td>
            <td class="td-field-edit">
                <input id="EMERGENCY_RELATIONSHIP" name="EMERGENCY_RELATIONSHIP" data-bind="value:EMERGENCY_RELATIONSHIP" />
            </td>
            <td class="td-field-label">
            </td>
            <td class="td-field-edit">
            </td>
        </tr>
        <tr>
            <td class="td-field-label">
                備註
            </td>
            <td class="td-field-edit" colspan="3">
                <input id="MEMORY" name="MEMORY" class='k-textbox' data-bind="value:MEMORY" style="width: 90%" />
            </td>
        </tr>
        <tr>
            <td colspan="4" style="text-align:center">
                <input type="checkbox" name="Check_YN" id="Check_YN" value="Y" checked="false" required validationMessage="請確認以上資料">
                以上資料已確認無誤
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
                        <span class="input-group-addon">職類</span>
                        <input id="TITLE_ID_DropDownList" />
                    </div>
                    <div class="input-group col-lg-3 col-md-3 col-sm-3 pull-left">
                        <span class="input-group-addon">實習單位</span>
                        <input id="INTERNSHIP_DEPT_I_DropDownList" />
                    </div>
                    <input id="INTERNSHIP_DEPT_II_DropDownList" />
                </td>
            </tr>
            <tr>
                <td style="border-top-width: 0px; border-top-style: none;">
                    <div class="input-group col-lg-3 col-md-3 col-sm-3 pull-left">
                        <span class="input-group-addon">學校名稱</span>
                        <input id="SCHOOL_ID_DropDownList" />
                    </div>
                    <div class="input-group col-lg-3 col-md-3 col-sm-3 pull-left">
                        <span class="input-group-addon">身分證字號</span>
                        <input class="form-control" id="NIDNO_TEXT" type="text" />
                    </div>
                    <div class="input-group col-lg-3 col-md-3 col-sm-3 pull-left">
                        <span class="input-group-addon">實習生姓名</span>
                        <input class="form-control" id="INTERN_NAMEC_TEXT" type="text" />
                    </div>
                    <div class="input-group col-lg-3 col-md-3 col-sm-3 pull-left" style="left: 0px; top: 0px;
                        width: 122px; height: 25px; margin-top: 2px; margin-left: 10px;">
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
