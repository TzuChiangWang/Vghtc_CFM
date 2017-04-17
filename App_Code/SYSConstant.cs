using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// SYS 的class定義
/// </summary>
/// 

    public static class MEM
    {

        public const string SystemID = "MEM";

        public class STATUS
        {
            /// <summary>新增</summary>
            public const string MTAdd = "10";
            /// <summary>已借出</summary>
            public const string LEND = "11";
            /// <summary>已完成保養</summary>
            public const string MTComplete = "30";
            /// <summary>已歸還</summary>
            public const string BACK = "31";
            /// <summary>已審核</summary>
            public const string MTChecked = "40";
            /// <summary>報廢</summary>
            public const string FF = "80";
        }

        public const string SQL_MD_BASIC = @" LEFT OUTER JOIN MGT.MEM_MD_BASIC S ON T.ECRI_CODE = S.ECRI_CODE AND T.MD_SEQ = S.MD_SEQ  ";

        public class MT_TYPE
        {
            /// <summary>一般保養</summary>
            public const string normalMaintain = "NM";
            /// <summary>借出保養</summary>
            public const string lendMaintain = "LM";
            /// <summary>歸還保養</summary>
            public const string returnMaintain = "RM";
        }

        public class MTPERIOD_TYPE
        {
            /// <summary>初級保養</summary>
            public const string First = "F";
            /// <summary>二級保養</summary>
            public const string Second = "S";
            /// <summary>校驗</summary>
            public const string Check = "C";
        }

        public class PERIOD
        {
            /// <summary>免保養</summary>
            public const string PERIOD_N = "N";
            /// <summary>每次</summary>
            public const string PERIOD_T = "T";
            /// <summary>一日三次-早</summary>
            public const string PERIOD_D1 = "D1";
            /// <summary>一日三次-午</summary>
            public const string PERIOD_D2 = "D2";
            /// <summary>一日三次-晚</summary>
            public const string PERIOD_D3 = "D3";       
            /// <summary>每天</summary>
            public const string PERIOD_1D = "1D";
            /// <summary>每週</summary>
            public const string PERIOD_1W = "1W";
            /// <summary>雙週</summary>
            public const string PERIOD_2W = "2W";
            /// <summary>每月</summary>
            public const string PERIOD_1M = "1M";            
            /// <summary>雙月</summary>
            public const string PERIOD_2M = "2M";
            /// <summary>季</summary>
            public const string PERIOD_3M = "3M";
            /// <summary>四個月</summary>
            public const string PERIOD_4M = "4M";
            /// <summary>半年</summary>
            public const string PERIOD_6M = "6M";
            /// <summary>一年</summary>
            public const string PERIOD_1Y = "1Y";    
        }
    }

    public static class sConstant
    {
        public class JSON_PAGE
        {
            public string TAKE { get; set; }
            public string SKIP { get; set; }
            public string PAGE { get; set; }
            public string PAGESIZE { get; set; }
            public List<Sort> SORT { get; set; }
        }

        public class Sort
        {
            public string field { get; set; }
            public string dir { get; set; }
        }
    }

    public static class JSONMGTCODE
    {
        public class MGTCODM
        {
            public string SystemID { get; set; }
            public string SyscodeType { get; set; }
            public string SyscodeNM { get; set; }
            public string PROCDATETIME { get; set; }
            public string PROCID { get; set; }
            public string PROCNMC { get; set; }
            public string CREATEDATETIME { get; set; }
            public string CREATEID { get; set; }
            public string CREATENMC { get; set; }
            public string SyscodeLength { get; set; }
            public List<MGTCODE> MGTCODE { get; set; }
        }

        public class MGTCODE
        {
            public string SystemID { get; set; }
            public string SyscodeType { get; set; }
            public string MGTSysCode { get; set; }
            public string MGTSysCodeNM { get; set; }
            public string MGTSysCodeNME { get; set; }
            public string DisplaySort { get; set; }
            public string MGTCodeMemo { get; set; }
            public string CANCELYN { get; set; }
            public string CANCELDATETIME { get; set; }
            public string CANCELID { get; set; }
            public string CANCELNMC { get; set; }
            public string PROCDATETIME { get; set; }
            public string PROCID { get; set; }
            public string PROCNMC { get; set; }
            public string CREATEDATETIME { get; set; }
            public string CREATEID { get; set; }
            public string CREATENMC { get; set; }
        }
    }