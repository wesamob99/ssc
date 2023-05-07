//ignore_for_file: file_names
import 'package:flutter/cupertino.dart';

import '../../../model/services/servicesRepository.dart';
import '../insuranceServices/screens/oneTimeCompensationRequestScreen.dart';
import '../insuranceServices/screens/workInjuryComplaintScreen.dart';
import '../maternityServices/screens/maternityAllowanceApplicationScreen.dart';
import '../mostVisited/screens/unemploymentApplicationScreen.dart';
import '../optionalAndFreeInclusion/screens/continuityOfCoverageRequestScreen.dart';
import '../optionalAndFreeInclusion/screens/membershipRequestScreen.dart';
import '../otherServices/screens/issuingRetirementDecisionScreen.dart';
import '../retirementServices/screens/applicationForPensionersLoan.dart';
import '../retirementServices/screens/deceasedRetirementApplicationScreen.dart';
import '../retirementServices/screens/earlyRetirementRequestScreen.dart';
import '../retirementServices/screens/historicalPensionDetailsScreen.dart';

class ServicesList{

  static final ServicesRepository _servicesRepository = ServicesRepository();
  
  /// Quick Access Services ****************************************************

  static Service unemploymentApplication = Service(
    title: "unemploymentApplication", supTitle: "individuals", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/unemploymentIcon.svg', screen:  const UnemploymentApplicationScreen(), duplicated: true, serviceApiCall: ()=> _servicesRepository.getApplicationService(3)
  );
  static Service onePayment = Service(
      title: "onePayment", supTitle: "optionalAndFreeInclusionServices", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/onePaymentIcon.svg', screen:  const WorkInjuryComplaintScreen(), serviceApiCall: ()=> _servicesRepository.optionalSubGetDetailService()
  );
  static Service reportAnAccident = Service(
      title: "reportAnAccident", supTitle: "workInjuries", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/reportAnAccidentIcon.svg', screen:  const WorkInjuryComplaintScreen(), serviceApiCall: ()=> _servicesRepository.optionalSubGetDetailService()
  );
  // static Service optionalSubscription = Service(
  //     title: "optionalSubscription", supTitle: "optionalAndFreeInclusionServices", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/optionalSubscriptionIcon.svg', screen:  const WorkInjuryComplaintScreen(), serviceApiCall: ()=> _servicesRepository.optionalSubGetDetailService()
  // );
  static Service accountStatement = Service(
      title: "accountStatement", supTitle: "maternity", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/accountStatementIcon.svg', screen:  const WorkInjuryComplaintScreen(), serviceApiCall: ()=> _servicesRepository.optionalSubGetDetailService()
  );
  static List<Service> quickAccessServices = [earlyRetirementRequest, deceasedRetirementApplication, unemploymentApplication, onePayment, reportAnAccident, accountStatement, membershipRequest];

  /// **************************************************************************
  /// Insurance Benefits Services **********************************************

  static Service reportSicknessComplaint = Service(
      title: "report_a_sickness/work_injury_complaint", supTitle: "workInjuries", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/unemploymentIcon.svg', screen:  const WorkInjuryComplaintScreen(), serviceApiCall: ()=> _servicesRepository.getAccountDataService()
  );
  static Service oneTimeCompensationRequest = Service(
      title: "oneTimeCompensationRequest", supTitle: "compensation", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/unemploymentIcon.svg', screen:  const OneTimeCompensationRequestScreen(), serviceApiCall: ()=> _servicesRepository.getApplicationService(2)
  );
  static Service savingsBalanceDisbursementRequest = Service(
      title: "savingsBalanceDisbursementRequest", supTitle: "savingsBalance", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/unemploymentIcon.svg', screen:  const WorkInjuryComplaintScreen(), serviceApiCall: ()=> _servicesRepository.optionalSubGetDetailService()
  );
  static Service workInjuryInsurance = Service(
      title: "workInjuryInsurance", supTitle: "workInjuries", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/unemploymentIcon.svg', screen:  const WorkInjuryComplaintScreen(), serviceApiCall: ()=> _servicesRepository.optionalSubGetDetailService()
  );
  static List<Service> insuranceBenefitsServices = [oneTimeCompensationRequest, savingsBalanceDisbursementRequest, unemploymentApplication, reportSicknessComplaint, workInjuryInsurance];

  /// **************************************************************************
  /// optional And Free Inclusion Services *************************************

  static Service membershipRequest = Service(
      title: "membershipRequest", supTitle: "optionalAndFreeInclusionServices", description: "this supposed to be about the service description", icon: 'assets/icons/servicesIcons/individualsServices.svg', screen:  const MembershipRequestScreen(), serviceApiCall: ()=> _servicesRepository.optionalSubGetDetailService()
  );
  static Service continuityOfCoverage = Service(
      title: "continuityOfCoverage", supTitle: "optionalAndFreeInclusionServices", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/unemploymentIcon.svg', screen:  const WorkInjuryComplaintScreen(), serviceApiCall: ()=> _servicesRepository.optionalSubGetDetailService()
  );
  static Service amendTheAnnualIncreasePercentage = Service(
      title: "requestToAmendTheAnnualIncreasePercentage", supTitle: "optionalAndFreeInclusionServices", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/percent.svg', screen:  const ContinuityOfCoverageRequestScreen(), serviceApiCall: ()=> _servicesRepository.optionalSubIncGetDetailNewService()
  );
  static Service excessPaymentRequest = Service(
      title: "excessPaymentRequest", supTitle: "optionalAndFreeInclusionServices", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/unemploymentIcon.svg', screen:  const WorkInjuryComplaintScreen(), serviceApiCall: ()=> _servicesRepository.optionalSubGetDetailService()
  );
  static List<Service> optionalAndFreeInclusionServices = [membershipRequest, continuityOfCoverage, amendTheAnnualIncreasePercentage, excessPaymentRequest];


/// **************************************************************************
/// retirement Services ******************************************************

  static Service earlyRetirementRequest = Service(
      title: "earlyRetirementRequest", supTitle: "retirementServices", description: "this supposed to be about the service description", icon: 'assets/icons/servicesIcons/retiredServices.svg', screen:  const EarlyRetirementRequestScreen(serviceType: 8,), serviceApiCall: ()=> _servicesRepository.getApplicationService(8)
  );
  static Service deceasedRetirementApplication = Service(
      title: "deceasedRetirementApplication", supTitle: "retirementServices", description: "this supposed to be about the service description", icon: 'assets/icons/servicesIcons/retiredServices.svg', screen:  const DeceasedRetirementApplicationScreen(), serviceApiCall: ()=> _servicesRepository.getApplicationService(11)
  );
  static Service applicationForOldAgePension = Service(
      title: "applicationForOldAgePension", supTitle: "retirementServices", description: "this supposed to be about the service description", icon: 'assets/icons/servicesIcons/retiredServices.svg', screen:  const EarlyRetirementRequestScreen(serviceType: 1,), serviceApiCall: ()=> _servicesRepository.getApplicationService(1)
  );
  static Service applicationForPensionersLoan = Service(
      title: "applicationForPensionersLoan", supTitle: "retirementServices", description: "this supposed to be about the service description", icon: 'assets/icons/servicesIcons/retiredServices.svg', screen:  const ApplicationForPensionersLoan(serviceType: 10), serviceApiCall: ()=> _servicesRepository.getApplicationService(10)
  );
  static Service applicationOfReschedulePensionersLoan = Service(
      title: "applicationOfReschedulePensionersLoan", supTitle: "retirementServices", description: "this supposed to be about the service description", icon: 'assets/icons/servicesIcons/retiredServices.svg', screen:  const ApplicationForPensionersLoan(serviceType: 14), serviceApiCall: ()=> _servicesRepository.getApplicationService(14)
  );
  static Service historicalPensionDetails = Service(
      title: "historicalPensionDetails", supTitle: "retirementServices", description: "this supposed to be about the service description", icon: 'assets/icons/servicesIcons/retiredServices.svg', screen:  const HistoricalPensionDetailsScreen(), serviceApiCall: ()=> _servicesRepository.getPensionsBasicInformationsService()
  );

  static List<Service> retirementServices = [earlyRetirementRequest, applicationForOldAgePension, deceasedRetirementApplication, applicationForPensionersLoan, applicationOfReschedulePensionersLoan, historicalPensionDetails];

/// **************************************************************************
/// other Services ***********************************************************

  static Service toWhomItMayConcernLetter = Service(
      title: "toWhomItMayConcernLetter", supTitle: "officialBooks", description: "this supposed to be about the service description", icon: 'assets/icons/servicesIcons/retiredServices.svg', screen:  Container(), serviceApiCall: ()=> _servicesRepository.optionalSubGetDetailService()
  );
  static Service issuingRetirementDecision = Service(
      title: "issuingRetirementDecision", supTitle: "officialBooks", description: "this supposed to be about the service description", icon: 'assets/icons/servicesIcons/retiredServices.svg', screen:  const IssuingRetirementDecisionScreen(), serviceApiCall: ()=> _servicesRepository.getDecExistence()
  );
  static List<Service> otherServices = [toWhomItMayConcernLetter, issuingRetirementDecision];

/// **************************************************************************
/// maternity Services *******************************************************

  static Service maternityAllowanceApplication = Service(
      title: "maternityAllowanceApplication", supTitle: "maternity", description: "this supposed to be about the service description", icon: 'assets/icons/servicesIcons/retiredServices.svg', screen:  const MaternityAllowanceApplicationScreen(), serviceApiCall: ()=> _servicesRepository.getApplicationService(4)
  );
  static Service careRequest = Service(
      title: "careRequest", supTitle: "maternity", description: "this supposed to be about the service description", icon: 'assets/icons/servicesIcons/retiredServices.svg', screen:  const IssuingRetirementDecisionScreen(), serviceApiCall: ()=> _servicesRepository.getDecExistence()
  );

  static List<Service> maternityServices = [maternityAllowanceApplication, careRequest];

/// **************************************************************************

  static List<Service> earlyAndOldRetirements = [earlyRetirementRequest, applicationForOldAgePension];

  static List<Service> mostVisitedServices = [applicationForPensionersLoan, unemploymentApplication, maternityAllowanceApplication];

  static List<Service> allServices = [quickAccessServices, insuranceBenefitsServices, optionalAndFreeInclusionServices, retirementServices, otherServices, maternityServices].expand((element) => element).toList();

}

class Service{
  final String title;
  final String supTitle;
  final String icon;
  final String description;
  final Widget screen;
  final Future<dynamic> Function() serviceApiCall;
  bool isSelected;
  bool duplicated;

  Service({this.title, this.supTitle, this.icon, this.description, this.screen,this.serviceApiCall ,this.isSelected = true, this.duplicated = false});
}