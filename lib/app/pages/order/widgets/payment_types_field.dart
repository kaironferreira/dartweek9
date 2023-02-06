import 'package:delivery_app/app/core/ui/helpers/size_extensions.dart';
import 'package:delivery_app/app/core/ui/styles/colors_app.dart';
import 'package:delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:delivery_app/app/models/payment_type_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_select/flutter_awesome_select.dart';

class PaymentTypesField extends StatelessWidget {
  final List<PaymentTypeModel> paymentTypes;
  final ValueChanged<int> valueChanged;
  final bool validate;
  final String valueSelected;
  const PaymentTypesField({
    super.key,
    required this.paymentTypes,
    required this.valueChanged,
    required this.validate,
    required this.valueSelected,
  });

  @override
  Widget build(BuildContext context) {
    String select = '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: validate ? Colors.grey.shade400 : Colors.red,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.only(
            top: 12,
            left: 12,
            right: 12,
            bottom: 8,
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SmartSelect<String>.single(
                title: 'Formas de Pagamento',
                selectedValue: valueSelected,
                choiceStyle: S2ChoiceStyle(color: context.colors.primary),
                modalType: S2ModalType.bottomSheet,
                onChange: (selected) {
                  valueChanged(int.parse(selected.value));
                  select = selected.value;
                },
                tileBuilder: (context, state) {
                  return InkWell(
                    onTap: state.showModal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(0),
                          width: context.screenWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                state.selected.title ?? 'Formas de Pagamento',
                                style: context.textStyles.textRegular.copyWith(
                                  fontSize: 16,
                                  color: select != ''
                                      ? Colors.black
                                      : Colors.grey.shade400,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_right_outlined,
                                color: Colors.grey,
                              )
                            ],
                          ),
                        ),
                        // Visibility(
                        //   visible: !validate,
                        //   child: const Divider(color: Colors.red),
                        // ),
                        // Visibility(
                        //   visible: !validate,
                        //   child: Text(
                        //     'Selecioneee uma forma de pagamento',
                        //     style: context.textStyles.textRegular.copyWith(
                        //       color: Colors.red,
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  );
                },
                choiceItems: S2Choice.listFrom<String, Map<String, String>>(
                  source: paymentTypes
                      .map((p) => {'value': p.id.toString(), 'title': p.name})
                      .toList(),
                  // [
                  //   {'value': 'VA', 'title': 'Vale Alimentação'},
                  //   {'value': 'VR', 'title': 'Vale Refeição'},
                  //   {'value': 'CC', 'title': 'Cartão de Crédito'},
                  // ],
                  title: (index, item) => item['title'] ?? '',
                  value: (index, item) => item['value'] ?? '',
                  group: (index, item) => 'Selecione uma forma de pagamento',
                ),
                choiceType: S2ChoiceType.radios,
                choiceGrouped: false,
                modalFilter: false,
                placeholder: '',
              )
            ],
          ),
        ),
        Visibility(
          visible: !validate,
          child: Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              'Selecioneee uma forma de pagamento',
              style: context.textStyles.textRegular.copyWith(
                color: Colors.red,
              ),
            ),
          ),
        )
      ],
    );
  }
}
