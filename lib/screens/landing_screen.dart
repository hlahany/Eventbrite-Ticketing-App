///This screen is the landing screen of our application. It contains the search bar, the filter button and the list of events.
///It is the first screen that the user sees when opening the app. It is a stateful widget because it contains a text field that the user can type in and we need to be able to access the text that the user types in.
///The build method returns a SingleChildScrollView widget. This is because we want the user to be able to scroll down the page if there are too many events to fit on the screen.
///The SingleChildScrollView widget takes a child widget as an argument. In this case, the child widget is a Column widget. The Column widget takes a list of widgets as an argument. In this case, the list contains a SizedBox widget, a TextField widget, a Row widget and an EventList widget. The SizedBox widget is used to add some space between the top of the screen and the TextField widget.
///The TextField widget is used to allow the user to search for events. The Row widget contains a Text widget and a FilterEventsScreen widget. The Text widget is used to display the text 'Filter by'. The FilterEventsScreen widget is used to allow the user to filter the events by category. The EventList widget is used to display the list of events.

import 'package:envie_cross_platform/providers/categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../requests/get_categories_api.dart';
import 'filter_events_screen.dart';
import '../widgets/events_list_widget.dart';
import 'time_filter_events_screen.dart';

class LandingScreen extends StatefulWidget {
  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  String searchForText = 'Search for...';
  TextEditingController _searchController =
      TextEditingController(text: 'Search for...');
  //String? dropdownValue = 'In my current Location';
  bool choice = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: TextField(
              onTap: () {
                if (_searchController.text == searchForText)
                  _searchController.clear();
              },
              onSubmitted: (_) => setState(() {
                choice = false;
              }),
              controller: _searchController,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                icon: Icon(Icons.search),
                //hintText: 'Search for...',
                suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.text = searchForText;
                      setState(() {
                        choice = true;
                      });
                    }),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                Icon(Icons.location_on, size: 20),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: Provider.of<CategoriesProvider>(context, listen: false)
                      .locationDropDownValue,
                  elevation: 0,
                  underline: Container(
                    height: 0,
                    color: Colors.transparent,
                  ),
                  items: <String>['In my current Location', 'Online']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 12),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      Provider.of<CategoriesProvider>(context, listen: false)
                          .locationDropDownValue = newValue;
                      (newValue == 'In my current Location')
                          ? Provider.of<CategoriesProvider>(context,
                                  listen: false)
                              .isOnlineCategory = false
                          : Provider.of<CategoriesProvider>(context,
                                  listen: false)
                              .isOnlineCategory = true;
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: ElevatedButton(
                      onPressed: () async {
                        await getAllCategories(context);
                        Navigator.of(context)
                            .pushReplacementNamed(FilterEventsScreen.routeName);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.tune, size: 20),
                          Text(
                              Provider.of<CategoriesProvider>(context,
                                          listen: false)
                                      .isCategorySelected
                                  ? Provider.of<CategoriesProvider>(context,
                                          listen: false)
                                      .selectedCategoryName!
                                  : 'Filters',
                              style: TextStyle(fontSize: 12)),
                          Icon(Icons.arrow_drop_down_outlined),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        backgroundColor: Provider.of<CategoriesProvider>(
                                    context,
                                    listen: false)
                                .isCategorySelected
                            ? Color.fromARGB(255, 64, 94, 211)
                            : Color.fromARGB(255, 192, 200, 231),
                        foregroundColor: Provider.of<CategoriesProvider>(
                                    context,
                                    listen: false)
                                .isCategorySelected
                            ? Colors.white
                            : Colors.black,
                        // fixedSize:
                        //     Size(MediaQuery.of(context).size.width * 0.4, 40),
                        alignment: Alignment.center,
                      )),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: ElevatedButton(
                      onPressed: () => Navigator.of(context)
                          .pushNamed(TimeFilterEventsScreen.routeName),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 15),
                          Text(
                              Provider.of<CategoriesProvider>(context,
                                          listen: false)
                                      .isTimeCategorySelected
                                  ? Provider.of<CategoriesProvider>(context,
                                          listen: false)
                                      .selectedTimeCategory!
                                      .toUpperCase()
                                  : 'Anytime',
                              style: TextStyle(fontSize: 12)),
                          Icon(Icons.arrow_drop_down_outlined),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        backgroundColor: Provider.of<CategoriesProvider>(
                                    context,
                                    listen: false)
                                .isTimeCategorySelected
                            ? Color.fromARGB(255, 64, 94, 211)
                            : Color.fromARGB(255, 192, 200, 231),
                        foregroundColor: Provider.of<CategoriesProvider>(
                                    context,
                                    listen: false)
                                .isTimeCategorySelected
                            ? Colors.white
                            : Colors.black,
                        //fixedSize: Size(125, 40),
                        alignment: Alignment.center,
                      )),
                ),
              ],
            ),
          ),
          EventsList(choice: choice, keyword: _searchController.text),
        ],
      ),
    );
  }
}
