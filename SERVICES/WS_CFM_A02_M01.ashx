<%@ WebHandler Language="C#" Class="WS_CFM_A02_M01" %>

/*code is far away from bug with the animal protecting
    *  ┏┓　　　┏┓
    *┏┛┻━━━┛━━┻┓
    *┃　　　　　　　┃ 　
    *┃　　　━━　　　┃
    *┃　┳┛　┗┳　┃
    *┃　　　　　　　┃
    *┃　　　┻　　　┃
    *┃　　　　　　　┃
    *┗━ ┓　　　┏━┛
    *　　┃　　　┃神獸保佑
    *　　┃　　　┃程式永無BUG！
    *　　┃　　　┗━━━━━┓
    *　　┃　　　　　　　┣┓
    *　　┃　　　　　　　┏┛
    *　　┗┓┓┏━━┳┓┏┛
    *　　　┃┫┫　┃┫┫
    *　　　┗┻┛　┗┻┛ 
    *
    *Program ID  : WS_CFM_A02_M01
    *Description : 狀態代碼維護
    *Create By   : Tzu-Chiang, Wang
    *Create Date : 20170324　　　
    */

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

public class WS_CFM_A02_M01 : uiAshxCommon
{

    public override void ProcessRequest(HttpContext context)
    {
        base.ProgramID = "A02M01";
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
                        case "C":
                            {
                                var models = js.Deserialize<JSONClass.JSON_CFM_A02_M01>(WPS.getKeys("models"));
                                OraDB.InsertCommand = @"
                                INSERT INTO MGT.MGTCODE(
                                    SYSTEMID,       SYSCODETYPE,
                                    MGTSYSCODE,     MGTSYSCODENM,   MGTSYSCODENME,
                                    DISPLAYSORT,    MGTCODEMEMO,    CANCELYN,
                                    CANCELDATETIME, CANCELID,       CANCELNMC,
                                    PROCDATETIME,   PROCID,         PROCNMC,
                                    CREATEDATETIME, CREATEID,       CREATENMC)
                                VALUES(
                                    :SYSTEMID,      '01',
                                    :MGTSYSCODE,    :MGTSYSCODENM,  :MGTSYSCODENME,
                                    '9999',         'STATUS_CODE',  'N',
                                    '',             '',             '',
                                    :PROCDATETIME,  :PROCID,        :PROCNMC,
                                    :CREATEDATETIME,:CREATEID,      :CREATENMC)";

                                OraDB.InsertParameters.Add("SYSTEMID", base.sSystemID);
                                OraDB.InsertParameters.Add("MGTSYSCODE", models.APPLY_STATUS);
                                OraDB.InsertParameters.Add("MGTSYSCODENM", models.STATUS_DESCRIPTION);
                                OraDB.InsertParameters.Add("MGTSYSCODENME", models.STATUS_DESCRIPTION);
                                OraDB.InsertParameters.Add("PROCDATETIME", DateTime.Now.ToString("yyyyMMddHHmmss"));
                                OraDB.InsertParameters.Add("PROCID", base.sUserID);
                                OraDB.InsertParameters.Add("PROCNMC", base.sUserNM);
                                OraDB.InsertParameters.Add("CREATEDATETIME", DateTime.Now.ToString("yyyyMMddHHmmss"));
                                OraDB.InsertParameters.Add("CREATEID", base.sUserID);
                                OraDB.InsertParameters.Add("CREATENMC", base.sUserNM);

                                OraDB.Insert();
                                dicResult.Add("SRESULT", "TRUE");
                                dicResult.Add("SMESSAGE", "新增成功");
                                break;
                            }
                        case "R":
                            {
                                StringBuilder sOrderBy = new StringBuilder();
                                StringBuilder sQuery = new StringBuilder();
                                string sStatusId = Utils.StrEmpty(context.Request["StatusID"]);
                                var models = js.Deserialize<JSONClass.JSON_EDU_PAGE>(WPS.getKeys("models"));

                                //欄位名稱轉換成DB名稱
                                Dictionary<string, string> dicMap = new Dictionary<string, string>();
                                dicMap.Add("APPLY_STATUS", "MGTSYSCODE");
                                dicMap.Add("STATUS_DESCRIPTION", "MGTSYSCODENM");
                                dicMap.Add("LAST_EDIT_DTTM", "PROCDATETIME");
                                dicMap.Add("LAST_EDIT_USER_ID", "PROCID");
                                dicMap.Add("LAST_EDIT_USER_NAMEC", "PROCNMC");

                                #region 根據排序傳入的排序 給定row number
                                if (models.SORT == null)
                                {
                                    //default sort 
                                    sOrderBy.Append("MGTSYSCODE ASC");
                                }
                                else
                                {
                                    //sort by user selection
                                    foreach (var e in models.SORT)
                                    {
                                        if (dicMap.ContainsKey(e.field))
                                            e.field = dicMap[e.field];
                                        sOrderBy.Append(e.field + " " + e.dir + ",");
                                    }
                                }
                                #endregion

                                #region 查詢條件
                                sQuery.AppendFormat(@"
                                        FROM MGT.MGTCODE T
                                       WHERE T.SYSTEMID = '{0}'
                                         AND T.SYSCODETYPE = '01'
                                         AND T.CANCELYN = 'N'", base.sSystemID);
                                if (!sStatusId.Equals(""))
                                {
                                    sQuery.AppendFormat("AND T.APPLY_STATUS like '%{0}%'", sStatusId);
                                }
                                #endregion

                                #region 組SQL
                                sbSQL.AppendFormat(@"
                                     SELECT *
                                     FROM (SELECT ROW_NUMBER() OVER(ORDER BY {0}) AS RNUM,
                                           T.MGTSYSCODE,
                                           T.MGTSYSCODENM,
                                           TO_CHAR(TO_DATE(T.PROCDATETIME, 'YYYYMMDDHH24MISS'),
                                                       'YYYY/MM/DD HH24:MI') AS PROCDATETIME,
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
                                    foreach (DataRow dr in dtData.Rows)
                                    {
                                        listResult.Add(new JSONClass.JSON_CFM_A02_M01()
                                        {
                                            APPLY_STATUS         = dr["MGTSYSCODE"].ToString(),
                                            STATUS_DESCRIPTION   = dr["MGTSYSCODENM"].ToString(),
                                            LAST_EDIT_DTTM       = dr["PROCDATETIME"].ToString(),
                                            LAST_EDIT_USER_ID    = dr["PROCID"].ToString(),
                                            LAST_EDIT_USER_NAMEC = dr["PROCNMC"].ToString(),
                                        });
                                    }

                                    //取得總筆數
                                    OraDB.SelectCommand = string.Format("SELECT COUNT(*) {0} ", sQuery);
                                    dicResult.Add("TOTALCOUNT", OraDB.Select().Rows[0][0].ToString());

                                    dicResult.Add("SRESULT", "TRUE");
                                    dicResult.Add("SMESSAGE", "");
                                    dicResult.Add("DATA", listResult);
                                }
                                else
                                {
                                    dicResult.Add("SRESULT", "TRUE");
                                    dicResult.Add("SMESSAGE", "查無資料");
                                }
                                break;
                            }
                        case "U":
                            {
                                var models = js.Deserialize<JSONClass.JSON_CFM_A02_M01>(WPS.getKeys("models"));
                                OraDB.UpdateCommand = @"
                                UPDATE MGT.MGTCODE T
                                   SET 
                                       T.MGTSYSCODENM        = :MGTSYSCODENM,
                                       T.PROCDATETIME        = :PROCDATETIME,
                                       T.PROCID              = :PROCID,
                                       T.PROCNMC             = :PROCNMC
                                 WHERE T.SYSTEMID            = :SYSTEMID
                                   AND T.SYSCODETYPE         = '01' 
                                   AND T.MGTSYSCODE          = :MGTSYSCODE";

                                OraDB.UpdateParameters.Add("MGTSYSCODE", models.APPLY_STATUS);
                                OraDB.UpdateParameters.Add("PROCDATETIME", DateTime.Now.ToString("yyyyMMddHHmmss"));
                                OraDB.UpdateParameters.Add("PROCID", base.sUserID);
                                OraDB.UpdateParameters.Add("PROCNMC", base.sUserNM);
                                OraDB.UpdateParameters.Add("SYSTEMID", base.sSystemID);
                                OraDB.UpdateParameters.Add("MGTSYSCODENM", models.STATUS_DESCRIPTION);

                                OraDB.Update();
                                dicResult.Add("SRESULT", "TRUE");
                                dicResult.Add("SMESSAGE", "更新成功");
                                break;
                            }
                        case "D":
                            {
                                var models = js.Deserialize<JSONClass.JSON_CFM_A02_M01>(WPS.getKeys("models"));
                                
                                //不直接刪除, 改以修改CANCELYN以及記錄刪除時間
                                OraDB.UpdateCommand = @"
                                UPDATE MGT.MGTCODE T
                                   SET 
                                       T.CANCELYN            = 'Y',
                                       T.CANCELDATETIME      = :CANCELDATETIME,
                                       T.CANCELID            = :CANCELID,
                                       T.CANCELNMC           = :CANCELNMC,
                                       T.PROCDATETIME        = :PROCDATETIME,
                                       T.PROCID              = :PROCID,
                                       T.PROCNMC             = :PROCNMC
                                 WHERE T.SYSTEMID            = :SYSTEMID
                                   AND T.SYSCODETYPE         = '01'
                                   AND MGTSYSCODE            = :MGTSYSCODE";

                                OraDB.UpdateParameters.Add("CANCELDATETIME", DateTime.Now.ToString("yyyyMMddHHmmss"));
                                OraDB.UpdateParameters.Add("CANCELID", base.sUserID);
                                OraDB.UpdateParameters.Add("CANCELNMC", base.sUserNM);
                                OraDB.UpdateParameters.Add("PROCDATETIME", DateTime.Now.ToString("yyyyMMddHHmmss"));
                                OraDB.UpdateParameters.Add("PROCID", base.sUserID);
                                OraDB.UpdateParameters.Add("PROCNMC", base.sUserNM);
                                OraDB.UpdateParameters.Add("SYSTEMID", base.sSystemID);
                                OraDB.UpdateParameters.Add("MGTSYSCODE", models.APPLY_STATUS);

                                OraDB.Update();
                                dicResult.Add("SRESULT", "TRUE");
                                dicResult.Add("SMESSAGE", "刪除成功");
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
                    Utility ut = new Utility();
                    //ut.SendMail("cc4f@vghtc.gov.tw", "cc4f@vghtc.gov.tw", "程式錯誤_" + base.sSystemID + "_" + base.ProgramID, content);
                    //ErrorLogger ErrLog = new ErrorLogger(base.ProgramID, OraDB.SQL, OraDB.Message);
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