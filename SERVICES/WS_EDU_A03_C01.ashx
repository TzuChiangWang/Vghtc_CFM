/*
SW_EDU_A03_C01

Description : 實習生請假
Create By : 菜菜
Create Date : 20160318
*/

<%@ WebHandler Language="C#" Class="WS_EDU_A03_C01" %>

using System;
using System.Web;
using System.Data;
using System.Text;
using System.IO;
using System.Web.SessionState;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using dmxUtils;
using dmxUserInterface;
using dmxDataAccess;
using C1.Web.C1WebReport;

public class WS_EDU_A03_C01 : uiAshxCommon
{
    public override void ProcessRequest(HttpContext context)
    {
        base.ProgramID = "A03C01";
        base.ProcessRequest(context);
        // 設定回傳頁面型態
        context.Response.ContentType = "application/json";
        WebParamaters WPS = new WebParamaters();
        JavaScriptSerializer js = new JavaScriptSerializer() { MaxJsonLength = Int32.MaxValue };
        // 設定回傳資料集
        Dictionary<string, object> dicResult = new Dictionary<string, object>();
        List<object> listResult = new List<object>();
        double listRules = 0;
        StringBuilder sbSQL = new StringBuilder();
        string sFCode = WPS.getKeys("FCode");

        //判斷登入連線session是否存在
        if (base.sUserID != "" && base.sUserNM != "")
        {
            using (OracleDataSource OraDB = new OracleDataSource("VGHTC.EDU.ConnStr", true))
            {
                try
                {
                    switch (sFCode)
                    {
                        case "C":
                            {
                                var models = js.Deserialize<JSONClass.JSON_EDU_A03_C01>(WPS.getKeys("models"));

                                OraDB.InsertCommand = @"
                                INSERT INTO COMMON.EDU_INTERN_LEAVES
                                  (INTERN_STUDENT_ID,LEAVE_SEQ,LEAVE_TYPE,LEAVE_SDTTM,LEAVE_EDTTM
                                    ,LEAVE_DAYS,LEAVE_HOURS,LEAVE_STATUS,INTERNSHIP_DEPT
                                    ,LEAVE_REASON,AGENT_CARDNO,AGENT_NAME,AGENT_TEL,INSPECT_CARDNO
                                    ,INSPECT_NAMEC,INSPECT_DATE,PROCDATETIME,PROCID,PROCNMC
                                    ,CREATEDATETIME,CREATEID,CREATENMC)
                                VALUES
                                  (:INTERN_STUDENT_ID,:LEAVE_SEQ,:LEAVE_TYPE,:LEAVE_SDTTM
                                    ,:LEAVE_EDTTM,:LEAVE_DAYS,:LEAVE_HOURS,:LEAVE_STATUS
                                    ,:INTERNSHIP_DEPT,:LEAVE_REASON,:AGENT_CARDNO,:AGENT_NAME
                                    ,:AGENT_TEL,:INSPECT_CARDNO,:INSPECT_NAMEC,:INSPECT_DATE
                                    ,TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),:PROCID,:PROCNMC,
                                    TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),:CREATEID,:CREATENMC) ";

                                // TODO : 取號
                                Utility ut = new Utility();
                                models.LEAVE_SEQ = ut.GetSeqNo("", "EDU_INTERN_LEAVES", "LEAVE_SEQ", 4, 3, OraDB);

                                OraDB.InsertParameters.Add("INTERN_STUDENT_ID", models.INTERN_STUDENT_ID);
                                OraDB.InsertParameters.Add("LEAVE_SEQ", models.LEAVE_SEQ);
                                OraDB.InsertParameters.Add("LEAVE_TYPE", models.LEAVE_TYPE);
                                OraDB.InsertParameters.Add("LEAVE_SDTTM", models.LEAVE_SDTTM);
                                OraDB.InsertParameters.Add("LEAVE_EDTTM", models.LEAVE_EDTTM);
                                OraDB.InsertParameters.Add("LEAVE_DAYS", models.LEAVE_DAYS);
                                OraDB.InsertParameters.Add("LEAVE_HOURS", models.LEAVE_HOURS);
                                OraDB.InsertParameters.Add("LEAVE_STATUS", models.LEAVE_STATUS==""?"10":models.LEAVE_STATUS);
                                OraDB.InsertParameters.Add("INTERNSHIP_DEPT", models.INTERNSHIP_DEPT);
                                OraDB.InsertParameters.Add("LEAVE_REASON", models.LEAVE_REASON);
                                OraDB.InsertParameters.Add("AGENT_CARDNO", models.AGENT_CARDNO);
                                OraDB.InsertParameters.Add("AGENT_NAME", models.AGENT_NAME);
                                OraDB.InsertParameters.Add("AGENT_TEL", models.AGENT_TEL);
                                OraDB.InsertParameters.Add("INSPECT_CARDNO", models.INSPECT_CARDNO);
                                OraDB.InsertParameters.Add("INSPECT_NAMEC", models.INSPECT_NAMEC);
                                OraDB.InsertParameters.Add("INSPECT_DATE", models.INSPECT_DATE);
                                OraDB.InsertParameters.Add("PROCID", base.sUserID);
                                OraDB.InsertParameters.Add("PROCNMC", base.sUserNM);
                                OraDB.InsertParameters.Add("CREATEID", base.sUserID);
                                OraDB.InsertParameters.Add("CREATENMC", base.sUserNM);

                                OraDB.Insert();

                                // 檔案重新命名
                                if (models.HIDDEN_FILENAME != "")  //若有上傳檔案才去重新命名
                                {
                                    String[] names = models.HIDDEN_FILENAME.Split('?');
                                    int i;
                                    for (i=1;i< names.Length;i++)
                                    {
                                        var num = ut.GetfileSeqNo("", "EDU_UPLOADFILES", models.LEAVE_SEQ , "FILE_SEQ", 0, 1, OraDB);
                                        //所上傳之附件原始檔名(檔名內已包含副檔名)
                                        string oldFileName = HttpContext.Current.Server.MapPath("../UploadFiles/EDU_A03C01/" + names[i]);
                                        //將檔案命名為假單編號  
                                        string newFileName = HttpContext.Current.Server.MapPath("../UploadFiles/EDU_A03C01/" + models.INTERN_STUDENT_ID + "_" + models.LEAVE_SEQ + "_"+ num +Path.GetExtension(oldFileName));
                                        File.Move(oldFileName, newFileName);

                                        // 將附件檔案insert into EDU_UPLOADFILES資料表
                                        OraDB.InsertCommand = @"
                                                     INSERT INTO COMMON.EDU_UPLOADFILES
                                                       (FUNCTION_NAME,FUNCTION_KEY,FILE_SEQ,FILENAME_ORIGIN,FILENAME_RENAME
                                                         ,PROCDATETIME,PROCID,PROCNMC,CREATEDATETIME
                                                         ,CREATEID,CREATENMC)
                                                     VALUES
                                                       (:FUNCTION_NAME,:FUNCTION_KEY,:FILE_SEQ,:FILENAME_ORIGIN
                                                         ,:FILENAME_RENAME,TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),:PROCID,:PROCNMC
                                                         ,TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),:CREATEID,:CREATENMC) ";

                                        OraDB.InsertParameters.Add("FUNCTION_NAME", "A03C01");  //存入頁面名稱
                                        OraDB.InsertParameters.Add("FUNCTION_KEY", models.LEAVE_SEQ);  //存入假單編號
                                        OraDB.InsertParameters.Add("FILE_SEQ", num);  //檔案流水號(自行編碼)
                                        OraDB.InsertParameters.Add("FILENAME_ORIGIN", names[i]);  //原始檔名
                                        OraDB.InsertParameters.Add("FILENAME_RENAME", models.INTERN_STUDENT_ID + "_" + models.LEAVE_SEQ + "_"+ num +Path.GetExtension(oldFileName));  //重新命名後檔名
                                        OraDB.InsertParameters.Add("PROCID",  base.sUserID);  //紀錄處理人員IDNO
                                        OraDB.InsertParameters.Add("PROCNMC", base.sUserNM);  //紀錄處理人員姓名
                                        OraDB.InsertParameters.Add("CREATEID", base.sUserID);  //紀錄建立人員IDNO
                                        OraDB.InsertParameters.Add("CREATENMC", base.sUserNM);  //紀錄建立人員姓名

                                        OraDB.Insert();

                                    }
                                }

                                OraDB.transaction.Commit();
                                dicResult.Add("SRESULT", "TRUE");
                                dicResult.Add("SMESSAGE", "新增成功!請記得提醒您的代理人!");
                                break;
                            }
                        case "R":
                            {
                                StringBuilder sOrderBy = new StringBuilder();
                                StringBuilder sQuery = new StringBuilder();
                                //string sNIDNO = Utils.StrEmpty(context.Request["NIDNO"]);
                                string sLEAVE_TYPE = Utils.StrEmpty(context.Request["LEAVE_TYPE"]);
                                string sTITLE_ID = Utils.StrEmpty(context.Request["TITLE_ID"]);
                                string sStartDate = Utils.StrEmpty(context.Request["StartDate"]);
                                string sEndDate = Utils.StrEmpty(context.Request["EndDate"]);
                                var models = js.Deserialize<JSONClass.JSON_EDU_PAGE>(WPS.getKeys("models"));
                                string userID = base.sUserID.Length.ToString();
                                int num = Int32.Parse(userID);

                                //欄位名稱轉換成DB名稱
                                Dictionary<string, string> dicMap = new Dictionary<string, string>();
                                dicMap.Add("LEAVE_TYPEC", "T2.HISSYSCODENM");
                                dicMap.Add("LEAVE_STATUSC", "T3.HISSYSCODENM");
                                dicMap.Add("INTERNSHIP_DEPTC", "T4.NAME");

                                #region 根據排序傳入的排序 給定row number
                                if (models.SORT == null)
                                {
                                    sOrderBy.Append("LEAVE_SEQ DESC");  //default sort
                                }
                                else
                                {
                                    for (int i = 0; i < models.SORT.Count; i++)
                                    {
                                        if (dicMap.ContainsKey(models.SORT[i].field))
                                            models.SORT[i].field = dicMap[models.SORT[i].field];
                                        sOrderBy.Append(models.SORT[i].field);
                                        sOrderBy.Append(" ");
                                        sOrderBy.Append(models.SORT[i].dir);
                                        sOrderBy.Append(",");
                                    }
                                }
                                #endregion

                                #region 查詢條件
                                sQuery.Append(@"
                                          FROM COMMON.EDU_INTERN_LEAVES T 
                                         INNER JOIN COMMON.EDU_INTERN_BASIC T1 
                                                ON T.INTERN_STUDENT_ID = T1.INTERN_STUDENT_ID
                                         LEFT JOIN COMMON.EDEPT_VGHTC T4 
                                                ON T.INTERNSHIP_DEPT = T4.DEPTNO 
                                         INNER JOIN OPDUSR.BASCODE T2 
                                                ON T.LEAVE_TYPE = T2.HISSYSCODE
                                                AND T2.SYSTEMID = 'EDUPRJ'
                                                AND T2.SYSCODETYPE = '12'
                                         INNER JOIN OPDUSR.BASCODE T3 
                                                ON T.LEAVE_STATUS = T3.HISSYSCODE
                                                AND T3.SYSTEMID = 'EDUPRJ'
                                                AND T3.SYSCODETYPE = '17'
                                         
                                         WHERE 1=1 ");
                                if (!sLEAVE_TYPE.Equals(""))
                                {
                                    sQuery.Append("AND T.LEAVE_TYPE = :LEAVE_TYPE ");
                                    OraDB.SelectParameters.Add("LEAVE_TYPE", sLEAVE_TYPE);
                                }
                                if (!sStartDate.Equals(""))
                                {
                                    sQuery.Append("AND T.LEAVE_SDTTM >= :LEAVE_SDTTM  ");
                                    OraDB.SelectParameters.Add("LEAVE_SDTTM", sStartDate+"0000");
                                }
                                if (!sEndDate.Equals(""))
                                {
                                    sQuery.Append("AND T.LEAVE_EDTTM <= :LEAVE_EDTTM ");
                                    OraDB.SelectParameters.Add("LEAVE_EDTTM", sEndDate+"2359");
                                }
                                if (!sTITLE_ID.Equals(""))
                                {
                                    sQuery.Append("AND T1.TITLE_ID = :TITLE_ID ");
                                    OraDB.SelectParameters.Add("TITLE_ID", sTITLE_ID);
                                }


                                #endregion

                                #region 組SQL
                                sbSQL.AppendFormat(@"
                                SELECT *
                                  FROM (SELECT ROW_NUMBER() OVER(ORDER BY {0}) AS RNUM,
                                               T.LEAVE_SEQ,
                                               T1.NIDNO,
                                               T1.INTERN_NAMEC,
                                               T.INTERN_STUDENT_ID,
                                               T.LEAVE_TYPE,
                                               T2.HISSYSCODENM LEAVE_TYPEC,
                                               TO_CHAR(TO_DATE(T.LEAVE_SDTTM,'YYYY/MM/DD HH24:MI'),'YYYY/MM/DD HH24:MI') LEAVE_SDTTM,
                                               TO_CHAR(TO_DATE(T.LEAVE_EDTTM,'YYYY/MM/DD HH24:MI'),'YYYY/MM/DD HH24:MI') LEAVE_EDTTM,
                                               T.LEAVE_DAYS,
                                               T.LEAVE_HOURS,
                                               T.LEAVE_STATUS,
                                               T3.HISSYSCODENM LEAVE_STATUSC,
                                               T.INTERNSHIP_DEPT,
                                               NVL2(T4.NAME,T4.NAME,T.Internship_Dept) INTERNSHIP_DEPTC,
                                               T.LEAVE_REASON,
                                               T.AGENT_CARDNO,
                                               T.AGENT_NAME,
                                               T.AGENT_TEL,
                                               T.INSPECT_CARDNO,
                                               T.INSPECT_NAMEC,
                                               T.INSPECT_DATE
                                {1}    ", sOrderBy.ToString().TrimEnd(','), sQuery.ToString());
                                if (num < 10)
                                {
                                    sbSQL.Append(@") WHERE RNUM BETWEEN :skip + 1 AND :skip + :pagesize");

                                    OraDB.SelectCommand = sbSQL.ToString();
                                    OraDB.SelectParameters.Add("skip", models.SKIP);
                                    OraDB.SelectParameters.Add("pagesize", models.PAGESIZE);
                                }
                                else
                                {
                                    sbSQL.Append(@"AND T.INTERN_STUDENT_ID = :sID ) WHERE RNUM BETWEEN :skip + 1 AND :skip + :pagesize");

                                    OraDB.SelectCommand = sbSQL.ToString();
                                    OraDB.SelectParameters.Add("sID", base.sUserID);
                                    OraDB.SelectParameters.Add("skip", models.SKIP);
                                    OraDB.SelectParameters.Add("pagesize", models.PAGESIZE);
                                }
                                #endregion

                                DataTable dtData = OraDB.Select();
                                if (dtData.Rows.Count > 0)
                                {
                                    //GetBaseCode gbc = new GetBaseCode();
                                    foreach (DataRow dr in dtData.Rows)
                                    {
                                        listResult.Add(new JSONClass.JSON_EDU_A03_C01()
                                        {
                                            LEAVE_SEQ = dr["LEAVE_SEQ"].ToString(),
                                            NIDNO = dr["NIDNO"].ToString(),
                                            INTERN_NAMEC = dr["INTERN_NAMEC"].ToString(),
                                            INTERN_STUDENT_ID = dr["INTERN_STUDENT_ID"].ToString(),
                                            LEAVE_TYPE = dr["LEAVE_TYPE"].ToString(),
                                            LEAVE_TYPEC = dr["LEAVE_TYPEC"].ToString(),
                                            LEAVE_SDTTM = dr["LEAVE_SDTTM"].ToString(),
                                            LEAVE_EDTTM = dr["LEAVE_EDTTM"].ToString(),
                                            LEAVE_DAYS = dr["LEAVE_DAYS"].ToString(),
                                            LEAVE_HOURS = dr["LEAVE_HOURS"].ToString(),
                                            LEAVE_STATUS = dr["LEAVE_STATUS"].ToString(),
                                            LEAVE_STATUSC = dr["LEAVE_STATUSC"].ToString(),
                                            INTERNSHIP_DEPT = dr["INTERNSHIP_DEPT"].ToString(),
                                            INTERNSHIP_DEPTC = dr["INTERNSHIP_DEPTC"].ToString(),
                                            LEAVE_REASON = dr["LEAVE_REASON"].ToString(),
                                            AGENT_CARDNO = dr["AGENT_CARDNO"].ToString(),
                                            AGENT_NAME = dr["AGENT_NAME"].ToString(),
                                            AGENT_TEL = dr["AGENT_TEL"].ToString(),
                                            INSPECT_CARDNO = dr["INSPECT_CARDNO"].ToString(),
                                            INSPECT_NAMEC = dr["INSPECT_NAMEC"].ToString(),
                                            INSPECT_DATE = dr["INSPECT_DATE"].ToString(),
                                        });
                                    }

                                    //取得總筆數
                                    OraDB.SelectCommand = string.Format("SELECT COUNT(*) {0} ", sQuery);
                                    if (!sLEAVE_TYPE.Equals(""))
                                        OraDB.SelectParameters.Add("LEAVE_TYPE", sLEAVE_TYPE);
                                    if (!sStartDate.Equals(""))
                                        OraDB.SelectParameters.Add("LEAVE_SDTTM", sStartDate.Substring(0, 8));
                                    if (!sEndDate.Equals(""))
                                        OraDB.SelectParameters.Add("LEAVE_EDTTM", sEndDate.Substring(0, 8));
                                    if (!sTITLE_ID.Equals(""))
                                        OraDB.SelectParameters.Add("TITLE_ID", sTITLE_ID);

                                    dicResult.Add("TOTALCOUNT", OraDB.Select().Rows[0][0].ToString());

                                    dicResult.Add("SRESULT", "TRUE");
                                    dicResult.Add("SMESSAGE", "");
                                    dicResult.Add("DATA", listResult);
                                }
                                else
                                {
                                    dicResult.Add("SRESULT", "FALSE");
                                    dicResult.Add("SMESSAGE", "查無資料");
                                }
                                break;
                            }
                        case "U":
                            {
                                var models = js.Deserialize<JSONClass.JSON_EDU_A03_C01>(WPS.getKeys("models"));
                                OraDB.UpdateCommand = @"
                                UPDATE COMMON.EDU_INTERN_LEAVES
                                   SET LEAVE_TYPE=:LEAVE_TYPE,
                                        LEAVE_SDTTM=:LEAVE_SDTTM,
                                        LEAVE_EDTTM=:LEAVE_EDTTM,
                                        LEAVE_DAYS=:LEAVE_DAYS,
                                        LEAVE_HOURS=:LEAVE_HOURS,
                                        LEAVE_STATUS=:LEAVE_STATUS,
                                        INTERNSHIP_DEPT=:INTERNSHIP_DEPT,
                                        LEAVE_REASON=:LEAVE_REASON,
                                        AGENT_CARDNO=:AGENT_CARDNO,
                                        AGENT_NAME=:AGENT_NAME,
                                        AGENT_TEL=:AGENT_TEL,
                                        INSPECT_CARDNO=:INSPECT_CARDNO,
                                        INSPECT_NAMEC=:INSPECT_NAMEC,
                                        INSPECT_DATE=:INSPECT_DATE,
                                        PROCID                 = :PROCID,
                                        PROCNMC                = :PROCNMC,                                      
                                        PROCDATETIME           = TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')                                       
                                 WHERE INTERN_STUDENT_ID = :INTERN_STUDENT_ID 
                                       AND LEAVE_SEQ= :LEAVE_SEQ";


                                OraDB.UpdateParameters.Add("LEAVE_TYPE", models.LEAVE_TYPE);
                                OraDB.UpdateParameters.Add("LEAVE_SDTTM", models.LEAVE_SDTTM);
                                OraDB.UpdateParameters.Add("LEAVE_EDTTM", models.LEAVE_EDTTM);
                                OraDB.UpdateParameters.Add("LEAVE_DAYS", models.LEAVE_DAYS);
                                OraDB.UpdateParameters.Add("LEAVE_HOURS", models.LEAVE_HOURS);
                                OraDB.UpdateParameters.Add("LEAVE_STATUS", models.LEAVE_STATUS);
                                OraDB.UpdateParameters.Add("INTERNSHIP_DEPT", models.INTERNSHIP_DEPT);
                                OraDB.UpdateParameters.Add("LEAVE_REASON", models.LEAVE_REASON);
                                OraDB.UpdateParameters.Add("AGENT_CARDNO", models.AGENT_CARDNO);
                                OraDB.UpdateParameters.Add("AGENT_NAME", models.AGENT_NAME);
                                OraDB.UpdateParameters.Add("AGENT_TEL", models.AGENT_TEL);
                                OraDB.UpdateParameters.Add("INSPECT_CARDNO", models.INSPECT_CARDNO);
                                OraDB.UpdateParameters.Add("INSPECT_NAMEC", models.INSPECT_NAMEC);
                                OraDB.UpdateParameters.Add("INSPECT_DATE", models.INSPECT_DATE);
                                OraDB.UpdateParameters.Add("PROCID", base.sUserID);
                                OraDB.UpdateParameters.Add("PROCNMC", base.sUserNM);
                                OraDB.UpdateParameters.Add("INTERN_STUDENT_ID", models.INTERN_STUDENT_ID);
                                OraDB.UpdateParameters.Add("LEAVE_SEQ", models.LEAVE_SEQ);

                                OraDB.Update();

                                // 檔案重新命名
                                if (models.HIDDEN_FILENAME != "")  //若有上傳檔案才去重新命名
                                {

                                    String[] names = models.HIDDEN_FILENAME.Split('?');  // 將串起來的原始檔名用','切割  

                                    int i;
                                    for (i = 1; i < names.Length; i++)  // 上傳了i個檔案
                                    {
                                        // 編檔案流水號
                                        Utility ut = new Utility();
                                        var num = ut.GetfileSeqNo("", "EDU_UPLOADFILES", models.LEAVE_SEQ ,"FILE_SEQ", 0, 1, OraDB);

                                        //所上傳之附件原始檔名(檔名內已包含副檔名)
                                        string oldFileName = HttpContext.Current.Server.MapPath("../UploadFiles/EDU_A03C01/" + names[i]);
                                        //將檔案命名為假單編號_i
                                        string newFileName = HttpContext.Current.Server.MapPath("../UploadFiles/EDU_A03C01/"
                                            + models.INTERN_STUDENT_ID + "_" + models.LEAVE_SEQ + "_" + num +Path.GetExtension(oldFileName));
                                        File.Copy(oldFileName, newFileName);  // 將舊檔名複製，並改名為新檔名
                                        File.Delete(oldFileName);  // 將舊檔名刪掉

                                        // 將附件檔案insert into EDU_UPLOADFILES資料表
                                        OraDB.InsertCommand = @"
                                                         INSERT INTO COMMON.EDU_UPLOADFILES
                                                           (FUNCTION_NAME,FUNCTION_KEY,FILE_SEQ,FILENAME_ORIGIN,FILENAME_RENAME
                                                             ,PROCDATETIME,PROCID,PROCNMC,CREATEDATETIME
                                                             ,CREATEID,CREATENMC)
                                                         VALUES
                                                           (:FUNCTION_NAME,:FUNCTION_KEY,:FILE_SEQ,:FILENAME_ORIGIN
                                                             ,:FILENAME_RENAME,TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),:PROCID,:PROCNMC
                                                             ,TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),:CREATEID,:CREATENMC) ";

                                        OraDB.InsertParameters.Add("FUNCTION_NAME", "A03C01");  //存入頁面名稱
                                        OraDB.InsertParameters.Add("FUNCTION_KEY", models.LEAVE_SEQ);  //存入假單編號
                                        OraDB.InsertParameters.Add("FILE_SEQ", num);  //檔案流水號(自行編碼)
                                        OraDB.InsertParameters.Add("FILENAME_ORIGIN", names[i]);  //原始檔名
                                        OraDB.InsertParameters.Add("FILENAME_RENAME", models.INTERN_STUDENT_ID + "_"
                                                                    + models.LEAVE_SEQ + "_"+ num +Path.GetExtension(oldFileName));  //重新命名後檔名
                                        OraDB.InsertParameters.Add("PROCID", base.sUserID);  //紀錄處理人員IDNO
                                        OraDB.InsertParameters.Add("PROCNMC", base.sUserNM);  //紀錄處理人員姓名
                                        OraDB.InsertParameters.Add("CREATEID", base.sUserID);  //紀錄建立人員IDNO
                                        OraDB.InsertParameters.Add("CREATENMC", base.sUserNM);  //紀錄建立人員姓名

                                        OraDB.Insert();

                                    }  // for迴圈                                                                      
                                }

                                OraDB.transaction.Commit();
                                dicResult.Add("SRESULT", "TRUE");
                                dicResult.Add("SMESSAGE", "更新成功");
                                break;
                            }
                        case "S":
                            {
                                var models = js.Deserialize<JSONClass.JSON_EDU_A03_C01>(WPS.getKeys("models"));
                                string userID = base.sUserID.Length.ToString();
                                int num = Int32.Parse(userID);
                                string aaa = models.LEAVE_STATUS;
                                string bbb = models.INTERNSHIP_DEPT;

                                if (models.LEAVE_STATUS.Equals("10") || num < 10)
                                {
                                    OraDB.UpdateCommand = @"
                                    UPDATE COMMON.EDU_INTERN_LEAVES
                                            SET LEAVE_STATUS= :LEAVE_STATUS, 
                                                    LEAVE_APPLY_DATE = TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')
                                     WHERE INTERN_STUDENT_ID = :INTERN_STUDENT_ID 
                                           AND LEAVE_SEQ= :LEAVE_SEQ";
                                    OraDB.UpdateParameters.Add("LEAVE_STATUS", "20");
                                    OraDB.UpdateParameters.Add("INTERN_STUDENT_ID", models.INTERN_STUDENT_ID);
                                    OraDB.UpdateParameters.Add("LEAVE_SEQ", models.LEAVE_SEQ);

                                    OraDB.Update();
                                    OraDB.transaction.Commit();
                                    dicResult.Add("SRESULT", "TRUE");
                                    dicResult.Add("SMESSAGE", "送單成功");
                                }
                                else
                                {
                                    dicResult.Add("SRESULT", "FALSE");
                                    dicResult.Add("SMESSAGE", "請勿重複送單");
                                }
                                break;
                            }
                        case "CheckLeaveType":
                            {
                                //LeaveRules GLR = new LeaveRules();
                                var models = js.Deserialize<JSONClass.JSON_EDU_A03_C01>(WPS.getKeys("models"));
                                //dicResult = GLR.sLeaveRules(models.LEAVE_TYPEC, 0, models.NIDNO);
                                break;
                            }
                        case "CheckLeaveRules":
                            {
                                //LeaveRules GLR = new LeaveRules();
                                var models = js.Deserialize<JSONClass.JSON_EDU_A03_C01>(WPS.getKeys("LeaveTime"));
                                string LEAVESDTTM = models.LEAVE_SDTTM.Substring(0, 8);
                                string LEAVEEDTTM = models.LEAVE_EDTTM.Substring(0, 8);

                                // TODO : 檢核請假規則                                
                                if (models.LEAVE_SDTTM.Equals("19700101"))
                                {
                                    dicResult.Add("SRESULT", "FALSE");
                                    dicResult.Add("SMESSAGE", "請先選擇請假起");
                                }
                                else if (models.LEAVE_EDTTM.Equals("19700101"))
                                {
                                    break;
                                }
                                else
                                {
                                    //dicResult = GLR.calculateEightDays(models.NIDNO);
                                    //listRules = GLR.calculateLeavePeriod(models.LEAVE_SDTTM, models.LEAVE_EDTTM);

                                    if (listRules > 0)
                                    {
                                        //dicResult = GLR.sLeaveRules(models.LEAVE_TYPEC, listRules, models.NIDNO);
                                        dicResult.Add("DATA", listRules);
                                    }
                                }

                                break;
                            }
                        case "LeaveTypeList":
                            {
                                //GetBaseCode gbc = new GetBaseCode();
                                //listResult = gbc.getHISSYSCODEList("12");
                                dicResult.Add("SRESULT", "TURE");
                                dicResult.Add("SMESSAGE", "");
                                dicResult.Add("DATA", listResult);
                                break;
                            }
                        case "LeaveStatusList":
                            {
                                //GetBaseCode gbc = new GetBaseCode();
                                //listResult = gbc.getHISSYSCODEList("17");
                                dicResult.Add("SRESULT", "TRUE");
                                dicResult.Add("SMESSAGE", "");
                                dicResult.Add("DATA", listResult);
                                break;
                            }
                        case "InternStudentBasic":
                            {
                                string sNIDNO = Utils.StrEmpty(context.Request["NIDNO"]);
                                //GetBaseCode gbc = new GetBaseCode();
                                //dicResult = gbc.getInternStudentBasic(sNIDNO);
                                break;
                            }
                        case "calLeaveDays":
                            {
                                string sNIDNO = Utils.StrEmpty(context.Request["sNIDNO"]);
                                //LeaveRules GLR = new LeaveRules();
                                //listResult = GLR.calculateYearLeave(sNIDNO);
                                dicResult.Add("SRESULT", "TRUE");
                                dicResult.Add("SMESSAGE", "");
                                dicResult.Add("DATA", listResult);
                                //var models = js.Deserialize<JSONClass.JSON_EDU_A03_C01>(WPS.getKeys("NIDNO"));
                                //GetBaseCode gbc = new GetBaseCode();
                                //dicResult = gbc.getInternStudentBasic(sNIDNO);
                                break;
                            }
                        case "getInternDEPT":
                            {
                                var models = js.Deserialize<JSONClass.JSON_EDU_A03_C01>(WPS.getKeys("LeaveTime"));
                                string ssNIDNO = Utils.StrEmpty(context.Request["tNIDNO"]);
                                string deptLEAVE_SDTTM = models.LEAVE_SDTTM.Substring(0, 8);
                                string deptLEAVE_EDTTM = models.LEAVE_EDTTM.Substring(0, 8);

                                if (deptLEAVE_EDTTM.Equals("19700101"))
                                {
                                    break;
                                }
                                else
                                {
                                    //GetBaseCode gbc = new GetBaseCode();
                                    //dicResult = gbc.getGetDept(ssNIDNO, deptLEAVE_SDTTM, deptLEAVE_EDTTM, models.LEAVE_TYPEC);
                                    //dicResult.Add("SRESULT", true);
                                    //dicResult.Add("SMESSAGE", "");
                                }
                                //dicResult = gbc.getGetDept("Q223758390", "20121127", "20121128",models.LEAVE_TYPEC);
                                break;
                            }
                        case "Upload":
                            {
                                try
                                {
                                    if (context.Request.Files.Count > 0)
                                    {
                                        var allFileName = "";  //串檔名用
                                                               // 接參數
                                                               //string sdataID = Utils.StrEmpty(context.Request["dataID"]);
                                                               // 檔案上傳
                                        string path = context.Server.MapPath("~/UploadFiles/EDU_A03C01");

                                        if (!Directory.Exists(path))
                                            Directory.CreateDirectory(path);

                                        for (int i = 0; i < context.Request.Files.Count; i++)  //前端用batch傳，跑迴圈抓出array裡的檔案
                                        {
                                            var file = context.Request.Files[i];
                                            string fileName = Path.Combine(path,Path.GetFileName(file.FileName));
                                            file.SaveAs(fileName);

                                            allFileName = allFileName + "?" + file.FileName;

                                        }
                                        dicResult.Add("FILENAME", allFileName);  //將檔名傳回前端
                                        dicResult.Add("SRESULT", "TRUE");
                                        dicResult.Add("SMESSAGE", "上傳成功，請記得點選確定或更新鈕，上傳資料才會生效。");
                                    }
                                }
                                catch (Exception e)
                                {
                                    dicResult.Add("SRESULT", "FALSE");
                                    dicResult.Add("SMESSAGE", "上傳失敗");
                                }

                                break;
                            }

                        //附件下載處，刪除檔案
                        case "DeleteFiles":
                            {
                                try
                                {
                                    //傳入參數
                                    string sfileSeq = Utils.StrEmpty(context.Request["fileSeq"]);
                                    string sLeaveSeq = Utils.StrEmpty(context.Request["leaveSeq"]);
                                    string sFileName = Utils.StrEmpty(context.Request["fileName"]);
                                    string sNewUploadFiles=Utils.StrEmpty(context.Request["newUploadFiles"]);
                                    //String[] FILESEQ = sfileSeq.Split('_'); //1052100001_2016033_1.pdf→ 用"_"切，切割出 1052100001 及 2016033 及 1.pdf
                                    //String[] NUM = FILESEQ[2].Split('.');  //再把1.pdf→用"."切，切割出1及pdf

                                    sNewUploadFiles = sNewUploadFiles.Replace("?" + sFileName, "");
                                    //已經產生請假單的才要更新資料庫
                                    if(sLeaveSeq!="")
                                    {
                                        OraDB.DeleteCommand = @" DELETE FROM COMMON.EDU_UPLOADFILES T 
                                                                 WHERE T.FUNCTION_NAME = 'A03C01' 
                                                                       AND T.FUNCTION_KEY = :FUNCTION_KEY 
                                                                       AND T.FILE_SEQ = :FILESEQ ";
                                        OraDB.DeleteParameters.Add("FUNCTION_KEY", sLeaveSeq);  //假單編號。FILESEQ[1] = 2016033
                                        OraDB.DeleteParameters.Add("FILESEQ",sfileSeq);  //檔案流水號。NUM[0] = 1
                                        OraDB.Delete();  // 將資料庫中此檔案資料刪除
                                    }
                                    //該筆檔案路徑
                                    string FileName = HttpContext.Current.Server.MapPath("../UploadFiles/EDU_A03C01/" + sFileName);
                                    File.Delete(FileName);  // 將該檔案刪除

                                    OraDB.transaction.Commit();

                                    GetBaseCode gbc = new GetBaseCode();
                                    listResult = gbc.getUploadFiles("A03C01", sLeaveSeq, OraDB);
                                    if (listResult.Count>0)
                                        dicResult.Add("DATA", listResult);
                                    else
                                        dicResult.Add("DATA", "");

                                    dicResult.Add("FILENAME", sNewUploadFiles);
                                    dicResult.Add("SRESULT", "TRUE");
                                    dicResult.Add("SMESSAGE", "刪除成功");
                                }
                                catch (Exception e)
                                {
                                    OraDB.transaction.Rollback();
                                    dicResult.Add("SRESULT", "FALSE");
                                    dicResult.Add("SMESSAGE", "刪除失敗");
                                }
                                break;
                            }

                        // 判斷附件檔案是否存在
                        case "FileCheck":
                            {
                                try
                                {
                                    //該筆假單編號
                                    string sLeaveSeq = Utils.StrEmpty(context.Request["dataID"]);
                                    string sstudentID = Utils.StrEmpty(context.Request["studentID"]);
                                    GetBaseCode gbc = new GetBaseCode();
                                    listResult = gbc.getUploadFiles("A03C01", sLeaveSeq, OraDB);
                                    dicResult.Add("DATA", listResult);

                                    if (listResult.Count==0)
                                        dicResult.Add("FILECHECK", "FALSE");  //no files
                                    else
                                        dicResult.Add("FILECHECK", "TRUE");

                                    /*
                                    OraDB.SelectCommand = @" SELECT MAX(CAST(T.FILE_SEQ AS int)) AS MAXFILE_SEQ, 
                                                             MIN(CAST(T.FILE_SEQ AS int)) AS MINFILE_SEQ , 
                                                             COUNT(*) AS TOTAL_NUM  
                                                             FROM COMMON.EDU_UPLOADFILES T 
                                                             WHERE T.FUNCTION_KEY = :dataID ";
                                    OraDB.SelectParameters.Add("dataID", sdataID);  //定義判斷用的變數為傳過來的string
                                    DataTable dtData = OraDB.Select();
                                    foreach (DataRow dr in dtData.Rows)
                                    {
                                        var Max = dr["MAXFILE_SEQ"].ToString();
                                        var Min = dr["MINFILE_SEQ"].ToString();
                                        var Num = dr["TOTAL_NUM"].ToString();  // 計算該筆假單所含的附件檔總數

                                        if (Int32.Parse(Num) > 0)
                                        {
                                            dicResult.Add("FILECHECK", "TRUE");  //回傳TRUE

                                            string existfiles ="";  // 設一個字串，用以串起資料庫中該假單編號所含的所有檔案
                                            string originfilenames ="";
                                            for (var i = Int32.Parse(Min); i <= Int32.Parse(Max); i++)
                                            {
                                                // 查詢檔案所對應的原始檔名
                                                //      sbSQL.Append("AND T.FILENAME_RENAME = :filename ");
                                                //      OraDB.SelectCommand = sbSQL.ToString();

                                                OraDB.SelectCommand = @"SELECT * FROM COMMON.EDU_UPLOADFILES T 
                                                                        WHERE T.FUNCTION_KEY = :dataID AND T.FILENAME_RENAME = :filename";
                                                OraDB.SelectParameters.Add("dataID", sdataID);  //定義判斷用的變數為傳過來的string
                                                OraDB.SelectParameters.Add("filename", sstudentID + "_" + sdataID + "_"+ i +".pdf");
                                                DataTable fnameorigin = OraDB.Select();

                                                foreach (DataRow fdr in fnameorigin.Rows)
                                                {
                                                    // 找出原始檔名
                                                    var orifilename = fdr["FILENAME_ORIGIN"].ToString();

                                                    string path = HttpContext.Current.Server.MapPath("../UploadFiles/EDU_A03C01/" + sstudentID + "_" + sdataID + "_"+ i +".pdf");
                                                    string filename = sstudentID + "_" + sdataID + "_" + i +".pdf";

                                                    if (File.Exists(path))  //若該檔存在
                                                    {
                                                        //將重先命名過後的檔名串起來
                                                        existfiles = existfiles + "," + filename;
                                                        //將原始檔名串起來
                                                        originfilenames = originfilenames + "," + orifilename;
                                                    }
                                                    else { } //若不存在
                                                }
                                            }
                                            dicResult.Add("EXISTFILES", existfiles);  //回傳重新命名之檔名
                                            dicResult.Add("ORIGINFILENAMES", originfilenames);  //回傳原始檔名
                                        }
                                        else  //若不存在
                                        {
                                            dicResult.Add("FILECHECK", "FALSE");  //回傳FALSE
                                        }
                                    }
                                    */
                                }
                                catch (Exception e)
                                {
                                    dicResult.Add("SRESULT", "FALSE");
                                    dicResult.Add("SMESSAGE", "搜尋失敗");
                                }
                                break;
                            }

                        //下載 產生PDF
                        case "CreatePDF":
                            {

                                // 資料庫
                                StringBuilder sPDF = new StringBuilder();
                                string sdataID = Utils.StrEmpty(context.Request["dataID"]); //context.Request[""] 接參數    


                                OraDB.SelectCommand = @" 
                                        SELECT T.*,
                                               T1.*,
                                               TO_CHAR(TO_DATE(T.LEAVE_APPLY_DATE,'YYYY/MM/DD HH24:MI:SS'),'YYYY/MM/DD HH24:MI:SS') LEAVE_APPLY_DATEF,
                                               TO_CHAR(TO_DATE(T.LEAVE_SDTTM,'YYYY/MM/DD HH24:MI'),'YYYY/MM/DD HH24:MI') LEAVE_SDTTMF,
                                               TO_CHAR(TO_DATE(T.LEAVE_EDTTM,'YYYY/MM/DD HH24:MI'),'YYYY/MM/DD HH24:MI') LEAVE_EDTTMF,
                                               T5.SCHOOL_DEPT AS AGENT_SCHOOL_DEPT,
                                               T6.HISSYSCODENM AS AGENT_SCHOOL_NAME,
                                               T2.HISSYSCODENM AS LEAVE_TYPEC,
                                               T3.HISSYSCODENM AS SCHOOL_NAME,
                                               T4.NAME AS INTERNSHIP_DEPTC
                                          FROM COMMON.EDU_INTERN_LEAVES T
                                         INNER JOIN COMMON.EDU_INTERN_BASIC T1 ON T.INTERN_STUDENT_ID =
                                                                                  T1.INTERN_STUDENT_ID
                                          LEFT JOIN COMMON.EDU_INTERN_BASIC T5 ON T.AGENT_CARDNO = T5.PROCID
                                          LEFT JOIN COMMON.EDEPT_VGHTC T4 ON T.INTERNSHIP_DEPT = T4.DEPTNO
                                         INNER JOIN OPDUSR.BASCODE T2 ON T.LEAVE_TYPE = T2.HISSYSCODE
                                                                     AND T2.SYSTEMID = 'EDUPRJ'
                                                                     AND T2.SYSCODETYPE = '12'
                                         INNER JOIN OPDUSR.BASCODE T3 ON T1.SCHOOL_ID = T3.HISSYSCODE
                                                                     AND T3.SYSTEMID = 'EDUPRJ'
                                                                     AND T3.SYSCODETYPE = '01'
                                          LEFT JOIN OPDUSR.BASCODE T6 ON T5.SCHOOL_ID = T6.HISSYSCODE
                                                                     AND T6.SYSTEMID = 'EDUPRJ'
                                                                     AND T6.SYSCODETYPE = '01'
                                         WHERE T.LEAVE_SEQ =  :dataID ";

                                OraDB.SelectParameters.Add("dataID", sdataID);  //定義判斷用的變數為傳過來的string
                                DataTable dtData = OraDB.Select();

                                // 開始列印
                                C1WebReport C1WebReport = new C1WebReport();
                                C1WebReport.ReportSource.ReportName = "EDUA03C01"; //報表名稱
                                C1WebReport.ReportSource.FileName = HttpContext.Current.Server.MapPath(string.Format("../Reports/EDUA03C01.xml")); //報表檔名

                                foreach (DataRow dr in dtData.Rows)
                                {
                                    //assign field value
                                    //Row1
                                    C1WebReport.Report.Fields["Field82"].Value = dr["INTERN_STUDENT_ID"].ToString(); //請假人卡號
                                    C1WebReport.Report.Fields["Field83"].Value = dr["SCHOOL_NAME"].ToString()+ "_" + dr["SCHOOL_DEPT"].ToString();  //請假人學校與科系
                                    C1WebReport.Report.Fields["Field84"].Value = dr["INTERN_NAMEC"].ToString();  //請假人姓名
                                    C1WebReport.Report.Fields["Field85"].Value = dr["AGENT_CARDNO"].ToString(); //代理人卡號
                                    C1WebReport.Report.Fields["Field86"].Value = dr["AGENT_SCHOOL_NAME"].ToString()+ "_" + dr["AGENT_SCHOOL_DEPT"].ToString();  //代理人學校與科系
                                                                                                                                                                //  C1WebReport.Report.Fields["Field87"].Value = dr[" "].ToString();  //代理人姓名 AGENT_NAME (親簽，留白)
                                    C1WebReport.Report.Fields["Field88"].Value = dr["AGENT_TEL"].ToString();  //代理人連絡電話
                                    C1WebReport.Report.Fields["Field89"].Value = dr["INTERNSHIP_DEPTC"].ToString();  //請假人實習單位
                                                                                                                     //Row2
                                    C1WebReport.Report.Fields["Field90"].Value = dr["LEAVE_TYPEC"].ToString();  //假別
                                    C1WebReport.Report.Fields["Field91"].Value = dr["LEAVE_REASON"].ToString();  //事由
                                                                                                                 //Row3
                                    C1WebReport.Report.Fields["Field92"].Value = dr["LEAVE_SDTTMF"].ToString() + "~" + dr["LEAVE_EDTTMF"].ToString()+string.Format("(共{0}天{1}小時)",dr["Leave_DAYS"].ToString(),dr["Leave_Hours"].ToString());  //請假時間
                                                                                                                                                                                                                                              //Row4 
                                                                                                                                                                                                                                              //  C1WebReport.Report.Fields["Field93"].Value = dr[" "].ToString();  //指導老師/總醫師以上老師 (親簽，留白)
                                                                                                                                                                                                                                              //  C1WebReport.Report.Fields["Field94"].Value = dr[" "].ToString();  //教學部醫學教學組        (親簽，留白)
                                                                                                                                                                                                                                              //  C1WebReport.Report.Fields["Field95"].Value = dr[" "].ToString();  //教學部主任              (親簽，留白)
                                                                                                                                                                                                                                              //  C1WebReport.Report.Fields["Field96"].Value = dr[" "].ToString();  //主任秘書                (親簽，留白)
                                                                                                                                                                                                                                              //Row5
                                    C1WebReport.Report.Fields["Field3"].Value = dr["LEAVE_APPLY_DATEF"].ToString(); //填寫日期
                                                                                                                    //Row6
                                    C1WebReport.Report.Fields["Field113"].Value = dr["LEAVE_APPLY_DATEF"].ToString(); //填寫日期
                                                                                                                      //Row7
                                    C1WebReport.Report.Fields["Field97"].Value = dr["INTERN_STUDENT_ID"].ToString(); //請假人卡號
                                    C1WebReport.Report.Fields["Field98"].Value = dr["SCHOOL_NAME"].ToString()+ "_" + dr["SCHOOL_DEPT"].ToString();  //請假人學校與科系
                                    C1WebReport.Report.Fields["Field99"].Value = dr["INTERN_NAMEC"].ToString();  //請假人姓名
                                    C1WebReport.Report.Fields["Field100"].Value = dr["AGENT_CARDNO"].ToString(); //代理人卡號
                                    C1WebReport.Report.Fields["Field101"].Value = dr["AGENT_SCHOOL_NAME"].ToString()+ "_" + dr["AGENT_SCHOOL_DEPT"].ToString();  //代理人學校與科系
                                                                                                                                                                 //  C1WebReport.Report.Fields["Field102"].Value = dr[" "].ToString();  //代理人姓名 AGENT_NAME (親簽，留白)
                                    C1WebReport.Report.Fields["Field103"].Value = dr["AGENT_TEL"].ToString();  //代理人連絡電話
                                    C1WebReport.Report.Fields["Field104"].Value = dr["INTERNSHIP_DEPTC"].ToString();  //請假人實習單位
                                                                                                                      //Row8
                                    C1WebReport.Report.Fields["Field105"].Value = dr["LEAVE_TYPEC"].ToString();  //假別
                                    C1WebReport.Report.Fields["Field106"].Value = dr["LEAVE_REASON"].ToString();  //事由
                                                                                                                  //Row9
                                    C1WebReport.Report.Fields["Field107"].Value = dr["LEAVE_SDTTMF"].ToString() + "~" + dr["LEAVE_EDTTMF"].ToString()+string.Format("(共{0}天{1}小時)",dr["Leave_DAYS"].ToString(),dr["Leave_Hours"].ToString());  //請假時間
                                }
                                //轉成pdf
                                C1WebReport.Report.RenderToFile(HttpContext.Current.Server.MapPath("../TempFiles/Sample_"+ sdataID +".pdf"), C1.C1Report.FileFormatEnum.PDFEmbedFonts);

                                dicResult.Add("SRESULT", "TRUE");
                                dicResult.Add("SMESSAGE", "下載成功，請允許彈出新視窗。");
                                dicResult.Add("SHOWPDF", "../TempFiles/Sample_"+ sdataID +".pdf");
                                break;
                            }
                    }
                }
                catch (Exception ex)
                {
                    string content = "操作者卡號：" + base.sUserID + @"<br/>
                                      操作者：" + base.sUserNM + @"<br/>
                                      錯誤例外訊息：" + ex.Message + @"<br/><br/>                                        
                                      錯誤SQL：" + OraDB.SQL + @"<br/>                                       
                                      錯誤SQL訊息：" + OraDB.Message + @"<br/>";
                    //Utility ut = new Utility();
                    //ut.SendMail("cc4f@vghtc.gov.tw", "cc4f@vghtc.gov.tw", "程式錯誤_" + base.sSystemID + "_" + base.ProgramID, content);
                    ErrorLogger ErrLog = new ErrorLogger(base.ProgramID, OraDB.SQL, OraDB.Message);
                    dicResult.Add("SRESULT", "FALSE");
                    dicResult.Add("SMESSAGE", ex.Message);
                }
            }
        }
        else
        {
            dicResult.Add("SRESULT", "BREAK");
            dicResult.Add("SMESSAGE", "連線逾時，請重新操作！");
            dicResult.Add("DATA", "");
        }
        // 序列化dicResult
        string strJSON = js.Serialize(dicResult);
        context.Response.Write(strJSON);
        context.Response.End();
    }
}