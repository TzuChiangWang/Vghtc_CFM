<%@ WebHandler Language="C#" Class="WS_CFM_Remove" %>

using System;
using System.Web;
using System.IO;
using dmxUtils;
using dmxUserInterface;
using dmxDataAccess;

public class WS_CFM_Remove : uiAshxCommon
{
    public override void ProcessRequest(HttpContext context)
    {
        string path = context.Server.MapPath("~/UploadFiles");
        var uploadFile = context.Request.Files;
        string fileName = "";
        string FullPath = "" + fileName;

        if (File.Exists(FullPath))
        {
            File.Delete(FullPath);
        }
    }
}