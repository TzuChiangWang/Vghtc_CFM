/*
SW_CFM_A02_C01

Description : 實習生建檔
Create By : 菜菜
Create Date : 20150710
*/

<%@ WebHandler Language="C#" Class="WS_CFM_A02_C01" %>

using System;
using System.Web;
using System.Data;
using System.Text;
using System.Web.SessionState;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using dmxUtils;
using dmxUserInterface;
using dmxDataAccess;

public class WS_CFM_A02_C01 : uiAshxCommon
{
    public override void ProcessRequest(HttpContext context)
    {
        base.ProgramID = "A02C01";
        base.ProcessRequest(context);
        // 設定回傳頁面型態
        context.Response.ContentType = "application/json";
        WebParamaters WPS = new WebParamaters();
        JavaScriptSerializer js = new JavaScriptSerializer() { MaxJsonLength = Int32.MaxValue };
        // 設定回傳資料集
        Dictionary<string, object> dicResult = new Dictionary<string, object>();
        List<object> listResult = new List<object>();
        StringBuilder sbSQL = new StringBuilder();
        string sFCode = WPS.getKeys("FCode");

        //判斷登入連線session是否存在
        if (base.sUserID != "" && base.sUserNM != "")
        {
            using (OracleDataSource OraDB = new OracleDataSource("VGHTC.EDU.ConnStr"))
            {
                try
                {
                    switch (sFCode)
                    {
                        //case "C":
                        //    {
                        //        var models = js.Deserialize<JSONClass.JSON_CFM_A02_C01>(WPS.getKeys("models"));
                        //        OraDB.InsertCommand = @"
                        //        INSERT INTO COMMON.EDU_INTERN_BASIC
                        //          (INTERN_STUDENT_ID, TITLE_ID, SCHOOL_ID, STUDENT_ID, SCHOOL_DEPT, SCHOOL_SYSTEM, SCHOOL_GRADE,
                        //           INTERN_NAMEC, INTERN_NAME, NIDNO, SEX, BIRTHDAY, PRACTICE_ITEMS, INTERN_HOURS,
                        //           ADDRESS, EMAIL, INTERNSHIP_DEPT, PRIVATE_PHONE, CHECK_IN_DATE, CARDNO,
                        //           CHECK_OUT_DATE, INTERN_DAYS, EMERGENCY_CONTACT, EMERGENCY_PHONE, EMERGENCY_RELATIONSHIP,
                        //           MEMORY, PROCDATETIME, PROCID, PROCNMC, CREATEDATETIME, CREATEID, CREATENMC)
                        //        VALUES
                        //          (:INTERN_STUDENT_ID, :TITLE_ID, :SCHOOL_ID, :STUDENT_ID, :SCHOOL_DEPT, :SCHOOL_SYSTEM, :SCHOOL_GRADE,
                        //           :INTERN_NAMEC, :INTERN_NAME, :NIDNO, :SEX, :BIRTHDAY, :PRACTICE_ITEMS, :INTERN_HOURS,
                        //           :ADDRESS, :EMAIL, :INTERNSHIP_DEPT, :PRIVATE_PHONE, :CHECK_IN_DATE, :CARDNO,
                        //           :CHECK_OUT_DATE, :INTERN_DAYS, :EMERGENCY_CONTACT, :EMERGENCY_PHONE, :EMERGENCY_RELATIONSHIP,
                        //           :MEMORY, TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'), :PROCID, :PROCNMC, TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'), :CREATEID, :CREATENMC) ";

                        //        //取號
                        //        Utility ut = new Utility();
                        //        string prefix;
                        //        if (DateTime.Now.Month > 5)
                        //            prefix = (DateTime.Now.Year - 1911).ToString() + models.TITLE_ID;  //6月起新的學年度+職類
                        //        else
                        //            prefix = (DateTime.Now.Year - 1912).ToString() + models.TITLE_ID;  //6月前舊的學年度+職類
                        //        models.INTERN_STUDENT_ID = ut.GetSeqNo(prefix, "EDU_INTERN_BASIC", "INTERN_STUDENT_ID", 0, 5, OraDB);


                        //        OraDB.InsertParameters.Add("INTERN_STUDENT_ID", models.INTERN_STUDENT_ID);
                        //        OraDB.InsertParameters.Add("TITLE_ID", models.TITLE_ID);
                        //        OraDB.InsertParameters.Add("SCHOOL_ID", models.SCHOOL_ID);
                        //        OraDB.InsertParameters.Add("STUDENT_ID", models.STUDENT_ID);
                        //        OraDB.InsertParameters.Add("SCHOOL_DEPT", models.SCHOOL_DEPT);
                        //        OraDB.InsertParameters.Add("SCHOOL_SYSTEM", models.SCHOOL_SYSTEM);
                        //        OraDB.InsertParameters.Add("SCHOOL_GRADE", models.SCHOOL_GRADE);
                        //        OraDB.InsertParameters.Add("INTERN_NAMEC", models.INTERN_NAMEC);
                        //        OraDB.InsertParameters.Add("INTERN_NAME", models.INTERN_NAME);
                        //        OraDB.InsertParameters.Add("NIDNO", models.NIDNO);
                        //        OraDB.InsertParameters.Add("SEX", models.SEX);
                        //        OraDB.InsertParameters.Add("BIRTHDAY", models.BIRTHDAY.Replace("/", ""));
                        //        OraDB.InsertParameters.Add("ADDRESS", models.ADDRESS);
                        //        OraDB.InsertParameters.Add("EMAIL", models.EMAIL);
                        //        OraDB.InsertParameters.Add("INTERNSHIP_DEPT", models.INTERNSHIP_DEPT);
                        //        OraDB.InsertParameters.Add("PRIVATE_PHONE", models.PRIVATE_PHONE);
                        //        OraDB.InsertParameters.Add("CHECK_IN_DATE", models.CHECK_IN_DATE.Replace("/", ""));
                        //        OraDB.InsertParameters.Add("CHECK_OUT_DATE", models.CHECK_OUT_DATE.Replace("/", ""));
                        //        OraDB.InsertParameters.Add("INTERN_DAYS", models.INTERN_DAYS);
                        //        OraDB.InsertParameters.Add("INTERN_HOURS", models.INTERN_HOURS);
                        //        OraDB.InsertParameters.Add("PRACTICE_ITEMS", models.PRACTICE_ITEMS);
                        //        OraDB.InsertParameters.Add("EMERGENCY_CONTACT", models.EMERGENCY_CONTACT);
                        //        OraDB.InsertParameters.Add("EMERGENCY_PHONE", models.EMERGENCY_PHONE);
                        //        OraDB.InsertParameters.Add("EMERGENCY_RELATIONSHIP", models.EMERGENCY_RELATIONSHIP);
                        //        OraDB.InsertParameters.Add("MEMORY", models.MEMORY);
                        //        OraDB.InsertParameters.Add("PROCID", base.sUserID);
                        //        OraDB.InsertParameters.Add("PROCNMC", base.sUserNM);
                        //        OraDB.InsertParameters.Add("CREATEID", base.sUserID);
                        //        OraDB.InsertParameters.Add("CREATENMC", base.sUserNM);
                        //        OraDB.InsertParameters.Add("CARDNO", models.CARDNO);

                        //        OraDB.Insert();
                        //        dicResult.Add("SRESULT", "TRUE");
                        //        dicResult.Add("SMESSAGE", "新增成功");
                        //        break;
                        //    }
                        case "R":
                            {
                                StringBuilder sOrderBy = new StringBuilder();
                                StringBuilder sQuery = new StringBuilder();
                                string sNIDNO = Utils.StrEmpty(context.Request["NIDNO"]);
                                string sINTERN_NAMEC = Utils.StrEmpty(context.Request["INTERN_NAMEC"]);
                                string sSCHOOL_ID = Utils.StrEmpty(context.Request["SCHOOL_ID"]);
                                string sTITLE_ID = Utils.StrEmpty(context.Request["TITLE_ID"]);
                                string sINTERNSHIP_DEPT_I = Utils.StrEmpty(context.Request["INTERNSHIP_DEPT_I"]);
                                string sINTERNSHIP_DEPT_II = Utils.StrEmpty(context.Request["INTERNSHIP_DEPT_II"]);
                                var models = js.Deserialize<JSONClass.JSON_EDU_PAGE>(WPS.getKeys("models"));

                                //欄位名稱轉換成DB名稱
                                Dictionary<string, string> dicMap = new Dictionary<string, string>();
                                //dicMap.Add("SCHOOL_ID", "HISSYSCODE");
                                dicMap.Add("SCHOOL_NAME", "T1.HISSYSCODENM");
                                dicMap.Add("TITLE_NAME", "T2.HISSYSCODENM");

                                #region 根據排序傳入的排序 給定row number
                                if (models.SORT == null)
                                {
                                    sOrderBy.Append("INTERN_STUDENT_ID ASC");  //default sort
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
                                          FROM COMMON.EDU_INTERN_BASIC T 
                                         INNER JOIN OPDUSR.BASCODE T1 ON T.SCHOOL_ID = T1.HISSYSCODE 
                                                                     AND T1.SYSTEMID = 'EDUPRJ'
                                                                     AND T1.SYSCODETYPE = '01'
                                         INNER JOIN OPDUSR.BASCODE T2 ON T.TITLE_ID = T2.HISSYSCODE 
                                                                     AND T2.SYSTEMID = 'EDUPRJ'
                                                                     AND T2.SYSCODETYPE = '02' 
                                         WHERE 1=1 ");
                                if (!sNIDNO.Equals(""))
                                {
                                    sQuery.Append("AND T.NIDNO = :NIDNO ");
                                    OraDB.SelectParameters.Add("NIDNO", sNIDNO);
                                }
                                if (!sINTERN_NAMEC.Equals(""))
                                {
                                    sQuery.Append("AND T.INTERN_NAMEC = :INTERN_NAMEC ");
                                    OraDB.SelectParameters.Add("INTERN_NAMEC", sINTERN_NAMEC);
                                }
                                if (!sSCHOOL_ID.Equals(""))
                                {
                                    sQuery.Append("AND T.SCHOOL_ID = :SCHOOL_ID ");
                                    OraDB.SelectParameters.Add("SCHOOL_ID", sSCHOOL_ID);
                                }
                                if (!sTITLE_ID.Equals(""))
                                {
                                    sQuery.Append("AND T.TITLE_ID = :TITLE_ID ");
                                    OraDB.SelectParameters.Add("TITLE_ID", sTITLE_ID);
                                }
                                if (!sINTERNSHIP_DEPT_II.Equals(""))
                                {
                                    sQuery.Append("AND T.INTERNSHIP_DEPT = :INTERNSHIP_DEPT ");
                                    OraDB.SelectParameters.Add("INTERNSHIP_DEPT", sINTERNSHIP_DEPT_II);
                                }
                                else if (!sINTERNSHIP_DEPT_I.Equals(""))
                                {
                                    sQuery.Append("AND T.INTERNSHIP_DEPT = :INTERNSHIP_DEPT ");
                                    OraDB.SelectParameters.Add("INTERNSHIP_DEPT", sINTERNSHIP_DEPT_I);
                                }
                                #endregion

                                #region 組SQL
                                sbSQL.AppendFormat(@"
                                SELECT *
                                  FROM (SELECT ROW_NUMBER() OVER(ORDER BY {0}) AS RNUM,
                                               INTERN_STUDENT_ID,
                                               TITLE_ID,
                                               T1.HISSYSCODENM SCHOOL_NAME,                                               
                                               SCHOOL_ID,
                                               T2.HISSYSCODENM TITLE_NAME,                                          
                                               STUDENT_ID,
                                               SCHOOL_DEPT,
                                               SCHOOL_SYSTEM,
                                               SCHOOL_GRADE,
                                               INTERN_NAMEC,
                                               INTERN_NAME,
                                               NIDNO,
                                               SEX,
                                               NVL2(BIRTHDAY,TO_CHAR(TO_DATE(BIRTHDAY, 'YYYYMMDD'),'YYYY/MM/DD'),'') BIRTHDAY,
                                               ADDRESS,
                                               EMAIL,
                                               CARDNO,                                               
                                               INTERNSHIP_DEPT,
                                               PRIVATE_PHONE,
                                               TO_CHAR(TO_DATE(CHECK_IN_DATE, 'YYYYMMDD'),'YYYY/MM/DD') CHECK_IN_DATE,
                                               TO_CHAR(TO_DATE(CHECK_OUT_DATE, 'YYYYMMDD'),'YYYY/MM/DD') CHECK_OUT_DATE,
                                               INTERN_DAYS,
                                               INTERN_HOURS, 
                                               PRACTICE_ITEMS,                                              
                                               EMERGENCY_CONTACT,
                                               EMERGENCY_PHONE,
                                               EMERGENCY_RELATIONSHIP,
                                               MEMORY,
                                               TO_CHAR(TO_DATE(T.PROCDATETIME, 'YYYYMMDDHH24MISS'),
                                                       'YYYY/MM/DD HH24:MI') PROCDATETIME,
                                               T.PROCID,
                                               T.PROCNMC
                                {1}    ", sOrderBy.ToString().TrimEnd(','), sQuery.ToString());

                                sbSQL.Append(@") WHERE RNUM BETWEEN :skip + 1 AND :skip + :pagesize");

                                OraDB.SelectCommand = sbSQL.ToString();
                                OraDB.SelectParameters.Add("skip", models.SKIP);
                                OraDB.SelectParameters.Add("pagesize", models.PAGESIZE);
                                #endregion

                                DataTable dtData = OraDB.Select();
                                if (dtData.Rows.Count > 0)
                                {
                                    //GetBaseCode gbc = new GetBaseCode();
                                    foreach (DataRow dr in dtData.Rows)
                                    {
                                        listResult.Add(new JSONClass.JSON_CFM_A02_C01()
                                        {
                                            INTERN_STUDENT_ID = dr["INTERN_STUDENT_ID"].ToString(),
                                            TITLE_ID = dr["TITLE_ID"].ToString(),
                                            TITLE_NAME = dr["TITLE_NAME"].ToString(),
                                            SCHOOL_ID = dr["SCHOOL_ID"].ToString(),
                                            SCHOOL_NAME = dr["SCHOOL_NAME"].ToString(),
                                            STUDENT_ID = dr["STUDENT_ID"].ToString(),
                                            SCHOOL_DEPT = dr["SCHOOL_DEPT"].ToString(),
                                            SCHOOL_SYSTEM = dr["SCHOOL_SYSTEM"].ToString(),
                                            SCHOOL_GRADE = dr["SCHOOL_GRADE"].ToString(),
                                            INTERN_NAMEC = dr["INTERN_NAMEC"].ToString(),
                                            INTERN_NAME = dr["INTERN_NAME"].ToString(),
                                            NIDNO = dr["NIDNO"].ToString(),
                                            SEX = dr["SEX"].ToString(),
                                            BIRTHDAY = dr["BIRTHDAY"].ToString(),
                                            ADDRESS = dr["ADDRESS"].ToString(),
                                            EMAIL = dr["EMAIL"].ToString(),
                                            INTERNSHIP_DEPT_P = "INTERNSHIP_DEPT_P",
                                            //INTERNSHIP_DEPT_P = gbc.getGetDeptII(dr["INTERNSHIP_DEPT"].ToString()).Count > 0 ?
                                            //                    ((JSONClass.JSON_EDU_BASCODE_3)(gbc.getGetDeptII(dr["INTERNSHIP_DEPT"].ToString())[0])).HISSYSCODE : dr["INTERNSHIP_DEPT"].ToString(),
                                            INTERNSHIP_DEPT = dr["INTERNSHIP_DEPT"].ToString(),
                                            PRIVATE_PHONE = dr["PRIVATE_PHONE"].ToString(),
                                            CHECK_IN_DATE = dr["CHECK_IN_DATE"].ToString(),
                                            CHECK_OUT_DATE = dr["CHECK_OUT_DATE"].ToString(),
                                            INTERN_DAYS = dr["INTERN_DAYS"].ToString(),
                                            EMERGENCY_CONTACT = dr["EMERGENCY_CONTACT"].ToString(),
                                            EMERGENCY_PHONE = dr["EMERGENCY_PHONE"].ToString(),
                                            EMERGENCY_RELATIONSHIP = dr["EMERGENCY_RELATIONSHIP"].ToString(),
                                            MEMORY = dr["MEMORY"].ToString(),
                                            PROCDATETIME = dr["PROCDATETIME"].ToString(),
                                            PROCID = dr["PROCID"].ToString(),
                                            PROCNMC = dr["PROCNMC"].ToString(),
                                            INTERN_HOURS = dr["INTERN_HOURS"].ToString(),
                                            PRACTICE_ITEMS = dr["PRACTICE_ITEMS"].ToString(),
                                            CARDNO = dr["CARDNO"].ToString()
                                        });
                                    }

                                    //取得總筆數
                                    OraDB.SelectCommand = string.Format("SELECT COUNT(*) {0} ", sQuery);
                                    if (!sNIDNO.Equals(""))
                                        OraDB.SelectParameters.Add("NIDNO", sNIDNO);
                                    if (!sINTERN_NAMEC.Equals(""))
                                        OraDB.SelectParameters.Add("INTERN_NAMEC", sINTERN_NAMEC);
                                    if (!sSCHOOL_ID.Equals(""))
                                        OraDB.SelectParameters.Add("SCHOOL_ID", sSCHOOL_ID);
                                    if (!sTITLE_ID.Equals(""))
                                        OraDB.SelectParameters.Add("TITLE_ID", sTITLE_ID);
                                    if (!sINTERNSHIP_DEPT_II.Equals(""))
                                        OraDB.SelectParameters.Add("INTERNSHIP_DEPT", sINTERNSHIP_DEPT_II);
                                    else if (!sINTERNSHIP_DEPT_I.Equals(""))
                                        OraDB.SelectParameters.Add("INTERNSHIP_DEPT", sINTERNSHIP_DEPT_I);

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
                            //case "U":
                            //    {
                            //        var models = js.Deserialize<JSONClass.JSON_CFM_A02_C01>(WPS.getKeys("models"));
                            //        OraDB.UpdateCommand = @"
                            //        UPDATE COMMON.EDU_INTERN_BASIC
                            //           SET TITLE_ID               = :TITLE_ID,
                            //               SCHOOL_ID              = :SCHOOL_ID,
                            //               STUDENT_ID             = :STUDENT_ID,
                            //               SCHOOL_DEPT            = :SCHOOL_DEPT,
                            //               SCHOOL_SYSTEM          = :SCHOOL_SYSTEM,
                            //               SCHOOL_GRADE           = :SCHOOL_GRADE,
                            //               INTERN_NAMEC           = :INTERN_NAMEC,
                            //               INTERN_NAME            = :INTERN_NAME,
                            //               NIDNO                  = :NIDNO,
                            //               SEX                    = :SEX,
                            //               BIRTHDAY               = :BIRTHDAY,
                            //               ADDRESS                = :ADDRESS,
                            //               EMAIL                  = :EMAIL,
                            //               CARDNO                 = :CARDNO,                                       
                            //               INTERNSHIP_DEPT        = :INTERNSHIP_DEPT,
                            //               PRIVATE_PHONE          = :PRIVATE_PHONE,
                            //               CHECK_IN_DATE          = :CHECK_IN_DATE,
                            //               CHECK_OUT_DATE         = :CHECK_OUT_DATE,
                            //               INTERN_DAYS            = :INTERN_DAYS,
                            //               INTERN_HOURS           = :INTERN_HOURS,
                            //               PRACTICE_ITEMS         = :PRACTICE_ITEMS,                                                                              
                            //               EMERGENCY_CONTACT      = :EMERGENCY_CONTACT,
                            //               EMERGENCY_PHONE        = :EMERGENCY_PHONE,
                            //               EMERGENCY_RELATIONSHIP = :EMERGENCY_RELATIONSHIP,
                            //               MEMORY                 = :MEMORY,
                            //               PROCID                 = :PROCID,
                            //               PROCNMC                = :PROCNMC,                                      
                            //               PROCDATETIME           = TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')                                       
                            //         WHERE INTERN_STUDENT_ID = :INTERN_STUDENT_ID ";

                            //        models.INTERNSHIP_DEPT = models.INTERNSHIP_DEPT == "" ? models.INTERNSHIP_DEPT_P : models.INTERNSHIP_DEPT;

                            //        OraDB.UpdateParameters.Add("TITLE_ID", models.TITLE_ID);
                            //        OraDB.UpdateParameters.Add("SCHOOL_ID", models.SCHOOL_ID);
                            //        OraDB.UpdateParameters.Add("STUDENT_ID", models.STUDENT_ID);
                            //        OraDB.UpdateParameters.Add("SCHOOL_DEPT", models.SCHOOL_DEPT);
                            //        OraDB.UpdateParameters.Add("SCHOOL_SYSTEM", models.SCHOOL_SYSTEM);
                            //        OraDB.UpdateParameters.Add("SCHOOL_GRADE", models.SCHOOL_GRADE);
                            //        OraDB.UpdateParameters.Add("INTERN_NAMEC", models.INTERN_NAMEC);
                            //        OraDB.UpdateParameters.Add("INTERN_NAME", models.INTERN_NAME);
                            //        OraDB.UpdateParameters.Add("NIDNO", models.NIDNO);
                            //        OraDB.UpdateParameters.Add("SEX", models.SEX);
                            //        OraDB.UpdateParameters.Add("BIRTHDAY", models.BIRTHDAY.Replace("/", ""));
                            //        OraDB.UpdateParameters.Add("ADDRESS", models.ADDRESS);
                            //        OraDB.UpdateParameters.Add("EMAIL", models.EMAIL);
                            //        OraDB.UpdateParameters.Add("CARDNO", models.CARDNO);
                            //        OraDB.UpdateParameters.Add("INTERNSHIP_DEPT", models.INTERNSHIP_DEPT);
                            //        OraDB.UpdateParameters.Add("PRIVATE_PHONE", models.PRIVATE_PHONE);
                            //        OraDB.UpdateParameters.Add("CHECK_IN_DATE", models.CHECK_IN_DATE.Replace("/", ""));
                            //        OraDB.UpdateParameters.Add("CHECK_OUT_DATE", models.CHECK_OUT_DATE.Replace("/", ""));
                            //        OraDB.UpdateParameters.Add("INTERN_DAYS", models.INTERN_DAYS);
                            //        OraDB.UpdateParameters.Add("INTERN_HOURS", models.INTERN_HOURS);
                            //        OraDB.UpdateParameters.Add("PRACTICE_ITEMS", models.PRACTICE_ITEMS);
                            //        OraDB.UpdateParameters.Add("EMERGENCY_CONTACT", models.EMERGENCY_CONTACT);
                            //        OraDB.UpdateParameters.Add("EMERGENCY_PHONE", models.EMERGENCY_PHONE);
                            //        OraDB.UpdateParameters.Add("EMERGENCY_RELATIONSHIP", models.EMERGENCY_RELATIONSHIP);
                            //        OraDB.UpdateParameters.Add("MEMORY", models.MEMORY);
                            //        OraDB.UpdateParameters.Add("PROCID", base.sUserID);
                            //        OraDB.UpdateParameters.Add("PROCNMC", base.sUserNM);
                            //        OraDB.UpdateParameters.Add("INTERN_STUDENT_ID", models.INTERN_STUDENT_ID);

                            //        OraDB.Update();
                            //        dicResult.Add("SRESULT", "TRUE");
                            //        dicResult.Add("SMESSAGE", "更新成功");
                            //        break;
                            //    }
                            //case "D":
                            //    {
                            //        var models = js.Deserialize<JSONClass.JSON_CFM_A02_C01>(WPS.getKeys("models"));

                            //        OraDB.DeleteCommand = @"
                            //            DELETE FROM COMMON.EDU_INTERN_BASIC WHERE INTERN_STUDENT_ID = :INTERN_STUDENT_ID ";
                            //        OraDB.DeleteParameters.Add("INTERN_STUDENT_ID", models.INTERN_STUDENT_ID);

                            //        OraDB.Delete();
                            //        dicResult.Add("SRESULT", "TRUE");
                            //        dicResult.Add("SMESSAGE", "刪除成功");
                            //        break;
                            //    }
                            //case "SchoolList":
                            //    {
                            //        GetBaseCode gbc = new GetBaseCode();
                            //        listResult = gbc.getSchoolList();
                            //        dicResult.Add("SRESULT", "TRUE");
                            //        dicResult.Add("SMESSAGE", "");
                            //        dicResult.Add("DATA", listResult);
                            //        break;
                            //    }
                            //case "TitleList":
                            //    {
                            //        GetBaseCode gbc = new GetBaseCode();
                            //        listResult = gbc.getTitleList();
                            //        dicResult.Add("SRESULT", "TRUE");
                            //        dicResult.Add("SMESSAGE", "");
                            //        dicResult.Add("DATA", listResult);
                            //        break;
                            //    }
                            //case "EmergencyRelationship":
                            //    {
                            //        GetBaseCode gbc = new GetBaseCode();
                            //        listResult = gbc.getEmergyRelationshipList();
                            //        dicResult.Add("SRESULT", "TRUE");
                            //        dicResult.Add("SMESSAGE", "");
                            //        dicResult.Add("DATA", listResult);
                            //        break;
                            //    }
                            //case "GetDeptI":
                            //    {
                            //        GetBaseCode gbc = new GetBaseCode();
                            //        listResult = gbc.getGetDeptI();
                            //        dicResult.Add("SRESULT", "TRUE");
                            //        dicResult.Add("SMESSAGE", "");
                            //        dicResult.Add("DATA", listResult);
                            //        break;
                            //    }
                            //case "GetDeptII":
                            //    {
                            //        GetBaseCode gbc = new GetBaseCode();
                            //        listResult = gbc.getGetDeptII("");
                            //        dicResult.Add("SRESULT", "TRUE");
                            //        dicResult.Add("SMESSAGE", "");
                            //        dicResult.Add("DATA", listResult);
                            //        break;
                            //    }
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