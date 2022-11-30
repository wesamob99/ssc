//ignore_for_file: file_names
import 'package:flutter/cupertino.dart';

import '../../../model/services/servicesRepository.dart';
import '../insuranceServices/screens/workInjuryComplaintScreen.dart';
import '../optionalAndFreeInclusion/screens/membershipRequestScreen.dart';

class ServicesList{

  /// Quick Access Services ****************************************************

  static Service individualsUnemploymentApplication = Service(
    title: "unemploymentApplication", supTitle: "individuals", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/unemploymentIcon.svg', screen:  const WorkInjuryComplaintScreen(), duplicated: true, serviceApiCall: ServicesRepository().optionalSubGetDetailService()
  );
  static Service maternityUnemploymentApplication = Service(
      title: "unemploymentApplication", supTitle: "maternity", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/unemploymentIcon.svg', screen:  const WorkInjuryComplaintScreen(), duplicated: true, serviceApiCall: ServicesRepository().optionalSubGetDetailService()
  );
  static Service onePayment = Service(
      title: "onePayment", supTitle: "optionalAndFreeInclusionServices", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/onePaymentIcon.svg', screen:  const WorkInjuryComplaintScreen(), serviceApiCall: ServicesRepository().optionalSubGetDetailService()
  );
  static Service reportAnAccident = Service(
      title: "reportAnAccident", supTitle: "workInjuries", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/reportAnAccidentIcon.svg', screen:  const WorkInjuryComplaintScreen(), serviceApiCall: ServicesRepository().optionalSubGetDetailService()
  );
  static Service optionalSubscription = Service(
      title: "optionalSubscription", supTitle: "optionalAndFreeInclusionServices", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/optionalSubscriptionIcon.svg', screen:  const WorkInjuryComplaintScreen(), serviceApiCall: ServicesRepository().optionalSubGetDetailService()
  );
  static Service accountStatement = Service(
      title: "accountStatement", supTitle: "maternity", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/accountStatementIcon.svg', screen:  const WorkInjuryComplaintScreen(), serviceApiCall: ServicesRepository().optionalSubGetDetailService()
  );
  static List<Service> quickAccessServices = [individualsUnemploymentApplication, onePayment, reportAnAccident, optionalSubscription, accountStatement, membershipRequest];

  /// **************************************************************************
  /// Most Visited Services ****************************************************

  static Service requestRetiredLoan = Service(
      title: "requestRetiredLoan", supTitle: "retired", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/unemploymentIcon.svg', screen:  const WorkInjuryComplaintScreen(), serviceApiCall: ServicesRepository().optionalSubGetDetailService()
  );
  static Service reportSicknessComplaint = Service(
      title: "report_a_sickness/work_injury_complaint", supTitle: "workInjuries", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/unemploymentIcon.svg', screen:  const WorkInjuryComplaintScreen(), serviceApiCall: ServicesRepository().optionalSubGetDetailService()
  );

  static List<Service> mostVisitedServices = [requestRetiredLoan, individualsUnemploymentApplication, maternityUnemploymentApplication];

  /// **************************************************************************
  /// Insurance Benefits Services **********************************************

  static Service oneTimeCompensationRequest = Service(
      title: "oneTimeCompensationRequest", supTitle: "compensation", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/unemploymentIcon.svg', screen:  const WorkInjuryComplaintScreen(), serviceApiCall: ServicesRepository().optionalSubGetDetailService()
  );
  static Service savingsBalanceDisbursementRequest = Service(
      title: "savingsBalanceDisbursementRequest", supTitle: "savingsBalance", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/unemploymentIcon.svg', screen:  const WorkInjuryComplaintScreen(), serviceApiCall: ServicesRepository().optionalSubGetDetailService()
  );
  static Service workInjuryInsurance = Service(
      title: "workInjuryInsurance", supTitle: "workInjuries", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/unemploymentIcon.svg', screen:  const WorkInjuryComplaintScreen(), serviceApiCall: ServicesRepository().optionalSubGetDetailService()
  );
  static List<Service> insuranceBenefitsServices = [oneTimeCompensationRequest, savingsBalanceDisbursementRequest, reportSicknessComplaint, workInjuryInsurance];

  /// **************************************************************************
  /// optional And Free Inclusion Services *************************************

  static Service membershipRequest = Service(
      title: "membershipRequest", supTitle: "optionalAndFreeInclusionServices", description: "this supposed to be about the service description", icon: 'assets/icons/servicesIcons/individualsServices.svg', screen:  const MembershipRequestScreen(), serviceApiCall: ServicesRepository().optionalSubGetDetailService()
  );
  static Service continuityOfCoverage = Service(
      title: "continuityOfCoverage", supTitle: "optionalAndFreeInclusionServices", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/unemploymentIcon.svg', screen:  const WorkInjuryComplaintScreen(), serviceApiCall: ServicesRepository().optionalSubGetDetailService()
  );
  static Service excessPaymentRequest = Service(
      title: "excessPaymentRequest", supTitle: "optionalAndFreeInclusionServices", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/unemploymentIcon.svg', screen:  const WorkInjuryComplaintScreen(), serviceApiCall: ServicesRepository().optionalSubGetDetailService()
  );
  static List<Service> optionalAndFreeInclusionServices = [membershipRequest, continuityOfCoverage, excessPaymentRequest];

/// **************************************************************************


  static List<Service> allServices = [individualsUnemploymentApplication, continuityOfCoverage, maternityUnemploymentApplication, onePayment, reportAnAccident, optionalSubscription, accountStatement, membershipRequest, requestRetiredLoan, reportSicknessComplaint, oneTimeCompensationRequest, savingsBalanceDisbursementRequest, workInjuryInsurance];

}

class Service{
  final String title;
  final String supTitle;
  final String icon;
  final String description;
  final Widget screen;
  final Future serviceApiCall;
  bool isSelected;
  bool duplicated;

  Service({this.title, this.supTitle, this.icon, this.description, this.screen,this.serviceApiCall ,this.isSelected = true, this.duplicated = false});
}