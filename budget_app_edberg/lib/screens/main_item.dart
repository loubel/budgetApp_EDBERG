import 'package:budget_app_finalest/helpers/color_helper.dart';
import 'package:budget_app_finalest/models/category.dart';
import 'package:budget_app_finalest/models/item.dart';
import 'package:budget_app_finalest/screens/item_list.dart';
import 'package:budget_app_finalest/screens/main_category.dart';
import 'package:budget_app_finalest/services/category_service.dart';
import 'package:budget_app_finalest/services/item_service.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:intl/intl.dart';

class MainItemScreen extends StatefulWidget {
  final int item_id;
  String item_name;
  int category_max_amount;
  int category_current_amount;

  MainItemScreen(this.item_id, this.item_name, this.category_max_amount,
      this.category_current_amount);

  @override
  _MainItemScreenState createState() => _MainItemScreenState();
}

class _MainItemScreenState extends State<MainItemScreen> {
  var totalSum = 0;

  var item;
  var category;

  List<Item> _itemList = <Item>[];

  var _item = Item();
  var _category = Category();

  var _categoryService = CategoryService();
  var _itemService = ItemService();

  var itemTitleController = TextEditingController();
  var itemAmountController = TextEditingController();
  var editItemTitleController = TextEditingController();
  var editItemAmountController = TextEditingController();
  DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    getAllItems();
  }

  //percentageBar() {}

  //percentage() {}

  getAllItems() async {
    _itemList = List<Item>();
    var items = await _itemService.readItem(widget.item_id);
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
    totalSum = 0;
    for (int i = 0; i < _itemList.length; i++) {
      setState(() {
        totalSum += _itemList[i].item_amount;
      });
    }
    _updateAmount();
  }

  _updateAmount() async {
    _category.category_id = widget.item_id;
    _category.category_name = widget.item_name;
    _category.category_max_amount = widget.category_max_amount;
    _category.category_current_amount = totalSum;
    var result = await _categoryService.updateCategory(_category);
  }

  _deleteItem(BuildContext context, itemId) async {
    _deleteDialog(context, itemId);
  }

  _deleteDialog(BuildContext context, itemId) {
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
                    var result = await _itemService.deleteItem(itemId);
                    Navigator.pop(context);
                    getAllItems();
                  }),
            ],
          );
        });
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  _editItem(BuildContext context, itemId) async {
    item = await _itemService.readItemById(itemId);
    setState(() {
      editItemTitleController.text = item[0]['item_name'];
      editItemAmountController.text = item[0]['item_amount'].toString();
      _selectedDate =
          DateFormat("yyyy-MM-dd hh:mm:ss").parse(item[0]['item_date']);
    });
    _editDialog(context);
  }

  _editDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        //Popup Dialogue
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          elevation: 16,
          content: Container(
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

                          //TEXT FIELD ONLY
                          child: Column(
                            children: [
                              TextField(
                                controller: editItemTitleController,
                                decoration:
                                    InputDecoration(hintText: 'New Item Name'),
                              ),
                              TextField(
                                controller: editItemAmountController,
                                decoration: InputDecoration(
                                  hintText: 'New Item Amount',
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              Container(
                                height: 70,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        _selectedDate == null
                                            ? 'New Date'
                                            : DateFormat.yMd()
                                                .format(_selectedDate),
                                        style: TextStyle(
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ),
                                    // ignore: deprecated_member_use
                                    FlatButton(
                                      child: Text('Choose Date'),
                                      onPressed: () {
                                        setState(() {
                                          _presentDatePicker();
                                        });
                                      },
                                      textColor: Theme.of(context).primaryColor,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                // ignore: deprecated_member_use
                                child: RaisedButton(
                                  child: Text(
                                    'Save',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  color: Colors.green,
                                  onPressed: () async {
                                    if (editItemTitleController.text.isEmpty ||
                                        editItemAmountController.text.isEmpty ||
                                        _selectedDate == null) {
                                      return;
                                    } else if (widget.category_max_amount <=
                                            0 ||
                                        int.parse(
                                                editItemAmountController.text) >
                                            widget.category_max_amount) {
                                      return;
                                    } else {
                                      _item.item_id = item[0]['item_id'];
                                      _item.item_name =
                                          editItemTitleController.text;
                                      _item.item_amount = int.parse(
                                          editItemAmountController.text);
                                      _item.item_date =
                                          _selectedDate.toString();
                                      _item.category_id =
                                          item[0]['category_id'];
                                      print(_item.item_id);
                                      print(_item.item_name);
                                      print(_item.item_amount);
                                      var result =
                                          await _itemService.updateItem(_item);
                                      Navigator.of(context).pop();
                                      getAllItems();
                                    }
                                    editItemAmountController.text = '';
                                    editItemTitleController.text = '';
                                    _selectedDate = null;
                                  },
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //EDIT BUTTON
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
                                  if (editItemTitleController.text.isEmpty ||
                                      editItemAmountController.text.isEmpty) {
                                    return;
                                  } else if (widget.category_current_amount <=
                                          0 ||
                                      int.parse(editItemAmountController.text) >
                                          widget.category_current_amount) {
                                    return;
                                  } else {
                                    _item.item_id = item[0]['item_id'];
                                    _item.item_name =
                                        editItemTitleController.text;
                                    _item.item_amount = int.parse(
                                        editItemAmountController.text);
                                    _item.item_date = _selectedDate.toString();
                                    _item.category_id = item[0]['category_id'];
                                    print(_item.item_id);
                                    print(_item.item_name);
                                    print(_item.item_amount);
                                    var result =
                                        await _itemService.updateItem(_item);
                                    print(result);

                                    editItemTitleController.text = '';
                                    editItemAmountController.text = '';
                                    _selectedDate = null;
                                    Navigator.of(context).pop();

                                    getAllItems();
                                  }
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

  void _startAddNewItem(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (param) {
          return StatefulBuilder(builder: (context, setState) {
            return Card(
              elevation: 5,
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Item Title',
                      ),
                      controller: itemTitleController,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Amount',
                      ),
                      controller: itemAmountController,
                      keyboardType: TextInputType.number,
                    ),
                    Container(
                      height: 70,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              _selectedDate == null
                                  ? 'No Date Chosen'
                                  : DateFormat.yMd().format(_selectedDate),
                            ),
                          ),
                          // ignore: deprecated_member_use
                          FlatButton(
                            child: Text('Choose Date'),
                            onPressed: () async {
                              var pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1999),
                                  lastDate: DateTime.now());
                              if (pickedDate != null) {
                                _selectedDate = pickedDate;
                                setState(() {
                                  _selectedDate = pickedDate;
                                });
                              }
                            },
                            textColor: Theme.of(context).primaryColor,
                          )
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 150,
                        height: 40,
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          child: Text(
                            'Add Item',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          color: Colors.green,
                          onPressed: () async {
                            if (itemTitleController.text.isEmpty ||
                                itemAmountController.text.isEmpty ||
                                _selectedDate == null) {
                              return;
                            } else {
                              _item.item_name = itemTitleController.text;
                              _item.item_amount =
                                  int.parse(itemAmountController.text);
                              _item.item_date = _selectedDate.toString();
                              _item.category_id = widget.item_id;
                              var result = await _itemService.saveItem(_item);

                              getAllItems();
                              itemTitleController.text = '';
                              itemAmountController.text = '';
                              _selectedDate = null;
                            }
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

//########################################################
//########################################################
//########################################################
//########################################################
//########################################################
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            getAllItems();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MainScreen(),
              ),
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _startAddNewItem(context);
            },
          )
        ],
        title: Text(
          widget.item_name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              elevation: 6,
              margin: EdgeInsets.all(10),
              child: Container(
                height: 300,
                //Radial CHART
                //###########
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    new CircularPercentIndicator(
                      radius: 200.0,
                      lineWidth: 13.0,
                      animation: true,
                      percent: (totalSum / widget.category_max_amount),
                      center: Text(
                        (totalSum / widget.category_max_amount * 100)
                                .toStringAsFixed(1) +
                            '%',
                        style: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: getColor(
                          context, (totalSum / widget.category_max_amount)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '₱ ' + '$totalSum',
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          "  /  ",
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          '₱ ' +
                              '${widget.category_max_amount.toStringAsFixed(2)}',
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ItemList(_itemList, _editItem, _deleteItem)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        focusColor: Colors.green,
        backgroundColor: Colors.pink,
        child: Icon(Icons.add),
        onPressed: () {
          _startAddNewItem(context);
        },
      ),
    );
  }
}
