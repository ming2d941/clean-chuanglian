import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class CustomProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    buildImg(Color color, double height, double width) {
      return SizedBox(
          height: height,
          width: width,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.rectangle,
            ),
          ));
    }

    buildCollapsed() {
      return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildImg(Colors.lightGreenAccent, 70, 70),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "窗帘标题",
                      style: Theme.of(context).textTheme.title,
                    ),
                    Text(
                      "我是内容",
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                  ],
                ),
              ),
            ),
          ]);
    }

    buildExpanded1() {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Expandable",
                    style: Theme.of(context).textTheme.body1,
                  ),
                  Text(
                    "3 Expandable widgets",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
          ]);
    }

    buildExpanded3() {
      return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '规格：180cm x 140cm\n材料：棉\n单价：￥100.0',
              softWrap: true,
            ),
          ],
        ),
      );
    }

    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: ScrollOnExpand(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expandable(
                collapsed: buildCollapsed(),
                expanded: buildCollapsed(),
              ),
              Expandable(
                collapsed: new Container(),
                expanded: buildExpanded3(),
              ),
              Divider(
                height: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Builder(
                    builder: (context) {
                      var controller = ExpandableController.of(context);
                      return FlatButton(
                        child: Text(
                          controller.expanded ? "收起" : "编辑",
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: Colors.deepPurple),
                        ),
                        onPressed: () {
                          controller.toggle();
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
