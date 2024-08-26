import 'dart:async';

import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.optionsBuilder,
    this.onSetTextController,
    this.onTextChanged,
    this.onTextSubmitted,
    this.onSelected,
  });

  final FutureOr<Iterable<Map<String, dynamic>>> Function(TextEditingValue)
      optionsBuilder;
  final void Function(TextEditingController)? onSetTextController;
  final void Function(String)? onTextChanged;
  final void Function(String)? onTextSubmitted;
  final void Function(Map<String, dynamic>)? onSelected;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Map<String, dynamic>>(
      optionsViewOpenDirection: OptionsViewOpenDirection.down,
      optionsBuilder: widget.optionsBuilder,
      displayStringForOption: (op) => op["name"],
      optionsViewBuilder: (context, onSelected, options) {
        final optionsList = options.toList();
        return Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.surface,
          child: Material(
            child: ListView.separated(
              itemBuilder: (context, index) {
                final op = optionsList[index];
                return ListTile(
                  title: Text(
                    op["name"],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text("${op["country"] ?? "N/A"} - ${op["admin1"] ?? "N/A"}"),
                  dense: false,
                  onTap: () => onSelected(op),
                  // isThreeLine: true,
                );
              },
              separatorBuilder: (context, index) => const Divider(height: 0),
              itemCount: options.length,
            ),
          ),
        );
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        this.controller = controller;
        widget.onSetTextController?.call(controller);
        return TextField(
          controller: controller,
          focusNode: focusNode,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
          onChanged: widget.onTextChanged,
          onSubmitted: (value) {
            onFieldSubmitted();
            widget.onTextSubmitted?.call(value);
          },
          decoration: InputDecoration(
            hintText: "Search cities...",
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(100),
                    onPressed: () {
                      setState(() {
                        controller.clear();
                        widget.onTextChanged?.call("");
                      });
                    },
                    icon: const Icon(Icons.clear_rounded, size: 20),
                  )
                : null,
          ),
        );
      },
      onSelected: widget.onSelected,
    );
  }
}
