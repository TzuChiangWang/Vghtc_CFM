<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AccessDenied.ASPX.cs" Inherits="AccessDenied" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <!-- BOOTSTRAP AND SHARED CSS -->
    <link href="CSS/style.css" rel="stylesheet" />
    <!-- SHARED JS -->
    <script src="/JAVASCRIPT/jquery.min.js"></script>
    <!--[if lt IE 9]>
      <script src="JAVASCRIPT/html5shiv.js"></script>
    <![endif]-->
    <script type="text/javascript">
        $(function () {
            var login = $('#login');
            var h = login.height();
            var t = 221 - (h / 2);
            login.css('top', t);
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
                <table id="login">
                    <tbody>
                        <tr>
                            <td class="text-center">
                                <p style="color: Red; font-family: Impact; font-size: x-large;">
                                    ACCESS DENIED
                                </p>
                                <div style="border: solid 1px #ebebeb; width: 100%;">
                                    <table class="table" style="margin: 2px">
                                        <tr>
                                            <td style="height: 30px; background-color: #ebebeb; color: Red; font-size: medium; text-align: center; letter-spacing: 2px; line-height: 200%;">您不允許操作本頁<br />
                                                按此<a href="javascript:history.back(1);">回上一頁</a>，重新操作
                                            </td>
                                        </tr>
                                    </table>
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
