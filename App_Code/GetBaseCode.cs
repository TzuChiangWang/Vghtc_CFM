using System;
using System.Data;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Net.Mail;
using System.Text;
using dmxDataAccess;
using dmxUtils;

/// <summary>
/// GetBaseCode 取得資料庫的資料表基本資料 簡稱gbc
/// </summary>
public class GetBaseCode
{
    public GetBaseCode()
    {
        //
        // TODO: 在此加入建構函式的程式碼
        //
    }

    /// <summary>
    /// </summary>
    /// <param name="functionKey"></param>
    /// <param name="functionName"></param>
    /// <param name="OraDB"></param>
    //public List<object> getUploadFiles(string functionName, string functionKey, OracleDataSource OraDB)
    //{
    //    try
    //    {
    //        StringBuilder sbSQL = new StringBuilder();
    //        List<object> listResult = new List<object>();
    //        sbSQL.AppendFormat(@"SELECT T.FILE_SEQ, T.FILENAME_ORIGIN, T.FILENAME_RENAME
    //                               FROM COMMON.EDU_UPLOADFILES T 
    //                              WHERE T.FUNCTION_NAME = :FUNCTION_NAME 
    //                                AND T.FUNCTION_KEY = :FUNCTION_KEY
    //                           ORDER BY TO_NUMBER(T.FILE_SEQ) ASC");
    //        OraDB.SelectCommand = sbSQL.ToString();
    //        OraDB.SelectParameters.Add("FUNCTION_NAME", functionName);
    //        OraDB.SelectParameters.Add("FUNCTION_KEY", functionKey);
    //        DataTable dtTable = OraDB.Select();
    //        if (dtTable.Rows.Count > 0)
    //        {
    //            foreach (DataRow dr in dtTable.Rows)
    //            {
    //                listResult.Add(new JSONClass.JSON_EDU_UPLOADFILE()
    //                {
    //                    FUNCTION_KEY = functionName,
    //                    FUNCTION_NAME = functionKey,
    //                    FILE_SEQ = dr["FILE_SEQ"].ToString(),
    //                    FILENAME_ORIGIN = dr["FILENAME_ORIGIN"].ToString(),
    //                    FILENAME_RENAME = dr["FILENAME_RENAME"].ToString(),
    //                });
    //            }
    //        }
    //        return listResult;
    //    }
    //    catch (Exception ex)
    //    {
    //        throw ex;
    //    }
    //}

    /// <summary>
    /// </summary>
    /// <param name="functionKey"></param>
    /// <param name="functionName"></param>
    /// <param name="OraDB"></param>
    public List<object> getUploadFiles(string functionName, string functionKey, OracleDataSource OraDB)
    {
        try
        {
            StringBuilder sbSQL = new StringBuilder();
            List<object> listResult = new List<object>();
            sbSQL.AppendFormat(@"SELECT T.FILE_SEQ, T.FILENAME_ORIGIN, T.FILENAME_RENAME
                                   FROM COMMON.CFM_UPLOADFILES T 
                                  WHERE T.FUNCTION_NAME = :FUNCTION_NAME 
                                    AND T.FUNCTION_KEY = :FUNCTION_KEY
                               ORDER BY TO_NUMBER(T.FILE_SEQ) ASC");
            OraDB.SelectCommand = sbSQL.ToString();
            OraDB.SelectParameters.Add("FUNCTION_NAME", functionName);
            OraDB.SelectParameters.Add("FUNCTION_KEY", functionKey);
            DataTable dtTable = OraDB.Select();
            if (dtTable.Rows.Count > 0)
            {
                foreach (DataRow dr in dtTable.Rows)
                {
                    listResult.Add(new JSONClass.JSON_CFM_UPLOADFILE()
                    {
                        FUNCTION_KEY = functionName,
                        FUNCTION_NAME = functionKey,
                        FILE_SEQ = dr["FILE_SEQ"].ToString(),
                        FILENAME_ORIGIN = dr["FILENAME_ORIGIN"].ToString(),
                        FILENAME_RENAME = dr["FILENAME_RENAME"].ToString(),
                    });
                }
            }
            return listResult;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
}