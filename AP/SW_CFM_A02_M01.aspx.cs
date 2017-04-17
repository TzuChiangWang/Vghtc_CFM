using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using dmxJson;
using dmxUserInterface;
using dmxDataObject;
using System.Collections;
using dmxUtils;

public partial class AP_SW_CFM_A02_M01 : uiQuery
{
    protected override void Page_Load(object sender, EventArgs e)
    {
        base.isAuthPage = true;
        base.ProgramID = "A02M01"; // TODO : 修改成這個程式的Program ID , Ex : SW_TestPrj_A01_Q01 --> A01Q01
        base.Page_Load(sender, e);
        if (!IsPostBack)
        {

        }
    }
}