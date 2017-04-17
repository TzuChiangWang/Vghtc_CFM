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

/// <summary>
/// Utility 的摘要描述
/// </summary>
public class Utility
{
	public Utility()
	{
		//
		// TODO: 在此加入建構函式的程式碼
		//
	}

    /// <summary>
    /// 取號
    /// </summary>
    /// <param name="Spc">前置字串</param>
    /// <param name="table">取號表格</param>
    /// <param name="col">取號欄位</param>
    /// <param name="YearNum">年份(兩碼(傳入'2')或四碼(傳入'4')</param>
    /// <param name="SeqCount">總長</param>
    /// <param name="OraDB">資料庫連線</param>
    /// <returns></returns>
    public String GetSeqNo(String Spc, String table, String col, int YearNum, int SeqCount, OracleDataSource OraDB)
    {
        string strSeq = Spc;
        int intSeqNo = 0;
        try
        {
            switch (YearNum)
            {
                case 0:
                    break;
                case 4:
                    strSeq += DateTime.Now.Year.ToString();
                    break;
                case 2:
                    strSeq += DateTime.Now.Year.ToString().Substring(2);
                    break;
            }

            OraDB.SelectCommand = "select nvl(max(" + col + "),'0') from " + table + " where " + col + " like :no";
            OraDB.SelectParameters.Add("no", strSeq + "%");
            DataTable dtTable = OraDB.Select();

            foreach (DataRow drRow in dtTable.Rows)
            {
                if (drRow[0].ToString() == "0")
                {
                    intSeqNo = 1;
                }
                else
                {
                    intSeqNo = int.Parse(drRow[0].ToString().Replace(strSeq, "")) + 1;
                }
            }
            return strSeq + intSeqNo.ToString().PadLeft(SeqCount, '0');
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    /// <summary>
    /// 取號
    /// </summary>
    /// <param name="Spc">前置字串</param>
    /// <param name="table">取號表格</param>
    /// <param name="seqcol">取號欄位</param>
    /// <param name="col">條件欄位</param>
    /// <param name="YearNum">年份(兩碼(傳入'2')或四碼(傳入'4')</param>
    /// <param name="SeqCount">總長</param>
    /// <param name="OraDB">資料庫連線</param>
    /// <returns></returns>
    public String GetSeqNo(String Spc, String table, String seqcol, string col, int YearNum, int SeqCount, OracleDataSource OraDB)
    {
        string strSeq = Spc;
        int intSeqNo = 0;
        try
        {
            switch (YearNum)
            {
                case 0:
                    break;
                case 4:
                    strSeq += DateTime.Now.Year.ToString();
                    break;
                case 2:
                    strSeq += DateTime.Now.Year.ToString().Substring(2);
                    break;
            }

            OraDB.SelectCommand = "select nvl(max(" + seqcol + "),'0') from " + table + " where " + col + " = :no";
            OraDB.SelectParameters.Add("no", strSeq);
            DataTable dtTable = OraDB.Select();

            foreach (DataRow drRow in dtTable.Rows)
            {
                if (drRow[0].ToString() == "0")
                {
                    intSeqNo = 1;
                }
                else
                {
                    intSeqNo = int.Parse(drRow[0].ToString().Replace(strSeq, "")) + 1;
                }
            }
            return intSeqNo.ToString().PadLeft(SeqCount, '0');
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    /// <summary>
    /// 檔案取號
    /// </summary>
    /// <param name="Spc">前置字串</param>
    /// <param name="table">取號表格</param>
    /// <param name="functionKey">檔案擁有者ID</param>
    /// <param name="col">取號欄位</param>
    /// <param name="YearNum">年份(兩碼(傳入'2')或四碼(傳入'4')</param>
    /// <param name="SeqCount">總長</param>
    /// <param name="OraDB">資料庫連線</param>
    /// <returns></returns>
    public String GetfileSeqNo(String Spc, String table, String functionKey, String col, int YearNum, int SeqCount, OracleDataSource OraDB)
    {
        string strSeq = Spc;
        int intSeqNo = 0;
        try
        {
            switch (YearNum)
            {
                case 0:
                    break;
                case 4:
                    strSeq += DateTime.Now.Year.ToString();
                    break;
                case 2:
                    strSeq += DateTime.Now.Year.ToString().Substring(2);
                    break;
            }

            OraDB.SelectCommand = "select nvl(max(" + col + "),'0') from " + table + " where " + col + " like :no and FUNCTION_KEY = :FUNCTION_KEY";
            OraDB.SelectParameters.Add("no", strSeq + "%");
            OraDB.SelectParameters.Add("FUNCTION_KEY", functionKey);
            DataTable dtTable = OraDB.Select();

            foreach (DataRow drRow in dtTable.Rows)
            {
                if (drRow[0].ToString() == "0")
                {
                    intSeqNo = 1;
                }
                else
                {
                    intSeqNo = int.Parse(drRow[0].ToString()) + 1;
                }
            }
            if (intSeqNo.ToString().Length == 1)
                return strSeq + intSeqNo.ToString().PadLeft(SeqCount, '0');
            else
                return intSeqNo.ToString().PadLeft(SeqCount, '0');
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    /// <summary>
    /// 發送郵件
    /// </summary>
    /// <param name="strMailFrom">寄件者</param>
    /// <param name="strMailTo">收件者</param>
    /// <param name="strTITLE">主旨</param>
    /// <param name="strCONTENT">內文</param>
    /// <returns></returns>
    public bool SendMail(string strMailFrom, string strMailTo, string strTITLE, string strCONTENT)
    {
        bool bolRET = false;
        try
        {
            MailMessage msgMail = new MailMessage(strMailFrom, strMailTo, strTITLE, strCONTENT);
            msgMail.BodyEncoding = Encoding.UTF8;
            msgMail.IsBodyHtml = true;
            SmtpClient smtpObject = new SmtpClient("mail.vghtc.gov.tw", 25);
            smtpObject.DeliveryMethod = SmtpDeliveryMethod.Network;
            smtpObject.Send(msgMail);
            bolRET = true;
        }
        catch
        {
            bolRET = false;
        }
        return bolRET;
    }
}
