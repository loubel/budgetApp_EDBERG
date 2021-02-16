import 'package:budget_app_finalest/models/category.dart';
import 'package:budget_app_finalest/models/item.dart';
import 'package:budget_app_finalest/screens/category_list.dart';
import 'package:budget_app_finalest/screens/chart.dart';
import 'package:budget_app_finalest/services/category_service.dart';
import 'package:budget_app_finalest/services/item_service.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Category> _categoryList = <Category>[];
  List<Item> _itemList = <Item>[];

  final categoryTitleController = TextEditingController();
  final categoryAmountController = TextEditingController();
  final editCategoryTitleController = TextEditingController();
  final editCategoryAmountController = TextEditingController();

  var category;
  var _category = Category();
  var _categoryService = CategoryService();
  var _itemService = ItemService();

  @override
  void initState() {
    super.initState();
    getAllCategories();
    getAllItems();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllCategories() async {
    _categoryList = List<Category>();
    var categories = await _categoryService.readCategory();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.category_name = category['category_name'];
        categoryModel.category_id = category['category_id'];
        categoryModel.category_max_amount = category['category_max_amount'];
        categoryModel.category_current_amount =
            category['category_current_amount'] == null
                ? category['category_max_amount']
                : category['category_current_amount'];
        _categoryList.add(categoryModel);
      });
    });
  }

  getAllItems() async {
    _itemList = List<Item>();
    var items = await _itemService.readAllItem();
    items.forEach((item) {
      setState(() {
        var itemModel = Item();
        itemModel.item_name = item['item_name'];
        itemModel.item_id = item['item_id'];
        itemModel.item_amount = item['item_amount'];
        itemModel.item_date = item['item_date'];
        itemModel.category_id = item['category_id'];
        _itemList.add(itemModel);
      });
    });
  }

  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      editCategoryTitleController.text =
          category[0]['category_name'] ?? 'No Name';
      editCategoryAmountController.text =
          category[0]['category_max_amount'].toString() ?? 'No Budget';
    });
    editDialog(context);
  }

  _deleteCategory(BuildContext context, categoryId) async {
    _deleteDialog(context, categoryId);
  }

  _deleteDialog(BuildContext context, categoryId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            title: Text('Are you sure you want to delete this item?'),
            actions: [
              RaisedButton(
                  color: Colors.grey,
                  child: Text('Cancel'),
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              RaisedButton(
                  color: Colors.red,
                  child: Text('Delete'),
                  textColor: Colors.white,
                  onPressed: () async {
                    var result =
                        await _categoryService.deleteCategory(categoryId);
                    Navigator.pop(context);
                    getAllCategories();
                  }),
            ],
          );
        });
  }

  editDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        //Popup Dialogue
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          elevation: 16,
          child: Container(
            height: 300.0,
            width: 360.0,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 30.0,
                right: 30.0,
              ),
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Edit Details",
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 25.0,
                          ),

                          //TEXT FIELD
                          child: Column(
                            children: [
                              TextField(
                                controller: editCategoryTitleController,
                                decoration: InputDecoration(
                                  hintText: 'New Title',
                                ),
                              ),
                              TextField(
                                controller: editCategoryAmountController,
                                decoration: InputDecoration(
                                  hintText: 'New Amount',
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),

                        // SAVE EDITED BUTTON
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Container(
                            width: 150,
                            height: 40,
                            // ignore: deprecated_member_use
                            child: RaisedButton(
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              color: Colors.green,
                              onPressed: () {
                                setState(() async {
                                  if (editCategoryTitleController
                                          .text.isEmpty ||
                                      editCategoryAmountController
                                          .text.isEmpty) {
                                    return;
                                  } else {
                                    _category.category_id =
                                        category[0]['category_id'];
                                    _category.category_name =
                                        editCategoryTitleController.text;
                                    _category.category_max_amount = int.parse(
                                        editCategoryAmountController.text);
                                    _category.category_current_amount =
                                        _category.category_current_amount;
                                    var result = await _categoryService
                                        .updateCategory(_category);
                                    print(result);
                                    Navigator.of(context).pop();
                                  }
                                  getAllCategories();
                                  getAllItems();
                                });
                              },
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  addNewCategory(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(30.0),
                    topRight: const Radius.circular(30.0),
                  )),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(30.0),
                        topRight: const Radius.circular(30.0))),
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Center(
                          child: Text(
                        'New Category',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      )),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Category Name',
                      ),
                      controller: categoryTitleController,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Amount Per Week',
                      ),
                      controller: categoryAmountController,
                      keyboardType: TextInputType.number,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Center(
                        child: Container(
                          width: 150,
                          height: 40,
                          child: RaisedButton(
                            child: Text(
                              'Add Category',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            color: Colors.pink,
                            onPressed: () async {
                              if (categoryTitleController.text.isEmpty ||
                                  categoryAmountController.text.isEmpty) {
                                return;
                              } else {
                                _category.category_name =
                                    categoryTitleController.text;
                                _category.category_current_amount = 0;

                                _category.category_max_amount =
                                    int.parse(categoryAmountController.text);

                                var result = await _categoryService
                                    .saveCategory(_category);

                                Navigator.of(context).pop();
                                categoryTitleController.text = '';
                                categoryAmountController.text = '';
                                getAllCategories();
                              }
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.list_sharp),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              addNewCategory(context);
            },
          )
        ],
        title: Text(
          "Budget App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 220,
            width: double.infinity,
            child: Card(
              //BAR CHART NI SIYA ED PARA DILI KALIMOT
              elevation: 6,
              child: Chart(_itemList),
            ),
          ),
          CategoryList(
            _categoryList,
            _editCategory,
            _deleteCategory,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        focusColor: Colors.green,
        backgroundColor: Colors.pink,
        child: Icon(Icons.add),
        onPressed: () {
          addNewCategory(context);
        },
      ),
    );
  }
}
