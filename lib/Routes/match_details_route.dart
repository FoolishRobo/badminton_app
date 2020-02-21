import 'package:badminton_app/update_match_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badminton_app/constants.dart';
import 'package:badminton_app/ColorList.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:badminton_app/rounded_button.dart';
import 'package:badminton_app/refresh_all_details.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

final people = <Person>[];

class MatchDetails extends StatefulWidget {
  static String id = 'match_details';
  @override
  _MatchDetailsState createState() => _MatchDetailsState();
}

class _MatchDetailsState extends State<MatchDetails> {
  bool spinner = false;
  DateTime selectedDate;
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    date = "$selectedDate".split(' ')[0];
  }

//  void getMatchCounter() async {
//    await _firestore
//        .collection('Match_Counter')
//        .getDocuments()
//        .then((QuerySnapshot snapshot) {
//      snapshot.documents.forEach((f) {
//        print('f = ${f.data}');
//        match_counter = f.data['Number'];
//        print('Match Counter = $match_counter');
//      });
//    });
//  }

  void updatePersonMap() {
    people.clear();
    for (int i = 0; i < userName.length; i++) {
      people.add(Person(userName[i], userEmail[i]));
    }
    print(people);
  }

  @override
  void initState() {
    super.initState();
//    setState(() {
//      getMatchCounter();
//    });
    updatePersonMap();
    print(userEmail);
    print(userEmail.indexOf('krishnenduroy.dbpc@gmail.com'));
    print(userName[userEmail.indexOf('krishnenduroy.dbpc@gmail.com')]);
    updatePersonMap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: blackShade, offset: Offset(2, 2), blurRadius: 2),
                  BoxShadow(
                      color: whiteShade, offset: Offset(-2, -2), blurRadius: 2),
                ],
              ),
              child: Icon(Icons.home),
            ),
          ),
        ),
        backgroundColor: backgroundColor,
        title: Text(
          'Add Match Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        child: Column(
          children: <Widget>[
//            Expanded(
//              child: ListView.builder(
//                scrollDirection: Axis.horizontal,
//                itemCount: userName.length,
//                itemBuilder: (_, Value) {
//                  return UserList(
//                    name: userName[Value],
//                    email: userEmail[Value],
//                  );
//                },
//              ),
//            ),
            Expanded(
              flex: 5,
              child: ListView(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      teamText(
                        text: 'Winning Team',
                        color: textColor,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      playerNameRow(
                        hinitBox1: 'email',
                        hintBox2: 'email',
                        labelbox1: 'Player 1',
                        labelbox2: 'Player 2',
                        var1: 1,
                        var2: 2,
                        KeyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      teamText(
                        text: 'Loosing Team',
                        color: textColor,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      playerNameRow(
                        hinitBox1: 'email',
                        hintBox2: 'email',
                        labelbox1: 'Player 1',
                        labelbox2: 'Player 2',
                        var1: 3,
                        var2: 4,
                        KeyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      teamText(
                        text: 'Team Score',
                        color: textColor,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              enableSuggestions: true,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                assignTextValue(value, 5);
                              },
                              decoration: kTextFieldDecoration.copyWith(
                                labelText: "Score",
                                hintText: "Number",
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: TextField(
                              enableSuggestions: true,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                //Do something with the user input.
                                assignTextValue(value, 6);
                              },
                              decoration: kTextFieldDecoration.copyWith(
                                labelText: "Score",
                                hintText: "Number",
                              ),
                            ),
                          ),
                        ],
                      ),
//                  playerNameRow(
//                    hinitBox1: 'Score',
//                    hintBox2: 'Score',
//                    labelbox1: 'Winning Team',
//                    labelbox2: 'Loosing Team',
//                    var1: 5,
//                    var2: 6,
//                    KeyboardType: TextInputType.number,
//                  ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              selectedDate != null ? "$selectedDate".split(' ')[0]: 'Date',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Expanded(
                            child: RoundedButton(
                              color: textColor,
                              text: 'Set Date',
                              onPress: () => _selectDate(context),
                            ),
                          ),
                        ],
                      ),
                      RoundedButton(
                        color: textColor,
                        text: 'Upload Details',
                        onPress: () {
                          bool check = false;

                          if (t1p1 != null &&
                              t1p2 != null &&
                              t2p1 != null &&
                              t2p2 != null &&
                              winningScore != null &&
                              loosingScore != null &&
                              date != null) {
                            if (userName.contains(t1p1) &&
                                userName.contains(t1p2) &&
                                userName.contains(t2p1) &&
                                userName.contains(t2p2)) {
                              check = updatePlayerDetails();
                              if (check) {
                                Fluttertoast.showToast(
                                    msg: "Uploaded",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIos: 1,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                setState(() {
                                  refreshAllDetails();
                                });

                                Navigator.pop(context);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Error Uploading",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIos: 1,
                                    backgroundColor: Colors.redAccent,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Wrong Email Id provided",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIos: 2,
                                  backgroundColor: Colors.redAccent,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "please fill up all the details to upload",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIos: 2,
                                backgroundColor: Colors.redAccent,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                      ),
                    ],
                  ),
                ],

              ),
            ),

            //Flexible(child: DropDown()),
          ],
        ),
      ),
    );
  }
}

class AutoFillTextField extends StatelessWidget {

  int varr;
  String label;
  AutoFillTextField({this.varr, this.label});

  String selectedLetter;
  Person selectedPerson;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  bool autovalidate = false;

  @override
  Widget build(BuildContext context) {
    return SimpleAutocompleteFormField<Person>(
      decoration: kTextFieldDecoration.copyWith(labelText: label),
      itemBuilder: (context, person) => Padding(
        padding: EdgeInsets.all(8.0),
        child: Column( children: [
          Text(person.name, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
          Text(person.email,style: TextStyle(color: textColor))
        ]),
      ),
      onSearch: (search) async => people
          .where((person) =>
              person.name.toLowerCase().contains(search.toLowerCase()) ||
              person.email.toLowerCase().contains(search.toLowerCase()))
          .toList(),
      itemFromString: (string) => people.singleWhere(
          (person) => person.name.toLowerCase() == string.toLowerCase(),
          orElse: () => null),
      onChanged: (value){
        assignTextValue(value.toString(), varr);
      },
      onSaved: (value) {
        assignTextValue(value.toString(), varr);
      },
      validator: (person) => person == null ? 'Invalid person.' : null,
    );
  }
}

class playerNameRow extends StatelessWidget {
  String hinitBox1, hintBox2, labelbox1, labelbox2;
  int var1, var2;
  TextInputType KeyboardType;
  playerNameRow(
      {this.hinitBox1,
      this.hintBox2,
      this.labelbox1,
      this.labelbox2,
      this.var1,
      this.var2,
      this.KeyboardType});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: AutoFillTextField(varr: var1, label: 'Name',),
//          TextField(
//            enableSuggestions: true,
//            keyboardType: KeyboardType,
//            textAlign: TextAlign.center,
//            onChanged: (value) {
//              assignTextValue(value, var1);
//            },
//            decoration: kTextFieldDecoration.copyWith(
//              labelText: labelbox1,
//              hintText: hinitBox1,
//            ),
//          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: AutoFillTextField(varr: var2, label: 'Name',),
//          TextField(
//            enableSuggestions: true,
//            keyboardType: KeyboardType,
//            textAlign: TextAlign.center,
//            onChanged: (value) {
//              //Do something with the user input.
//              assignTextValue(value, var2);
//            },
//            decoration: kTextFieldDecoration.copyWith(
//              labelText: labelbox2,
//              hintText: hintBox2,
//            ),
//          ),
        ),
      ],
    );
  }
}

void assignTextValue(String value, int variable) {
  //print('Value : $value and variable = $variable');
  if (variable == 1) {
    t1p1 = value;
    print('t1p1 = $t1p1');
  } else if (variable == 2) {
    t1p2 = value;
    print('t1p2 = $t1p2');
  } else if (variable == 3) {
    t2p1 = value;
    print('t2p1 = $t2p1');
  } else if (variable == 4) {
    t2p2 = value;
    print('t2p2 = $t2p2');
  } else if (variable == 5) {
    winningScore = value;
    print('winningScore = $winningScore');
  } else if (variable == 6) {
    loosingScore = value;
    print('lossingScore = $loosingScore');
  }

  //print('Done Printing');
}

class teamText extends StatelessWidget {
  String text;
  Color color;
  teamText({this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }
}

class Person {
  Person(this.name, this.email);
  final String name, email;
  @override
  String toString() => name;
}
