<%@ WebHandler Language="C#" Class="WS_CFM_A01_Q01" %>

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
    *Program ID  : SW_CFM_A01_Q01
    *Description : 檢視所有申請
    *Create By   : Tzu-Chiang, Wang
    *Create Date : 20170324　　　
    */

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

public class WS_CFM_A01_Q01 : uiAshxCommon
{

    public override void ProcessRequest(HttpContext context)
    {
        base.ProgramID = "A01Q01";
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
                                var models = js.Deserialize<JSONClass.JSON_CFM_A01_Q01>(WPS.getKeys("models"));
                                string sCreateUserId = Utils.StrEmpty(context.Request["CreateUserID"]);
                                // TODO : 取號 參數請參考GetSeqNo查看定義
                                Utility ut = new Utility();
                                models.APPLY_SEQ = ut.GetSeqNo("", "COMPUTER_FUNCTION_MASTER", "TO_NUMBER(APPLY_SEQ)", "APPLY_YYYY", 4, 0, OraDB);

                                OraDB.InsertCommand = @"
                                INSERT INTO COMMON.Computer_Function_Master (
                                    FORM_ID,           FORM_VERSION,        APPLY_YYYY,         APPLY_SEQ,
                                    APPLY_STATUS,      APPLY_DEPT,          APPLY_ID,           APPLY_NAMEC,        APPLY_TEL,
                                    SIGN_DEPT,         SIGN_ID,             SIGN_NAMEC,
                                    APPLY_BEGIN_DTTM,  APPLY_END_DTTM,
                                    FUNCTION_NAME,     MODIFIED_REASONS,    MODIFIED_CONTENTS,  MODIFIED_BENEFITS,
                                    ATTACH_FILE1_NAME, ATTACH_FILE1_RENAME, 
                                    ATTACH_FILE2_NAME, ATTACH_FILE2_RENAME,
                                    ATTACH_FILE3_NAME, ATTACH_FILE3_RENAME,
                                    SCHEDULE_OPTION,   EXPECTATION_DT,
                                    SATISFIED_DEGREE,
                                    PROC_DTTM,         PROC_USER_ID,        PROC_NAMEC,
                                    CREATE_DTTM,       CREATE_USER_ID,      CREATE_NAMEC)
                                VALUES(
                                    'CFM',             'ISMS-P-014-01',     :APPLY_YYYY,        :APPLYSEQ,
                                    :APPLY_STATUS,     :APPLY_DEPT,         :APPLY_ID,          :APPLY_NAMEC,       :APPLY_TEL,
                                    '',                '',                  '',
                                    '',                '',
                                    :FUNCTION_NAME,    :MODIFIED_REASONS,   :MODIFIED_CONTENTS, :MODIFIED_BENEFITS,
                                    '',                '',
                                    '',                '',
                                    '',                '',
                                    '',                :EXPECTATION_DT,
                                    '',
                                    :PROC_DTTM,        :PROC_USER_ID,       :PROC_NAMEC,
                                    :CREATE_DTTM,      :CREATE_USER_ID,     :CREATE_NAMEC )";

                                OraDB.InsertParameters.Add("APPLY_YYYY", DateTime.Now.ToString("yyyy"));
                                OraDB.InsertParameters.Add("APPLYSEQ", models.APPLY_SEQ);
                                OraDB.InsertParameters.Add("APPLY_STATUS", models.APPLY_STATUS);
                                OraDB.InsertParameters.Add("APPLY_DEPT", base.sDeptID);
                                OraDB.InsertParameters.Add("APPLY_ID", base.sUserID);
                                OraDB.InsertParameters.Add("APPLY_NAMEC", base.sUserNM);
                                OraDB.InsertParameters.Add("APPLY_TEL", models.APPLY_TEL);
                                OraDB.InsertParameters.Add("FUNCTION_NAME", models.FUNCTION_NAME);
                                OraDB.InsertParameters.Add("MODIFIED_REASONS", models.MODIFIED_REASONS);
                                OraDB.InsertParameters.Add("MODIFIED_CONTENTS", models.MODIFIED_CONTENTS);
                                OraDB.InsertParameters.Add("MODIFIED_BENEFITS", models.MODIFIED_BENEFITS);
                                OraDB.InsertParameters.Add("EXPECTATION_DT", models.EXPECTATION_DT);
                                OraDB.InsertParameters.Add("PROC_DTTM", DateTime.Now.ToString("yyyyMMddHHmmss"));
                                OraDB.InsertParameters.Add("PROC_USER_ID", base.sUserID);
                                OraDB.InsertParameters.Add("PROC_NAMEC", base.sUserNM);
                                OraDB.InsertParameters.Add("CREATE_DTTM", DateTime.Now.ToString("yyyyMMddHHmmss"));
                                OraDB.InsertParameters.Add("CREATE_USER_ID", base.sUserID);
                                OraDB.InsertParameters.Add("CREATE_NAMEC", base.sUserNM);

                                OraDB.Insert();

                                // 檔案重新命名
                                if (models.FILESNM != "")  //若有上傳檔案才去重新命名
                                {
                                    String[] names = models.FILESNM.Split('?');
                                    models.UNIQUE_ID = DateTime.Now.ToString("yyyy") + models.APPLY_SEQ.PadLeft(4, '0');

                                    for (int i = 1; i < names.Length; i++)
                                    {
                                        var num = ut.GetfileSeqNo("", "CFM_UPLOADFILES", models.UNIQUE_ID, "TO_NUMBER(FILE_SEQ)", 0, 1, OraDB);
                                        //所上傳之附件原始檔名(檔名內已包含副檔名)
                                        string oldFileName = HttpContext.Current.Server.MapPath("../UploadFiles/CFM_A01Q01/" + names[i]);
                                        //將檔案命名為假單編號  
                                        string newFileName = HttpContext.Current.Server.MapPath("../UploadFiles/CFM_A01Q01/" + models.UNIQUE_ID + "_" + num + Path.GetExtension(oldFileName));
                                        File.Move(oldFileName, newFileName);

                                        // 將附件檔案insert into EDU_UPLOADFILES資料表
                                        OraDB.InsertCommand = @"
                                                     INSERT INTO COMMON.CFM_UPLOADFILES
                                                       (    FUNCTION_NAME,      FUNCTION_KEY,       FILE_SEQ,
                                                            FILENAME_ORIGIN,    FILENAME_RENAME,
                                                            PROCDATETIME,       PROCID,             PROCNMC,
                                                            CREATEDATETIME,     CREATEID,           CREATENMC)
                                                     VALUES
                                                       (    :FUNCTION_NAME,     :FUNCTION_KEY,      :FILE_SEQ,
                                                            :FILENAME_ORIGIN,   :FILENAME_RENAME,   
                                                            :PROCDATETIME,      :PROCID,            :PROCNMC,           
                                                            :CREATEDATETIME,    :CREATEID,          :CREATENMC) ";

                                        OraDB.InsertParameters.Add("FUNCTION_NAME", "A01Q01");  //存入頁面名稱
                                        OraDB.InsertParameters.Add("FUNCTION_KEY", models.UNIQUE_ID);  //存入假單編號
                                        OraDB.InsertParameters.Add("FILE_SEQ", num);  //檔案流水號(自行編碼)
                                        OraDB.InsertParameters.Add("FILENAME_ORIGIN", names[i]);  //原始檔名
                                        OraDB.InsertParameters.Add("FILENAME_RENAME", models.UNIQUE_ID + "_" + num + Path.GetExtension(oldFileName));  //重新命名後檔名
                                        OraDB.InsertParameters.Add("PROCDATETIME", DateTime.Now.ToString("yyyyMMddHHmmss"));
                                        OraDB.InsertParameters.Add("PROCID", base.sUserID);  //紀錄處理人員IDNO
                                        OraDB.InsertParameters.Add("PROCNMC", base.sUserNM);  //紀錄處理人員姓名
                                        OraDB.InsertParameters.Add("CREATEDATETIME", DateTime.Now.ToString("yyyyMMddHHmmss"));
                                        OraDB.InsertParameters.Add("CREATEID", base.sUserID);  //紀錄建立人員IDNO
                                        OraDB.InsertParameters.Add("CREATENMC", base.sUserNM);  //紀錄建立人員姓名

                                        OraDB.Insert();
                                    }
                                }
                                dicResult.Add("SRESULT", "TRUE");
                                dicResult.Add("SMESSAGE", "新增成功");
                                break;
                            }
                        case "R":
                            {
                                StringBuilder sOrderBy = new StringBuilder();
                                StringBuilder sQuery = new StringBuilder();
                                string sCreateUserId = Utils.StrEmpty(context.Request["CreateUserID"]);
                                var models = js.Deserialize<JSONClass.JSON_EDU_PAGE>(WPS.getKeys("models"));

                                //欄位名稱轉換成DB名稱
                                Dictionary<string, string> dicMap = new Dictionary<string, string>();
                                dicMap.Add("APPLY_STATUS", "MGTSYSCODE");
                                dicMap.Add("STATUS_DESCRIPTION", "MGTSYSCODENM");
                                #region 根據排序傳入的排序 給定row number
                                if (models.SORT == null)
                                {
                                    //default sort
                                    sOrderBy.Append("T.CREATE_DTTM DESC");
                                }
                                else
                                {
                                    //sort by user's selection
                                    foreach (var e in models.SORT)
                                    {
                                        if (dicMap.ContainsKey(e.field))
                                            e.field = dicMap[e.field];
                                        sOrderBy.Append(e.field + " " + e.dir + ",");
                                    }
                                }
                                #endregion

                                #region 查詢條件
                                sQuery.Append(@"
                                        FROM COMPUTER_FUNCTION_MASTER T
                                        LEFT JOIN ((SELECT    A.DEPTNO,A.NAME AS DEPTNM
                                                      FROM    COMMON.EDEPT_VGHTC A
                                                     WHERE    A.GRADE = '1') B)
                                               ON   TRIM(T.APPLY_DEPT) = B.DEPTNO
                                       INNER JOIN ((SELECT    C.MGTSYSCODE,C.MGTSYSCODENM
                                                       FROM    MGT.MGTCODE C
                                                      WHERE    C.SYSTEMID = 'CFM' 
                                                        AND    C.SYSCODETYPE = '01') D)
                                               ON   D.MGTSYSCODE = T.APPLY_STATUS
                                            WHERE   1 = 1 " );
                                //資訊室人員才能看到所有申請單, 否則只能看到自己的申請單
                                if (!base.sDeptID.Equals("CC"))
                                    sQuery.AppendFormat(@"AND T.CREATE_USER_ID = '{0}' 
                                                          AND T.APPLY_STATUS != '80'", base.sUserID);
                                if (!sCreateUserId.Equals(""))
                                    sQuery.AppendFormat("AND T.CREATE_USER_ID like '%{0}%'", sCreateUserId);
                                #endregion

                                #region 組SQL
                                sbSQL.AppendFormat(@"
                                     SELECT *
                                     FROM (SELECT ROW_NUMBER() OVER(ORDER BY {0}) AS RNUM,
                                           T.FORM_ID,
                                           CONCAT(T.APPLY_YYYY,LPAD(TRIM(T.APPLY_SEQ),4,'0')) AS UNIQUE_ID,
                                           T.APPLY_SEQ,
                                           T.APPLY_YYYY, 
                                           T.APPLY_STATUS,                                          
                                           D.MGTSYSCODENM AS STATUS_DESCRIPTION,
                                           T.FUNCTION_NAME,
                                           T.MODIFIED_REASONS,
                                           T.MODIFIED_CONTENTS,
                                           T.MODIFIED_BENEFITS,
                                           TO_CHAR(TO_DATE(T.EXPECTATION_DT, 'YYYYMMDD'),
                                                   'YYYYMMDD') AS EXPECTATION_DT,
                                           TO_CHAR(TO_DATE(T.CREATE_DTTM, 'YYYYMMDDHH24MISS'),
                                                   'YYYY/MM/DD HH24:MI') AS CREATE_DTTM,
                                           T.CREATE_USER_ID,
                                           T.CREATE_NAMEC,
                                           T.APPLY_TEL,
                                           T.APPLY_DEPT,
                                           B.DEPTNM
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
                                        listResult.Add(new JSONClass.JSON_CFM_A01_Q01()
                                        {
                                            FORM_ID = dr["FORM_ID"].ToString(),
                                            UNIQUE_ID = dr["UNIQUE_ID"].ToString(),
                                            APPLY_SEQ = dr["APPLY_SEQ"].ToString(),
                                            APPLY_YYYY = dr["APPLY_YYYY"].ToString(),
                                            APPLY_STATUS = dr["APPLY_STATUS"].ToString(),
                                            STATUS_DESCRIPTION = dr["STATUS_DESCRIPTION"].ToString(),
                                            FUNCTION_NAME = dr["FUNCTION_NAME"].ToString(),
                                            MODIFIED_REASONS = dr["MODIFIED_REASONS"].ToString(),
                                            MODIFIED_CONTENTS = dr["MODIFIED_CONTENTS"].ToString(),
                                            MODIFIED_BENEFITS = dr["MODIFIED_BENEFITS"].ToString(),
                                            EXPECTATION_DT = dr["EXPECTATION_DT"].ToString(),
                                            CREATE_DTTM = dr["CREATE_DTTM"].ToString(),
                                            CREATE_USER_ID = dr["CREATE_USER_ID"].ToString(),
                                            CREATE_NAMEC = dr["CREATE_NAMEC"].ToString(),
                                            APPLY_TEL = dr["APPLY_TEL"].ToString(),
                                            APPLY_DEPT = dr["APPLY_DEPT"].ToString(),
                                            DEPTNM = dr["DEPTNM"].ToString()
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
                                var models = js.Deserialize<JSONClass.JSON_CFM_A01_Q01>(WPS.getKeys("models"));
                                OraDB.UpdateCommand = @"
                                UPDATE COMPUTER_FUNCTION_MASTER T
                                   SET 
                                       T.FUNCTION_NAME       = :FUNCTION_NAME,
                                       T.MODIFIED_REASONS    = :MODIFIED_REASONS,
                                       T.MODIFIED_CONTENTS   = :MODIFIED_CONTENTS,
                                       T.MODIFIED_BENEFITS   = :MODIFIED_BENEFITS,
                                       T.EXPECTATION_DT      = :EXPECTATION_DT,
                                       T.APPLY_TEL           = :APPLY_TEL,
                                       T.PROC_DTTM           = :PROC_DTTM,
                                       T.PROC_USER_ID        = :PROC_USER_ID,
                                       T.PROC_NAMEC          = :PROC_NAMEC 
                                 WHERE 1 = 1 
                                   AND T.APPLY_SEQ           = :APPLY_SEQ
                                   AND T.APPLY_YYYY          = :APPLY_YYYY";

                                OraDB.UpdateParameters.Add("APPLY_SEQ", models.APPLY_SEQ);
                                OraDB.UpdateParameters.Add("APPLY_YYYY", models.APPLY_YYYY);
                                OraDB.UpdateParameters.Add("FUNCTION_NAME", models.FUNCTION_NAME);
                                OraDB.UpdateParameters.Add("MODIFIED_REASONS", models.MODIFIED_REASONS);
                                OraDB.UpdateParameters.Add("MODIFIED_CONTENTS", models.MODIFIED_CONTENTS);
                                OraDB.UpdateParameters.Add("MODIFIED_BENEFITS", models.MODIFIED_BENEFITS);
                                OraDB.UpdateParameters.Add("EXPECTATION_DT", models.EXPECTATION_DT);
                                OraDB.UpdateParameters.Add("APPLY_TEL", models.APPLY_TEL);
                                OraDB.UpdateParameters.Add("PROC_DTTM", DateTime.Now.ToString("yyyyMMddHHmmss"));
                                OraDB.UpdateParameters.Add("PROC_USER_ID", base.sUserID);
                                OraDB.UpdateParameters.Add("PROC_NAMEC", base.sUserNM);

                                OraDB.Update();

                                // 檔案重新命名
                                if (models.FILESNM != "")  //若有上傳檔案才去重新命名
                                {
                                    String[] names = models.FILESNM.Split('?');
                                    Utility ut = new Utility();

                                    for (int i = 1; i < names.Length; i++)
                                    {

                                        var num = ut.GetfileSeqNo("", "CFM_UPLOADFILES", models.UNIQUE_ID, "TO_NUMBER(FILE_SEQ)", 0, 1, OraDB);
                                        //所上傳之附件原始檔名(檔名內已包含副檔名)
                                        string oldFileName = HttpContext.Current.Server.MapPath("../UploadFiles/CFM_A01Q01/" + names[i]);
                                        //將檔案命名為假單編號  
                                        string newFileName = HttpContext.Current.Server.MapPath("../UploadFiles/CFM_A01Q01/" + models.UNIQUE_ID + "_" + num + Path.GetExtension(oldFileName));
                                        File.Move(oldFileName, newFileName);

                                        // 將附件檔案insert into CFM_UPLOADFILES資料表
                                        OraDB.InsertCommand = @"
                                                     INSERT INTO COMMON.CFM_UPLOADFILES
                                                       (    FUNCTION_NAME,      FUNCTION_KEY,       FILE_SEQ,
                                                            FILENAME_ORIGIN,    FILENAME_RENAME,
                                                            PROCDATETIME,       PROCID,             PROCNMC,
                                                            CREATEDATETIME,     CREATEID,           CREATENMC)
                                                     VALUES
                                                       (    :FUNCTION_NAME,     :FUNCTION_KEY,      :FILE_SEQ,
                                                            :FILENAME_ORIGIN,   :FILENAME_RENAME,   
                                                            :PROCDATETIME,      :PROCID,            :PROCNMC,           
                                                            :CREATEDATETIME,    :CREATEID,          :CREATENMC) ";

                                        OraDB.InsertParameters.Add("FUNCTION_NAME", "A01Q01");  //存入頁面名稱
                                        OraDB.InsertParameters.Add("FUNCTION_KEY", models.UNIQUE_ID);  //存入假單編號
                                        OraDB.InsertParameters.Add("FILE_SEQ", num);  //檔案流水號(自行編碼)
                                        OraDB.InsertParameters.Add("FILENAME_ORIGIN", names[i]);  //原始檔名
                                        OraDB.InsertParameters.Add("FILENAME_RENAME", models.UNIQUE_ID + "_" + num + Path.GetExtension(oldFileName));  //重新命名後檔名
                                        OraDB.InsertParameters.Add("PROCDATETIME", DateTime.Now.ToString("yyyyMMddHHmmss"));
                                        OraDB.InsertParameters.Add("PROCID", base.sUserID);  //紀錄處理人員IDNO
                                        OraDB.InsertParameters.Add("PROCNMC", base.sUserNM);  //紀錄處理人員姓名
                                        OraDB.InsertParameters.Add("CREATEDATETIME", DateTime.Now.ToString("yyyyMMddHHmmss"));
                                        OraDB.InsertParameters.Add("CREATEID", base.sUserID);  //紀錄建立人員IDNO
                                        OraDB.InsertParameters.Add("CREATENMC", base.sUserNM);  //紀錄建立人員姓名

                                        OraDB.Insert();
                                    }
                                }
                                dicResult.Add("SRESULT", "TRUE");
                                dicResult.Add("SMESSAGE", "更新成功");
                                break;
                            }
                        case "D":
                            {
                                var models = js.Deserialize<JSONClass.JSON_CFM_A01_Q01>(WPS.getKeys("models"));
                                OraDB.UpdateCommand = @"
                                UPDATE COMPUTER_FUNCTION_MASTER T
                                   SET 
                                       T.APPLY_STATUS        = :APPLY_STATUS,
                                       T.PROC_DTTM           = :PROC_DTTM,
                                       T.PROC_USER_ID        = :PROC_USER_ID,
                                       T.PROC_NAMEC          = :PROC_NAMEC 
                                 WHERE T.APPLY_SEQ           = :APPLY_SEQ
                                   AND T.APPLY_YYYY          = :APPLY_YYYY";

                                OraDB.UpdateParameters.Add("APPLY_SEQ", models.APPLY_SEQ);
                                OraDB.UpdateParameters.Add("APPLY_YYYY", models.APPLY_YYYY);
                                OraDB.UpdateParameters.Add("APPLY_STATUS", "80");
                                OraDB.UpdateParameters.Add("PROC_DTTM", DateTime.Now.ToString("yyyyMMddHHmmss"));
                                OraDB.UpdateParameters.Add("PROC_USER_ID", base.sUserID);
                                OraDB.UpdateParameters.Add("PROC_NAMEC", base.sUserNM);
                                // 更新表單狀態取代直接刪除資料
                                OraDB.Update();

                                dicResult.Add("SRESULT", "TRUE");
                                dicResult.Add("SMESSAGE", "刪除成功");
                                break;
                            }
                        case "Upload":
                            {
                                try
                                {
                                    if (context.Request.Files.Count > 0)
                                    {
                                        // 串檔名用 接參數 檔案上傳
                                        var allFileName = "";
                                        // COMMON.CFM_FILEUPLOAD 的 FUNCTION KEY
                                        string sUniqueId = Utils.StrEmpty(context.Request["uniqueId"]);
                                        // 儲存檔案的路徑
                                        string path = context.Server.MapPath("~/UploadFiles/CFM_A01Q01");

                                        if (!Directory.Exists(path))
                                            Directory.CreateDirectory(path);
                                        for (int i = 0; i < context.Request.Files.Count; i++)  //前端用batch傳，跑迴圈抓出array裡的檔案
                                        {
                                            var file = context.Request.Files[i];
                                            string fileName = Path.Combine(path, Path.GetFileName(file.FileName));
                                            file.SaveAs(fileName);
                                            allFileName +=  "?" + file.FileName;
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
                                    // 未來可以考慮有無sUniqueId 刪除的是新上傳還是資料庫有紀錄的資料
                                    // COMMON.CFM_FILEUPLOAD 的 FILESEQ
                                    string sfileSeq = Utils.StrEmpty(context.Request["fileSeq"]);
                                    // COMMON.CFM_FILEUPLOAD 的 FUNCTION KEY
                                    string sUniqueId = Utils.StrEmpty(context.Request["uniqueId"]);
                                    // COMMON.CFM_FILEUPLOAD 的 FILENAME RENAME || 被刪除的檔案名稱
                                    string sFileName = Utils.StrEmpty(context.Request["fileName"]);
                                    // 所有新上傳的檔案字串
                                    string sNewUploadFiles = Utils.StrEmpty(context.Request["newUploadFiles"]);

                                    //已經產生請假單的才要更新資料庫
                                    if (sUniqueId != "")
                                    {
                                        OraDB.DeleteCommand = @" DELETE FROM COMMON.CFM_UPLOADFILES T 
                                                                       WHERE T.FUNCTION_NAME = 'A01Q01' 
                                                                         AND T.FUNCTION_KEY = :FUNCTION_KEY 
                                                                         AND T.FILE_SEQ = :FILESEQ ";
                                        OraDB.DeleteParameters.Add("FUNCTION_KEY", sUniqueId);  //假單編號。FILESEQ[1] = 2016033
                                        OraDB.DeleteParameters.Add("FILESEQ", sfileSeq);  //檔案流水號。NUM[0] = 1
                                        OraDB.Delete();  // 將資料庫中此檔案資料刪除
                                    }
                                    // 從新上傳的檔案中刪除掉要被刪除的檔案
                                    sNewUploadFiles = sNewUploadFiles.Replace("?" + sFileName, "");
                                    //該筆檔案路徑
                                    string FileName = HttpContext.Current.Server.MapPath("../UploadFiles/CFM_A01Q01/" + sFileName);
                                    File.Delete(FileName);  // 將該檔案刪除

                                    GetBaseCode gbc = new GetBaseCode();
                                    listResult = gbc.getUploadFiles("A01Q01", sUniqueId, OraDB);
                                    if (listResult.Count > 0)
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
                        // 送單申請
                        case "sentRequest":
                            {
                                var model = js.Deserialize<JSONClass.JSON_CFM_A01_Q01>(context.Request["model"]);

                                if(model.APPLY_STATUS.Equals("00"))
                                {
                                    OraDB.UpdateCommand = @"
                                            UPDATE COMPUTER_FUNCTION_MASTER T
                                               SET 
                                                   T.APPLY_STATUS        = :APPLY_STATUS,
                                                   T.PROC_DTTM           = :PROC_DTTM,
                                                   T.PROC_USER_ID        = :PROC_USER_ID,
                                                   T.PROC_NAMEC          = :PROC_NAMEC 
                                             WHERE T.APPLY_SEQ           = :APPLY_SEQ
                                               AND T.APPLY_YYYY          = :APPLY_YYYY";

                                    OraDB.UpdateParameters.Add("APPLY_SEQ", model.APPLY_SEQ);
                                    OraDB.UpdateParameters.Add("APPLY_YYYY", model.APPLY_YYYY);
                                    OraDB.UpdateParameters.Add("APPLY_STATUS", "01");
                                    OraDB.UpdateParameters.Add("PROC_DTTM", DateTime.Now.ToString("yyyyMMddHHmmss"));
                                    OraDB.UpdateParameters.Add("PROC_USER_ID", base.sUserID);
                                    OraDB.UpdateParameters.Add("PROC_NAMEC", base.sUserNM);
                                    // 更新表單狀態至送出
                                    OraDB.Update();

                                    dicResult.Add("SRESULT", "TRUE");
                                    dicResult.Add("SMESSAGE", "送單成功");
                                }
                                else
                                {
                                    dicResult.Add("SRESULT", "FALSE");
                                    dicResult.Add("SMESSAGE", "表單狀態不是暫存");
                                }
                                break;
                            }
                        // 判斷附件檔案是否存在
                        case "FileCheck":
                            {
                                try
                                {
                                    //該筆申請單編號
                                    string sFormId = Utils.StrEmpty(context.Request["formID"]);
                                    GetBaseCode gbc = new GetBaseCode();
                                    listResult = gbc.getUploadFiles("A01Q01", sFormId, OraDB);
                                    dicResult.Add("DATA", listResult);

                                    if (listResult.Count == 0)
                                        dicResult.Add("FILECHECK", "FALSE");  //no files
                                    else
                                        dicResult.Add("FILECHECK", "TRUE");
                                }
                                catch (Exception e)
                                {
                                    dicResult.Add("SRESULT", "FALSE");
                                    dicResult.Add("SMESSAGE", "搜尋失敗");
                                }
                                break;
                            }
                        case "CreatePDF":
                            {
                                StringBuilder sPDF = new StringBuilder();
                                string sdataID = Utils.StrEmpty(context.Request["dataID"]); //context.Request[""] 接參數    

                                OraDB.SelectCommand = @"
                                        SELECT T.*,B.DEPTNM
                                          FROM COMMON.COMPUTER_FUNCTION_MASTER T
                                     LEFT JOIN ((SELECT    A.DEPTNO,A.NAME AS DEPTNM
                                                   FROM    COMMON.EDEPT_VGHTC A
                                                  WHERE    A.GRADE = '1') B)
                                            ON   TRIM(T.APPLY_DEPT) = B.DEPTNO
                                         WHERE T.APPLY_YYYY = :APPLY_YYYY
                                           AND T.APPLY_SEQ  = :APPLY_SEQ";
                                OraDB.SelectParameters.Add("APPLY_YYYY", sdataID.Substring(0, 4));  //定義判斷用的變數為傳過來的string
                                OraDB.SelectParameters.Add("APPLY_SEQ", sdataID.Substring(4, 4).TrimStart('0').PadRight(4, ' '));
                                DataTable dtData = OraDB.Select();

                                // 開始列印
                                C1WebReport C1WebReport = new C1WebReport();
                                C1WebReport.ReportSource.ReportName = "CFM_A01_Q01"; //報表名稱
                                C1WebReport.ReportSource.FileName = HttpContext.Current.Server.MapPath(string.Format("../Reports/CFMA01Q01.xml")); //報表檔名

                                foreach (DataRow dr in dtData.Rows)
                                {
                                    //Detail, assign field value
                                    //Row1 電腦作業或功能名稱, 作業單位
                                    C1WebReport.Report.Fields["function_name"].Value = dr["FUNCTION_NAME"].ToString();
                                    C1WebReport.Report.Fields["apply_dept"].Value = dr["DEPTNM"].ToString().Equals(string.Empty) ? dr["APPLY_DEPT"].ToString() : dr["DEPTNM"].ToString();
                                    //Row2 增改理由
                                    C1WebReport.Report.Fields["modified_reasons"].Value = dr["MODIFIED_REASONS"].ToString();
                                    //Row3 增改內容
                                    C1WebReport.Report.Fields["modified_contents"].Value = dr["MODIFIED_CONTENTS"].ToString();
                                    //Row4 預期效益
                                    C1WebReport.Report.Fields["modified_benefits"].Value = dr["MODIFIED_BENEFITS"].ToString();
                                    //Row5 申請日期, 希望使用日期, 作業申請人, 連絡電話
                                    C1WebReport.Report.Fields["create_dttm"].Value = string.Format("{0}年{1}月{2}日", dr["CREATE_DTTM"].ToString().Substring(0, 4), dr["CREATE_DTTM"].ToString().Substring(4, 2), dr["CREATE_DTTM"].ToString().Substring(6, 2));
                                    C1WebReport.Report.Fields["expectation_dt"].Value = string.Format("{0}年{1}月{2}日", dr["EXPECTATION_DT"].ToString().Substring(0, 4), dr["EXPECTATION_DT"].ToString().Substring(4, 2), dr["EXPECTATION_DT"].ToString().Substring(6, 2));
                                    C1WebReport.Report.Fields["apply_namec"].Value = dr["APPLY_NAMEC"].ToString();
                                    C1WebReport.Report.Fields["apply_tel"].Value = dr["APPLY_TEL"].ToString();
                                    //PageFooter, assign field value
                                    //文件版本
                                    C1WebReport.Report.Fields["form_version"].Value = dr["FORM_VERSION"].ToString();

                                }
                                //轉成pdf
                                C1WebReport.Report.RenderToFile(HttpContext.Current.Server.MapPath("../TempFiles/Sample_" + sdataID + ".pdf"), C1.C1Report.FileFormatEnum.PDFEmbedFonts);

                                dicResult.Add("SRESULT", "TRUE");
                                dicResult.Add("SMESSAGE", "下載成功。");
                                dicResult.Add("SHOWPDF", "../TempFiles/Sample_" + sdataID + ".pdf");
                                dicResult.Add("FILENM", sdataID);
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