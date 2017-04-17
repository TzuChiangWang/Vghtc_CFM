<%@ WebHandler Language="C#" Class="WS_CFM_A01_C01" %>

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
    *Program ID  : SW_CFM_A01_C01
    *Description : 新增功能修改申請
    *Create By   : Tzu-Chiang, Wang
    *Create Date : 20170329　　　
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

public class WS_CFM_A01_C01 : uiAshxCommon {
    
    public override void ProcessRequest (HttpContext context) {
        base.ProgramID = "A01C01";
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
                                
                                break;
                            }
                        case "R":
                            {
                                
                                break;
                            }
                        case "U":
                            {
                                
                                break;
                            }
                        case "GET_DEPTNO":
                            {
                                
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