using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Web.UI;
using dmxDataObject;
using dmxJson;
using dmxUserInterface;
using dmxUtils;
using dmxDataAccess;
using System.Data;

public partial class SW_CFM_LOGIN : uiQuery
{

    private string getWelcome()
    {

        int intHour = DateTime.Now.Hour;
        string strWelcome = "";
        if (intHour >= 6 && intHour <= 11)
        {
            strWelcome = "早安!";
        }
        else if (intHour >= 12 && intHour <= 16)
        {
            strWelcome = "午安!";
        }
        else
        {
            strWelcome = "晚安!";
        }
        return strWelcome;
    }

    private void LocationHref(string login_method)
    {
        if (login_method == "logineip")
        {
            string strWelcome = this.getWelcome();
            if (sCurrentUrl != "" && base.ProgramID != "LOGIN")
            {
                MessageBox.Show(this, JavaScript.GetHref(sCurrentUrl));
            }
            else
            {
                MessageBox.Show(this, JavaScript.GetHref("AP/" + sProgramUrl));
            }
        }
        else
        {
            string strWelcome = this.getWelcome();
            if (sCurrentUrl != "" && base.ProgramID != "LOGIN")
            {
                MessageBox.Show(this, JavaScript.GetMessageBox(sUserNM + ",登入成功。", "[提示訊息:::" + strWelcome + "]", sCurrentUrl));
            }
            else
            {
                MessageBox.Show(this, JavaScript.GetMessageBox(sUserNM + ",登入成功。", "[提示訊息:::" + strWelcome + "]", "AP/" + sProgramUrl));
            }
        }

    }

    protected void Page_Init(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            #region 抓網站基本資料
            String sSystemID = ConfigurationManager.AppSettings["VGHTC.SystemID"].ToUpper();
            String sProductionYN = ConfigurationManager.AppSettings["ProductionYN"].ToUpper();
            Session[doSession.SystemID] = sSystemID;
            Session[doSession.LoginPage] = ConfigurationManager.AppSettings["LOGINPAGE"].ToUpper();
            Session[doSession.ProductionYN] = sProductionYN;
            JsonUtils jUtils = new JsonUtils() { SystemID = sSystemID, ProductionYN = sProductionYN };//Y是正式機，N是測試機
            jUtils.GET_SYSTEMJSON();
            SystemJson sysJson = jUtils.System;
            if (sysJson != null && sysJson.SRESULT == "TRUE")
            {
                Session[doSession.SystemNM] = sysJson.SYSTEMNM;
                Session[doSession.IconURL] = sysJson.ICONURL;
                Session[doSession.AuthMode] = sysJson.AUTHMODE;
            }
            #endregion
        }
    }
    private void CheckInThroughRate(string CardNo)
    {
        using (OracleDataSource OraDB = new OracleDataSource("VGHTC.EDU.ConnStr"))
        {
            try
            {
                Utility ul = new Utility();
                string ulSeq = ul.GetSeqNo("", "EDU_CLICK_THROUGH_RATE", "CLICK_SEQ", 4, 6, OraDB);
                OraDB.InsertCommand = @"insert into EDU_CLICK_THROUGH_RATE(CLICK_SEQ,LOGINDate,CARDNO) 
                                        values(:CLICK_SEQ,TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),:CARDNO)";
                OraDB.InsertParameters.Add("CLICK_SEQ", ulSeq);
                if (CardNo.Equals("EDUINTERN")) CardNo = CardNo.Substring(0, 5);
                OraDB.InsertParameters.Add("CARDNO", CardNo);
                OraDB.Insert();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
    protected override void Page_Load(object sender, EventArgs e)
    {
        base.isAuthPage = false;
        base.ProgramID = "LOGIN";
        base.Page_Load(sender, e);
        WebParamaters WPS = new WebParamaters();
        string sessionid = WPS.getKeys("SessionID");
        if (sessionid != "")
        {
            logineip();
        }
        //else if (Session["USERID"]!= null)
        //{
        //    Session.Clear();
        //}

    }

    private void logineip()
    {
        WebParamaters WPS = new WebParamaters();

        string userid = WPS.getKeys("userid");
        string sessionid = WPS.getKeys("sessionid");

        JsonUtils jUtils = new JsonUtils() { SystemID = sSystemID, UserID = userid, SessionID = sessionid, CommentYN = true, ProductionYN = sProductionYN }; //Y是正式機，N是測試機
        jUtils.GET_EIPUSERJSON();
        UserJson userJson = jUtils.User;
        if (userJson != null && userJson.SRESULT == "TRUE")
        {
            Session[doSession.UserID] = userJson.USERID;
            Session[doSession.UserNM] = userJson.USERNM;
            Session[doSession.DeptID] = userJson.DEPTID;
            Session[doSession.DeptNM] = userJson.DEPTNM;
            Session[doSession.UnitID] = userJson.UNITID;
            Session[doSession.UnitNM] = userJson.UNITNM;
            Session[doSession.UserTel] = userJson.USERTEL;
            Session[doSession.UserPhone] = userJson.USERPHONE;
            Session[doSession.UserEmail] = userJson.USEREMAIL;
            Session[doSession.GroupID] = userJson.GROUPIDS[0].GROUPID;
            Session[doSession.ProgramID] = userJson.PROGRAMID;
            Session[doSession.DEPTS] = userJson.DEPTS;
            //if (userJson.GROUPIDS[0].GROUPID != "EDUCC")
            //{
            Session[doSession.ProgramUrl] = userJson.PROGRAMURL;
            //}
            //else
            //{
            //    Session[doSession.ProgramUrl] = "SW_RBM_A02_C10.aspx";
            //}

            List<SortedList> lstAuthPrograms = new List<SortedList>();
            doProgramBasic _doProgramBasic = new doProgramBasic();
            foreach (ProgramJson PJ in userJson.PROGRAMIDS)
            {
                SortedList slAuthProgramID = new SortedList();
                lstAuthPrograms.Add(slAuthProgramID);
                slAuthProgramID.Add(_doProgramBasic.ProgramID, PJ.PROGRAMID);
                slAuthProgramID.Add(_doProgramBasic.ProgramNM, PJ.PROGRAMNM);
                slAuthProgramID.Add(_doProgramBasic.ParentID, PJ.PARENTID);
                slAuthProgramID.Add(_doProgramBasic.ProgramUrl, PJ.PROGRAMURL);
                slAuthProgramID.Add(_doProgramBasic.ProgramTarget, PJ.PROGRAMTARGET);
                slAuthProgramID.Add(_doProgramBasic.SubProgramYN, PJ.SUBPROGRAMYN);
                slAuthProgramID.Add(_doProgramBasic.ProgramComment, PJ.PROGRAMCOMMENT);
                slAuthProgramID.Add(_doProgramBasic.Priority, PJ.PRIORITY);
                slAuthProgramID.Add(_doProgramBasic.InsertYN, PJ.OPERATION.INSERTYN);
                slAuthProgramID.Add(_doProgramBasic.UpdateYN, PJ.OPERATION.UPDATEYN);
                slAuthProgramID.Add(_doProgramBasic.DeleteYN, PJ.OPERATION.DELETEYN);
                slAuthProgramID.Add(_doProgramBasic.QueryYN, PJ.OPERATION.QUERYYN);
                slAuthProgramID.Add(_doProgramBasic.PrintYN, PJ.OPERATION.PRINTYN);
            }
            Session[doSession.AuthPrograms] = lstAuthPrograms;

            SortedList slAuthGroups = new SortedList();
            foreach (GroupJson GJ in userJson.GROUPIDS)
            {
                slAuthGroups.Add(GJ.GROUPID, GJ.GROUPNM);
            }
            Session[doSession.AuthGroups] = slAuthGroups;
            LocationHref("logineip");
        }
        else
        {
            MessageBox.Show(this, JavaScript.GetMessageBox(userJson.SMESSAGE, "", sLoginPage));
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        ////for 實習生登入
        //DataTable dtUser = new DataTable();
        //using (OracleDataSource OraDB = new OracleDataSource("VGHTC.EDU.ConnStr"))
        //{
        //    //驗證身分，取最新的一筆
        //    OraDB.SelectCommand = @"
        //        SELECT *
        //          FROM (SELECT RANK() OVER(ORDER BY T.CHECK_IN_DATE DESC) RANK,
        //                       T.INTERN_STUDENT_ID,
        //                       T.NIDNO,
        //                       T.INTERN_NAMEC,
        //                       T.INTERNSHIP_DEPT,
        //                       T1.NAME,
        //                       T.PRIVATE_PHONE,
        //                       T.EMAIL
        //                  FROM EDU_INTERN_BASIC T
        //                 INNER JOIN COMMON.EDEPT_VGHTC T1 ON T.INTERNSHIP_DEPT = T1.DEPTNO
        //                 WHERE T.NIDNO = :NIDNO
        //                   AND T.BIRTHDAY = :BIRTHDAY)
        //         WHERE RANK = 1 ";

        //    OraDB.SelectParameters.Add("NIDNO", txtUserID.Text);
        //    OraDB.SelectParameters.Add("BIRTHDAY", txtPassword.Text);
        //    dtUser = OraDB.Select();
        //    OraDB.Dispose();
        //}
        ////若為實習生，統一取得實習生權限
        //if (dtUser.Rows.Count > 0)
        //{
        //    txtUserID.Text = "EDUINTERN";
        //    txtPassword.Text = "EDUINTERN";
        //}

        JsonUtils jUtils = new JsonUtils() { SystemID = sSystemID, UserID = txtUserID.Text, Password = txtPassword.Text, CommentYN = true, ProductionYN = sProductionYN }; //Y是正式機，N是測試機
        jUtils.GET_USERJSON();
        UserJson userJson = jUtils.User;
        if (userJson != null && userJson.SRESULT == "TRUE")
        {
            //    //20170109 add UserLoginSysDate By YfLiang
            //    //CheckInThroughRate(userJson.USERID);

            //    if (dtUser.Rows.Count > 0)
            //    {
            //        //實習生資料
            //        DataRow drUser = dtUser.Rows[0];
            //        Session[doSession.UserID] = drUser["INTERN_STUDENT_ID"];
            //        Session[doSession.UserNM] = drUser["INTERN_NAMEC"];
            //        Session[doSession.DeptID] = drUser["INTERNSHIP_DEPT"];
            //        Session[doSession.DeptNM] = drUser["NAME"];
            //        Session[doSession.UnitID] = drUser["INTERNSHIP_DEPT"];
            //        Session[doSession.UnitNM] = drUser["NAME"];
            //        Session[doSession.UserTel] = drUser["PRIVATE_PHONE"];
            //        Session[doSession.UserPhone] = drUser["PRIVATE_PHONE"];
            //        Session[doSession.UserEmail] = drUser["EMAIL"];
            //    }
            //    else
            //    {
            Session[doSession.UserID] = userJson.USERID;
                Session[doSession.UserNM] = userJson.USERNM;
                Session[doSession.DeptID] = userJson.DEPTID;
                Session[doSession.DeptNM] = userJson.DEPTNM;
                Session[doSession.UnitID] = userJson.UNITID;
                Session[doSession.UnitNM] = userJson.UNITNM;
                Session[doSession.UserTel] = userJson.USERTEL;
                Session[doSession.UserPhone] = userJson.USERPHONE;
                Session[doSession.UserEmail] = userJson.USEREMAIL;
            //}
            Session[doSession.DEPTS] = userJson.DEPTS;
            Session[doSession.GroupID] = userJson.GROUPIDS[0].GROUPID;
            Session[doSession.ProgramID] = userJson.PROGRAMID;
            //if (userJson.GROUPIDS[0].GROUPID  != "RBM_ASSISTANT")
            //{
            Session[doSession.ProgramUrl] = userJson.PROGRAMURL;
            //}
            //else
            //{
            //    Session[doSession.ProgramUrl] = "SW_RBM_A01_C10.aspx";
            //}


            List<SortedList> lstAuthPrograms = new List<SortedList>();
            doProgramBasic _doProgramBasic = new doProgramBasic();
            foreach (ProgramJson PJ in userJson.PROGRAMIDS)
            {
                SortedList slAuthProgramID = new SortedList();
                lstAuthPrograms.Add(slAuthProgramID);
                slAuthProgramID.Add(_doProgramBasic.ProgramID, PJ.PROGRAMID);
                slAuthProgramID.Add(_doProgramBasic.ProgramNM, PJ.PROGRAMNM);
                slAuthProgramID.Add(_doProgramBasic.ParentID, PJ.PARENTID);
                slAuthProgramID.Add(_doProgramBasic.ProgramUrl, PJ.PROGRAMURL);
                slAuthProgramID.Add(_doProgramBasic.ProgramTarget, PJ.PROGRAMTARGET);
                slAuthProgramID.Add(_doProgramBasic.SubProgramYN, PJ.SUBPROGRAMYN);
                slAuthProgramID.Add(_doProgramBasic.ProgramComment, PJ.PROGRAMCOMMENT);
                slAuthProgramID.Add(_doProgramBasic.Priority, PJ.PRIORITY);
                slAuthProgramID.Add(_doProgramBasic.InsertYN, PJ.OPERATION.INSERTYN);
                slAuthProgramID.Add(_doProgramBasic.UpdateYN, PJ.OPERATION.UPDATEYN);
                slAuthProgramID.Add(_doProgramBasic.DeleteYN, PJ.OPERATION.DELETEYN);
                slAuthProgramID.Add(_doProgramBasic.QueryYN, PJ.OPERATION.QUERYYN);
                slAuthProgramID.Add(_doProgramBasic.PrintYN, PJ.OPERATION.PRINTYN);
            }
            Session[doSession.AuthPrograms] = lstAuthPrograms;

            SortedList slAuthGroups = new SortedList();
            foreach (GroupJson GJ in userJson.GROUPIDS)
            {
                slAuthGroups.Add(GJ.GROUPID, GJ.GROUPNM);
            }
            Session[doSession.AuthGroups] = slAuthGroups;
            LocationHref("btnLogin");
        }
        else
        {
            MessageBox.Show(this, JavaScript.GetMessageBox(userJson.SMESSAGE, "", sLoginPage));
        }
    }
}