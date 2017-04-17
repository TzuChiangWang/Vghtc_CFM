using System;
using System.IO;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using dmxUtils;
using dmxUserInterface;
using dmxDataObject;
using System.Collections.Generic;
using dmxJson;


public partial class VGHTC_MSTPG : uiMasterCommon
{
    /// <summary>
    /// 取得目前網頁的根程式代號
    /// </summary>
    /// <param name="strParentID"></param>
    /// <returns></returns>
    private string GET_RootProgramID(string strParentID)
    {
        doProgramBasic _doProgramBasic = new doProgramBasic();
        string strResult = "";
        try
        {
            foreach (SortedList sl in sAuthPrograms)
            {
                if (sl[_doProgramBasic.ProgramID].ToString() == strParentID)
                {
                    if (sl[_doProgramBasic.ParentID].ToString() != "0")
                    {
                        strResult = GET_RootProgramID(sl[_doProgramBasic.ParentID].ToString());
                    }
                    else
                    {
                        strResult = sl[_doProgramBasic.ProgramID].ToString();
                        break;
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ErrorLogger ErrLog = new ErrorLogger(base.ProgramID, ExceptionHelper.GetStatus(ex));

        }
        return strResult;
    }

    /// <summary>
    /// 取得目前網頁至根網頁的sitepath
    /// </summary>
    /// <param name="strProgramID"></param>
    /// <param name="strParentID"></param>
    /// <returns></returns>
    private string GET_RoorPath(string strProgramID, string strParentID)
    {
        doProgramBasic _doProgramBasic = new doProgramBasic();
        string strResult = "";
        try
        {
            foreach (SortedList sl in sAuthPrograms)
            {
                if (sl[_doProgramBasic.ProgramID].ToString() == strParentID)
                {
                    if (sl[_doProgramBasic.ProgramID].ToString() == strProgramID)
                    {
                        strResult = String.Format("/<a href=\"{0}?programid={1}\" class=\"op1\">{2}</a>" + strResult, sl[_doProgramBasic.ProgramUrl], sl[_doProgramBasic.ProgramID], sl[_doProgramBasic.ProgramNM]);
                    }
                    else
                    {
                        strResult = String.Format("/<a href=\"{0}?programid={1}\" class=\"op\">{2}</a>" + strResult, sl[_doProgramBasic.ProgramUrl], sl[_doProgramBasic.ProgramID], sl[_doProgramBasic.ProgramNM]);
                    }
                    if (sl[_doProgramBasic.ParentID].ToString() != "0")
                    {
                        strResult = GET_RoorPath(strProgramID, sl[_doProgramBasic.ParentID].ToString()) + strResult;
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ErrorLogger ErrLog = new ErrorLogger(base.ProgramID, ExceptionHelper.GetStatus(ex));

        }
        return strResult;
    }

    /// <summary>
    /// 取得目前網頁操作說明
    /// </summary>
    /// <param name="strProgramID">程式代號</param>
    /// <returns>操作說明</returns>
    public string GET_ProgramComment(string strProgramID)
    {
        doProgramBasic _doProgramBasic = new doProgramBasic();
        string strResult = "";
        foreach (SortedList sl in sAuthPrograms)
        {
            if (Utils.StrEmpty(sl[_doProgramBasic.ProgramID]) == strProgramID)
            {
                strResult = Utils.StrEmpty(sl[_doProgramBasic.ProgramComment]);
            }
        }
        return strResult;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        WebParamaters WPS = new WebParamaters();
        string strProgramID = sCurrentID;
        if (!IsPostBack)
        {
            
            #region 繫結使用者功能MENU
            base.bindHtmlMenu();
           liMenu.Text = base.HtmlMenu;
            #endregion
            
            // 抓網頁Path
            string MenuPath = GET_RoorPath(strProgramID, strProgramID);
            //MenuPath += "<a class=\"op1\">(操作說明)<img id=\"imgbook\" align=\"absmiddle\" border=\"0\" alt=\"HELP\" src=\"../images/bookclose.gif\"/></a>";

            MenuPath += "　<a id=\"abook\" class=\"op1\">(操作說明)<img id=\"imgbook\" align=\"absmiddle\" border=\"0\" alt=\"HELP\" src=\"../images/bookclose.gif\"/></a>";


            liProgComment.Text = GET_ProgramComment(strProgramID);
            lblProgName.Text = MenuPath;
        }
        // 變更Root顏色
        string RootMenuItme = GET_RootProgramID(strProgramID);
        if (RootMenuItme != "")
        {
            string jScript = String.Format("$(\"#{0}\").css(\"color\",\"#ff0066\");", RootMenuItme);
            MessageBox.Run(this, jScript);
        }
    }

    protected void lbLogout_Click(object sender, EventArgs e)
    {
        MessageBox.Show(this, JavaScript.GetMessageBox("帳號已登出。", "", "../" + ConfigurationManager.AppSettings["LoginPage"]));
        Session.Abandon();
        Response.Redirect("../SW_CFM_LOGIN.ASPX");
    }
}
