import 'package:flutter/material.dart';
import 'package:pool_admin/db/repo.dart';
import 'package:pool_admin/models/player.dart';

class AddPendingView extends StatefulWidget {
  const AddPendingView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AddPendingViewState();
}

class AddPendingViewState extends State<AddPendingView> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController amountCtrl = TextEditingController(text: "0");

  bool playerOwes = true;
  bool phoneEditable = true;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    int amt = int.tryParse(amountCtrl.text) ?? 0;
    String finalStr = nameCtrl.text.isEmpty || amt == 0
        ? ""
        : playerOwes
            ? "${nameCtrl.text} will owe you $amt"
            : "You will owe ${nameCtrl.text} $amt";

    return Scaffold(
      appBar: AppBar(title: const Text("Add debt for new player")),
      body: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameCtrl,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name of player",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name is required";
                    }

                    return null;
                  },
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: phoneCtrl,
                  enabled: phoneEditable,
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Phone number",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null; // empty is fine
                    }

                    if (value.length != 10 || int.tryParse(value) == null) {
                      return "Enter a valid 10 digit phone number"; // invalid is not
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Player owes money?"),
                    Checkbox(
                      value: playerOwes,
                      onChanged: (value) => setState(() => playerOwes = !playerOwes),
                    ),
                    Expanded(child: Container()),
                    SizedBox(
                      width: 140,
                      child: TextField(
                        controller: amountCtrl,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          prefixText: "\u20B9",
                          hintText: "Amount",
                          hintStyle: TextStyle(fontSize: 14),
                        ),
                        onChanged: (value) => setState(() {}),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(finalStr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: _onCreatePressed,
        backgroundColor: Colors.green.shade500,
        child: const Icon(Icons.done),
      ),
    );
  }

  void _onCreatePressed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    var pExists = await Repo.getPlayerDao().exists(nameCtrl.text);
    if (pExists) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Player already exists!")),
        );
      }

      return;
    }

    var player = Player(
      id: "Player_${DateTime.now().millisecondsSinceEpoch}",
      phone: phoneCtrl.text,
      name: nameCtrl.text,
      amountPlayerOwes: int.tryParse(amountCtrl.text) ?? 0,
    );

    Repo.getPlayerDao().insert(player);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
