// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:flutter/material.dart';

class OrderInputField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final FormFieldValidator validator;
  final String hintText;
  const OrderInputField({
    super.key,
    required this.title,
    required this.controller,
    required this.validator,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    const defaultBorder = UnderlineInputBorder(
        borderSide: BorderSide(
      color: Colors.grey,
    ));
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(
          //   height: 35,
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16),
          //     child: Text(
          //       title,
          //       style: context.textStyles.textRegular.copyWith(
          //         overflow: TextOverflow.ellipsis,
          //         fontSize: 16,
          //       ),
          //     ),
          //   ),
          // ),
          TextFormField(
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText,
              border: defaultBorder,
              enabledBorder: defaultBorder,
              focusedBorder: defaultBorder,
            ),
          )
        ],
      ),
    );
  }
}
