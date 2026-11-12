import 'package:cnattendance/provider/companyrulesprovider.dart';
import 'package:cnattendance/widget/companyrulesscreen/ruleslist.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

class CompanyRulesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => CompanyRulesProvider(), child: CompanyRules());
  }
}

class CompanyRules extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CompanyRulesState();
}

class CompanyRulesState extends State<CompanyRules> {
  var initial = true;

  @override
  void didChangeDependencies() {
    if(initial){
      Provider.of<CompanyRulesProvider>(context).getContent();
      initial = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: RadialDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(translate('company_rules_screen.company_rules')),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: RulesList(),
        ),
      ),
    );
  }
}
