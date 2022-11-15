//ignore_for_file: file_names
import 'package:flutter/cupertino.dart';

import '../insuranceBenefits/screens/workInjuryComplaintScreen.dart';

class ServicesList{

  /// Quick Access Services ****************************************************

  static const Service unemploymentApplication = Service(
    title: "unemploymentApplication", supTitle: "individuals", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/unemploymentIcon.svg', screen: WorkInjuryComplaintScreen()
  );
  static const Service onePayment = Service(
      title: "onePayment", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/onePaymentIcon.svg', screen: WorkInjuryComplaintScreen()
  );
  static const Service reportAnAccident = Service(
      title: "reportAnAccident", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/reportAnAccidentIcon.svg', screen: WorkInjuryComplaintScreen()
  );
  static const Service optionalSubscription = Service(
      title: "optionalSubscription", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/optionalSubscriptionIcon.svg', screen: WorkInjuryComplaintScreen()
  );
  static const Service accountStatement = Service(
      title: "accountStatement", supTitle: "maternity", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/accountStatementIcon.svg', screen: WorkInjuryComplaintScreen()
  );
  List<Service> quickAccessServices = [unemploymentApplication, onePayment, reportAnAccident, optionalSubscription, accountStatement];

  /// **************************************************************************
  /// Most Visited Services ****************************************************

  static const Service requestRetiredLoan = Service(
      title: "requestRetiredLoan", supTitle: "retired", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/unemploymentIcon.svg', screen: WorkInjuryComplaintScreen()
  );
  static const Service reportSicknessComplaint = Service(
      title: "report_a_sickness/work_injury_complaint", supTitle: "workInjuries", description: "this supposed to be about the service description", icon: 'assets/icons/quickAccessIcons/unemploymentIcon.svg', screen: WorkInjuryComplaintScreen()
  );

  List<Service> mostVisitedServices = [requestRetiredLoan, unemploymentApplication, accountStatement, reportSicknessComplaint];

  /// **************************************************************************
  /// Insurance Benefits Services **********************************************



  /// **************************************************************************


}

class Service{
  final String title;
  final String supTitle;
  final String icon;
  final String description;
  final Widget screen;

  const Service({this.title, this.supTitle, this.icon, this.description, this.screen});
}