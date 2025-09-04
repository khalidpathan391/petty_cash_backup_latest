class ApiUrl {
  // static const String baseUrl = 'http://amala.contech-me.com:8001/';
  // static const String baseUrl = 'http://dm.crebritech.com:8096/';
  // static const String imageUrl = 'http://dm.crebritech.com:8096';

  // static var login = 'api/users/signin/';
  static String? baseUrl = '';
  static var baseUrlWithFile = 'http://dm.crebritech.com:8093/';
  // static var baseUrlWithFile = 'http://ta.sendan.com.sa:8003/';

  static var login = 'erp_api/crebri_login/';
  static var qrGenerating = 'erp_api/generate_qr_code/';
  static var qrActivate = 'erp_api/activate_qr_code/';
  static var appVersion = 'erp_api/app_version/';
  static var searchCompany = 'erp_api/get_comp_by_emp_code/';
  static var hseCommonSearch = 'erp_api/common_search/';
  static var hseReferenceDocSearch = 'erp_api/sor_ref_doc_no/';
  static var empIdDocuments = 'employee_apis/get_employee_id_card/';
  static var empDDT = 'employee_apis/get_driving_permit_card/';
  static var loanApllicationView = 'erp_api/loan_application_view/';
  static var commonDeleteAttachment = 'erp_api/delete_common_attachment/';
  static var loanApllicationDefault = 'erp_api/loan_application_default/';
  static var hseActionNCategorySearch =
      'erp_api/sor_get_action_type_or_category/';

  // here  below Petty cash  api

  static var signUp = 'api/users/signup/';
  static var setProfile = 'api/users/setprofile/';
  static var countryCommonSearch = 'api/users/get_country/';
  static var getJobCategory = 'api/users/get_job/';
  static var getQualification = 'api/users/get_education/';
  static var getCurrency = 'api/users/get_currency/';
  static var getPost = 'api/users/job_posting_new/';
  static var getDocumentList = 'api/users/get_document/';
  static var getUom = 'api/common/get_common_lookup/';
  static var chooseReference = 'api/common/get_reference/';
  static var getMultipost = 'api/users/job_posting_head/';
  static var getDashboardData = 'api/users/get_dashboard_job_data/';
  static var getUserTypeData = 'api/users/get_user_type_data/';
  static var dashBoard = 'erp_api/crebri_dashboard/';
  static var getCommonListing = 'erp_api/PoList/';
  static var getPoTransaction = 'erp_api/PurchaseOrderSaveSubmit/';
  static var commonReferenceSearch = 'erp_api/common_reference_list/';
  static var txnCodeRef = 'erp_api/common_reference_txn_code_list/';
  static var docNoref = 'erp_api/common_reference_doc_no_list/';
  static var commonSearch = 'erp_api/common_search/';
  static var getPrReference = 'erp_api/ReferencePRPopup/';
  static var getPettyCashAnalysis = 'erp_api/PettyCashAnalysis/';
  static var getPRAnalysis = 'erp_api/PRDashboardInPO/';
  static var getGrnnalysis = 'erp_api/GRNDashboardInPO/';
  static var commonSearching = 'erp_api/POSearchingApi/';
  static var getCommonReference = 'erp_api/CommonReferenceList/';
  static var getCommonRefTxnCodeList = 'erp_api/CommonReferenceTxnCodeList/';
  static var getRefDocNoList = 'erp_api/CommonReferenceDocNoList/';
  static var getItemDetailsSearch = 'erp_api/PurchaseOrderItemDetailSearch/';
}
