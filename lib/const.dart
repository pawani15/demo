import 'package:Edecofy/Admin/Admin-exammarks.dart';
import 'package:Edecofy/Admin/Adminparentinformation.dart';
import 'package:Edecofy/Admin/Adminstudentinformation.dart';
import 'package:Edecofy/Admin/questionpaper_admin.dart';
import 'package:Edecofy/Classrom_teacher.dart';
import 'package:Edecofy/Classromrecordings_teacher.dart';
import 'package:Edecofy/Student/Classrom_Student.dart';
import 'package:Edecofy/Student/Classromrecordings_student.dart';
import 'package:Edecofy/Student/academic_sylabus_student.dart';
import 'package:Edecofy/Student/attendance-student.dart';
import 'package:Edecofy/Student/class_routine_student.dart';
import 'package:Edecofy/Student/exam_marks_student.dart';
import 'package:Edecofy/Student/home_work_student.dart';
import 'package:Edecofy/Student/library_student.dart';
import 'package:Edecofy/Student/noticeboard_student.dart';
import 'package:Edecofy/Student/online_exam_student.dart';
import 'package:Edecofy/Student/paymet_student.dart';
import 'package:Edecofy/Student/student_transport.dart';
import 'package:Edecofy/Student/study_material.dart';
import 'package:Edecofy/Student/subject_students.dart';
import 'package:Edecofy/Admin/Studentattendancereport.dart';
import 'package:Edecofy/Studentsinvoices.dart';
import 'package:Edecofy/academicsylabus.dart' as prefix0;
import 'package:Edecofy/Admin/homeworklist.dart';
import 'package:Edecofy/Admin/manageattendance-admin.dart';
import 'package:Edecofy/manageattendance-teacher.dart';
import 'package:Edecofy/menu.dart';
import 'package:Edecofy/parent_Subject_wise_attendance.dart';
import 'package:Edecofy/parent_homework.dart';
import 'package:Edecofy/parent_online_view.dart';
import 'package:Edecofy/parent_payment.dart';
import 'package:Edecofy/prrivatemessages.dart';
import 'package:Edecofy/questionpaper_teacher.dart';
import 'package:Edecofy/searchfees.dart';
import 'package:Edecofy/Admin/student-admission.dart';
import 'package:Edecofy/Admin/studentbulkadmission.dart';
import 'package:Edecofy/Admin/studentcollectfees.dart';
import 'package:Edecofy/studentinformation.dart';
import 'package:Edecofy/Admin/studentpromotion.dart';
import 'package:Edecofy/subjects.dart';
import 'package:Edecofy/transport.dart';
import 'package:app_review/app_review.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info/package_info.dart';
import 'Admin/AdminAccountant.dart';
import 'Admin/AdminLibrarybooks.dart';
import 'Admin/AdminMnageonlineexams.dart';
import 'Admin/Admin_manageexams.dart';
import 'Admin/Admin_managegrades.dart';
import 'Admin/Admin_managesubjects.dart';
import 'Admin/Admin_mangesections.dart';
import 'Admin/Createonlineexam.dart';
import 'Admin/ExpenseCategory.dart';
import 'Admin/Expensereport.dart';
import 'Admin/Expenses.dart';
import 'Admin/academicsylabus_Admin.dart';
import 'Admin/admin_manage_profile.dart';
import 'Admin/admin_private_message.dart';
import 'Admin/classroutine_admin.dart';
import 'Admin/lms_add video.dart';
import 'Admin/lms_view.dart';
import 'Admin/tabulation_sheet.dart';
import 'Classroomstream.dart';
import 'Classroomstream.dart';
import 'Managepayments.dart';
import 'Parent/parent_private_messgae.dart';
import 'SharedPreferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'SharedPreferences.dart';
import 'Student/library_book_request.dart';
import 'Student/student_manage_profile.dart';
import 'Student/student_private_message.dart';
import 'Student/Student_QuestionScreen.dart';
import 'Student/sudent_subject_wise_attendance.dart';
import 'Studymaterial.dart';
import 'Teacher/Student_Admission.dart';
import 'Teacher/library_book_details_teachher.dart';
import 'Teacher/manage_subjectwise_attendance.dart';
import 'Teacher/sample.dart';
import 'Teacher/teacher_user_profile.dart';
import 'academicsylabus_teacher.dart';
import 'Admin/balancefeesreport.dart';
import 'bookdetails.dart';
import 'classroutine.dart';
import 'classroutine_teacher.dart';
import 'dashboard.dart';
import 'Admin/feediscounts.dart';
import 'Admin/feescarryforward.dart';
import 'Admin/feetypes.dart';
import 'Admin/fessgroup.dart';
import 'fessmaster.dart';
import 'login.dart';
import 'main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'manage-attendenca.dart';
import 'manage-exammarks.dart';
import 'manage-profile.dart';
import 'marks.dart';
import 'messagesystem.dart';
import 'noticeboard.dart';
import 'teachersinformation.dart';
import 'academicsylabus.dart';
import 'Admin/fessmanagement.dart';

SharedPref sp = new SharedPref();
String AppVersion = "";
String logo = "http://nalanda.edecofy.com/";

Future<String> GetAppversion() async {
  final PackageInfo info = await PackageInfo.fromPlatform();
  AppVersion = info.version.trim();
}

Future<String> Getlogo() async {
  logo = await sp.ReadString("clienturl")+"/";
}

class Constants {
  static bool check = false;
  static String BASE_URL = "https://www.edecofy.com/";
  static String BASE_Demo_URL = "http://demo.edecofy.com/";
  static String Login_Api = "verify_mobile_auth";
  static String Reset_Password_Api = "api_login/reset_password";
  static String Load_Teachers = "api_parents/get_teachers";
  static String Load_AcademicSyllabus = "/api_parents/academic_syllabus/";
  static String Load_Childrens = "api_parents/get_children_ids";
  static String Load_Student_Studymaterial = "/api_students/study_material/";
  static String Load_GeneralDetails = "/api_login/general_details/";
  static String DownloadSyllabus = "api_parents/download_academic_syllabus/";
  static String Manage_Profile ="api_parents/manage_profile/edit_profile_info/";
  static String Manage_Profile_Teacher ="api_teachers/manage_profile/edit_profile_info/";
  static String Load_Noticeboard = logintype == "teacher"
      ? "api_teachers/noticeboard"
      : "api_parents/noticeboard";
  static String Update_profile =
      "api_parents/manage_profile/update_profile_info";
  static String Update_Password = "api_parents/manage_profile/change_password";
  static String Load_Transport = logintype == "teacher"
      ? "api_teachers/transport"
      : "api_parents/transport";
  static String Load_Books_Teacher = "api_teachers/get_books/";
  static String Load_Books_Parent="api_parents/get_books/";
  static String Load_Classroutine = "api_parents/class_routine_day/";
  static String Load_Classroutine_class = "api_parents/class_routine/";
  static String Load_Runningyear = "api_parents/attendance_report/";
  static String Load_AttendanceRunningyear = "api_students/attendance_report_selector/";
  static String Load_Attendencereport =
      "api_parents/attendance_report_selector/";
  static String Load_Student_Attendenceselector =
      "api_students/attendance_report/";
  static String Load_Students_Library="api_students/get_books/";
  static String Load_Payments = "api_parents/invoice/";
  static String Load_Marks = "api_parents/exam_marks/";
  static String Load_Exams = "api_parents/exams_ids/";
  static String Load_Dashboard = "api_parents/dashboard_api/";
  static String Load_Receipents= "api_teachers/message/message_new";
  static String Send_Newmessage = "api_teachers/message/send_new";
  static String Load_Privateusers =  "api_teachers/new_message_users/";
  static String Load_Privateuserschat ="api_teachers/new_message_read/";
  static String Send_Privatechat = "api_teachers/message/send_reply/";
  static String Load_Groupusers = "api_teachers/group_message_display/";
  static String Load_Groupuserschat =  "api_teachers/group_message/group_message_read/";
  static String Send_replyGroupchat = "api_teachers/group_message/send_reply/";
  static String LoadHomeWork_students="api_students/home_work/";
  static String DownloadHomeWork_students="api_students/download_home_work/";
  static String LoadSubjects_students="api_students/subject/";
  static String LoadStudentsAcademicSyllabus="api_students/academic_syllabus/";
  static String Load_AcademicSyllabus_Teacher = "/api_teachers/academic_syllabus/";
  static String Load_Classes = logintype == "teacher"
      ? "api_teachers/classes_api" : "Api_admin/get_classes";
  static String Load_Classes_Admin = "Api_admin/get_classes";
  static String Load_Sectionwisetimetable = "api_teachers/class_routine/";
  static String Load_Studymaterial = "api_teachers/study_material/";
  static String Load_Sections = "api_teachers/section_api/";
  static String Load_Subjectsforstudymaterisl = "api_teachers/get_class_subject/";
  static String Create_studymaterial = "api_teachers/study_material/create";
  static String Update_studymaterial = "api_teachers/study_material_update/";
  static String Delete_studymaterial = "api_teachers/study_material/delete/";
  static String Student_Load_Marks="/api_students/exam_marks/";
  static String Student_Load_Exam="/api_students/exams_ids/";
  static String Load_student_transportdetails="api_students/transport/";
  static String Load_SubjectsandSections = "api_teachers/marks_manage/";
  static String Load_Exams_Teacher = "api_teachers/marks_manage/";
  static String Load_ExamsMarks = "api_teachers/marks_manage_view/";
  static String Load_Subjects = "api_teachers/subject/";
  static String Upload_ACADSyllabus = "api_teachers/upload_academic_syllabus";
  static String Update_profile_Teacher = "api_teachers/manage_profile/update_profile_info/";
  static String Manage_Attendance_Teacher = "api_teachers/manage_attendance_view/";
  static String Display_Questionpapers_Teacher = "api_teachers/question_paper/display/";
  static String Add_Questionpapers_Teacher = "api_teachers/question_paper/create/";
  static String Edit_Questionpapers_Teacher = "api_teachers/question_paper/update/";
  static String Load_Questionpapers_Teacher = "api_teachers/question_paper/display/";
  static String Delete_Questionpapers_Teacher = "api_teachers/question_paper/delete/";
//  static String Homework_Teacher =
//      "api_parents/home_work/";
  static String Homework_Parent = "api_parents/home_work/";
  // static String Display_Questionpapers_Teacher = "api_teachers/question_paper/display/";
  static String Update_Attendance = "api_teachers/attendance_update/";
  static String Update_Marks = "api_teachers/marks_update/";
  static String Load_AllStudents = "api_teachers/student_information/";
  static String Load_SectionswiseStudents = "api_teachers/student_section_wise/";
  static String View_Notice = "api_teachers/noticeboard/view/";
//new
  static String Load_StudentsAttendance = "api_students/attendance_report_new/";
  static String Load_Parent_manageprofile = "api_parents/manage_profile/edit_profile_info/";
  static String Load_Parent_updateprofile = "api_parents/manage_profile/update_profile_info/";
  // static String Load_StudentsAttendance =

  // static String Load_StudentsAttendance = "api_students/attendance_report/";
  static String Load_StudentsAttendanceSelector = "api_students/attendance_report_selector/";
//Parent//
  static String Parent_Load_Receipents="api_parents/message/message_new/";
  static String Parent_Send_Newmessag="api_parents/message/send_new/";
  static String Parent_Load_Privateusers="api_parents/new_message_users/";
  static String Parent_Load_Privateuserschat="api_parents/new_message_read/";
  static String Parent_Send_Privatechat="api_parents/message/send_reply/";
  static String Parent_Load_Groupusers="api_parents/group_message_display/";
  static String Parent_Load_Groupuserschat="api_parents/group_message/group_message_read/";
  static String Parent_Send_replyGroupchat="api_parents/group_message/send_reply/";
//Student
  static String Student_Load_Receipents="api_students/message";
  static String Student_Send_Newmessag="api_students/message/send_new/";
  static String Student_Load_Privateusers="api_students/new_message_users/";
  static String Student_Load_Privateuserschat="api_students/new_message_read/";
  static String Student_Send_Privatechat="api_students/message/send_reply/";
  static String Student_Load_Groupusers="api_students/group_message_display/";
  static String Student_Load_Groupuserschat="api_students/group_message/group_message_read/";
  static String Student_Send_replyGroupchat="api_students/group_message/send_reply/";
  static String Student_Fee_group="api_students/fees_group_info/";
  static String Student_Book_dropdown="Api_students/get_books_drop_down_list/";
  static String Student_Fee_="api_students/fees_payments_details/";
  static String Student_Manage_Profile="api_students/manage_profile";
  static String Student_send_newmessage="api_students/message/send_new/";
  static String parent_view_online_exam="/api_parents/online_exam_result/";
  static String student_view_online_exam="/api_students/online_exam_result/";
  static String student_view_result="/api_students/print_online_marks/";
  static String parent_view_result="/api_parents/print_online_marks/";
  static String Student_Onlineexams_list= "api_students/online_exam";
  static String Student_Onlineexamwuestions_list= "api_students/take_online_exam";
  static String Student_Submitexam = "api_students/submit_online_exam";
  static String Parent_paymentView = "api_parents/fees_group_info/";
  static String Parent_paymentFeesCollection = "api_parents/fees_payments_details/";
  static String Student_libraryRequestbook="api_students/get_book_request/";
  static String Student_SubjectWiseAttendance="api_students/subjecwise_attendance_report_view";
  static String Parent_subjectwise_Attendance="api_parents/subjecwise_attendance_report_view/";
//  static String Student_libraryRequestbook="api_students/get_book_request/";
  //Teacher//
  static String Load_Sections_Dropdown = "api_teachers/manage_attendance/";
  static String Load_subject_section_Dropdown="api_teachers/manage_attendance/";
  static String Load_dropdown_date_timetable_subject="api_teachers/dropdown_date_timetable_subject/";
  static String Load__subjectwise_attendance_view="api_teachers/manage_subjectwise_attendance_view/";
  static String Load_subjectwise_attendance_update="api_teachers/attendances_subjectwise_update/";
  static String Load_studentAdmission="api_teachers/student/create/";
  static String Display_homework_list="Api_teachers/get_home_work_list/";
  static String Manage_homework="Api_teachers/home_work/";
  static String Assign_homework_list="Api_teachers/get_assigned_sections/";
  static String Edit_homework_list="Api_teachers/get_home_work_edit/";
  static String Load_homework_list="Api_teachers/get_update_section_students/";
  static String Update_Questionpapers_Teacher = "api_teachers/question_paper/update/";
//
//  static String Student_Onlineexams_list= "api_students/online_exam";
//  static String Student_Onlineexamwuestions_list= "api_students/take_online_exam";
//  static String Student_Submitexam = "api_students/submit_online_exam";
//  static String student_view_result="/api_students/print_online_marks/";
//  static String student_view_online_exam="/api_students/online_exam_result/";
//  static String parent_view_result="/api_parents/print_online_marks/";

  //Admin Apis
  static String Create_Parent = "Api_admin/parent/";
  static String Edit_Parent = "Api_admin/parent/";
  static String Edit_Password_Parent = "Api_admin/parent/";
  static String Delete_Parent = "Api_admin/parent/";
  static String Load_Parents = "api_admin/get_parents_list";
  static String Create_Teacher = "Api_admin/teacher/";
  static String Edit_Teacher_Getdetails = "Api_admin/get_teacher/";
  static String Edit_Password_Teacher = "Api_admin/teacher/";
  static String Delete_Teacher = "Api_admin/teacher/";
  static String Create_Student = "Api_admin/student";
  static String Edit_Student = "Api_admin/student";
  static String Get_Student_Singledata = "api_admin/get_student_data";
  static String Edit_Password_Student = "Api_admin/student/";
  static String Delete_Student = "Api_admin/delete_student/";
  static String Load_Teachers_Admin = "Api_admin/get_teachers_list";
  static String Load_Sections_Admin = "Api_admin/get_section/";
  static String Load_Classwisestudents_Admin = "Api_admin/student_information";
  static String Load_Tabulationsheet_Admin = "api_admin/tabulation_sheet";
  static String Get_Collectfees_Admin = "api_admin/getStudentDetails";
  static String Search_Fees_Management = "api_admin/getPaymentDetails";
  static String Student_getpromotion = "Api_admin/student_promotion";
  static String Student_Managepromotion = "Api_admin/student_promotion/promote";
  static String GetParents_Admin = "Api_admin/get_parents";
  static String LoadManageclasses_Admin = "Api_admin/get_classes_list";
  static String CRUDManageclasses_Admin = "Api_admin/classes";
  static String CRUDManagecsections_Admin = "Api_admin/sections";
  static String Load_ManageSections_Admin = "Api_admin/get_section_list/";
  static String Load_AcademicSyllabus_Admin = "Api_admin/academic_syllabus/";
  static String Load_Librarians_Admin = "Api_admin/librarian_list";
  static String CRUDManageLibrarians_Admin = "Api_admin/librarian";
  static String Load_Acccountants_Admin = "Api_admin/accountant_list";
  static String CRUDAcccountants_Admin = "Api_admin/accountant";
  static String Load_Subjects_Admin = "Api_admin/get_subject_list";
  static String CRUDSubjects_Admin = "Api_admin/subject/";
  static String Load_Attendancetypes_Admin = "api_admin/get_attendance_type_data_list";
  static String CRUDAttendancetypes_Admin = "api_admin/attendance_type/";
  static String LoadAttendance_Admin = "api_admin/get_attendance_student_list/";
  static String UpdateAttendance_Admin = "api_admin/update_student_attendance/";
  static String CRUDManageExams_Admin = "api_admin/manage_exam";
  static String Load_Exams_Admin = "api_admin/get_exams_list";
  static String CRUDManagegraged_Admin = "api_admin/manage_grade";
  static String Load_Grades_Admin = "api_admin/get_grades_list";
  static String CRUDClassroutine_Admin = "api_admin/class_routine/create";
  static String LoadClassroutine_Admin = "api_admin/get_class_routine_details";
  static String Load_Questionpaper_Admin = "api_admin/question_paper";
  static String CRUDOnlineexam_Admin = "api_admin/manage_online_exam";
  static String LoadOnlineexam_Admin = "api_admin/get_online_exams_list";
  static String Status_Onlineexam_Admin = "api_admin/manage_online_exam_status";
  static String CRUDQuestions_Admin = "api_admin/manage_online_exam_question_bank";
  static String CRUDHomework_Admin = "api_admin/manage_home_work";
  static String LoadHomework_Admin = "api_admin/get_home_works_list";
  static String LoadQuestions_Admin = "api_admin/get_online_exam_questions";
  static String LoadLibrarybooks_Admin = "api_admin/get_library_books_list";
  static String CRUDLibrarybooks_Admin = "api_admin/manage_library_books";
  static String LoadTransport_Admin = "api_admin/get_transports_list";
  static String CRUDTransport_Admin = "api_admin/manage_transport";
  static String LoadDormitory_Admin = "api_admin/get_hostels_list";
  static String CRUDDormitory_Admin = "api_admin/manage_hostel";
  static String LoadNoticeboard_Admin = "api_admin/get_noticeboards_list";
  static String CRUDNoticeboard_Admin = "api_admin/manage_noticeboard";
  static String LoadExpensecat_Admin = "api_admin/get_expense_categorys_list";
  static String CRUDExpensecat_Admin = "api_admin/manage_expense_category";
  static String LoadExpenses_Admin = "api_admin/get_expenses_list";
  static String CRUDExpenses_Admin = "api_admin/manage_expense";
  static String LoadAssignedhomework_Admin = "api_admin/get_section_wise_assigned_home_work_list";
  static String CRUDAssignedhomeworks_Admin = "api_admin/manage_assigned_home_work";
  static String Viewresult_Admin = "api_admin/view_online_exam_result";
  static String LoadExamamrks_Admin = "api_admin/manage_subject_wise_student_view";
  static String UpdateExamamrks_Admin = "api_admin/marks_update";
  static String Load_Attendancereport_Admin = "api_admin/attendance_report_new";
  static String Load_Profile_Admin = "api_admin/manage_profile/edit_profile_info/";
  static String Update_Profile_Admin = "api_admin/manage_profile/update_profile_info/";
  static String Load_Groups_Addmin = "api_admin/group_message_display/";
  static String Admin_Load_Receipents="api_admin/message";
  static String Admin_Send_Newmessage="api_admin/message/send_new/";
  static String Admin_Load_Privateusers="api_admin/new_message_users/";
  static String Admin_Load_Privateuserschat="api_admin/new_message_read/";
  static String Admin_Send_Privatechat="api_admin/message/send_reply/";
  static String Admin_Load_Groupusers="api_admin/group_message_display/";
  static String Admin_Load_Groupuserschat="api_admin/group_message/group_message_read/";
  static String Admin_Send_replyGroupchat="api_admin/group_message/send_reply/";
  static String Add_AcademicSyllabus_Admin = "Api_admin/Api_admin/upload_academic_syllabus/";
//LMS//
  static String Admin_Get_CourseList="api_admin/get_cource_lists/";
  static String Admin_Create_Lms_CourseList="/api_admin/create_lms_courses/";
  static String Admin_Create_LmsTopicList="/api_admin/create_courses_topics/";
  static String Admin_Get_CourseTopic_List="/api_admin/get_course_topics_lists/";
  static String Admin_Delete_Lms_topic="api_admin/delete_lms_topic/";
  static String Admin_Update_Lms_Topic="/api_admin/update_lms_topic";
  static String Admin_Get_Course_VideoList="api_admin/get_cource_topics_video_lists/";
  static String Admin_Add_Video="api_admin/upload_video_lms/";
  static String Admin_Update_Video_list="/api_admin/update_video_lms";
  static String Admin_delete_video_list="/api_admin/delete_lms_video/";
  static String Admin_get_videoList="api_admin/get_cource_topics_video_lists/";


  Future<String> Appversion = GetAppversion();
  Future<String> Logourl = Getlogo();
  String fcmkey = "AIzaSyA3C02WzsiQQjoadGKuH4SoE4dmKgM4ZhY";

  Future<String> USER_N_PASSWORD() async
  {
    return "?l=" +
        await sp.ReadString("Username") +
        "&p=" +
        await sp.ReadString("password");
  }

  Future<String> Userid() async {
    return await sp.ReadString("Userid");
  }

  Future<String> Clientid() async {
    return await sp.ReadString("client");
  }

  Future<String> Orgid() async {
    return await sp.ReadString("orgid");
  }

  Future<String> Orgname() async {
    return await sp.ReadString("orgname");
  }

  Future<String> Classroomurl() async {
    return await sp.ReadString("classroomurl");
  }

  Future<String> Classroomkey() async {
    return await sp.ReadString("classroomkey");
  }

  Future<String> Clienturl() async {
    return await sp.ReadString("clienturl") +
        "/"; //"https://demo-fms.rampfleet.com/";
  }

  Future<String> getUserfcmid(String approver) async {
    String userpass = await new Constants().USER_N_PASSWORD();
    String url = "${Constants.BASE_URL}ADUser$userpass&_where=id='$approver'";
    final response = await http.get(url);
    final responseJson = json.decode(response.body)["response"]["data"];
    print("response json $responseJson");
    return responseJson[0]['description'];
  }

  Sendnotification(String message, String id, String page, String fcmid) {
    Map body = new Map();
    Map data = new Map();
    Map notification = new Map();
    notification['title'] = "Edecofy";
    notification['body'] = message;
    notification['click_action'] = "FLUTTER_NOTIFICATION_CLICK";
    data['open'] = page;
    data['id'] = id;
    body['notification'] = notification;
    body['data'] = data;
    body['priority'] = "high";
    body['to'] = fcmid;
    print('body is${json.encode(body)} $body');
    var url = "https://fcm.googleapis.com/fcm/send";
    http.post(url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'key=$fcmkey'
        },
        body: json.encode(body))
        .then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    });
  }

  List Childrenlist = new List();

  var bodyProgress = new Container(
    alignment: AlignmentDirectional.center,
    color: Colors.white,
    child: Image(image: new AssetImage("assets/loader.gif")),
  );
  static String email = "";
  static String username = "";
  static String dynmenulist = "";
  static String logintype = "";
  static String schooltype="";

  Widget drawer(BuildContext context) {
    List<Widget> Childrenwidgetlist = new List();
    List<Widget> Childrenclasseslist = new List();
    List<Widget> Childrenattendencelist = new List();
    List<Widget> ChildrenPaymentslist = new List();
    List<Widget> ChildrenMarkslist = new List();
    List Childlist;

    if (logintype == "parent") {
      Childlist = json.decode(dynmenulist)['result'];
      print("cl--" + dynmenulist + "--");
    }

    List Classeslist;

    if (logintype == "teacher") {
      Classeslist = json.decode(dynmenulist)['result']['classes'];
      print("cl--" + dynmenulist + "--");

    }
    if (logintype == 'admin') {
      Classeslist = json.decode(dynmenulist)['result'];
      print("cl--" + dynmenulist + "--");
    }

    var drawer = new SizedBox(
        width: 300,
        child: new Drawer(
          child: new ListView(
              children: <Widget>[
                new Container(
                  height:150,
                  child: DrawerHeader(
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: new Image.network(logo +
                              "uploads/" +
                              logo.split("://")[1] +
                              "logo.png",fit:BoxFit.fitWidth,height: 50,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:8.0,bottom:3.0 ),
                          child: new Text(schooltype,style: TextStyle(color: Colors.white)),
                        ),
                        new Text(username, style: TextStyle(color: Colors.white)),
                        // Text('Drawer Header'),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
//                logintype =="admin"?
//                new Container(
//                    margin: EdgeInsets.all(5),
//                    child: new Row(
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      mainAxisAlignment: MainAxisAlignment.start,
//                      children: <Widget>[
//                        Expanded(
//                          child: new Container(
//                            decoration: BoxDecoration(
//                                shape: BoxShape.circle,
//                                boxShadow: [
//                                  BoxShadow(
//                                    color: Colors.blueGrey,
//                                    blurRadius: 5.0,
//                                  ),
//                                ],
//                                border:
//                                Border.all(color: Colors.white, width: 3),
//                                color: Theme.of(context).primaryColor),
//                            child: new SvgPicture.asset(
//                              "assets/dashboard.svg",
//                              width: 20,
//                              height: 20,
//                              color: Colors.white,
//                            ),
//                            padding: EdgeInsets.all(10),
//                          ),
//                          flex: 3,
//                        ),
//                        Expanded(
//                          child: new Container(
//                            child: new Text(
//                              "Dashboard",
//                              style: TextStyle(
//                                fontSize: 15,
//                                color: Theme.of(context).primaryColor,
//                                fontWeight: FontWeight.bold,
//                              ),
//                            ),
//                            margin: EdgeInsets.only(left: 5),
//                          ),
//                          flex: 17,
//                        ),
//                      ],
//                    )): new Container(),
//                logintype == "admin" ?
//                new Container(
//                    margin: EdgeInsets.only(left: 10, right: 10),
//                    child: GridView.count(
//                        shrinkWrap: true,
////                      physics: ScrollPhysics(),
//                        crossAxisCount: 3,
//                        children: List.generate(1, (index) {
//                          return new Card(
//                            elevation: 5,
//                            margin:
//                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//                            shape: RoundedRectangleBorder(
//                                borderRadius:
//                                BorderRadius.all(Radius.circular(10))),
//                            color: Colors.white,
//                            child: new InkWell(
//                              child: new Container(
//                                padding: EdgeInsets.symmetric(
//                                    horizontal: 10, vertical: 15),
//                                child: new Column(
//                                  mainAxisSize: MainAxisSize.max,
//                                  crossAxisAlignment: CrossAxisAlignment.center,
//                                  children: <Widget>[
//                                    Expanded(
//                                        child: new Container(
//                                          padding: EdgeInsets.all(3),
//                                          child: new SvgPicture.asset(
//                                            "assets/dashboard.svg",
//                                            width: 50,
//                                            height: 50,
//                                            color: Colors.green,
//                                          ),
//                                        )),
//                                    new Container(
//                                      padding: EdgeInsets.all(3),
//                                      child: new Text(
//                                        "Dashboard",
//                                        style: TextStyle(
//                                            color: Colors.green, fontSize: 10),
//                                        maxLines: 1,
//                                        overflow: TextOverflow.ellipsis,
//                                      ),
//                                    )
//                                  ],
//                                ),
//                              ),
//                              onTap: () {
//                                Navigator.of(context).pop();
//                                Navigator.of(context).push(new MaterialPageRoute(
//                                    builder: (BuildContext context) =>
//                                    new DashboardPage()));
//                              },
//                              splashColor: Colors.green,
//                            ),
//                          );
//                        }))): new Container(),

                logintype == "admin" ?
                new Column(children: <Widget>[
//                  new Container(
//                      margin: EdgeInsets.all(5),
//                      child: new Row(
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        children: <Widget>[
//                          Expanded(
//                            child: new Container(
//                              decoration: BoxDecoration(
//                                  shape: BoxShape.circle,
//                                  boxShadow: [
//                                    BoxShadow(
//                                      color: Colors.blueGrey,
//                                      blurRadius: 5.0,
//                                    ),
//                                  ],
//                                  border:
//                                  Border.all(color: Colors.white, width: 3),
//                                  color: Theme.of(context).primaryColor),
//                              child: new SvgPicture.asset(
//                                "assets/student.svg",
//                                width: 20,
//                                height: 20,
//                                color: Colors.white,
//                              ),
//                              padding: EdgeInsets.all(10),
//                            ),
//                            flex: 3,
//                          ),
//                          Expanded(
//                            child: new Container(
//                              child: new Text(
//                                "Students",
//                                style: TextStyle(
//                                  fontSize: 15,
//                                  color: Theme.of(context).primaryColor,
//                                  fontWeight: FontWeight.bold,
//                                ),
//                              ),
//                              margin: EdgeInsets.only(left: 5),
//                            ),
//                            flex: 17,
//                          ),
//                        ],
//                      )),
//                  new Container(
//                      margin: EdgeInsets.only(left: 10,right:10),
//                      child: GridView.count(
//                          shrinkWrap: true,
//                          physics: ScrollPhysics(),
//                          crossAxisCount: 3,
//                          children: <Widget>[
//                            new Card(
//                              elevation: 5,
//                              margin: EdgeInsets.symmetric(
//                                  vertical: 5, horizontal: 5),
//                              shape: RoundedRectangleBorder(
//                                  borderRadius: BorderRadius.all(
//                                      Radius.circular(10))),
//                              color: Colors.white,
//                              child: new InkWell(
//                                child: new Container(
//                                  padding: EdgeInsets.symmetric(
//                                      horizontal: 10, vertical: 5),
//                                  child: new Column(
//                                    mainAxisSize: MainAxisSize.max,
//                                    crossAxisAlignment:
//                                    CrossAxisAlignment.center,
//                                    children: <Widget>[
//                                      Expanded(
//                                          child: new Container(
//                                            padding: EdgeInsets.all(3),
//                                            child: new SvgPicture.asset(
//                                              "assets/student1.svg",
//                                              width: 40,
//                                              height: 40,
//                                              color: Colors.green,
//                                            ),
//                                          )),
//                                      new Container(
//                                        padding: EdgeInsets.only(top:3),
//                                        child: new Text(
//                                          "Student Admission",
//                                          style: TextStyle(
//                                              color: Colors.green,
//                                              fontSize: 8),
//                                          textAlign: TextAlign.center,
//                                          maxLines: 2,
//                                         // overflow: TextOverflow.ellipsis,
//                                        ),
//                                      )
//                                    ],
//                                  ),
//                                ),
//                                onTap: () {
//                                  Navigator.of(context).pop();
//                                  Navigator.of(context).push(
//                                      new MaterialPageRoute(
//                                          builder: (BuildContext
//                                          context) =>
//                                          new StudentadmissionPage()));
//                                },
//                                splashColor: Colors.green,
//                              ),
//                            ),
//                          ])),

                  new ExpansionTile(
                      title: new Container(
                          margin: EdgeInsets.all(5),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: new Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueGrey,
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                      border: Border.all(color: Colors.white, width: 3),
                                      color: Theme.of(context).primaryColor),
                                  child: new SvgPicture.asset(
                                    "assets/dashboard.svg",
                                    width: 15,
                                    height: 15,
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                                flex: 5,
                              ),
                              Expanded(
                                child: new Container(
                                  child: new Text(
                                    "Dashboard",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(left: 5),
                                ),
                                flex: 17,
                              ),
                            ],
                          )),
                      children: <Widget>[
                        new Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: GridView.count(
                                shrinkWrap: true,
//                      physics: ScrollPhysics(),
                                crossAxisCount: 3,
                                children: List.generate(1, (index) {
                                  return new Card(
                                    elevation: 5,
                                    margin:
                                    EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                    color: Colors.white,
                                    child: new InkWell(
                                      child: new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                child: new Container(
                                                  padding: EdgeInsets.only(top:3),
                                                  child: new SvgPicture.asset(
                                                    "assets/dashboard.svg",
                                                    width: 40,
                                                    height: 40,
                                                    color: Colors.green,
                                                  ),
                                                )),
                                            new Container(
                                              padding: EdgeInsets.all(3),
                                              child: new Text(
                                                "Dashboard",
                                                style: TextStyle(
                                                    color: Colors.green, fontSize: 8),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                            new DashboardPage()));
                                      },
                                      splashColor: Colors.green,
                                    ),
                                  );
                                }))),
                      ]) ,
                  ExpansionTile(
                    title:   new Container(
                        margin: EdgeInsets.all(5),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: new Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blueGrey,
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                    border:
                                    Border.all(color: Colors.white, width: 3),
                                    color: Theme.of(context).primaryColor),
                                child: new SvgPicture.asset(
                                  "assets/student.svg",
                                  width: 15,
                                  height: 15,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(10),
                              ),
                              flex:5,
                            ),
                            Expanded(
                              child: new Container(
                                child: new Text(
                                  "Student Information",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                margin: EdgeInsets.only(left: 5),
                              ),
                              flex: 17,
                            ),
                          ],
                        )),
                    children: <Widget>[
                      new Container(
                          margin: EdgeInsets.only(left: 10,right:10),
                          child: GridView.count(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              crossAxisCount: 3,
                              children: List.generate(Classeslist.length, (index) {
                                return new Card(
                                  elevation: 5,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                                  color: Colors.white,
                                  child: new InkWell(
                                    child: new Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 15),
                                      child: new Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                              child: new Container(
                                                padding: EdgeInsets.all(3),
                                                child: new SvgPicture.asset(
                                                  "assets/class1.svg",
                                                  width: 40,
                                                  height: 40,
                                                  color: Colors.green,
                                                ),
                                              )),
                                          new Container(
                                            padding: EdgeInsets.only(top:3),
                                            child: new Text(
                                              "Class - " +
                                                  Classeslist[index]['class_name'],
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 8),
                                              maxLines: 2,
                                              //overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                              new AdminStudentstabsPage(
                                                id: Classeslist[index]
                                                ['class_id'],)));
                                    },
                                    splashColor: Colors.green,
                                  ),
                                );
                              }))),
                    ],
                  ),
                  ExpansionTile(
                    title:  new Container(
                        margin: EdgeInsets.all(5),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: new Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blueGrey,
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                    border:
                                    Border.all(color: Colors.white, width: 3),
                                    color: Theme.of(context).primaryColor),
                                child: new SvgPicture.asset(
                                  "assets/family.svg",
                                  width: 15,
                                  height: 15,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(10),
                              ),
                              flex: 5,
                            ),
                            Expanded(
                              child: new Container(
                                child: new Text(
                                  "Parent Information",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                margin: EdgeInsets.only(left: 5),
                              ),
                              flex: 17,
                            ),
                          ],
                        )),
                    children: <Widget>[
                      new Container(
                          margin: EdgeInsets.only(left: 10,right:10),
                          child: GridView.count(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              crossAxisCount: 3,
                              children: <Widget>[
                                new Card(
                                  elevation: 5,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  color: Colors.white,
                                  child: new InkWell(
                                    child: new Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: new Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                              child: new Container(
                                                padding: EdgeInsets.all(3),
                                                child: new SvgPicture.asset(
                                                  "assets/family.svg",
                                                  width: 40,
                                                  height: 40,
                                                  color: Colors.green,
                                                ),
                                              )),
                                          new Container(
                                            padding: EdgeInsets.only(top:3),
                                            child: new Text(
                                              "Parent Information",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 8),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              //    overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext
                                              context) =>
                                              new AdminParentsPage()));
                                    },
                                    splashColor: Colors.green,
                                  ),
                                ),
                              ])),
                    ],
                  ),
                  ExpansionTile(
                    title:  new Container(
                        margin: EdgeInsets.all(5),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: new Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blueGrey,
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                    border: Border.all(
                                        color: Colors.white, width: 3),
                                    color: Theme.of(context).primaryColor),
                                child: new SvgPicture.asset(
                                  "assets/exam.svg",
                                  width: 15,
                                  height: 15,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(10),
                              ),
                              flex:5,
                            ),
                            Expanded(
                              child: new Container(
                                child: new Text(
                                  "Exams",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                margin: EdgeInsets.only(left: 5),
                              ),
                              flex: 17,
                            ),
                          ],
                        )),
                    children: <Widget>[
                      new Container(
                          margin: EdgeInsets.only(left: 10,right:10),
                          child: GridView.count(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              crossAxisCount: 3,
                              children: <Widget>[
                                new Card(
                                  elevation: 5,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  color: Colors.white,
                                  child: new InkWell(
                                    child: new Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: new Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                              child: new Container(
                                                padding: EdgeInsets.all(3),
                                                child: new SvgPicture.asset(
                                                  "assets/exam.svg",
                                                  width: 40,
                                                  height: 40,
                                                  color: Colors.green,
                                                ),
                                              )),
                                          new Container(
                                            padding: EdgeInsets.all(3),
                                            child: new Text(
                                              "Create Exam/List",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 10),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext
                                              context) =>
                                              new ManageexamstabsPage()));
                                    },
                                    splashColor: Colors.green,
                                  ),
                                ),
                                new Card(
                                  elevation: 5,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  color: Colors.white,
                                  child: new InkWell(
                                    child: new Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: new Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                              child: new Container(
                                                padding: EdgeInsets.all(3),
                                                child: new SvgPicture.asset(
                                                  "assets/exam.svg",
                                                  width: 50,
                                                  height: 50,
                                                  color: Colors.green,
                                                ),
                                              )),
                                          new Container(
                                            padding: EdgeInsets.all(3),
                                            child: new Text(
                                              "Exam Grades",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 10),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext
                                              context) =>
                                              new ManagegradestabsPage()));
                                    },
                                    splashColor: Colors.green,
                                  ),
                                ),
                                new Card(
                                  elevation: 5,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  color: Colors.white,
                                  child: new InkWell(
                                    child: new Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: new Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                              child: new Container(
                                                padding: EdgeInsets.all(3),
                                                child: new SvgPicture.asset(
                                                  "assets/exam.svg",
                                                  width: 50,
                                                  height: 50,
                                                  color: Colors.green,
                                                ),
                                              )),
                                          new Container(
                                            padding: EdgeInsets.all(3),
                                            child: new Text(
                                              "Exam Marks",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 10),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext
                                              context) =>
                                              new AdminExamMarksPage()));
                                    },
                                    splashColor: Colors.green,
                                  ),
                                ),
                                new Card(
                                  elevation: 5,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  color: Colors.white,
                                  child: new InkWell(
                                    child: new Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: new Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                              child: new Container(
                                                padding: EdgeInsets.all(3),
                                                child: new SvgPicture.asset(
                                                  "assets/paper.svg",
                                                  width: 50,
                                                  height: 50,
                                                  color: Colors.green,
                                                ),
                                              )),
                                          new Container(
                                            padding: EdgeInsets.all(3),
                                            child: new Text(
                                              "Question Paper",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 10),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext
                                              context) =>
                                              new Questionpaper_AdminPage()));
                                    },
                                    splashColor: Colors.green,
                                  ),
                                ),

                                new Card(
                                  elevation: 5,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  color: Colors.white,
                                  child: new InkWell(
                                    child: new Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: new Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                              child: new Container(
                                                padding: EdgeInsets.all(3),
                                                child: new SvgPicture.asset(
                                                  "assets/exam.svg",
                                                  width: 50,
                                                  height: 50,
                                                  color: Colors.green,
                                                ),
                                              )),
                                          new Container(
                                            padding: EdgeInsets.all(3),
                                            child: new Text(
                                              "Create Online Exam",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 10),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext
                                              context) =>
                                              new CreateonlineexamPage(type: "new",details: null,)));
                                    },
                                    splashColor: Colors.green,
                                  ),
                                ),
                                new Card(
                                  elevation: 5,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  color: Colors.white,
                                  child: new InkWell(
                                    child: new Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: new Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                              child: new Container(
                                                padding: EdgeInsets.all(3),
                                                child: new SvgPicture.asset(
                                                  "assets/exam.svg",
                                                  width: 50,
                                                  height: 50,
                                                  color: Colors.green,
                                                ),
                                              )),
                                          new Container(
                                            padding: EdgeInsets.all(3),
                                            child: new Text(
                                              "Manage Online Exam",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 10),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext
                                              context) =>
                                              new AdminManageonlineexamsPage()));
                                    },
                                    splashColor: Colors.green,
                                  ),
                                ),
                                new Card(
                                  elevation: 5,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  color: Colors.white,
                                  child: new InkWell(
                                    child: new Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: new Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                              child: new Container(
                                                padding: EdgeInsets.all(3),
                                                child: new SvgPicture.asset(
                                                  "assets/exam.svg",
                                                  width: 50,
                                                  height: 50,
                                                  color: Colors.green,
                                                ),
                                              )),
                                          new Container(
                                            padding: EdgeInsets.all(3),
                                            child: new Text(
                                              "Tabulation Sheet",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 10),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext
                                              context) =>
                                              new ManageTabulationsheetPage()));
                                    },
                                    splashColor: Colors.green,
                                  ),
                                ),

                              ])),
                    ],
                  ),

                  ExpansionTile(
                    title:    new Container(
                        margin: EdgeInsets.all(5),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: new Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blueGrey,
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                    border: Border.all(
                                        color: Colors.white, width: 3),
                                    color: Theme.of(context).primaryColor),
                                child: new SvgPicture.asset(
                                  "assets/creditcard.svg",
                                  color: Colors.white,
                                  width: 15,
                                  height: 15,
                                ),
                                padding: EdgeInsets.all(10),
                              ),
                              flex: 5,
                            ),
                            Expanded(
                              child: new Container(
                                child: new Text(
                                  "Financial",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                margin: EdgeInsets.only(left: 5),
                              ),
                              flex: 17,
                            ),
                          ],
                        )),
                    children: <Widget>[
                      new Container(
                          margin: EdgeInsets.only(left: 10,right:10),
                          child: GridView.count(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              crossAxisCount: 3,
                              children: <Widget>[
                                new Card(
                                  elevation: 5,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  color: Colors.white,
                                  child: new InkWell(
                                    child: new Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: new Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                              child: new Container(
                                                padding: EdgeInsets.all(3),
                                                child: new SvgPicture.asset(
                                                  "assets/creditcard.svg",
                                                  width: 50,
                                                  height: 50,
                                                  color: Colors.green,
                                                ),
                                              )),
                                          new Container(
                                            padding: EdgeInsets.all(3),
                                            child: new Text(
                                              "Expenditures",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 10),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext
                                              context) =>
                                              new ExpensesPage()));
                                    },
                                    splashColor: Colors.green,
                                  ),
                                ),
                                new Card(
                                  elevation: 5,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  color: Colors.white,
                                  child: new InkWell(
                                    child: new Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: new Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                              child: new Container(
                                                padding: EdgeInsets.all(3),
                                                child: new SvgPicture.asset(
                                                  "assets/creditcard.svg",
                                                  width: 50,
                                                  height: 50,
                                                  color: Colors.green,
                                                ),
                                              )),
                                          new Container(
                                            padding: EdgeInsets.all(3),
                                            child: new Text(
                                              "Expense Category",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 10),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext
                                              context) =>
                                              new ExpensescategoryPage()));
                                    },
                                    splashColor: Colors.green,
                                  ),
                                ),
                                new Card(
                                  elevation: 5,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  color: Colors.white,
                                  child: new InkWell(
                                    child: new Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: new Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                              child: new Container(
                                                padding: EdgeInsets.all(3),
                                                child: new SvgPicture.asset(
                                                  "assets/creditcard.svg",
                                                  width: 50,
                                                  height: 50,
                                                  color: Colors.green,
                                                ),
                                              )),
                                          new Container(
                                            padding: EdgeInsets.all(3),
                                            child: new Text(
                                              "Expenditure Report",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 10),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext
                                              context) =>
                                              new ExpensesreportPage()));
                                    },
                                    splashColor: Colors.green,
                                  ),
                                ),
                              ])),
                    ],
                  ),
                  new ExpansionTile(
                      title: new Container(
                          margin: EdgeInsets.all(5),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: new Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueGrey,
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                      border: Border.all(color: Colors.white, width: 3),
                                      color: Theme.of(context).primaryColor),
                                  child: new SvgPicture.asset(
                                    "assets/dashboard.svg",
                                    width: 15,
                                    height: 15,
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                                flex: 5,
                              ),
                              Expanded(
                                child: new Container(
                                  child: new Text(
                                    "LearningManagementSystem",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(left: 5),
                                ),
                                flex: 17,
                              ),
                            ],
                          )),
                      children: <Widget>[
                        new Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: GridView.count(
                                shrinkWrap: true,
//                      physics: ScrollPhysics(),
                                crossAxisCount: 3,
                                children: List.generate(1, (index) {
                                  return new Card(
                                    elevation: 5,
                                    margin:
                                    EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                    color: Colors.white,
                                    child: new InkWell(
                                      child: new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                child: new Container(
                                                  padding: EdgeInsets.only(top:3),
                                                  child: new SvgPicture.asset(
                                                    "assets/dashboard.svg",
                                                    width: 40,
                                                    height: 40,
                                                    color: Colors.green,
                                                  ),
                                                )),
                                            new Container(
                                              padding: EdgeInsets.all(3),
                                              child: new Text(
                                                "Dashboard",
                                                style: TextStyle(
                                                    color: Colors.green, fontSize: 8),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                            new AdminCourseListPage()));
                                      },
                                      splashColor: Colors.green,
                                    ),
                                  );
                                }))),
                      ]) ,

//end
//                  new ListTile(
//                      title: new Text("Home Work"),
//                      leading: new Icon(FontAwesomeIcons.userEdit, color: Theme.of(context).primaryColor),
//                      onTap: () {
//                        Navigator.of(context).pop();
//                        Navigator.of(context).push(new MaterialPageRoute(
//                            builder: (BuildContext context) =>
//                            new HomeworklistPage()));
//                      }) ,
                  /*new Container(
                    margin: EdgeInsets.all(5),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: new Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueGrey,
                                    blurRadius: 5.0,
                                  ),
                                ],
                                border: Border.all(
                                    color: Colors.white, width: 3),
                                color: Theme.of(context).primaryColor),
                            child: new SvgPicture.asset(
                              "assets/openbook.svg",
                              width: 10,
                              height: 10,
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(10),
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: new Container(
                            child: new Text(
                              "Academic Syllabus",
                              style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            margin: EdgeInsets.only(left: 5),
                          ),
                          flex: 17,
                        ),
                      ],
                    )),
                new Container(
                    margin: EdgeInsets.only(left: 10,right: 10),
                    child: GridView.count(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        crossAxisCount: 3,
                        children: List.generate(1, (index) {
                          return new Card(
                            elevation: 5,
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10))),
                            color: Colors.white,
                            child: new InkWell(
                              child: new Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: new Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                        child: new Container(
                                          padding: EdgeInsets.all(3),
                                          child: new SvgPicture.asset(
                                            "assets/openbook.svg",
                                            width: 50,
                                            height: 50,
                                            color: Colors.green,
                                          ),
                                        )),
                                    new Container(
                                      padding: EdgeInsets.all(3),
                                      child: new Text(
                                        "Academic Syllabus",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 10),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (BuildContext
                                        context) =>
                                        new AdminAcademicsyllabustabsPage()));
                              },
                              splashColor: Colors.green,
                            ),
                          );
                        }))),
                new Container(
                    margin: EdgeInsets.all(5),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: new Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueGrey,
                                    blurRadius: 5.0,
                                  ),
                                ],
                                border: Border.all(
                                    color: Colors.white, width: 3),
                                color: Theme.of(context).primaryColor),
                            child: new SvgPicture.asset(
                              "assets/class1.svg",
                              color: Colors.white,
                              width: 10,
                              height: 10,
                            ),
                            padding: EdgeInsets.all(10),
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: new Container(
                            child: new Text(
                              "Class Routine",
                              style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            margin: EdgeInsets.only(left: 5),
                          ),
                          flex: 17,
                        ),
                      ],
                    )),
                new Container(
                    margin: EdgeInsets.only(left: 10),
                    child: GridView.count(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        crossAxisCount: 3,
                        children:
                        List.generate(Classeslist.length, (index) {
                          return new Card(
                            elevation: 5,
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10))),
                            color: Colors.white,
                            child: new InkWell(
                              child: new Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                child: new Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                        child: new Container(
                                          padding: EdgeInsets.all(3),
                                          child: new SvgPicture.asset(
                                            "assets/class1.svg",
                                            width: 50,
                                            height: 50,
                                            color: Colors.green,
                                          ),
                                        )),
                                    new Container(
                                      padding: EdgeInsets.all(3),
                                      child: new Text(
                                        Classeslist[index]['class_name'],
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 10),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder:
                                            (BuildContext context) =>
                                        new AdminclassroutinetabsPage(
                                          id: Classeslist[index]['class_id']
                                        )));
                              },
                              splashColor: Colors.green,
                            ),
                          );
                        }))),
                new ListTile(
                    title: new Text("Student Promotion"),
                    leading: new Icon(FontAwesomeIcons.userEdit, color: Theme.of(context).primaryColor),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new StudentPromotionPage()));
                    }) ,
                new ListTile(
                    title: new Text("Student Bulk Admission"),
                    leading: new Icon(FontAwesomeIcons.userEdit, color: Theme.of(context).primaryColor),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new StudentBulkAdmissionPage()));
                    }) ,
                new ListTile(
                    title: new Text("Transport"),
                    leading: new Icon(FontAwesomeIcons.userEdit, color: Theme.of(context).primaryColor),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new AdminTransportPage()));
                    }) ,
                new ListTile(
                    title: new Text("Library Books"),
                    leading: new Icon(FontAwesomeIcons.userEdit, color: Theme.of(context).primaryColor),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new AdminLibrarybooksPage()));
                    }) ,
                new ListTile(
                    title: new Text("Dormitory"),
                    leading: new Icon(FontAwesomeIcons.userEdit, color: Theme.of(context).primaryColor),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new AdminDormitaryPage()));
                    }) ,
                new ListTile(
                    title: new Text("Notice Board"),
                    leading: new Icon(FontAwesomeIcons.userEdit, color: Theme.of(context).primaryColor),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new AdminNoticeboardPage()));
                    }) ,
                new ListTile(
                    title: new Text("Fees"),
                    leading: new Icon(FontAwesomeIcons.userEdit, color: Theme.of(context).primaryColor),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new StudentColectfeesPage()));
                    }) ,
                new ListTile(
                    title: new Text("Fees Management"),
                    leading: new Icon(FontAwesomeIcons.userEdit, color: Theme.of(context).primaryColor),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new StudentFeesmanagePage()));
                    }) ,
                new ListTile(
                    title: new Text("Due Fees"),
                    leading: new Icon(FontAwesomeIcons.userEdit, color: Theme.of(context).primaryColor),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new SearchduefeesPage()));
                    }) ,
                new ListTile(
                    title: new Text("Fees Master"),
                    leading: new Icon(FontAwesomeIcons.userEdit, color: Theme.of(context).primaryColor),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new FeesmasterPage()));
                    }) ,
                new ListTile(
                    title: new Text("Fees Group"),
                    leading: new Icon(FontAwesomeIcons.userEdit, color: Theme.of(context).primaryColor),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new FeesGroupage()));
                    }) ,
                new ListTile(
                    title: new Text("Fees Type"),
                    leading: new Icon(FontAwesomeIcons.userEdit, color: Theme.of(context).primaryColor),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new FeestypesPage()));
                    }) ,
                new ListTile(
                    title: new Text("Fees Discount"),
                    leading: new Icon(FontAwesomeIcons.userEdit, color: Theme.of(context).primaryColor),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new FeediscountssPage()));
                    }) ,
                new ListTile(
                    title: new Text("Fees Carry Forward"),
                    leading: new Icon(FontAwesomeIcons.userEdit, color: Theme.of(context).primaryColor),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new feesCarryforwardPage()));
                    }) ,
                new ListTile(
                    title: new Text("Balance Report"),
                    leading: new Icon(FontAwesomeIcons.userEdit, color: Theme.of(context).primaryColor),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new BalancefeesreportPage()));
                    }) ,
                new ListTile(
                    title: new Text("Manage Teacher"),
                    leading: new Icon(FontAwesomeIcons.userEdit, color: Theme.of(context).primaryColor),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new AdminteacherPage()));
                    }) ,
                new ListTile(
                    title: new Text("Manage Librarian"),
                    leading: new Icon(FontAwesomeIcons.userEdit, color: Theme.of(context).primaryColor),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new AdminLibrarianPage()));
                    }) ,
                new ListTile(
                    title: new Text("Manage Acccountant"),
                    leading: new Icon(FontAwesomeIcons.userEdit, color: Theme.of(context).primaryColor),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new AdminAccountatantPage()));
                    }) ,
                new ListTile(
                    title: new Text("Manage Class"),
                    leading: new Icon(FontAwesomeIcons.userEdit, color: Theme.of(context).primaryColor),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new ManageclasstabsPage()));
                    }) ,
                new ListTile(
                    title: new Text("Manage Sections"),
                    leading: new Icon(FontAwesomeIcons.userEdit, color: Theme.of(context).primaryColor),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new ManageSectionstabsPage()));
                    }) ,
                new Container(
                    margin: EdgeInsets.all(5),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: new Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueGrey,
                                    blurRadius: 5.0,
                                  ),
                                ],
                                border:
                                Border.all(color: Colors.white, width: 3),
                                color: Theme.of(context).primaryColor),
                            child: new SvgPicture.asset(
                              "assets/openbook.svg",
                              width: 10,
                              height: 10,
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(10),
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: new Container(
                            child: new Text(
                              "Manage Subjects",
                              style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            margin: EdgeInsets.only(left: 5),
                          ),
                          flex: 17,
                        ),
                      ],
                    )),
                new Container(
                    margin: EdgeInsets.only(left: 10,right:10),
                    child: GridView.count(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        crossAxisCount: 3,
                        children: List.generate(Classeslist.length, (index) {
                          return new Card(
                            elevation: 5,
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                            color: Colors.white,
                            child: new InkWell(
                              child: new Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                child: new Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                        child: new Container(
                                          padding: EdgeInsets.all(3),
                                          child: new SvgPicture.asset(
                                            "assets/class1.svg",
                                            width: 50,
                                            height: 50,
                                            color: Colors.green,
                                          ),
                                        )),
                                    new Container(
                                      padding: EdgeInsets.all(3),
                                      child: new Text(
                                        "Class - " +
                                            Classeslist[index]['class_name'],
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 10),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                        new ManagesubjectstabsPage(
                                          id: Classeslist[index]
                                          ['class_id'],)));
                              },
                              splashColor: Colors.green,
                            ),
                          );
                        }))),
                new ListTile(
                    title: new Text("Student Attendance Report"),
                    leading: new Icon(FontAwesomeIcons.userEdit, color: Theme.of(context).primaryColor),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new StudentattendancereportPage()));
                    })*/
                ]) : new Container(),
                logintype =="teacher"?
                new ExpansionTile(
                    title: new Container(
                        margin: EdgeInsets.all(5),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: new Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blueGrey,
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                    border: Border.all(color: Colors.white, width: 3),
                                    color: Theme.of(context).primaryColor),
                                child: new SvgPicture.asset(
                                  "assets/dashboard.svg",
                                  width: 15,
                                  height: 15,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(10),
                              ),
                              flex: 5,
                            ),
                            Expanded(
                              child: new Container(
                                child: new Text(
                                  "Dashboard",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                margin: EdgeInsets.only(left: 5),
                              ),
                              flex: 17,
                            ),
                          ],
                        )),
                    children: <Widget>[
                      new Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: GridView.count(
                              shrinkWrap: true,
//                      physics: ScrollPhysics(),
                              crossAxisCount: 3,
                              children: List.generate(1, (index) {
                                return new Card(
                                  elevation: 5,
                                  margin:
                                  EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                                  color: Colors.white,
                                  child: new InkWell(
                                    child: new Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 15),
                                      child: new Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                              child: new Container(
                                                padding: EdgeInsets.all(3),
                                                child: new SvgPicture.asset(
                                                  "assets/dashboard.svg",
                                                  width: 40,
                                                  height: 40,
                                                  color: Colors.green,
                                                ),
                                              )),
                                          new Container(
                                            padding: EdgeInsets.all(3),
                                            child: new Text(
                                              "Dashboard",
                                              style: TextStyle(
                                                  color: Colors.green, fontSize: 10),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                          new DashboardPage()));
                                    },
                                    splashColor: Colors.green,
                                  ),
                                );
                              }))),
                    ]) : new Container(),
                logintype=="student"?
                new ExpansionTile(
                    title: new Container(
                        margin: EdgeInsets.all(5),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: new Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blueGrey,
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                    border: Border.all(color: Colors.white, width: 3),
                                    color: Theme.of(context).primaryColor),
                                child: new SvgPicture.asset(
                                  "assets/dashboard.svg",
                                  width: 15,
                                  height: 15,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(7),
                              ),
                              flex: 5,
                            ),
                            Expanded(
                              child: new Container(
                                child: new Text(
                                  "Dashboard",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                margin: EdgeInsets.only(left: 5),
                              ),
                              flex: 17,
                            ),
                          ],
                        )),
                    children: <Widget>[
                      new Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: GridView.count(
                              shrinkWrap: true,
//                      physics: ScrollPhysics(),
                              crossAxisCount: 3,
                              children: List.generate(1, (index) {
                                return new Card(
                                  elevation: 5,
                                  margin:
                                  EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                                  color: Colors.white,
                                  child: new InkWell(
                                    child: new Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 15),
                                      child: new Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                              child: new Container(
                                                padding: EdgeInsets.all(3),
                                                child: new SvgPicture.asset(
                                                  "assets/dashboard.svg",
                                                  width: 40,
                                                  height: 40,
                                                  color: Colors.green,
                                                ),
                                              )),
                                          new Container(
                                            padding: EdgeInsets.all(3),
                                            child: new Text(
                                              "Dashboard",
                                              style: TextStyle(
                                                  color: Colors.green, fontSize: 10),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                          new DashboardPage()));
                                    },
                                    splashColor: Colors.green,
                                  ),
                                );
                              }))),
                    ])  : new Container(),

                logintype == "teacher"
                    ? new ExpansionTile(
                  title: new Container(
                      margin: EdgeInsets.all(5),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[

                          Expanded(
                            child: new Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueGrey,
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                  border:
                                  Border.all(color: Colors.white, width: 3),
                                  color: Theme.of(context).primaryColor),
                              child: new SvgPicture.asset(
                                "assets/student.svg",
                                width: 15,
                                height: 15,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.all(10),
                            ),
                            flex: 5,
                          ),
                          Expanded(
                            child: new Container(
                              child: new Text(
                                "Student Information",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Theme
                                      .of(context)
                                      .primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              margin: EdgeInsets.only(left: 5),
                            ),
                            flex: 17,
                          ),
                        ],
                      )),
                  children: <Widget>[
                    new Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: GridView.count(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            crossAxisCount: 3,
                            children: List.generate(Classeslist.length, (index) {
                              return new Card(
                                elevation: 5,
                                margin: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                                color: Colors.white,
                                child: new InkWell(
                                  child: new Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    child: new Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                            child: new Container(
                                              padding: EdgeInsets.all(3),
                                              child: new SvgPicture.asset(
                                                "assets/class1.svg",
                                                width: 40,
                                                height: 40,
                                                color: Colors.green,
                                              ),
                                            )),
                                        new Container(
                                          padding: EdgeInsets.only(top:3),
                                          child: new Text(
                                            "Class - " +
                                                Classeslist[index]['name'],
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 8),
                                            maxLines: 2,
                                            //   overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                            new StudentstabsPage(
                                              id: Classeslist[index]
                                              ['class_id'],
                                            )));
                                  },
                                  splashColor: Colors.green,
                                ),
                              );
                            })))
                  ],
                )
                    : new Container(),
//                logintype == "student"
//                    ? new ExpansionTile(
//                  title: new Container(
//                      margin: EdgeInsets.all(5),
//                      child: new Row(
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        children: <Widget>[
////
////                            Expanded(
////                              child: new Container(
////                                decoration: BoxDecoration(
////                                    shape: BoxShape.circle,
////                                    boxShadow: [
////                                      BoxShadow(
////                                        color: Colors.blueGrey,
////                                        blurRadius: 5.0,
////                                      ),
////                                    ],
////                                    border:
////                                    Border.all(color: Colors.white, width: 3),
////                                    color: Theme.of(context).primaryColor),
////                                child: new SvgPicture.asset(
////                                  "assets/student.svg",
////                                  width: 20,
////                                  height: 20,
////                                  color: Colors.white,
////                                ),
////                                padding: EdgeInsets.all(10),
////                              ),
////                              flex: 5,
////                            ),
//                          Expanded(
//                            child: new Container(
//                              child: new Text(
//                                "Student Information",
//                                style: TextStyle(
//                                  fontSize: 15,
//                                  color: Theme
//                                      .of(context)
//                                      .primaryColor,
//                                  fontWeight: FontWeight.bold,
//                                ),
//                              ),
//                              margin: EdgeInsets.only(left: 5),
//                            ),
//                            flex: 17,
//                          ),
//                        ],
//                      )),
//                  children: <Widget>[
//                    new Container(
//                        margin: EdgeInsets.only(left: 10, right: 10),
//                        child: GridView.count(
//                            shrinkWrap: true,
//                            physics: ScrollPhysics(),
//                            crossAxisCount: 3,
//                            children: List.generate(Classeslist.length, (index) {
//                              return new Card(
//                                elevation: 5,
//                                margin: EdgeInsets.symmetric(
//                                    vertical: 5, horizontal: 5),
//                                shape: RoundedRectangleBorder(
//                                    borderRadius:
//                                    BorderRadius.all(Radius.circular(10))),
//                                color: Colors.white,
//                                child: new InkWell(
//                                  child: new Container(
//                                    padding: EdgeInsets.symmetric(
//                                        horizontal: 10, vertical: 15),
//                                    child: new Column(
//                                      mainAxisSize: MainAxisSize.max,
//                                      crossAxisAlignment:
//                                      CrossAxisAlignment.center,
//                                      children: <Widget>[
//                                        Expanded(
//                                            child: new Container(
//                                              padding: EdgeInsets.all(3),
//                                              child: new SvgPicture.asset(
//                                                "assets/class1.svg",
//                                                width: 50,
//                                                height: 50,
//                                                color: Colors.green,
//                                              ),
//                                            )),
//                                        new Container(
//                                          padding: EdgeInsets.all(3),
//                                          child: new Text(
//                                            "Class - " +
//                                                Classeslist[index]['name'],
//                                            style: TextStyle(
//                                                color: Colors.green,
//                                                fontSize: 10),
//                                            maxLines: 1,
//                                            overflow: TextOverflow.ellipsis,
//                                          ),
//                                        )
//                                      ],
//                                    ),
//                                  ),
//                                  onTap: () {
//                                    Navigator.of(context).pop();
//                                    Navigator.of(context).push(
//                                        new MaterialPageRoute(
//                                            builder: (BuildContext context) =>
//                                            new StudentstabsPage(
//                                              id: Classeslist[index]
//                                              ['class_id'],
//                                            )));
//                                  },
//                                  splashColor: Colors.green,
//                                ),
//                              );
//                            })))
//                  ],
//                )
//                    : new Container(),

                logintype=="parent" ?
                new ExpansionTile(
                    title: new Container(
                        margin: EdgeInsets.all(5),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: new Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blueGrey,
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                    border: Border.all(color: Colors.white, width: 3),
                                    color: Theme.of(context).primaryColor),
                                child: new SvgPicture.asset(
                                  "assets/dashboard.svg",
                                  width: 15,
                                  height: 15,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(10),
                              ),
                              flex: 5,
                            ),
                            Expanded(
                              child: new Container(
                                child: new Text(
                                  "Dashboard",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                margin: EdgeInsets.only(left: 5),
                              ),
                              flex: 17,
                            ),
                          ],
                        )),
                    children: <Widget>[
                      new Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: GridView.count(
                              shrinkWrap: true,
//                      physics: ScrollPhysics(),
                              crossAxisCount: 3,
                              children: List.generate(1, (index) {
                                return new Card(
                                  elevation: 5,
                                  margin:
                                  EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                                  color: Colors.white,
                                  child: new InkWell(
                                    child: new Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 15),
                                      child: new Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                              child: new Container(
                                                padding: EdgeInsets.all(3),
                                                child: new SvgPicture.asset(
                                                  "assets/dashboard.svg",
                                                  width: 40,
                                                  height: 40,
                                                  color: Colors.green,
                                                ),
                                              )),
                                          new Container(
                                            padding: EdgeInsets.all(3),
                                            child: new Text(
                                              "Dashboard",
                                              style: TextStyle(
                                                  color: Colors.green, fontSize: 10),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                          new DashboardPage()));
                                    },
                                    splashColor: Colors.green,
                                  ),
                                );
                              }))),
                    ])
                    : new Container(),
                logintype == "admin" ? new Container() :
                ExpansionTile(
                    title: new Container(
                        margin: EdgeInsets.all(5),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: new Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blueGrey,
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                    border: Border.all(color: Colors.white, width: 3),
                                    color: Theme.of(context).primaryColor),
                                child: new SvgPicture.asset(
                                  "assets/classroom.svg",
                                  width: 15,
                                  height: 15,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(10),
                              ),
                              flex: 5,
                            ),
                            Expanded(
                              child: new Container(
                                child: new Text(
                                  "Teachers",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                margin: EdgeInsets.only(left: 5),
                              ),
                              flex: 17,
                            ),
                          ],
                        )),
                    children: <Widget>[
                      new Container(
                          margin: EdgeInsets.only(left: 10,right:10),
                          child: GridView.count(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              crossAxisCount: 3,
                              children: List.generate(1, (index) {
                                return new Card(
                                  elevation: 5,
                                  margin:
                                  EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                                  color: Colors.white,
                                  child: new InkWell(
                                    child: new Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 15),
                                      child: new Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                              child: new Container(
                                                padding: EdgeInsets.all(3),
                                                child: new SvgPicture.asset(
                                                  "assets/teacher.svg",
                                                  width: 40,
                                                  height: 40,
                                                  color: Colors.green,
                                                ),
                                              )),
                                          new Container(
                                            padding: EdgeInsets.all(3),
                                            child: new Text(
                                              "Teachers",
                                              style: TextStyle(
                                                  color: Colors.green, fontSize: 10),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                          new TeachersformationPage()));
                                    },
                                    splashColor: Colors.green,
                                  ),
                                );
                              })))
                    ]
                ),
                logintype == "teacher"
                    ? new Column(
                  children: <Widget>[

                    ExpansionTile(
                      title:     new Container(
                          margin: EdgeInsets.all(5),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: new Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueGrey,
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                      border: Border.all(color: Colors.white, width: 3),
                                      color: Theme.of(context).primaryColor),
                                  child: new SvgPicture.asset(
                                    "assets/book.svg",
                                    width: 15,
                                    height: 15,
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                                flex: 5,
                              ),
                              Expanded(
                                child: new Container(
                                  child: new Text(
                                    "Subject",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(left: 5),
                                ),
                                flex: 17,
                              ),
                            ],
                          )),
                      children: <Widget>[
                        new Container(
                            margin: EdgeInsets.only(left: 10,right: 10),
                            child: GridView.count(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                crossAxisCount: 3,
                                children:
                                List.generate(Classeslist.length, (index) {
                                  return new Card(
                                    elevation: 5,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    color: Colors.white,
                                    child: new InkWell(
                                      child: new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                child: new Container(
                                                  padding: EdgeInsets.all(3),
                                                  child: new SvgPicture.asset(
                                                    "assets/class1.svg",
                                                    width: 40,
                                                    height: 40,
                                                    color: Colors.green,
                                                  ),
                                                )),
                                            new Container(
                                              padding: EdgeInsets.only(top:3),
                                              child: new Text(
                                                "Class - " +
                                                    Classeslist[index]['name'].toString(),
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 8),
                                                maxLines: 2,
                                                //overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                new SubjectsPage(
                                                  classname:
                                                  Classeslist[index]
                                                  ['name'].toString(),
                                                  id: Classeslist[index]
                                                  ['class_id'],
                                                )));
                                      },
                                      splashColor: Colors.green,
                                    ),
                                  );
                                }))),
                      ],
                    ),
                    ExpansionTile(
                      title: new Container(
                          margin: EdgeInsets.all(5),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: new Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueGrey,
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                      border: Border.all(
                                          color: Colors.white, width: 3),
                                      color: Theme.of(context).primaryColor),
                                  child: new SvgPicture.asset(
                                    "assets/openbook.svg",
                                    width: 15,
                                    height: 15,
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                                flex:5,
                              ),
                              Expanded(
                                child: new Container(
                                  child: new Text(
                                    "Academic Syllabus",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(left: 5),
                                ),
                                flex: 17,
                              ),
                            ],
                          )),
                      children: <Widget>[
                        new Container(
                            margin: EdgeInsets.only(left: 10,right: 10),
                            child: GridView.count(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                crossAxisCount: 3,
                                children: List.generate(1, (index) {
                                  return new Card(
                                    elevation: 5,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    color: Colors.white,
                                    child: new InkWell(
                                      child: new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                child: new Container(
                                                  padding: EdgeInsets.all(3),
                                                  child: new SvgPicture.asset(
                                                    "assets/openbook.svg",
                                                    width: 40,
                                                    height: 40,
                                                    color: Colors.green,
                                                  ),
                                                )),
                                            new Container(
                                              padding: EdgeInsets.only(top:3),
                                              child: new Text(
                                                "Academic Syllabus",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 8),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                // overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (BuildContext
                                                context) =>
                                                new AcademicsyllabustabsPage()));
                                      },
                                      splashColor: Colors.green,
                                    ),
                                  );
                                }))),
                      ],
                    ),
                    ExpansionTile(
                      title:   new Container(
                          margin: EdgeInsets.all(5),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: new Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueGrey,
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                      border: Border.all(
                                          color: Colors.white, width: 3),
                                      color: Theme.of(context).primaryColor),
                                  child: new SvgPicture.asset(
                                    "assets/class1.svg",
                                    color: Colors.white,
                                    width: 15,
                                    height: 15,
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                                flex:5,
                              ),
                              Expanded(
                                child: new Container(
                                  child: new Text(
                                    "Class Routine",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(left: 5),
                                ),
                                flex: 17,
                              ),
                            ],
                          )),
                      children: <Widget>[

                        new Container(
                            margin: EdgeInsets.only(left: 10,right: 10),
                            child: GridView.count(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                crossAxisCount: 3,
                                children:
                                List.generate(Classeslist.length, (index) {
                                  return new Card(
                                    elevation: 5,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    color: Colors.white,
                                    child: new InkWell(
                                      child: new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                child: new Container(
                                                  padding: EdgeInsets.all(3),
                                                  child: new SvgPicture.asset(
                                                    "assets/class1.svg",
                                                    width: 40,
                                                    height: 40,
                                                    color: Colors.green,
                                                  ),
                                                )),
                                            new Container(
                                              padding: EdgeInsets.only(top:3),
                                              child: new Text(
                                                "Class - " +
                                                    Classeslist[index]['name'].toString(),
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 8),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (BuildContext
                                                context) =>
                                                new SectionstimetabletabsPage(
                                                  id: Classeslist[index]
                                                  ['class_id'],
                                                  name: Classeslist[index]
                                                  ['name'].toString(),
                                                )));
                                      },
                                      splashColor: Colors.green,
                                    ),
                                  );
                                }))),
                      ],
                    ),
                    ExpansionTile(
                      title: new Container(
                          margin: EdgeInsets.all(5),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: new Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueGrey,
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                      border: Border.all(color: Colors.white, width: 3),
                                      color: Theme.of(context).primaryColor),
                                  child: new SvgPicture.asset(
                                    "assets/book.svg",
                                    width: 15,
                                    height: 15,
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                                flex:5,
                              ),
                              Expanded(
                                child: new Container(
                                  child: new Text(
                                    "Study Material",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(left: 5),
                                ),
                                flex: 17,
                              ),
                            ],
                          )),
                      children: <Widget>[

                        new Container(
                            margin: EdgeInsets.only(left: 10,right:10),
                            child: GridView.count(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                crossAxisCount: 3,
                                children: List.generate(1, (index) {
                                  return new Card(
                                    elevation: 5,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    color: Colors.white,
                                    child: new InkWell(
                                      child: new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                child: new Container(
                                                  padding: EdgeInsets.all(3),
                                                  child: new SvgPicture.asset(
                                                    "assets/folder.svg",
                                                    width: 40,
                                                    height: 40,
                                                    color: Colors.green,
                                                  ),
                                                )),
                                            new Container(
                                              padding: EdgeInsets.all(3),
                                              child: new Text(
                                                "Study Material",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 10),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (BuildContext
                                                context) =>
                                                new StudymaterialPage()));
                                      },
                                      splashColor: Colors.green,
                                    ),
                                  );
                                }))),

                      ],
                    ),

                    ExpansionTile(
                      title: new Container(
                          margin: EdgeInsets.all(5),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: new Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueGrey,
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                      border: Border.all(
                                          color: Colors.white, width: 3),
                                      color: Theme.of(context).primaryColor),
                                  child: new SvgPicture.asset(
                                    "assets/checklist.svg",
                                    color: Colors.white,
                                    width: 15,
                                    height: 15,
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                                flex:5,
                              ),
                              Expanded(
                                child: new Container(
                                  child: new Text(
                                    "Daily Attendance",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(left: 5),
                                ),
                                flex: 17,
                              ),
                            ],
                          )),
                      children: <Widget>[
                        new Container(
                            margin: EdgeInsets.only(left: 10,right: 10),
                            child: GridView.count(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                crossAxisCount: 3,
                                children:
                                List.generate(Classeslist.length, (index) {
                                  return new Card(
                                    elevation: 5,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    color: Colors.white,
                                    child: new InkWell(
                                      child: new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                child: new Container(
                                                  padding: EdgeInsets.all(3),
                                                  child: new SvgPicture.asset(
                                                    "assets/class1.svg",
                                                    width: 40,
                                                    height: 40,
                                                    color: Colors.green,
                                                  ),
                                                )),
                                            new Container(
                                              padding: EdgeInsets.only(top:3),
                                              child: new Text(
                                                "Class - " +
                                                    Classeslist[index]['name'].toString(),
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 8),
                                                maxLines: 2,
                                                // overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (BuildContext
                                                context) =>
                                                new ManageTeacherattendancePage(
                                                  id: Classeslist[index]
                                                  ['class_id'],
                                                )));
                                      },
                                      splashColor: Colors.green,
                                    ),
                                  );
                                }))),
                      ],
                    ),
                    //
                    ExpansionTile(
                      title:             new Container(
                          margin: EdgeInsets.all(5),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: new Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueGrey,
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                      border: Border.all(
                                          color: Colors.white, width: 3),
                                      color: Theme.of(context).primaryColor),
                                  child: new SvgPicture.asset(
                                    "assets/checklist.svg",
                                    color: Colors.white,
                                    width: 15,
                                    height:15 ,
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                                flex: 5,
                              ),
                              Expanded(
                                child: new Container(
                                  child: new Text(
                                    "Subject Wise Daily Attendance",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(left: 5),
                                ),
                                flex: 17,
                              ),
                            ],
                          )),
                      children: <Widget>[
                        new Container(
                            margin: EdgeInsets.only(left: 10,right: 10),
                            child: GridView.count(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                crossAxisCount: 3,
                                children:
                                List.generate(Classeslist.length, (index) {
                                  return new Card(
                                    elevation: 5,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    color: Colors.white,
                                    child: new InkWell(
                                      child: new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                child: new Container(
                                                  padding: EdgeInsets.all(3),
                                                  child: new SvgPicture.asset(
                                                    "assets/class1.svg",
                                                    width: 40,
                                                    height: 40,
                                                    color: Colors.green,
                                                  ),
                                                )),
                                            new Container(
                                              padding: EdgeInsets.only(top:3),
                                              child: new Text(
                                                "Class - " +
                                                    Classeslist[index]['name'].toString(),
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 8),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (BuildContext
                                                context) =>
                                                new ManageSubjectWiseAttendance(
                                                  id: Classeslist[index]
                                                  ['class_id'],
                                                )));
                                      },
                                      splashColor: Colors.green,
                                    ),
                                  );
                                }))),
                      ],
                    ),
                    ExpansionTile(
                      title:  new Container(
                          margin: EdgeInsets.all(5),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: new Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueGrey,
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                      border: Border.all(color: Colors.white, width: 3),
                                      color: Theme.of(context).primaryColor),
                                  child: new SvgPicture.asset(
                                    "assets/class1.svg",
                                    width: 15,
                                    height: 15,
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                                flex: 5,
                              ),
                              Expanded(
                                child: new Container(
                                  child: new Text(
                                    "Online Classroom",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(left: 5),
                                ),
                                flex: 17,
                              ),
                            ],
                          )),
                      children: <Widget>[

                        new Container(
                            margin: EdgeInsets.only(left: 10,right:10),
                            child: GridView.count(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                crossAxisCount: 3,
                                children: <Widget>[
                                  new Card(
                                    elevation: 5,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    color: Colors.white,
                                    child: new InkWell(
                                      child: new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                child: new Container(
                                                  padding: EdgeInsets.all(3),
                                                  child: new Icon(Icons.camera,size: 40,color: Colors.green,),
                                                )),
                                            new Container(
                                              padding: EdgeInsets.all(3),
                                              child: new Text(
                                                "Online Classroom",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 10),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (BuildContext
                                                context) =>
                                                new TeacherClassroomPage()));
                                      },
                                      splashColor: Colors.green,
                                    ),
                                  ),
                                  new Card(
                                    elevation: 5,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    color: Colors.white,
                                    child: new InkWell(
                                      child: new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                child: new Container(
                                                  padding: EdgeInsets.all(3),
                                                  child: new Icon(Icons.videocam,size: 40,color: Colors.green,),
                                                )),
                                            new Container(
                                              padding: EdgeInsets.all(3),
                                              child: new Text(
                                                "Classroom Recordings",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 10),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (BuildContext
                                                context) =>
                                                new TeacherClassroomrecordingsPage()));
                                      },
                                      splashColor: Colors.green,
                                    ),
                                  )
                                ]
                            )),
                      ],
                    ),    //
                    ExpansionTile(
                      title:new Container(
                          margin: EdgeInsets.all(5),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: new Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueGrey,
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                      border: Border.all(
                                          color: Colors.white, width: 3),
                                      color: Theme.of(context).primaryColor),
                                  child: new SvgPicture.asset(
                                    "assets/exam.svg",
                                    width: 15,
                                    height: 15,
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                                flex:5,
                              ),
                              Expanded(
                                child: new Container(
                                  child: new Text(
                                    "Exams",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(left: 5),
                                ),
                                flex: 17,
                              ),
                            ],
                          )),
                      children: <Widget>[
                        new Container(
                            margin: EdgeInsets.only(left: 10,right:10),
                            child: GridView.count(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                crossAxisCount: 3,
                                children: <Widget>[
                                  new Card(
                                    elevation: 5,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    color: Colors.white,
                                    child: new InkWell(
                                      child: new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                child: new Container(
                                                  padding: EdgeInsets.all(3),
                                                  child: new SvgPicture.asset(
                                                    "assets/exam.svg",
                                                    width: 40,
                                                    height: 40,
                                                    color: Colors.green,
                                                  ),
                                                )),
                                            new Container(
                                              padding: EdgeInsets.all(3),
                                              child: new Text(
                                                "Manage Exam Marks",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 10),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (BuildContext
                                                context) =>
                                                new ManageExamMarksPage()));
                                      },
                                      splashColor: Colors.green,
                                    ),
                                  ),
                                  new Card(
                                    elevation: 5,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    color: Colors.white,
                                    child: new InkWell(
                                      child: new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                child: new Container(
                                                  padding: EdgeInsets.all(3),
                                                  child: new SvgPicture.asset(
                                                    "assets/paper.svg",
                                                    width: 50,
                                                    height: 50,
                                                    color: Colors.green,
                                                  ),
                                                )),
                                            new Container(
                                              padding: EdgeInsets.all(3),
                                              child: new Text(
                                                "Question Paper",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 10),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (BuildContext
                                                context) =>
                                                new Questionpaper_TeacherPage()));
                                      },
                                      splashColor: Colors.green,
                                    ),
                                  ),
                                  new Card(
                                    elevation: 5,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    color: Colors.white,
                                    child: new InkWell(
                                      child: new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                child: new Container(
                                                  padding: EdgeInsets.all(3),
                                                  child: new SvgPicture.asset(
                                                    "assets/exam.svg",
                                                    width: 50,
                                                    height: 50,
                                                    color: Colors.green,
                                                  ),
                                                )),
                                            new Container(
                                              padding: EdgeInsets.all(3),
                                              child: new Text(
                                                "Create Online Exam",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 10),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (BuildContext
                                                context) =>
                                                new CreateonlineexamPage(type: "new",details: null,)));
                                      },
                                      splashColor: Colors.green,
                                    ),
                                  ),
                                  new Card(
                                    elevation: 5,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    color: Colors.white,
                                    child: new InkWell(
                                      child: new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                child: new Container(
                                                  padding: EdgeInsets.all(3),
                                                  child: new SvgPicture.asset(
                                                    "assets/exam.svg",
                                                    width: 50,
                                                    height: 50,
                                                    color: Colors.green,
                                                  ),
                                                )),
                                            new Container(
                                              padding: EdgeInsets.all(3),
                                              child: new Text(
                                                "Manage Online Exam",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 10),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (BuildContext
                                                context) =>
                                                new AdminManageonlineexamsPage()));
                                      },
                                      splashColor: Colors.green,
                                    ),
                                  ),
                                ])),
                      ],
                    ),

                    ExpansionTile(
                      title: Container(
                          margin: EdgeInsets.all(5),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: new Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueGrey,
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                      border: Border.all(color: Colors.white, width: 3),
                                      color: Theme.of(context).primaryColor),
                                  child: new SvgPicture.asset(
                                    "assets/book1.svg",
                                    width: 15,
                                    height: 15,
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                                flex: 5,
                              ),
                              Expanded(
                                child: new Container(
                                  child: new Text(
                                    "Library",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(left: 5),
                                ),
                                flex: 17,
                              ),
                            ],
                          )),
                      children: <Widget>[
                        new Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: GridView.count(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                crossAxisCount: 3,
                                children: List.generate(1, (index) {
                                  return new Card(
                                    elevation: 5,
                                    margin:
                                    EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                    color: Colors.white,
                                    child: new InkWell(
                                      child: new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: <Widget>[
                                            Expanded(
                                                child: new Container(
                                                  padding: EdgeInsets.all(3),
                                                  child: new SvgPicture.asset(
                                                    "assets/book1.svg",
                                                    width:40,
                                                    height: 40,
                                                    color: Colors.green,
                                                  ),
                                                )),
                                            new Container(
                                              padding: EdgeInsets.all(3),
                                              child: new Text(
                                                "Books",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 10),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {

                                        Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                              new BookdetailsPageTeacher()),
                                        );

                                      },
                                      splashColor: Colors.green,
                                    ),
                                  );
                                }))),


                      ],
                    ),

                  ],
                )
                    : new Container(),
                logintype == "parent"
                    ?  new Column(
                  children: <Widget>[
                    ExpansionTile(
                      title: new Container(
                          margin: EdgeInsets.all(5),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: new Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueGrey,
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                      border: Border.all(
                                          color: Colors.white, width: 3),
                                      color: Theme.of(context).primaryColor),
                                  child: new SvgPicture.asset(
                                    "assets/openbook.svg",
                                    width: 15,
                                    height: 15,
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                                flex: 5,
                              ),
                              Expanded(
                                child: new Container(
                                  child: new Text(
                                    "Academic Syllabus",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(left: 5),
                                ),
                                flex: 17,
                              ),
                            ],
                          )),
                      children: <Widget>[
                        new Container(
                            margin: EdgeInsets.only(left: 10),
                            child: GridView.count(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                crossAxisCount: 3,
                                children:
                                List.generate(Childlist.length, (index) {
                                  return new Card(
                                    elevation: 5,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    color: Colors.white,
                                    child: new InkWell(
                                      child: new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                child: new Container(
                                                  padding: EdgeInsets.all(
                                                      3),
                                                  child: new SvgPicture
                                                      .asset(
                                                    "assets/student1.svg",
                                                    width: 40,
                                                    height: 40,
                                                    color: Colors.green,
                                                  ),
                                                )),
                                            new Container(
                                              padding: EdgeInsets.only(top:3),
                                              child: new Text(
                                                Childlist[index]['name'],
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 8),
                                                maxLines: 2,
                                                // overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (BuildContext
                                                context) =>
                                                new AcademicsyllabusPage(
                                                  studentname:
                                                  Childlist[index]
                                                  ['name'],
                                                  studentid: Childlist[index]
                                                  ['student_id'],
                                                )));
                                      },
                                      splashColor: Colors.green,
                                    ),
                                  );
                                }))),
                      ],
                    ),
                    ExpansionTile(
                      title: new Container(
                          margin: EdgeInsets.all(5),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: new Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueGrey,
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                      border: Border.all(color: Colors.white, width: 3),
                                      color: Theme.of(context).primaryColor),
                                  child: new SvgPicture.asset(
                                    "assets/class1.svg",
                                    width: 15,
                                    height: 15,
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                                flex: 5,
                              ),
                              Expanded(
                                child: new Container(
                                  child: new Text(
                                    "Class Routine",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(left: 5),
                                ),
                                flex: 17,
                              ),
                            ],
                          )),

                      children: <Widget>[
                        new Container(
                            margin: EdgeInsets.only(left: 10),
                            child: GridView.count(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                crossAxisCount: 3,
                                children:
                                List.generate(Childlist.length, (index) {
                                  return new Card(
                                    elevation: 5,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    color: Colors.white,
                                    child: new InkWell(
                                      child: new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                child: new Container(
                                                  padding: EdgeInsets.all(
                                                      3),
                                                  child: new SvgPicture
                                                      .asset(
                                                    "assets/student1.svg",
                                                    width: 40,
                                                    height: 40,
                                                    color: Colors.green,
                                                  ),
                                                )),
                                            new Container(
                                              padding: EdgeInsets.only(top:3),
                                              child: new Text(
                                                Childlist[index]['name'],
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 8),
                                                maxLines: 2,
                                                //   overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder:
                                                    (
                                                    BuildContext context) =>
                                                new ClassroutinesPage(
                                                  studentname:
                                                  Childlist[index]
                                                  ['name'],
                                                  id: Childlist[index]
                                                  ['student_id'],
                                                )));
                                      },
                                      splashColor: Colors.green,
                                    ),
                                  );
                                }))),
                      ],
                    ),
                    ExpansionTile(
                      title: new Container(
                          margin: EdgeInsets.all(5),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: new Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueGrey,
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                      border: Border.all(
                                          color: Colors.white, width: 3),
                                      color: Theme.of(context).primaryColor),
                                  child: new SvgPicture.asset(
                                    "assets/checklist.svg",
                                    color: Colors.white,
                                    width: 15,
                                    height: 15,
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                                flex: 5,
                              ),
                              Expanded(
                                child: new Container(
                                  child: new Text(
                                    " Student Daily Attendance",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(left: 5),
                                ),
                                flex: 17,
                              ),
                            ],
                          )),
                      children: <Widget>[
                        new Container(
                            margin: EdgeInsets.only(left: 10),
                            child: GridView.count(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                crossAxisCount: 3,
                                children:
                                List.generate(Childlist.length, (index) {
                                  return new Card(
                                    elevation: 5,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    color: Colors.white,
                                    child: new InkWell(
                                      child: new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                child: new Container(
                                                  padding: EdgeInsets.all(
                                                      3),
                                                  child: new SvgPicture
                                                      .asset(
                                                    "assets/student1.svg",
                                                    width: 40,
                                                    height: 40,
                                                    color: Colors.green,
                                                  ),
                                                )),
                                            new Container(
                                              padding: EdgeInsets.only(top:3),
                                              child: new Text(
                                                Childlist[index]['name'],
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 8),
                                                maxLines: 2,
                                                //  overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (BuildContext
                                                context) =>
                                                // parentStudentAttendance()
                                                new parentStudentAttendance(
                                                  studentname:
                                                  Childlist[index]
                                                  ['name'],
                                                  id: Childlist[index]
                                                  ['student_id'],
                                                )
                                            ));
                                      },
                                      splashColor: Colors.green,
                                    ),
                                  );
                                }))),
                      ],
                    ),
                    ExpansionTile(
                      title: Container(
                          margin: EdgeInsets.all(5),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: new Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueGrey,
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                      border: Border.all(color: Colors.white, width: 3),
                                      color: Theme.of(context).primaryColor),
                                  child: new SvgPicture.asset(
                                    "assets/checklist.svg",
                                    width: 15,
                                    height: 15,
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                                flex: 5,
                              ),
                              Expanded(
                                child: new Container(
                                  child: new Text(
                                    "Subject-Wise-Attendance",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(left: 5),
                                ),
                                flex: 17,
                              ),
                            ],
                          )),
                      children: <Widget>[

                        new Container(
                            margin: EdgeInsets.only(left: 10),
                            child: GridView.count(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                crossAxisCount: 3,
                                children: List.generate(1, (index) {
                                  return new Card(
                                    elevation: 5,
                                    margin:
                                    EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                    color: Colors.white,
                                    child: new InkWell(
                                      child: new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: <Widget>[
                                            Expanded(
                                                child: new Container(
                                                  padding: EdgeInsets.all(
                                                      3),
                                                  child: new SvgPicture
                                                      .asset(
                                                    "assets/student1.svg",
                                                    width: 40,
                                                    height: 40,
                                                    color: Colors.green,
                                                  ),
                                                )),
                                            new Container(
                                              padding: EdgeInsets.only(top:3),
                                              child: new Text(
                                                Childlist[index]['name'],
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 8),
                                                maxLines: 2,
                                                //  overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext
                                              context) =>
                                              new ParentSubjectWiseAttendance(
                                                studentname:
                                                Childlist[index]
                                                ['name'],
                                              id: Childlist[index]
                                                ['student_id'],
                                              )),

                                        );
                                      },
                                      splashColor: Colors.green,
                                    ),
                                  );
                                }))),

                      ],
                    ),
                    ExpansionTile(
                      title: new Container(
                          margin: EdgeInsets.all(5),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: new Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueGrey,
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                      border: Border.all(
                                          color: Colors.white, width: 3),
                                      color: Theme.of(context).primaryColor),
                                  child: new SvgPicture.asset(
                                    "assets/exam.svg",
                                    width: 15,
                                    height: 15,
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                                flex:5,
                              ),
                              Expanded(
                                child: new Container(
                                  child: new Text(
                                    "Exam Marks",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(left: 5),
                                ),
                                flex: 17,
                              ),
                            ],
                          )),
                      children: <Widget>[
                        new Container(
                            margin: EdgeInsets.only(left: 10),
                            child: GridView.count(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                crossAxisCount: 3,
                                children:
                                List.generate(Childlist.length, (index) {
                                  return new Card(
                                    elevation: 5,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    color: Colors.white,
                                    child: new InkWell(
                                      child: new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                child: new Container(
                                                  padding: EdgeInsets.all(
                                                      3),
                                                  child: new SvgPicture
                                                      .asset(
                                                    "assets/student1.svg",
                                                    width: 40,
                                                    height: 40,
                                                    color: Colors.green,
                                                  ),
                                                )),
                                            new Container(
                                              padding: EdgeInsets.all(3),
                                              child: new Text(
                                                Childlist[index]['name'],
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 8),
                                                maxLines: 2,
                                                overflow: TextOverflow
                                                    .ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder:
                                                    (
                                                    BuildContext context) =>
                                                new MarksTabScreen(
                                                  studentname:
                                                  Childlist[index]
                                                  ['name'],
                                                  id: Childlist[index]
                                                  ['student_id'],
                                                )));
                                      },
                                      splashColor: Colors.green,
                                    ),
                                  );
                                }))),
                      ],
                    ),
                    ExpansionTile(
                      title: new Container(
                          margin: EdgeInsets.all(5),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: new Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueGrey,
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                      border: Border.all(color: Colors.white, width: 3),
                                      color: Theme.of(context).primaryColor),
                                  child: new SvgPicture.asset(
                                    "assets/book.svg",
                                    width: 15,
                                    height: 15,
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                                flex:5,
                              ),
                              Expanded(
                                child: new Container(
                                  child: new Text(
                                    "Online Marks",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(left: 5),
                                ),
                                flex: 17,
                              ),
                            ],
                          )),
                      children: <Widget>[
                        new Container(
                            margin: EdgeInsets.only(left: 10),
                            child: GridView.count(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                crossAxisCount: 3,
                                children:
                                List.generate(Childlist.length, (index) {
                                  return new Card(
                                    elevation: 5,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    color: Colors.white,
                                    child: new InkWell(
                                      child: new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                child: new Container(
                                                  padding: EdgeInsets.all(
                                                      3),
                                                  child: new SvgPicture
                                                      .asset(
                                                    "assets/student1.svg",
                                                    width: 40,
                                                    height: 40,
                                                    color: Colors.green,
                                                  ),
                                                )),
                                            new Container(
                                              padding: EdgeInsets.all(3),
                                              child: new Text(
                                                //"OnlineExam",
                                                Childlist[index]['name'],
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 8),
                                                maxLines: 1,
                                                //  overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
//
//                                        Navigator.of(context).pop();
//                                        Navigator.of(context).push(new MaterialPageRoute(
//                                            builder: (BuildContext context) =>
//                                            new ParentOnlineView()
//                                        )
//                                        );
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (BuildContext
                                                context) =>
                                                new ParentOnlineView(
                                                  studentname:
                                                  Childlist[index]
                                                  ['name'],
                                                  studentid: Childlist[index]
                                                  ['student_id'],
                                                )));
                                      },
                                      splashColor: Colors.green,
                                    ),
                                  );
                                }))),
                      ],
                    ),
                    ExpansionTile(
                      title: new Container(
                          margin: EdgeInsets.all(5),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: new Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueGrey,
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                      border: Border.all(color: Colors.white, width: 3),
                                      color: Theme.of(context).primaryColor),
                                  child: new SvgPicture.asset(
                                    "assets/book.svg",
                                    width: 15,
                                    height: 15,
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                                flex:5,
                              ),
                              Expanded(
                                child: new Container(
                                  child: new Text(
                                    "Home Work",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(left: 5),
                                ),
                                flex: 17,
                              ),
                            ],
                          )),
                      children: <Widget>[
                        new Container(
                            margin: EdgeInsets.only(left: 10),
                            child: GridView.count(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                crossAxisCount: 3,
                                children:
                                List.generate(Childlist.length, (index) {
                                  return new Card(
                                    elevation: 5,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    color: Colors.white,
                                    child: new InkWell(
                                      child: new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                child: new Container(
                                                  padding: EdgeInsets.all(
                                                      3),
                                                  child: new SvgPicture
                                                      .asset(
                                                    "assets/student1.svg",
                                                    width: 40,
                                                    height: 40,
                                                    color: Colors.green,
                                                  ),
                                                )),
                                            new Container(
                                              padding: EdgeInsets.only(top:3),
                                              child: new Text(
                                                Childlist[index]['name'],
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 8),
                                                maxLines: 1,
                                                // overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (BuildContext
                                                context) =>
                                                new ParentHomework(
                                                  studentname:
                                                  Childlist[index]
                                                  ['name'],
                                                  studentid: Childlist[index]
                                                  ['student_id'],
                                                )));
                                      },
                                      splashColor: Colors.green,
                                    ),
                                  );
                                }))),
                      ],
                    ),
                    ExpansionTile(
                      title: new Container(
                          margin: EdgeInsets.all(5),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: new Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueGrey,
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                      border: Border.all(
                                          color: Colors.white, width: 3),
                                      color: Theme.of(context).primaryColor),
                                  child: new SvgPicture.asset(
                                      "assets/creditcard.svg",
                                      color: Colors.white,
                                      width: 15,
                                      height: 15
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                                flex:5,
                              ),
                              Expanded(
                                child: new Container(
                                  child: new Text(
                                    "Payments",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(left: 5),
                                ),
                                flex: 17,
                              ),
                            ],
                          )),
                      children: <Widget>[
                        new Container(
                            margin: EdgeInsets.only(left: 10),
                            child: GridView.count(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                crossAxisCount: 3,
                                children:
                                List.generate(Childlist.length, (index) {
                                  return new Card(
                                    elevation: 5,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    color: Colors.white,
                                    child: new InkWell(
                                      child: new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                child: new Container(
                                                  padding: EdgeInsets.all(
                                                      3),
                                                  child: new SvgPicture
                                                      .asset(
                                                    "assets/student1.svg",
                                                    width: 40,
                                                    height: 40,
                                                    color: Colors.green,
                                                  ),
                                                )),
                                            new Container(
                                              padding: EdgeInsets.all(3),
                                              child: new Text(
                                                Childlist[index]['name'],
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 8),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder:
                                                    (
                                                    BuildContext context) =>
                                                new ParentPayment(
                                                  studentname:
                                                  Childlist[index]
                                                  ['name'],
                                                  studentid: Childlist[index]
                                                  ['student_id'],
                                                )));
                                      },
                                      splashColor: Colors.green,
                                    ),
                                  );
                                }))),
                      ],
                    ),
                    ExpansionTile(
                      title: Container(
                          margin: EdgeInsets.all(5),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: new Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueGrey,
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                      border: Border.all(color: Colors.white, width: 3),
                                      color: Theme.of(context).primaryColor),
                                  child: new SvgPicture.asset(
                                    "assets/book1.svg",
                                    width: 15,
                                    height: 15,
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                                flex:5,
                              ),
                              Expanded(
                                child: new Container(
                                  child: new Text(
                                    "Library",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(left: 5),
                                ),
                                flex: 17,
                              ),
                            ],
                          )),
                      children: <Widget>[
                        new Container(
                            margin: EdgeInsets.only(left: 10),
                            child: GridView.count(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                crossAxisCount: 3,
                                children:
                                List.generate(Childlist.length, (index) {
                                  return new Card(
                                    elevation: 5,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    color: Colors.white,
                                    child: new InkWell(
                                      child: new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                child: new Container(
                                                  padding: EdgeInsets.all(
                                                      3),
                                                  child: new SvgPicture
                                                      .asset(
                                                    "assets/student1.svg",
                                                    width: 40,
                                                    height: 40,
                                                    color: Colors.green,
                                                  ),
                                                )),
                                            new Container(
                                              padding: EdgeInsets.all(3),
                                              child: new Text(
                                                Childlist[index]['name'],
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 8),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder:
                                                    (
                                                    BuildContext context) =>
                                                new Parent_BookdetailsPage1(
                                                  studentname:
                                                  Childlist[index]
                                                  ['name'],
                                                  studentid: Childlist[index]
                                                  ['student_id'],
                                                )));
                                      },
                                      splashColor: Colors.green,
                                    ),
                                  );
                                }))),


                      ],
                    ),
                  ],
                )
                    : new Container(),
                logintype == "student"
                    ? new Column(
                    children: <Widget>[

                      ExpansionTile(
                        title: new Container(
                            margin: EdgeInsets.all(5),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: new Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blueGrey,
                                            blurRadius: 5.0,
                                          ),
                                        ],
                                        border: Border.all(color: Colors.white, width: 3),
                                        color: Theme.of(context).primaryColor),
                                    child: new SvgPicture.asset(
                                      "assets/book.svg",
                                      width: 15,
                                      height: 15,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.all(10),
                                  ),
                                  flex: 5,
                                ),
                                Expanded(
                                  child: new Container(
                                    child: new Text(
                                      "Subjects",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Theme
                                            .of(context)
                                            .primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    margin: EdgeInsets.only(left: 5),
                                  ),
                                  flex: 17,
                                ),
                              ],
                            )),
                        children: <Widget>[
                          new Container(
                              margin: EdgeInsets.only(left: 10),
                              child: GridView.count(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  crossAxisCount: 3,
                                  children: List.generate(1, (index) {
                                    return new Card(
                                      elevation: 5,
                                      margin:
                                      EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                      color: Colors.white,
                                      child: new InkWell(
                                        child: new Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),
                                          child: new Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              Expanded(
                                                  child: new Container(
                                                    padding: EdgeInsets.all(3),
                                                    child: new SvgPicture.asset(
                                                      "assets/book.svg",
                                                      width: 40,
                                                      height: 40,
                                                      color: Colors.green,
                                                    ),
                                                  )),
                                              new Container(
                                                padding: EdgeInsets.only(top:3),
                                                child: new Text(
                                                  "Subjects",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 8),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder: (
                                                      BuildContext context) =>
                                                  new StudentSubjects()));
                                        },
                                        splashColor: Colors.green,
                                      ),
                                    );
                                  }))),
                        ],
                      ),

                      ExpansionTile(
                        title: Container(
                            margin: EdgeInsets.all(5),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: new Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blueGrey,
                                            blurRadius: 5.0,
                                          ),
                                        ],
                                        border: Border.all(color: Colors.white, width: 3),
                                        color: Theme.of(context).primaryColor),
                                    child: new SvgPicture.asset(
                                      "assets/checklist.svg",
                                      width: 15,
                                      height: 15,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.all(10),
                                  ),
                                  flex: 5,
                                ),
                                Expanded(
                                  child: new Container(
                                    child: new Text(
                                      "Academic Syllabus",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    margin: EdgeInsets.only(left: 5),
                                  ),
                                  flex: 17,
                                ),
                              ],
                            )),
                        children: <Widget>[
                          new Container(
                              margin: EdgeInsets.only(left: 10),
                              child: GridView.count(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  crossAxisCount: 3,
                                  children: List.generate(1, (index) {
                                    return new Card(
                                      elevation: 5,
                                      margin:
                                      EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                      color: Colors.white,
                                      child: new InkWell(
                                        child: new Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),
                                          child: new Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              Expanded(
                                                  child: new Container(
                                                    padding: EdgeInsets.all(3),
                                                    child: new SvgPicture.asset(
                                                      "assets/checklist.svg",
                                                      width: 40,
                                                      height: 40,
                                                      color: Colors.green,
                                                    ),
                                                  )),
                                              new Container(
                                                padding: EdgeInsets.only(top:3),
                                                child: new Text(
                                                  "Academic Syllabus",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 8),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder: (
                                                      BuildContext context) =>
                                                  new StudentAcademicSyllabus()));
                                        },
                                        splashColor: Colors.green,
                                      ),
                                    );
                                  }))),
                        ],
                      ),
                      ExpansionTile(
                        title: new Container(
                            margin: EdgeInsets.all(5),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: new Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blueGrey,
                                            blurRadius: 5.0,
                                          ),
                                        ],
                                        border: Border.all(color: Colors.white, width: 3),
                                        color: Theme.of(context).primaryColor),
                                    child: new SvgPicture.asset(
                                      "assets/class1.svg",
                                      width: 15,
                                      height: 15,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.all(10),
                                  ),
                                  flex: 5,
                                ),
                                Expanded(
                                  child: new Container(
                                    child: new Text(
                                      "Class Routine",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Theme
                                            .of(context)
                                            .primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    margin: EdgeInsets.only(left: 5),
                                  ),
                                  flex: 17,
                                ),
                              ],
                            )),
                        children: <Widget>[
                          new Container(
                              margin: EdgeInsets.only(left: 10),
                              child: GridView.count(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  crossAxisCount: 3,
                                  children: List.generate(1, (index) {
                                    return new Card(
                                      elevation: 5,
                                      margin:
                                      EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                      color: Colors.white,
                                      child: new InkWell(
                                        child: new Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),
                                          child: new Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              Expanded(
                                                  child: new Container(
                                                    padding: EdgeInsets.all(3),
                                                    child: new SvgPicture.asset(
                                                      "assets/class1.svg",
                                                      width: 40,
                                                      height: 40,
                                                      color: Colors.green,
                                                    ),
                                                  )),
                                              new Container(
                                                padding: EdgeInsets.only(top:3),
                                                child: new Text(
                                                  "Class Routine",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 8),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder: (
                                                      BuildContext context) =>
                                                  new StudentClassRoutine(
//                                          id: Studentlist[index]
//                                          ['student_id']
                                                  )));
                                        },
                                        splashColor: Colors.green,
                                      ),
                                    );
                                  }))),
                        ],
                      ),
                      ExpansionTile(
                        title: Container(
                            margin: EdgeInsets.all(5),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: new Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blueGrey,
                                            blurRadius: 5.0,
                                          ),
                                        ],
                                        border: Border.all(color: Colors.white, width: 3),
                                        color: Theme.of(context).primaryColor),
                                    child: new SvgPicture.asset(
                                      "assets/checklist.svg",
                                      width: 15,
                                      height: 15,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.all(10),
                                  ),
                                  flex: 5,
                                ),
                                Expanded(
                                  child: new Container(
                                    child: new Text(
                                      "Attendance",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Theme
                                            .of(context)
                                            .primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    margin: EdgeInsets.only(left: 5),
                                  ),
                                  flex: 17,
                                ),
                              ],
                            )),
                        children: <Widget>[

                          new Container(
                              margin: EdgeInsets.only(left: 10),
                              child: GridView.count(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  crossAxisCount: 3,
                                  children: List.generate(1, (index) {
                                    return new Card(
                                      elevation: 5,
                                      margin:
                                      EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                      color: Colors.white,
                                      child: new InkWell(
                                        child: new Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),
                                          child: new Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              Expanded(
                                                  child: new Container(
                                                    padding: EdgeInsets.only(top:3),
                                                    child: new SvgPicture.asset(
                                                      "assets/checklist.svg",
                                                      width: 40,
                                                      height: 40,
                                                      color: Colors.green,
                                                    ),
                                                  )),
                                              new Container(
                                                padding: EdgeInsets.all(3),
                                                child: new Text(
                                                  "Attendance",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 8),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder: (
                                                      BuildContext context) =>
                                                  new StudentAttendance()));
                                        },
                                        splashColor: Colors.green,
                                      ),
                                    );
                                  }))),

                        ],
                      ),

                      ExpansionTile(
                        title: Container(
                            margin: EdgeInsets.all(5),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: new Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blueGrey,
                                            blurRadius: 5.0,
                                          ),
                                        ],
                                        border: Border.all(color: Colors.white, width: 3),
                                        color: Theme.of(context).primaryColor),
                                    child: new SvgPicture.asset(
                                      "assets/checklist.svg",
                                      width: 15,
                                      height: 15,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.all(10),
                                  ),
                                  flex: 5,
                                ),
                                Expanded(
                                  child: new Container(
                                    child: new Text(
                                      "Subject-Wise-Attendance",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Theme
                                            .of(context)
                                            .primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    margin: EdgeInsets.only(left: 5),
                                  ),
                                  flex: 17,
                                ),
                              ],
                            )),
                        children: <Widget>[

                          new Container(
                              margin: EdgeInsets.only(left: 10),
                              child: GridView.count(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  crossAxisCount: 3,
                                  children: List.generate(1, (index) {
                                    return new Card(
                                      elevation: 5,
                                      margin:
                                      EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                      color: Colors.white,
                                      child: new InkWell(
                                        child: new Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),
                                          child: new Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              Expanded(
                                                  child: new Container(
                                                    padding: EdgeInsets.only(top:3),
                                                    child: new SvgPicture.asset(
                                                      "assets/checklist.svg",
                                                      width: 40,
                                                      height: 40,
                                                      color: Colors.green,
                                                    ),
                                                  )),
                                              new Container(
                                                padding: EdgeInsets.only(top:3),
                                                child: new Text(
                                                  "Subject-Wise-Attendance",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 8),
                                                  maxLines:3,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder: (
                                                      BuildContext context) =>
                                                  new StudentSubjectWiseAttendance()));
                                        },
                                        splashColor: Colors.green,
                                      ),
                                    );
                                  }))),

                        ],
                      ),

                      ExpansionTile(
                        title: Container(
                            margin: EdgeInsets.all(5),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: new Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blueGrey,
                                            blurRadius: 5.0,
                                          ),
                                        ],
                                        border: Border.all(color: Colors.white, width: 3),
                                        color: Theme.of(context).primaryColor),
                                    child: new SvgPicture.asset(
                                      "assets/book.svg",
                                      width: 15,
                                      height:15,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.all(10),
                                  ),
                                  flex: 5,
                                ),
                                Expanded(
                                  child: new Container(
                                    child: new Text(
                                      "Study Material",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Theme
                                            .of(context)
                                            .primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    margin: EdgeInsets.only(left: 5),
                                  ),
                                  flex: 17,
                                ),
                              ],
                            )),
                        children: <Widget>[
                          new Container(
                              margin: EdgeInsets.only(left: 10),
                              child: GridView.count(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  crossAxisCount: 3,
                                  children: List.generate(1, (index) {
                                    return new Card(
                                      elevation: 5,
                                      margin:
                                      EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                      color: Colors.white,
                                      child: new InkWell(
                                        child: new Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),
                                          child: new Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              Expanded(
                                                  child: new Container(
                                                    padding: EdgeInsets.all(3),
                                                    child: new SvgPicture.asset(
                                                      "assets/book.svg",
                                                      width: 40,
                                                      height: 40,
                                                      color: Colors.green,
                                                    ),
                                                  )),
                                              new Container(
                                                padding: EdgeInsets.only(top:3),
                                                child: new Text(
                                                  "Study Material",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 8),
                                                  maxLines:2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder: (
                                                      BuildContext context) =>
                                                  new Studentmaterial()));
                                        },
                                        splashColor: Colors.green,
                                      ),
                                    );
                                  }))),
                        ],
                      ),
                      ExpansionTile(
                        title: Container(
                            margin: EdgeInsets.all(5),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: new Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blueGrey,
                                            blurRadius: 5.0,
                                          ),
                                        ],
                                        border: Border.all(color: Colors.white, width: 3),
                                        color: Theme.of(context).primaryColor),
                                    child: new SvgPicture.asset(
                                      "assets/exam.svg",
                                      width: 15,
                                      height: 15,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.all(10),
                                  ),
                                  flex: 5,
                                ),
                                Expanded(
                                  child: new Container(
                                    child: new Text(
                                      "Exam Marks",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    margin: EdgeInsets.only(left: 5),
                                  ),
                                  flex: 17,
                                ),
                              ],
                            )),
                        children: <Widget>[
                          new Container(
                              margin: EdgeInsets.only(left: 10),
                              child: GridView.count(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  crossAxisCount: 3,
                                  children: List.generate(1, (index) {
                                    return new Card(
                                      elevation: 5,
                                      margin:
                                      EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                      color: Colors.white,
                                      child: new InkWell(
                                        child: new Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),
                                          child: new Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              Expanded(
                                                  child: new Container(
                                                    padding: EdgeInsets.only(top:3),
                                                    child: new SvgPicture.asset(
                                                      "assets/exam.svg",
                                                      width: 40,
                                                      height: 40,
                                                      color: Colors.green,
                                                    ),
                                                  )),
                                              new Container(
                                                padding: EdgeInsets.only(top:3),
                                                child: new Text(
                                                  "Exam Marks",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 10),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder: (
                                                      BuildContext context) =>
                                                  new MarksStudentTabScreen(
//                                          studentname:
//                                          Childlist[index]
//                                          ['name'],
//                                          id: Childlist[index]
//                                          ['student_id'],
                                                  )));
                                        },
                                        splashColor: Colors.green,
                                      ),
                                    );
                                  }))),
                        ],),
                      ExpansionTile(
                        title: new Container(
                            margin: EdgeInsets.all(5),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: new Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blueGrey,
                                            blurRadius: 5.0,
                                          ),
                                        ],
                                        border: Border.all(color: Colors.white, width: 3),
                                        color: Theme.of(context).primaryColor),
                                    child: new SvgPicture.asset(
                                      "assets/class1.svg",
                                      width:15,
                                      height:15,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.all(10),
                                  ),
                                  flex: 5,
                                ),
                                Expanded(
                                  child: new Container(
                                    child: new Text(
                                      "Online Classroom",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Theme
                                            .of(context)
                                            .primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    margin: EdgeInsets.only(left: 5),
                                  ),
                                  flex: 17,
                                ),
                              ],
                            )),
                        children: <Widget>[
                          new Container(
                              margin: EdgeInsets.only(left: 10),
                              child: GridView.count(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  crossAxisCount: 3,
                                  children: <Widget> [
                                    new Card(
                                      elevation: 5,
                                      margin:
                                      EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                      color: Colors.white,
                                      child: new InkWell(
                                        child: new Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),
                                          child: new Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              Expanded(
                                                  child: new Container(
                                                    padding: EdgeInsets.all(3),
                                                    child: new Icon(Icons.camera,size: 40,color: Colors.green,),
                                                  )),
                                              new Container(
                                                padding: EdgeInsets.only(top:3),
                                                child: new Text(
                                                  "classroom",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 8),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder: (
                                                      BuildContext context) =>
                                                  new StudentClassroomPage()));
                                        },
                                        splashColor: Colors.green,
                                      ),
                                    ),
                                    new Card(
                                      elevation: 5,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      color: Colors.white,
                                      child: new InkWell(
                                        child: new Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          child: new Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                  child: new Container(
                                                    padding: EdgeInsets.all(3),
                                                    child: new Icon(Icons.videocam,size: 40,color: Colors.green,),
                                                  )),
                                              new Container(
                                                padding: EdgeInsets.only(top:3),
                                                child: new Text(
                                                  "Classroom Recordings",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 8),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder: (BuildContext
                                                  context) =>
                                                  new StudentClassroomrecordingsPage()));
                                        },
                                        splashColor: Colors.green,
                                      ),
                                    )
                                  ])),
                        ],
                      ),
                      ExpansionTile(
                        title: Container(
                            margin: EdgeInsets.all(5),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: new Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blueGrey,
                                            blurRadius: 5.0,
                                          ),
                                        ],
                                        border: Border.all(color: Colors.white, width: 3),
                                        color: Theme.of(context).primaryColor),
                                    child: new SvgPicture.asset(
                                      "assets/book.svg",
                                      width: 15,
                                      height: 15,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.all(10),
                                  ),
                                  flex: 5,
                                ),
                                Expanded(
                                  child: new Container(
                                    child: new Text(
                                      "Online Exam",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Theme
                                            .of(context)
                                            .primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    margin: EdgeInsets.only(left: 5),
                                  ),
                                  flex: 17,
                                ),
                              ],
                            )),
                        children: <Widget>[
                          new Container(
                              margin: EdgeInsets.only(left: 10),
                              child: GridView.count(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  crossAxisCount: 3,
                                  children: List.generate(1, (index) {
                                    return new Card(
                                      elevation: 5,
                                      margin:
                                      EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                      color: Colors.white,
                                      child: new InkWell(
                                        child: new Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),
                                          child: new Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              Expanded(
                                                  child: new Container(
                                                    padding: EdgeInsets.only(top:3),
                                                    child: new SvgPicture.asset(
                                                      "assets/book.svg",
                                                      width: 40,
                                                      height: 40,
                                                      color: Colors.green,
                                                    ),
                                                  )),
                                              new Container(
                                                padding: EdgeInsets.all(3),
                                                child: new Text(
                                                  "Online Exam",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 8),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder: (
                                                      BuildContext context) =>
                                                  new OnlineExamsPage()));
                                        },
                                        splashColor: Colors.green,
                                      ),
                                    );
                                  }))),
                        ],
                      ),

                      ExpansionTile(
                        title: Container(
                            margin: EdgeInsets.all(5),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: new Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blueGrey,
                                            blurRadius: 5.0,
                                          ),
                                        ],
                                        border: Border.all(color: Colors.white, width: 3),
                                        color: Theme.of(context).primaryColor),
                                    child: new SvgPicture.asset(
                                      "assets/book.svg",
                                      width: 15,
                                      height: 15,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.all(10),
                                  ),
                                  flex: 5,
                                ),

                                Expanded(
                                  child: new Container(
                                    child: new Text(
                                      "Home Work",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Theme
                                            .of(context)
                                            .primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    margin: EdgeInsets.only(left: 5),
                                  ),
                                  flex: 17,
                                ),
                              ],
                            )),
                        children: <Widget>[
                          new Container(
                              margin: EdgeInsets.only(left: 10),
                              child: GridView.count(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  crossAxisCount: 3,
                                  children: List.generate(1, (index) {
                                    return new Card(
                                      elevation: 5,
                                      margin:
                                      EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                      color: Colors.white,
                                      child: new InkWell(
                                        child: new Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),
                                          child: new Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              Expanded(
                                                  child: new Container(
                                                    padding: EdgeInsets.only(top:3),
                                                    child: new SvgPicture.asset(
                                                      "assets/book.svg",
                                                      width: 40,
                                                      height: 40,
                                                      color: Colors.green,
                                                    ),
                                                  )),
                                              new Container(
                                                padding: EdgeInsets.only(top:3),
                                                child: new Text(
                                                  "Home Work",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 8),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder: (
                                                      BuildContext context) =>
                                                  new StudentHomework()));
                                        },
                                        splashColor: Colors.green,
                                      ),
                                    );
                                  }))),

                        ],
                      ),
//                      ExpansionTile(
//                        title: Container(
//                            margin: EdgeInsets.all(5),
//                            child: new Row(
//                              crossAxisAlignment: CrossAxisAlignment.center,
//                              mainAxisAlignment: MainAxisAlignment.start,
//                              children: <Widget>[
//                                Expanded(
//                                  child: new Container(
//                                    decoration: BoxDecoration(
//                                        shape: BoxShape.circle,
//                                        boxShadow: [
//                                          BoxShadow(
//                                            color: Colors.blueGrey,
//                                            blurRadius: 5.0,
//                                          ),
//                                        ],
//                                        border: Border.all(color: Colors.white, width: 3),
//                                        color: Theme.of(context).primaryColor),
//                                    child: new SvgPicture.asset(
//                                      "assets/creditcard.svg",
//                                      width: 15,
//                                      height: 15,
//                                      color: Colors.white,
//                                    ),
//                                    padding: EdgeInsets.all(10),
//                                  ),
//                                  flex: 5,
//                                ),
//                                Expanded(
//                                  child: new Container(
//                                    child: new Text(
//                                      "Payment",
//                                      style: TextStyle(
//                                        fontSize: 15,
//                                        color: Theme
//                                            .of(context)
//                                            .primaryColor,
//                                        fontWeight: FontWeight.bold,
//                                      ),
//                                    ),
//                                    margin: EdgeInsets.only(left: 5),
//                                  ),
//                                  flex: 17,
//                                ),
//                              ],
//                            )),
//                        children: <Widget>[
//                          new Container(
//                              margin: EdgeInsets.only(left: 10),
//                              child: GridView.count(
//                                  shrinkWrap: true,
//                                  physics: ScrollPhysics(),
//                                  crossAxisCount: 3,
//                                  children: List.generate(1, (index) {
//                                    return new Card(
//                                      elevation: 5,
//                                      margin:
//                                      EdgeInsets.symmetric(
//                                          vertical: 5, horizontal: 5),
//                                      shape: RoundedRectangleBorder(
//                                          borderRadius:
//                                          BorderRadius.all(Radius.circular(10))),
//                                      color: Colors.white,
//                                      child: new InkWell(
//                                        child: new Container(
//                                          padding: EdgeInsets.symmetric(
//                                              horizontal: 10, vertical: 15),
//                                          child: new Column(
//                                            mainAxisSize: MainAxisSize.max,
//                                            crossAxisAlignment: CrossAxisAlignment
//                                                .center,
//                                            children: <Widget>[
//                                              Expanded(
//                                                  child: new Container(
//                                                    padding: EdgeInsets.all(3),
//                                                    child: new SvgPicture.asset(
//                                                      "assets/book.svg",
//                                                      width: 40,
//                                                      height: 40,
//                                                      color: Colors.green,
//                                                    ),
//                                                  )),
//                                              new Container(
//                                                padding: EdgeInsets.all(3),
//                                                child: new Text(
//                                                  "students",
//                                                  style: TextStyle(
//                                                      color: Colors.green,
//                                                      fontSize: 10),
//                                                  maxLines: 1,
//                                                  overflow: TextOverflow.ellipsis,
//                                                ),
//                                              )
//                                            ],
//                                          ),
//                                        ),
//                                        onTap: () {
//                                          Navigator.of(context).pop();
//                                          Navigator.of(context).push(
//                                              new MaterialPageRoute(
//                                                  builder: (
//                                                      BuildContext context) =>
//                                                  new StudentPayment()));
//                                        },
//                                        splashColor: Colors.green,
//                                      ),
//                                    );
//                                  }))),
//                        ],
//                      ),
                      ExpansionTile(
                        title: Container(
                            margin: EdgeInsets.all(5),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: new Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blueGrey,
                                            blurRadius: 5.0,
                                          ),
                                        ],
                                        border: Border.all(color: Colors.white, width: 3),
                                        color: Theme.of(context).primaryColor),
                                    child: new SvgPicture.asset(
                                      "assets/book1.svg",
                                      width:15,
                                      height:15,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.all(10),
                                  ),
                                  flex: 5,
                                ),
                                Expanded(
                                  child: new Container(
                                    child: new Text(
                                      "Library",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Theme
                                            .of(context)
                                            .primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    margin: EdgeInsets.only(left: 5),
                                  ),
                                  flex: 17,
                                ),
                              ],
                            )),
                        children: <Widget>[
                          new Container(
                              margin: EdgeInsets.only(left: 10),
                              child: GridView.count(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  crossAxisCount: 3,
                                  children: <Widget> [
                                    new Card(
                                      elevation: 5,
                                      margin:
                                      EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                      color: Colors.white,
                                      child: new InkWell(
                                        child: new Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),
                                          child: new Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              Expanded(
                                                  child: new Container(
                                                    padding: EdgeInsets.all(3),
                                                    child: new Icon(Icons.library_books,size: 40,color: Colors.green,),
                                                  )),
                                              new Container(
                                                padding: EdgeInsets.all(3),
                                                child: new Text(
                                                  "Library",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 10),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder: (
                                                      BuildContext context) =>
                                                  new StudentLibrary()));
                                        },
                                        splashColor: Colors.green,
                                      ),
                                    ),
                                    new Card(
                                      elevation: 5,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      color: Colors.white,
                                      child: new InkWell(
                                        child: new Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          child: new Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                  child: new Container(
                                                    padding: EdgeInsets.all(3),
                                                    child: new Icon(Icons.library_books,size: 40,color: Colors.green,),
                                                  )),
                                              new Container(
                                                padding: EdgeInsets.all(3),
                                                child: new Text(
                                                  "My Book Request",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 10),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder: (BuildContext
                                                  context) =>
                                                  new StudentLibraryRequest()));
                                        },
                                        splashColor: Colors.green,
                                      ),
                                    )
                                  ])),

                        ],
                      ),
                    ]
                ): new Container(),
                logintype == "admin" ? new Container() : ExpansionTile(
                  title: new Container(
                      margin: EdgeInsets.all(5),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: new Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueGrey,
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                  border: Border.all(color: Colors.white, width: 3),
                                  color: Theme.of(context).primaryColor),
                              child: new SvgPicture.asset(
                                "assets/route.svg",
                                width: 15,
                                height: 15,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.all(10),
                            ),
                            flex: 5,
                          ),
                          Expanded(
                            child: new Container(
                              child: new Text(
                                "Transportation",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Theme
                                      .of(context)
                                      .primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              margin: EdgeInsets.only(left: 5),
                            ),
                            flex: 17,
                          ),
                        ],
                      )),
                  children: <Widget>[
                    new Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: GridView.count(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            crossAxisCount: 3,
                            children: List.generate(1, (index) {
                              return new Card(
                                elevation: 5,
                                margin:
                                EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                                color: Colors.white,
                                child: new InkWell(
                                  child: new Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    child: new Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Expanded(
                                            child: new Container(
                                              padding: EdgeInsets.all(3),
                                              child: new SvgPicture.asset(
                                                "assets/route.svg",
                                                width: 40,
                                                height: 40,
                                                color: Colors.green,
                                              ),
                                            )),
                                        new Container(
                                          padding: EdgeInsets.all(3),
                                          child: new Text(
                                            "Transport",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 10),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    if (logintype == "student") {
                                      Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                            new StudentTransport()),
                                      );
                                    }
                                    else {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                              new TransportPage()));
                                    };
                                  },
                                  splashColor: Colors.green,
                                ),
                              );
                            }))),
                  ],
                ),
                logintype == "admin" ? new Container() :  ExpansionTile(
                  title: new Container(
                      margin: EdgeInsets.all(5),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: new Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueGrey,
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                  border: Border.all(color: Colors.white, width: 3),
                                  color: Theme.of(context).primaryColor),
                              child: new SvgPicture.asset(
                                "assets/noticeboard.svg",
                                width: 15,
                                height: 15,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.all(10),
                            ),
                            flex: 5,
                          ),
                          Expanded(
                            child: new Container(
                              child: new Text(
                                "Noticeboard",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Theme
                                      .of(context)
                                      .primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              margin: EdgeInsets.only(left: 5),
                            ),
                            flex: 17,
                          ),
                        ],
                      )),
                  children: <Widget>[
                    new Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: GridView.count(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            crossAxisCount: 3,
                            children: List.generate(1, (index) {
                              return new Card(
                                elevation: 5,
                                margin:
                                EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                                color: Colors.white,
                                child: new InkWell(
                                  child: new Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    child: new Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Expanded(
                                            child: new Container(
                                              padding: EdgeInsets.all(3),
                                              child: new SvgPicture.asset(
                                                "assets/noticeboard.svg",
                                                width: 40,
                                                height: 40,
                                                color: Colors.green,
                                              ),
                                            )),
                                        new Container(
                                          padding: EdgeInsets.only(top:3),
                                          child: new Text(
                                            "Noticeboard",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 8),
                                            maxLines:2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    if (logintype == "student") {
                                      Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>

                                            new StudentNoticeboard()),
                                      );
                                    }
                                    else {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                              new NoticeboardPage()));
                                    };
                                  },
                                  splashColor: Colors.green,
                                ),
                              );
                            })))
                  ],
                ),
//                logintype == "admin" ? new Container() :ExpansionTile(
//                  title: new Container(
//                      margin: EdgeInsets.all(5),
//                      child: new Row(
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        children: <Widget>[
//                          Expanded(
//                            child: new Container(
//                              decoration: BoxDecoration(
//                                  shape: BoxShape.circle,
//                                  boxShadow: [
//                                    BoxShadow(
//                                      color: Colors.blueGrey,
//                                      blurRadius: 5.0,
//                                   ),
//                                  ],
//                                  border: Border.all(color: Colors.white, width: 3),
//                                  color: Theme.of(context).primaryColor),
//                              child: new SvgPicture.asset(
//                                "assets/chat.svg",
//                                width: 15,
//                                height: 15,
//                                color: Colors.white,
//                              ),
//                              padding: EdgeInsets.all(10),
//                            ),
//                            flex: 5,
//                          ),
//                          Expanded(
//                            child: new Container(
//                              child: new Text(
//                                "Message",
//                                style: TextStyle(
//                                  fontSize: 15,
//                                  color: Theme
//                                      .of(context)
//                                      .primaryColor,
//                                  fontWeight: FontWeight.bold,
//                                ),
//                              ),
//                              margin: EdgeInsets.only(left: 5),
//                            ),
//                            flex: 17,
//                          ),
//                        ],
//                      )),
//                  children: <Widget>[
//                    new Container(
//                        margin: EdgeInsets.only(left: 10, right: 10),
//                        child: GridView.count(
//                            shrinkWrap: true,
//                            physics: ScrollPhysics(),
//                            crossAxisCount: 3,
//                            children: List.generate(1, (index) {
//                              return new Card(
//                                elevation: 5,
//                                margin:
//                                EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//                                shape: RoundedRectangleBorder(
//                                    borderRadius:
//                                    BorderRadius.all(Radius.circular(10))),
//                                color: Colors.white,
//                                child: new InkWell(
//                                  child: new Container(
//                                    padding: EdgeInsets.symmetric(
//                                        horizontal: 10, vertical: 15),
//                                    child: new Column(
//                                      mainAxisSize: MainAxisSize.max,
//                                      crossAxisAlignment: CrossAxisAlignment
//                                          .center,
//                                      children: <Widget>[
//                                        Expanded(
//                                            child: new Container(
//                                              padding: EdgeInsets.all(3),
//                                              child: new SvgPicture.asset(
//                                                "assets/chat.svg",
//                                                width: 40,
//                                                height: 40,
//                                                color: Colors.green,
//                                              ),
//                                            )),
//                                        new Container(
//                                          padding: EdgeInsets.all(3),
//                                          child: new Text(
//                                            "Message",
//                                            style: TextStyle(
//                                                color: Colors.green,
//                                                fontSize: 10),
//                                            maxLines: 1,
//                                            overflow: TextOverflow.ellipsis,
//                                          ),
//                                        )
//                                      ],
//                                    ),
//                                  ),
//                                  onTap: () {
//                                    Navigator.of(context).pop();
//                                    if (logintype == "student") {
//                                      Navigator.of(context).push(
//                                        new MaterialPageRoute(
//                                            builder: (BuildContext context) =>
//                                            new StudentPrivatemessagesPage()),
//                                      );
//                                    }
////                                    else if (logintype == "admin") {
////                                      Navigator.of(context).push(
////                                        new MaterialPageRoute(
////                                            builder: (BuildContext context) =>
////                                            new AdminPrivatemessagesPage()),
////                                      );
////                                    }
////                                    else if (logintype == "parent") {
////                                      Navigator.of(context).push(
////                                        new MaterialPageRoute(
////                                            builder: (BuildContext context) =>
////                                            new Parent_privatemessagesPage()),
////                                      );
////                                    }
//                                    if (logintype == "teacher") {
//                                      Navigator.of(context).push(
//                                          new MaterialPageRoute(
//                                              builder: (BuildContext context) =>
//                                              new PrivatemessagesPage()));
//                                    };
//                                  },
//                                  splashColor: Colors.green,
//                                ),
//                              );
//                            }))),
//                  ],
//                ),
                logintype == "admin" ? new Container() :  ExpansionTile(
                  title: new Container(
                      margin: EdgeInsets.all(5),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: new Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueGrey,
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                  border: Border.all(color: Colors.white, width: 3),
                                  color: Theme.of(context).primaryColor),
                              child: new Icon(
                                Icons.settings,
                                color: Colors.white,
                                size: 15,
                              ),
                              padding: EdgeInsets.all(10),
                            ),
                            flex:5,
                          ),
                          Expanded(
                            child: new Container(
                              child: new Text(
                                "Account",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              margin: EdgeInsets.only(left: 5),
                            ),
                            flex: 17,
                          ),
                        ],
                      )),
                  children: <Widget>[
                    new Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: GridView.count(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            crossAxisCount: 3,
                            children: List.generate(1, (index) {
                              return new Card(
                                elevation: 5,
                                margin:
                                EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                                color: Colors.white,
                                child: new InkWell(
                                    child: new Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 15),
                                      child: new Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: <Widget>[
                                          Expanded(
                                              child: new Container(
                                                padding: EdgeInsets.all(3),
                                                child: new SvgPicture.asset(
                                                  "assets/user.svg",
                                                  width: 40,
                                                  height: 40,
                                                  color: Colors.green,
                                                ),
                                              )),
                                          new Container(
                                            padding: EdgeInsets.all(3),
                                            child: new Text(
                                              username,
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 10),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      if (logintype == "student") {
                                        Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>

                                              new StudentManageProfilePage()),
                                        );
                                      }
                                      else if (logintype == "teacher") {
                                        Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                              new Teacher_ManageProfilePage()),
                                        );
                                      }
                                      else {
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                new ManageProfilePage()));
                                      };
                                    }
                                ),
                              );
                            }))),
                  ],
                ),
                //new Column(children: drawerOptions)
                new SizedBox(
                  width: 5,
                  height: 5,
                ),
                new Divider(
                  height: 1,
                ),
                new ListTile(
                    title: new Text("Review Us"),
                    leading: new Icon(
                      Icons.star,
                      color: Theme.of(context).primaryColor,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      AppReview.writeReview.then((onValue) {
                        print(onValue);
                      });
                    }),
                new ListTile(
                    title: new Text("Logout"),
                    leading: new Icon(
                      Icons.exit_to_app,
                      color: Theme.of(context).primaryColor,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      LogoutDialog(context);
                    }),
                new Divider(
                  height: 1.0,
                ),
                new ListTile(
                  title: new Text("Application Version: $AppVersion"),
                ),
              ]),
        ));
    return drawer;
  }

  Future<Null> LogoutDialog(BuildContext context) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding:
            EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
            children: <Widget>[
              Container(
                color: Theme.of(context).primaryColor,
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.exit_to_app,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 10.0),
                    ),
                    Text(
                      'Exit app',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Are you sure to exit app?',
                      style: TextStyle(color: Colors.white70, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.cancel,
                        color: Theme.of(context).primaryColor,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'CANCEL',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle,
                        color: Theme.of(context).primaryColor,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'YES',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        sp.Remove("Userid");
        sp.Remove("clienturl");
        sp.Remove("email");
        sp.Remove("mobile");
        Navigator.of(context)
            .pushReplacement(new MaterialPageRoute(builder: (_) => new LoginPage()));
        runApp(MyApp());
        break;
    }
  }

  Future<bool> ConfirmDialog(BuildContext context, String msg) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text(msg),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              new FlatButton(
                child: new Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              )
            ],
          );
        });
  }

  ShowAlertDialog(BuildContext context, String msg) {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Center(
            child: new Text(
              "Alert",
              style: new TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 20.0),
            ),
          ),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  ShowSuccessDialog(BuildContext context, String msg) {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Center(
            child: new Text(
              "Success",
              style: new TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 20.0),
            ),
          ),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
          ],
        );
      },
    );
  }

  onLoading(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Container(
              color: Colors.white,
              child: Image(image: new AssetImage("assets/loader.gif"))) ;
//            Center(child: new CircularProgressIndicator());
        });
  }

  onDownLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return new Dialog(
          child:  Image(image: new AssetImage("assets/loader.gif")) ,
//            new Container(
//              child: new Column(
//                mainAxisSize: MainAxisSize.min,
//                children: [
//                  new LinearProgressIndicator(),
//                  new Text(
//                    "Loading...",
//                    style: TextStyle(fontSize: 20.0),
//                  ),
//                ],
//              ),
//              margin: new EdgeInsets.all(5.0),
//            )
        );
      },
    );
  }

  Future<String> Selectiondialog(
      BuildContext context, String title, List<String> items) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new Dialog(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                  child: new Text(
                    title,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                items.length > 0
                    ? new ListView.separated(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${items[index]}'),
                      onTap: () {
                        Navigator.of(context).pop(items[index]);
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                )
                    : new Center(
                  child: new Text(
                    "No records found.",
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ),
              ],
            ));
      },
    );
  }
}
