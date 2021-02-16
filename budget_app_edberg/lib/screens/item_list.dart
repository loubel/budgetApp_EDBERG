import 'package:budget_app_finalest/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ItemList extends StatefulWidget {
  final List<Item> _itemList;
  final Function _editItem;
  final Function _deleteItem;

  ItemList(this._itemList, this._editItem, this._deleteItem);

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  SlidableController slidableController = SlidableController();

  final newItemController = TextEditingController();
  final newCostController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 416,
      child: widget._itemList.isEmpty
          ? Column(
              children: <Widget>[],
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return Slidable(
                  controller: slidableController,
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    height: 120,
                    child: Card(
                      margin: EdgeInsets.all(10),
                      elevation: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ListTile(
                            title: Text(
                              '${widget._itemList[index].item_name}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(DateFormat.yMd()
                                .format(DateTime.parse(
                                    widget._itemList[index].item_date))
                                .toString()),
                            trailing: Text(
                              '\₱ ${widget._itemList[index].item_amount}',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Edit',
                      color: Colors.black45,
                      icon: Icons.more_horiz,
                      onTap: () {
                        widget._editItem(
                            context, widget._itemList[index].item_id);
                      },
                    ),
                    IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          widget._deleteItem(
                              context, widget._itemList[index].item_id);
                        }),
                  ],
                );
              },
              itemCount: widget._itemList.length,
            ),
    );
  }
}
