import 'package:flutter/material.dart';

class Messagetile extends StatefulWidget {
  final String Message;
  final String Sender;
  final bool SendbyMe;

  const Messagetile({
    Key? key,
    required this.Message,
    required this.Sender,
    required this.SendbyMe,
  }) : super(key: key);

  @override
  State<Messagetile> createState() => _MessagetileState();
}

class _MessagetileState extends State<Messagetile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 4,
        top: 4,
        left: widget.SendbyMe ? 0 : 24,
        right: widget.SendbyMe ? 24 : 0,
      ),
      alignment: widget.SendbyMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: (widget.SendbyMe)
            ? const EdgeInsets.only(top: 10, bottom: 10, left: 40, right: 0)
            : const EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 40),
        padding:
            const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          color: (widget.SendbyMe)
              ? Colors.deepPurple
              : Colors.deepPurple.shade300,
          borderRadius: (widget.SendbyMe)
              ? const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.Sender.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade100,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.Message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
