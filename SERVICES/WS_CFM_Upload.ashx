<%@ WebHandler Language="C#" Class="WS_CFM_Upload" %>

using System;
using System.Web;
using System.IO;
using dmxUtils;
using dmxUserInterface;
using dmxDataAccess;

public class WS_CFM_Upload : uiAshxCommon
{
    public override void ProcessRequest(HttpContext context)
    {
        if (context.Request.Files.Count > 0)
        {
            string path = context.Server.MapPath("~/UploadFiles");

            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }

            var uploadFile = context.Request.Files[0];

            string fileName;
            string uniqueNM = Guid.NewGuid().ToString();
            int index = 1;
            string fullFileNM;
            string[] files;

            if (HttpContext.Current.Request.Browser.Browser.ToUpper() == "IE")
            {
                files = uploadFile.FileName.Split(new char[] { '\\' });
                fileName = files[files.Length - 1];
                fullFileNM = Path.Combine(path, fileName);
            }
            else
            {
                files = uploadFile.FileName.Split('.');
                fileName = base.sUserID + "_" + index + "." + files[files.Length - 1];
                fullFileNM = Path.Combine(path, fileName);
            }
            while (File.Exists(fullFileNM))
            {
                fileName = base.sUserID + "_" + ++index + "." + files[files.Length - 1];
                fullFileNM = Path.Combine(path, fileName);
            }
            uploadFile.SaveAs(fullFileNM);            
        }
    }
}