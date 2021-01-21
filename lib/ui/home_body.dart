import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:mpeischedule/common/fetch_http.dart';
import 'package:mpeischedule/models/lesson.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class BodyHome extends StatefulWidget {
  const BodyHome({Key key}) : super(key: key);

  @override
  _BodyHomeState createState() => _BodyHomeState();
}

class _BodyHomeState extends State<BodyHome> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        buildDayScrollItem(context),
        // Text("Новый текс"),
        buildDayInfoLesson(context)
        //DayInfo()
      ],
    );
  }

  ItemScrollController _scrollController = ItemScrollController();

  PageController controller = PageController(initialPage: 0);
  ScrollController _controllerList = ScrollController(keepScrollOffset: false);
  int sectionIndex = 0;
  List<String> day = ["Пон", "Вт", "Ср", "Чет", "Пят", "Суб", "Вос"];

  Widget buildDayScrollItem(BuildContext context) {
    return SizedBox(
        height: 35.0,
        child: ScrollablePositionedList.builder(
          scrollDirection: Axis.horizontal,
          itemScrollController: _scrollController,
          itemCount: day.length,
          itemBuilder: (context, index) => buildDayItem(index),
        ));
  }

  Widget buildDayItm(BuildContext context) {
    return SizedBox(
      height: 35.0,
      child: ListView.builder(
        controller: _controllerList,
        scrollDirection: Axis.horizontal,
        itemCount: day.length,
        itemBuilder: (context, index) => buildDayItem(index),
      ),
    );
  }

  Widget buildDayItem(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          sectionIndex = index;
          controller.jumpToPage(index);
        });
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 5.0,
        ),
        decoration: BoxDecoration(
            color: sectionIndex == index ? Colors.blue : Colors.red,
            borderRadius: BorderRadius.circular(16.0)),
        child: Text(
          day[index],
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget buildDayInfoLesson(BuildContext context) {
    return Expanded(
        child: PageView.builder(
      onPageChanged: (number) {
        setState(() {
          sectionIndex = number;
          _scrollController.scrollTo(
              index: number, duration: Duration(milliseconds: 300));
        });
      },
      controller: controller,
      itemCount: day.length,
      itemBuilder: (context, index) => Container(
        alignment: Alignment.center,
        child: Text(day[index]),
      ),
    ));
  }
}

class PageViewWidget extends StatefulWidget {
  PageViewWidget({Key key}) : super(key: key);

  @override
  _PageViewWidgetState createState() => _PageViewWidgetState();
}

class _PageViewWidgetState extends State<PageViewWidget> {
  PageController controller = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return PageView();
  }
}

class DayInfo extends StatefulWidget {
  const DayInfo({Key key}) : super(key: key);

  @override
  _DayInfoState createState() => _DayInfoState();
}

class _DayInfoState extends State<DayInfo> {
  List<Lesson> _sheduleList = [];

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
      future: _getHttpShedule(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container(
              child: Expanded(
            child: ListView.builder(
              itemCount: _sheduleList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          _sheduleList[index].name,
                          textAlign: TextAlign.center,
                        ),
                        Text(_sheduleList[index].type),
                        Text(_sheduleList[index].auditorium),
                        Text(_sheduleList[index].group),
                        Text(_sheduleList[index].lecturer),
                        Text(_sheduleList[index].time)
                      ],
                    ),
                  ),
                );
              },
            ),
          ));
        }
      },
    ));
  }

  _getHttpShedule() async {
    _sheduleList.clear();
    print("Респонс");
    var response = await fetchHttpShedule(
        'https://mpei.ru/Education/timetable/Pages/table.aspx?groupoid=9494&stt=9750000030935');
    var document = parse(response.body);
    var channel =
        document.getElementsByClassName('mpei-galaktika-lessons-grid-day');
    print(channel.length);
    channel.forEach((element) {
      String name = element.getElementsByTagName('span')[0].text.toString();
      print(name);
      String type = element.getElementsByTagName('span')[1].text.toString();
      print(type);
      String auditorium =
          element.getElementsByTagName('span')[2].text.toString();
      print(auditorium);
      String group = element.getElementsByTagName('span')[3].text.toString();
      print(group);
      String lector = element.getElementsByTagName('span')[4].text.toString();
      print(lector);
      Lesson lesson = Lesson(
          name: name,
          type: type,
          auditorium: auditorium,
          group: group,
          lecturer: lector,
          time: "12:45");
      _sheduleList.add(lesson);
    });
    // channel.items.forEach((element) {
    //   _sheduleList.add(element);
    // });

    return _sheduleList;
  }
}
