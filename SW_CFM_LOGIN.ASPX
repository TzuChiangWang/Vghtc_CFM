<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SW_CFM_LOGIN.ASPX.cs" Inherits="SW_CFM_LOGIN" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <!-- KENDO UI CSS -->
    <link href="CSS/kendo.common.min.css" rel="stylesheet" />
    <link href="CSS/kendo.default.min.css" rel="stylesheet" />
    <!-- BOOTSTRAP AND SHARED CSS -->
    <link href="CSS/style.css" rel="stylesheet" />
    <!-- SHARED JS -->
    <script src="JAVASCRIPT/jquery.min.js"></script>
    <script src="JAVASCRIPT/bootstrap.min.js"></script>
    <script src="JAVASCRIPT/jquery.blockUI.js"></script>
    <script src="JAVASCRIPT/jquery.maskedinput.js"></script>
    <script src="JAVASCRIPT/jquery.ui.core.js"></script>
    <script src="JAVASCRIPT/jquery.validate.min.js"></script>
    <script src="JAVASCRIPT/jquery.vghtc.js"></script>
    <!-- KENDO UI JS -->
    <script src="JAVASCRIPT/kendo.all.min.js"></script>
    <!--[if lt IE 9]>
      <script src="JAVASCRIPT/html5shiv.js"></script>
    <![endif]-->
    <script src="JAVASCRIPT/function.js"></script>
    <script type="text/javascript">
        $(function () {
            var login = $('#login');
            var h = login.height();
            var t = 221 - (h / 2);
            login.css('top', t);

            $('input:text').bind('keypress', function () {
                return LoginButton(event, 'btnLogin');
            });

            $('#banner div').eq(1).width($('#banner div').eq(0).width());
        });

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="container">
            <div id="banner">
                <img src="images/Banner.jpg" alt="*" />
                <div style="top: 20px;"><span style="font: bold 18pt '微軟正黑體';">臺中榮民總醫院．<%=sSystemNM %></span></div>
                <div style="top: 35px;">
                    <hr style="border: 1px solid #c0c0c0;" />
                </div>
                <div style="top: 60px;"><span style="font-family: Georgia; font-size: 12pt;">Taichung Veterans General Hospital</span></div>
            </div>
            <div class="bar"></div>
            <div id="body">
                <table id="login" class="table">
                    <thead>
                        <tr>
                            <td colspan="2">
                                <img src="images/login_title.gif" alt="*" /></td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <div class="input-group">
                                    <span class="input-group-addon">卡號</span>
                                    <asp:TextBox ID="txtUserID" CssClass="form-control required" required TabIndex="1" runat="server" />
                                </div>
                            </td>
                            <td rowspan="2" style="vertical-align: middle;">
                                <asp:Button ID="btnLogin" CssClass="btn btn-primary" Text="登入" TabIndex="3" runat="server" OnClick="btnLogin_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="input-group">
                                    <span class="input-group-addon">密碼</span>
                                    <asp:TextBox ID="txtPassword" CssClass="form-control required" required TextMode="Password" TabIndex="2" runat="server" />
                                </div>

                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="bar"></div>
            <div id="footer">
                <img src="images/Footer.jpg" alt="*" />
            </div>
        </div>
    </form>
</body>
</html>
