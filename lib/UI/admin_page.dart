import 'package:blueberrypoll/Data/database_interface.dart';
import 'package:blueberrypoll/Logic/answer.dart';
import 'package:blueberrypoll/Logic/poll.dart';
import 'package:blueberrypoll/Logic/star_rating_answer.dart';
import 'package:blueberrypoll/Logic/text_feild_answer.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:blueberrypoll/Logic/yes_no_answer.dart';
import 'package:blueberrypoll/Logic/yes_no_noopinion_answer.dart';
import 'package:blueberrypoll/UI/main_page.dart';
import 'package:blueberrypoll/UI/participants_view.dart';
import 'package:blueberrypoll/UI/poll_view.dart';
import 'package:blueberrypoll/UI/ui_generator.dart';
import 'package:flutter/cupertino.dart' as Cupertino;
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class AdminSettings extends StatefulWidget {
  DatabaseInterface database;
  AdminSettings(this.database);
  @override
  _AdminSettingsState createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  final _formKey = GlobalKey<FormState>();
  final adminEmailsTextBoxController = TextEditingController();
  final emailDomainsTextBoxController = TextEditingController();
  String originalAdminEmails;
  String originalEmailDomains;
  Map<String, String> info;
  Future dataLoaded;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Cupertino.Padding(
        padding: EdgeInsets.symmetric(horizontal: UIGenerator.toUnits(32)),
        child: FutureBuilder(
          future: dataLoaded,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // print("------- SETTINGS DATA: "+snapshot.data.toString());
              // print(snapshot.data[DatabaseInterface.ADMIN_EMAILS_NODE]);
              // print(snapshot.data[DatabaseInterface.EMAIL_DOMAINS_NODE]);
              return ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: UIGenerator.toUnits(100)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        UIGenerator.subtitle(
                            "Modify who has access to Blueberry Poll."),
                        SizedBox(
                          height: UIGenerator.toUnits(20),
                        ),
                        UIGenerator.heading("Admin Settings")
                      ],
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        UIGenerator.label("ADMIN EMAILS (seperated by commas)"),
                        SizedBox(
                          height: UIGenerator.toUnits(11),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                              color: Color.fromRGBO(243, 243, 247, 1)),
                          padding: EdgeInsets.only(
                              top: UIGenerator.toUnits(8),
                              left: UIGenerator.toUnits(17),
                              right: UIGenerator.toUnits(17)),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.none,
                            //  initialValue: snapshot.data[DatabaseInterface.ADMIN_EMAILS_NODE],

                            style: UIGenerator.textFeildTextStyle(),
                            controller: adminEmailsTextBoxController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                            ),
                            onChanged: (String bob) {
                              setState(() {});
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter an email, else no one will be an admin."';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: UIGenerator.toUnits(32),
                        ),
                        UIGenerator.label(
                            "AUTHORIZED EMAIL DOMAINS (seperated by commas)"),
                        SizedBox(
                          height: UIGenerator.toUnits(11),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                              color: Color.fromRGBO(243, 243, 247, 1)),
                          padding: EdgeInsets.only(
                              top: UIGenerator.toUnits(8),
                              left: UIGenerator.toUnits(17),
                              right: UIGenerator.toUnits(17)),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.none,
                            // initialValue: snapshot.data[DatabaseInterface.EMAIL_DOMAINS_NODE],
                            style: UIGenerator.textFeildTextStyle(),
                            controller: emailDomainsTextBoxController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                            ),
                            onChanged: (String bob) {
                              setState(() {});
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a domain, or else no one will be able to sign in."';
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: UIGenerator.toUnits(64),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      UIGenerator.buttonOutlined("Exit", () {
                        Navigator.of(context).pop();
                      }),
                      applyChangesButton()
                    ],
                  )
                ],
              );
            } else {
              return UIGenerator.loading(message: "loading settings");
            }
          },
        ),
      ),
    );
  }

  Widget applyChangesButton() {
    if (adminEmailsTextBoxController.text == originalAdminEmails &&
        emailDomainsTextBoxController.text == originalEmailDomains) {
      return Container();
    }
    return UIGenerator.button("Apply Changes", () async {
      await this
          .widget
          .database
          .setAdminEmails(adminEmailsTextBoxController.text);
      await this
          .widget
          .database
          .setEmailDomains(emailDomainsTextBoxController.text);
          await getAdminInfo();
      setState(()  {});
    });
  }

  Future<void> getAdminInfo() async {
    originalAdminEmails = await this.widget.database.getAdminEmails();
    originalEmailDomains = await this.widget.database.getEmailDomains();

    adminEmailsTextBoxController.text = originalAdminEmails;
    emailDomainsTextBoxController.text = originalEmailDomains;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataLoaded = getAdminInfo();
  }
}
