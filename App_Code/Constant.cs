using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Constrant 的摘要描述
/// </summary>

public static class Constant
{

}
public class JSONClass
{
    public class SectionStrct
    {
        public int Head { get; set; }
        public int Tail { get; set; }
        public int Count { get; set; }
        public DateTime Sdate { get; set; }
        public DateTime Edate { get; set; }
        public int Skip { get; set; }
        public int PageSize { get; set; }
    }
    public class A06_C08_Parameter
    {
        public string card { get; set; }
        public string Year { get; set; }
        public string DEPT { get; set; }
        public string Name { get; set; }
        public JSONClass.JSON_EDU_PAGE MODES { get; set; }
        //public JSONClass.JSON_EDU_PAGE models { get; set; }
        //public List<object> listResult { get; set; }

    }
    public class JSON_EDU_PAGE
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

    public class JSON_EDU_BASCODE
    {
        public string HISSYSCODE { get; set; }
        public string HISSYSCODENM { get; set; }
    }

    public class JSON_EDU_BASCODE_3
    {
        public string HISSYSCODE { get; set; }
        public string HISSYSCODE_II { get; set; }
        public string HISSYSCODENM_II { get; set; }
    }

    public class JSON_EDU_INTERN
    {
        //public string NIDNO { get; set; }
        public string INTERN_STUDENT_ID { get; set; }
        public string INTERN_NAMEC { get; set; }
        public string INTERNSHIP_DEPT { get; set; }
        public string INTERNSHIP_DEPTC { get; set; }
        public string SEX { get; set; }
        public string NIDNO { get; set; }
        public string INTERN_DAYS { get; set; }
    }
    public class JSON_EDU_CAL_LEAVEDAYS
    {
        public string ANNUAL_LEAVE { get; set; }
        public string MARRY_LEAVE { get; set; }
        public string MATERNITY_LEAVE { get; set; }
        public string PATERNITY_LEAVE { get; set; }
        public string PREMATERNITY_LEAVE { get; set; }
    }
    public class JSON_CFM_A01_C02
    {
        public string SCHOOL_ID { get; set; }
        public string SCHOOL_NAME { get; set; }
        public string PROCDATETIME { get; set; }
        public string PROCID { get; set; }
        public string PROCNMC { get; set; }
    }

    public class JSON_EDU_A01_C09
    {
        public string TITLE_ID { get; set; }
        public string TITLE_NAME { get; set; }
        public string PROCDATETIME { get; set; }
        public string PROCID { get; set; }
        public string PROCNMC { get; set; }
    }

    public class JSON_EDU_A01_C03
    {
        public string EMERGENCY_RELATIONSHIP_ID { get; set; }
        public string EMERGENCY_RELATIONSHIP_NAME { get; set; }
        public string PROCDATETIME { get; set; }
        public string PROCID { get; set; }
        public string PROCNMC { get; set; }
    }

    public class JSON_CFM_A02_C01
    {
        public string INTERN_STUDENT_ID { get; set; }
        public string TITLE_ID { get; set; }
        public string TITLE_NAME { get; set; }
        public string SCHOOL_ID { get; set; }
        public string SCHOOL_NAME { get; set; }
        public string STUDENT_ID { get; set; }
        public string SCHOOL_DEPT { get; set; }
        public string SCHOOL_SYSTEM { get; set; }
        public string SCHOOL_GRADE { get; set; }
        public string INTERN_NAMEC { get; set; }
        public string INTERN_NAME { get; set; }
        public string NIDNO { get; set; }
        public string SEX { get; set; }
        public string BIRTHDAY { get; set; }
        public string ADDRESS { get; set; }
        public string EMAIL { get; set; }
        public string INTERNSHIP_DEPT_P { get; set; }
        public string INTERNSHIP_DEPT { get; set; }
        public string PRIVATE_PHONE { get; set; }
        public string CHECK_IN_DATE { get; set; }
        public string CHECK_OUT_DATE { get; set; }
        public string PRACTICE_ITEMS { get; set; }
        public string INTERN_DAYS { get; set; }
        public string INTERN_HOURS { get; set; }
        public string EMERGENCY_CONTACT { get; set; }
        public string EMERGENCY_PHONE { get; set; }
        public string EMERGENCY_RELATIONSHIP { get; set; }
        public string MEMORY { get; set; }
        public string PROCDATETIME { get; set; }
        public string PROCID { get; set; }
        public string PROCNMC { get; set; }
        public string CARDNO { get; set; }
        //public string CREATEDATETIME { get; set; }
        //public string CREATEID { get; set; }
        //public string CREATENMC { get; set; }
    }

    public class JSON_BATCH_EDU_A02_C02
    {
        public List<JSON_EDU_A02_C02> models { get; set; }
    }

    public class JSON_EDU_A02_C02
    {
        public string INTERN_STUDENT_ID { get; set; }
        public string TITLE_ID { get; set; }
        public string TITLE_NAME { get; set; }
        public string SCHOOL_ID { get; set; }
        public string SCHOOL_NAME { get; set; }
        public string STUDENT_ID { get; set; }
        public string SCHOOL_DEPT { get; set; }
        public string SCHOOL_SYSTEM { get; set; }
        public string SCHOOL_GRADE { get; set; }
        public string INTERN_NAMEC { get; set; }
        public string INTERN_NAME { get; set; }
        public string NIDNO { get; set; }
        public string SEX { get; set; }
        public string SEXC { get; set; }
        public string BIRTHDAY { get; set; }
        public string ADDRESS { get; set; }
        public string EMAIL { get; set; }
        public string INTERNSHIP_DEPT_P { get; set; }
        public string INTERNSHIP_DEPT { get; set; }
        public string PRIVATE_PHONE { get; set; }
        public string CHECK_IN_DATE { get; set; }
        public string CHECK_OUT_DATE { get; set; }
        public string PRACTICE_ITEMS { get; set; }
        public string INTERN_DAYS { get; set; }
        public string INTERN_HOURS { get; set; }
        public string EMERGENCY_CONTACT { get; set; }
        public string EMERGENCY_PHONE { get; set; }
        public string EMERGENCY_RELATIONSHIP { get; set; }
        public string EMERGENCY_RELATIONSHIPC { get; set; }
        public string MEMORY { get; set; }
        public string CARDNO { get; set; }
    }

    public class JSON_EDU_A03_C01
    {
        public string INTERN_STUDENT_ID { get; set; }
        public string INTERN_NAMEC { get; set; }
        public string NIDNO { get; set; }
        public string LEAVE_SEQ { get; set; }
        public string LEAVE_TYPE { get; set; }
        public string LEAVE_TYPEC { get; set; }
        public string LEAVE_SDTTM { get; set; }
        public string LEAVE_EDTTM { get; set; }
        public string LEAVE_DAYS { get; set; }
        public string LEAVE_HOURS { get; set; }
        public string LEAVE_STATUS { get; set; }
        public string LEAVE_STATUSC { get; set; }
        public string INTERNSHIP_DEPT { get; set; }
        public string INTERNSHIP_DEPTC { get; set; }
        public string LEAVE_REASON { get; set; }
        public string AGENT_CARDNO { get; set; }
        public string AGENT_NAME { get; set; }
        public string AGENT_TEL { get; set; }
        public string INSPECT_CARDNO { get; set; }
        public string INSPECT_NAMEC { get; set; }
        public string INSPECT_DATE { get; set; }
        public string HIDDEN_FILENAME { get; set; }
    }

    public class JSON_EDU_UPLOADFILE
    {
        public string FUNCTION_NAME { get; set; }
        public string FUNCTION_KEY { get; set; }
        public string FILE_SEQ { get; set; }
        public string FILENAME_ORIGIN { get; set; }
        public string FILENAME_RENAME { get; set; }
    }
    public class JSON_GetClassesSubtotal
    {
        public string ClassesSubtotal { get; set; }
        public string ClassesSubtotalVal { get; set; }
        public string ClassSubtotalDownNa { get; set; }

    }
    public class JSON_CLINCAL_Sum_Year
    {
        public string CLINCAL_Sum_Year { get; set; }
    }
    public class JSON_BATCH_EDU_A04_C01
    {
        public List<JSON_EDU_A04_C01> models { get; set; }
    }
    public class JSON_EDU_A04_C01
    {
        public string NIDNO { get; set; }
        public string CARDNO { get; set; }
        public string FACULTY_TYPE { get; set; }
        public string PK_FACULTY_TYPE { get; set; }
        public string FACULTY_TYPEC { get; set; }

        public string SUBMITTAL_SCHOOL_ID { get; set; }
        public string SUBMITTAL_SCHOOL_NAME { get; set; }
        public string SENIORITY_FROM { get; set; }
        public string PK_SENIORITY_FROM { get; set; }
        public string SUBMITTAL_SCHOOL_NAMEC { get; set; }
        public string NAMEC { get; set; }
        public string DEPTNO { get; set; }
        public string REGISTR_PRACTICE { get; set; }
        public string TITLE { get; set; }
        public string TITLE2 { get; set; }
        public string EMAIL { get; set; }
        public string PSLVDT_DATE { get; set; }
        public string PERSONAL_STATUS { get; set; }
        public string PERSONAL_STATUSC { get; set; }
        public string DEPTOFACULTY_TYPE { get; set; }
        public string DEPTOFACULTY_TYPEC { get; set; }
    }

    public class JSON_BATCH_EDU_A04_C02
    {
        public List<JSON_EDU_A04_C02> models { get; set; }
    }
    public class JSON_EDU_A04_C02
    {
        //NIDNO, YEAR, PLAN_CATEGORY
        public string NIDNO { get; set; }
        public string CARDNO { get; set; }
        public string NAMEC { get; set; }
        public string DEPTNO { get; set; }
        public string YEAR { get; set; }
        public string PK_YEAR { get; set; }
        public string PLAN_CATEGORY { get; set; }
        public string PK_PLAN_CATEGORY { get; set; }
        public string PLAN_CATEGORYC { get; set; }
        public string TITLE { get; set; }
        public string TITLE2 { get; set; }
        public string TITLE_NAME { get; set; }
        public string TITLE_NAMEC { get; set; }
        public string NOTE { get; set; }
    }

    public class JSON_EDU_A04_C02_Detail
    {
        public string ATRAININGTERM { get; set; }
        public string ABELONGSCHOOLID { get; set; }
        public string ASTARTTRDATE { get; set; }
        public string ASTOPTRDATE { get; set; }
        public string ANAME { get; set; }
    }
    public class JSON_BATCH_EDU_A04_C03
    {
        public List<JSON_EDU_A04_C03> models { get; set; }
    }
    public class JSON_EDU_A04_C03
    {
        public string NIDNO { get; set; }
        public string CARDNO { get; set; }
        public string FACULTY_TYPE { get; set; }
        public string FACULTY_TYPEC { get; set; }
        public string CLINICAL_FACULTY_NO { get; set; }
        public string PK_CLINICAL_FACULTY_NO { get; set; }
        public string CERTIFICATION_NO { get; set; }
        public string TRAINED_END_DATE { get; set; }
        public string NAMEC { get; set; }
        public string DEPTNO { get; set; }
        public string EMAIL { get; set; }
        public string TITLE { get; set; }
        public string CERTIFICATION_START_DATE { get; set; }
        public string CERTIFICATION_END_DATE { get; set; }
        public string SENIOR_YN { get; set; }
        public string SENIORC { get; set; }
        public string PERSONNEL_STATUS { get; set; }
        public string PERSONNEL_STATUSC { get; set; }
        public string vseffectivedate { get; set; }
        public string gmt_trainingyear { get; set; }
        public string gmt_certificate { get; set; }
        public string specialistqualificationyn { get; set; }
        public string SENIOR_CLASS_ID { get; set; }
        public string SENIOR_CLASS_CN { get; set; }

    }
    public class JSON_BATCH_EDU_A04_C04
    {

        public List<JSON_EDU_A04_C04> models { get; set; }
    }

    public class JSON_EDU_A04_C04
    {
        public string AWARD_SEQ { get; set; }
        public string NIDNO { get; set; }
        public string CARDNO { get; set; }
        public string NAMEC { get; set; }
        public string DEPTNO { get; set; }
        public string DEPT_NAMEC { get; set; }
        public string AWARD_ID { get; set; }
        public string AWARD_NAMEC { get; set; }
        public string YEAR { get; set; }
        public string TITLE { get; set; }
        public string BONUS { get; set; }
    }
    //AWARD_NAMEC
    public class JSON_EDU_A04_C04_AWARD_NAMEC
    {
        public string AWARD_NAMEC { get; set; }
        public string Count_AWARD_NAMEC { get; set; }
    }

    public class JSON_EDU_A05_C01
    {
        public string YEAR { get; set; }
        public string SOURCE_FROM { get; set; }
        public string CLASSDATE { get; set; }
        public string LECTURER { get; set; }
        public string CARDNO { get; set; }
        public string NIDNO { get; set; }
        public string TITLE { get; set; }
        public string TITLE2 { get; set; }
        public string FIRST_DEPT_ID { get; set; }
        public string FIRST_DEPT_NAME { get; set; }
        public string CLASSNAME { get; set; }
        public string HOURS { get; set; }
        public string TYPE { get; set; }
        public string TRAINING_COURSE { get; set; }
        public string LOCATION { get; set; }
        public string DEPT { get; set; }

    }
    public class teacherTraining
    {
        public string DEPT { get; set; }
        public string TITLE { get; set; }
        public string CARD { get; set; }
        public string NAME { get; set; }
        public string SUMTIMES { get; set; }
    }
    public class tTLectHour
    {
        public string NAME { get; set; }
        public string HOUR { get; set; }
    }
    public class JSON_BATCH_EDU_A05_C02
    {
        public List<JSON_EDU_A05_02> models { get; set; }

    }
    public class JSON_EDU_A05_02
    {
        public string YEAR { get; set; }
        public string DEPT { get; set; }
        public string RECEIVE_DOC_NO { get; set; }
        public string RECEIVE_DOC_SEQ { get; set; }
        public string RECEIVE_DOC_DATE { get; set; }
        public string DOC_FROM_INSTITUTION { get; set; }
        public string SPEECH_SUBJECT { get; set; }
        public string MAIN_CATEGORY { get; set; }
        public string MAIN_CATEGORYC { get; set; }
        public string SECONDARY_CATEGORY { get; set; }
        public string SECONDARY_CATEGORYC { get; set; }
        public string NOTE { get; set; }
        public string SPEECH_DATE { get; set; }
        public string SPEECH_START_TIME { get; set; }
        public string SPEECH_END_TIME { get; set; }
        public string SPEECH_PLACE { get; set; }
        public string SPEECHER_ID { get; set; }
        public string SPEECHER { get; set; }
        public string SPEECHER_TITLE { get; set; }
        public string BACK_DATE { get; set; }
        public string LEAVE_TYPE { get; set; }
        public string LEAVE_TYPEC { get; set; }

        public List<JSON_EDU_A05_C02_SPEECHER> speecherDetail { get; set; }

        public List<JSON_EDU_A05_C02_SPEECHDT> speechdt { get; set; }
    }

    public class JSON_EDU_A05_C02_SPEECHER
    {
        public string SPEECHER_ID { get; set; }
        public string SPEECHER { get; set; }
        public string SPEECHER_TITLE { get; set; }
        public string RECEIVE_DOC_NO { get; set; }
        public string RECEIVE_DOC_SEQ { get; set; }
    }

    public class JSON_EDU_A05_C02_SPEECHDT
    {
        public string SPEECH_DATE { get; set; }
        public string SPEECH_START_TIME { get; set; }
        public string SPEECH_END_TIME { get; set; }
        public string SPEECH_PLACE { get; set; }
        public string BACK_DATE { get; set; }
        public string RECEIVE_DOC_NO { get; set; }
        public string RECEIVE_DOC_SEQ { get; set; }
    }

    public class JSON_BATCH_EDU_A05_C03
    {

        public List<JSON_EDU_A05_C03> models { get; set; }
    }

    public class JSON_EDU_A05_C03
    {
        public string OUT_CLASS_SEQ { get; set; }
        public string NIDNO { get; set; }
        public string CARDNO { get; set; }
        public string NAMEC { get; set; }
        public string DEPTNO { get; set; }
        public string TITLE { get; set; }
        public string SCHOOL_ID { get; set; }
        public string SCHOOL_NAME { get; set; }
        public string SCHOOL_DEPT { get; set; }
        public string SUBJECT { get; set; }
        public string PERIOD { get; set; }
        public string HOURS { get; set; }
        public string LEAVE_TYPE { get; set; }
        public string SCHOOL_YEAR { get; set; }
        public string SEMESTER { get; set; }
        public string CONFIRM_DATE { get; set; }
        public string TRACE1 { get; set; }
        public string TRACE2 { get; set; }

        public string REFERENCE_NO { get; set; }
    }

    public class JSON_BATCH_EDU_A05_C04
    {

        public List<JSON_EDU_A05_C04> models { get; set; }
    }
    public class JSON_EDU_A05_C04
    {
        public string YEAR { get; set; }
        public string OSCE_SEQ { get; set; }
        public string DEPTNO { get; set; }
        public string NIDNO { get; set; }
        public string CARDNO { get; set; }
        public string TRAINING_DATE { get; set; }
        public string FACULTY_TYPE { get; set; }
        public string FACULTY_TYPEC { get; set; }
        public string TITLE2 { get; set; }
        public string WORKSHOP { get; set; }
        public string TRAINING_COURSE { get; set; }
        public string NAMEC { get; set; }
        public string TRAINING_OBJECT { get; set; }
        public string TRAINING_OBJECTC { get; set; }
        public string HOURS { get; set; }
        public string SATISFACTION_RATE { get; set; }
        public string SPONSOR { get; set; }
        public string SPONSORC { get; set; }
        public string SPONSOR_NAME { get; set; }
    }
    public class JSON_EDU_A06_C01
    {
        public string NIDNO { get; set; }
        public string FACULTY_TYPE { get; set; }
        public string SUBMITTAL_SCHOOL_ID { get; set; }
        public string SENIORITY_FROM { get; set; }
        public string SUBMITTAL_SCHOOL_NAMEC { get; set; }
        public string PERSONAL_STATUS { get; set; }
        public string CARDNO { get; set; }
        public string FACULTY_TYPEC { get; set; }
        public string SUBMITTAL_SCHOOL_NAME { get; set; }
        public string NAMEC { get; set; }
        public string DEPTNO { get; set; }
        public string REGISTR_PRACTICE { get; set; }
        public string TITLE { get; set; }
        public string TITLE2 { get; set; }
        public string PSLVDT_DATE { get; set; }
        public string PERSONAL_STATUSC { get; set; }
    }
    public class JSON_EDU_A06_C08
    {
        public string Year { get; set; }
        public string Name { get; set; }
        public string cardno { get; set; }
        public string deptNa { get; set; }
        public string Titile { get; set; }
        public string Title2 { get; set; }
        public string HOURS { get; set; }
    }

    public class JSON_CFM_A01_Q01
    {
        public string FORM_ID { get; set; }
        public string APPLY_YYYY { get; set; }
        public string APPLY_SEQ { get; set; }
        public string UNIQUE_ID { get; set; }
        public string CREATE_USER_ID { get; set; }
        public string CREATE_NAMEC { get; set; }
        public string APPLY_STATUS { get; set; }
        public string STATUS_DESCRIPTION { get; set; }
        public string CREATE_DTTM { get; set; }
        public string FUNCTION_NAME { get; set; }
        public string MODIFIED_REASONS { get; set; }
        public string MODIFIED_CONTENTS { get; set; }
        public string MODIFIED_BENEFITS { get; set; }
        public string APPLY_TEL { get; set; }
        public string APPLY_DEPT { get; set; }
        public string DEPTNM { get; set; }
        public string EXPECTATION_DT { get; set; }
        public string FILESNM { get; set; }
    }
    public class JSON_CFM_A01_C01
    {
        public string FORM_ID { get; set; }
        public string FORM_VERSION { get; set; }
        public string APPLY_YYYY { get; set; } 
        public string APPLY_SEQ { get; set; }
        public string APPLY_STATUS { get; set; }
        public string APPLY_DEPT { get; set; }
        public string APPLY_ID { get; set; }
        public string APPLY_NAMEC { get; set; }
        public string APPLY_TEL { get; set; }
        public string FUNCTION_NAME { get; set; }
        public string MODIFIED_REASONS { get; set; }
        public string MODIFIED_CONTENTS { get; set; }
        public string MODIFIED_BENEFITS { get; set; }
        public string SCHEDULE_OPTION { get; set; }
        public string EXPECTATION_DT { get; set; }
    }
    public class JSON_CFM_A02_M01
    {
        public string APPLY_STATUS { get; set; }
        public string STATUS_DESCRIPTION { get; set; }
        public string LAST_EDIT_DTTM { get; set; }
        public string LAST_EDIT_USER_ID { get; set; }
        public string LAST_EDIT_USER_NAMEC { get; set; }
    }
    public class JSON_CFM_UPLOADFILE
    {
        public string FUNCTION_NAME { get; set; }
        public string FUNCTION_KEY { get; set; }
        public string FILE_SEQ { get; set; }
        public string FILENAME_ORIGIN { get; set; }
        public string FILENAME_RENAME { get; set; }
    }
}