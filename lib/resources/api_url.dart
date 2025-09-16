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

  static var commonDeleteAttachment = 'erp_api/delete_common_attachment/';

  static var hseActionNCategorySearch =
      'erp_api/sor_get_action_type_or_category/';

  // here  below Petty cash  api

  static var dashBoard = 'erp_api/crebri_dashboard/';
  static var dashBoardTab = 'erp_notification/get_all_notification_tab/';
  static var dashBoardFilter =
      'erp_notification/get_all_sort_type_filter_type/';
  static var dashBoardFilterApply =
      'erp_notification/get_all_notification_list_new/';
  static var dashBoardSetting =
      'erp_notification/update_view_notification_priority/';
  static var dashBoardSettingFYIClear = 'erp_notification/clear_all_fyi_api/';
  static var dashBoardSettingNotification =
      'erp_notification/notification_enable_disable/';
  static var dashBoardMultiFilter = 'erp_notification/get_all_rules_data/';
  static var dashBoardMultiFilterCondition =
      'erp_notification/get_all_conditional_list/';
  static var dashBoardMultiFilterTransaction =
      'erp_notification/get_all_txn_list/';
  static var dashBoardMultiFilterUser = 'erp_notification/get_all_user_list/';
  static var dashBoardMultiFilterNotification =
      'erp_notification/get_notification_type_rules/';
  static var dashBoardMultiFilterAdd =
      'erp_notification/save_all_notification_rules/';
  static var dashBoardMultiFilterUpdate = 'erp_notification/update_view_rules/';
  static var dashBoardMultiFilterDelete =
      'erp_notification/delete_all_rules_data/';
  static var getMenuPageList = 'erp_api/common_menu/';
  static var getPoList = 'erp_api/PoList/';
  static var getPoTransaction = 'erp_api/PurchaseOrderSaveSubmit/';
  static var commonReferenceSearch = 'erp_api/common_reference_list/';
  static var txnCodeRef = 'erp_api/common_reference_txn_code_list/';
  static var docNoref = 'erp_api/common_reference_doc_no_list/';
  static var commonSearch = 'erp_api/common_search/';
  static var getPrReference = 'erp_api/ReferencePRPopup/';
  static var addPrReference = 'erp_api/PrReferenceInPoItemDetails/';
  static var getPettyCashAnalysis = 'erp_api/PettyCashAnalysis/';
  static var getPRAnalysis = 'erp_api/PRDashboardInPO/';
  static var getGrnnalysis = 'erp_api/GRNDashboardInPO/';
  static var commonSearching = 'erp_api/POSearchingApi/';
  static var getCommonReference = 'erp_api/CommonReferenceList/';
  static var getCommonRefTxnCodeList = 'erp_api/CommonReferenceTxnCodeList/';
  static var getRefDocNoList = 'erp_api/CommonReferenceDocNoList/';
  static var getItemDetailsSearch = 'erp_api/PurchaseOrderItemDetailSearch/';
  static var getPoTaxLineItem = 'erp_api/PurchaseOrderTaxLineItem/';
  static var getTaxSearchList = 'erp_api/PurchaseOrderTaxLineItem/';
  static var getSupplierCodeSearchList = 'erp_api/CreateSupplierType/';
  static var getSupplierAdddressSearchList = 'erp_api/CreateSupplierAddress/';
  static var createSupplier = 'erp_api/CreateSupplierFromPo/';
  static var createSupplierValidationTypeSearch =
      'erp_api/CreateSupplierValidationTypeSearch/';

  static var wfApprove = 'erp_api/approve_wf/';
  static var wfReject = 'erp_api/reject_wf/';
  static var wfRFI = 'erp_api/rfi_wf/';
  static var wfForward = 'erp_api/forward_wf/';
  static var wfFNA = 'erp_api/approve_and_forward_wf/';
  static var wfReInit = 'erp_api/re_initiate_wf/';
  static var wfApproveAmend = 'erp_api/approved_amendment/';
  static var wfRejectAmend = 'erp_api/amend_reject_wf/';
  static var wfReply = 'erp_api/reply_wf/';
  static var wfMultiRFI = 'erp_api/multi_rfi_wf/';

  static var commonAddAttachments = 'erp_api/add_common_attachment/';
  static var commonGetAttachmentList = 'erp_api/view_common_attachment/';
  static var commonAttachmentTypeList = 'erp_api/get_attachment_docu_list/';
}
