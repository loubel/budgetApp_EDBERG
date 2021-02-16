import 'package:budget_app_finalest/helpers/color_helper.dart';
import 'package:budget_app_finalest/models/category.dart';
import 'package:budget_app_finalest/screens/main_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CategoryList extends StatelessWidget {
  final List<Category> _categoryList;
  final Function _editCategory;
  final Function _deleteCategory;

  CategoryList(this._categoryList, this._editCategory, this._deleteCategory);

  @override
  Widget build(BuildContext context) {
    SlidableController slidableController = SlidableController();
    return Container(
      height: 400,
      child: _categoryList.isEmpty
          ? Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: Text(
                    'No Categories Added Yet',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => MainItemScreen(
                            _categoryList[index].category_id,
                            _categoryList[index].category_name,
                            _categoryList[index].category_max_amount,
                            _categoryList[index].category_current_amount,
                          ),
                        ));
                  },
                  child: Slidable(
                    controller: slidableController,
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: Container(
                      height: 130,
                      child: Card(
                        margin: EdgeInsets.all(10),
                        elevation: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _categoryList[index].category_name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        _categoryList[index]
                                            .category_current_amount
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        ' /  ',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        _categoryList[index]
                                            .category_max_amount
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            LayoutBuilder(builder: (BuildContext context,
                                BoxConstraints constraints) {
                              final double maxBarWidth = constraints.maxWidth;
                              final double percent = double.parse(
                                      _categoryList[index]
                                          .category_current_amount
                                          .toString()) /
                                  double.parse(_categoryList[index]
                                      .category_max_amount
                                      .toString());
                              double barWidth = percent * maxBarWidth;
                              if (barWidth < 0) {
                                barWidth = 0;
                              }
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      height: 20.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Colors.grey[200],
                                      ),
                                    ),
                                    Container(
                                      height: 20.0,
                                      width: barWidth,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: getColor(context, percent),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    secondaryActions: <Widget>[
                      //EDIT BUTTON
                      IconSlideAction(
                          caption: 'Edit',
                          color: Colors.black45,
                          icon: Icons.more_horiz,
                          onTap: () {
                            _editCategory(
                                context, _categoryList[index].category_id);
                          }),

                      //DELETE BUTTON
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          _deleteCategory(
                              context, _categoryList[index].category_id);
                        },
                      ),
                    ],
                  ),
                );
              },
              itemCount: _categoryList.length,
            ),
    );
  }
}
