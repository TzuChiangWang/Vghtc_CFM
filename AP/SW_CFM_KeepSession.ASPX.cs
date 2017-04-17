using System;
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
using dmxUserInterface;

public partial class SW_CFM_KeepSession : uiQuery
{
    protected override void Page_Load(object sender, EventArgs e)
    {
        base.isAuthPage = false;
        base.ProgramID = "KeepSession";
        base.Page_Load(sender, e);
        Session["KeepSession"] = sCurrentDTTM;
    }
}
