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

public partial class AP_SW_CFM_A01_C01 : uiQuery
{
    protected override void Page_Load(object sender, EventArgs e)
    {
        base.isAuthPage = true;
        base.ProgramID = "A01C01"; // TODO : 修改成這個程式的Program ID , Ex : SW_TestPrj_A01_Q01 --> A01Q01
        base.Page_Load(sender, e);        
        if (!IsPostBack)
        {

        }        
    }
}