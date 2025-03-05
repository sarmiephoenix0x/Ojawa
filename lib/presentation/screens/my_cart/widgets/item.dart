import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  final BuildContext context;
  final int cartItemId;
  final String img;
  final String details;
  final double amount;
  final double slashedPrice;
  final int discount;
  final int quantity;
  final VoidCallback onRemove;
  final Function(int) onUpdateQuantity;

  const ItemWidget({
    super.key,
    required this.context,
    required this.cartItemId,
    required this.img,
    required this.details,
    required this.amount,
    required this.slashedPrice,
    required this.discount,
    required this.quantity,
    required this.onRemove,
    required this.onUpdateQuantity,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> quantityNotifier = ValueNotifier<int>(quantity);
    final ValueNotifier<String> selectedSizeNotifier =
        ValueNotifier<String>("L");
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left-side Image with Remove button below
            Column(
              children: [
                // Image with dynamic height based on content
                Image.network(
                  img,
                  width: 100,
                  height: MediaQuery.of(context).size.height * 0.2,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            SizedBox(width: 16.0),
            // Right-side Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    details,
                    style: TextStyle(fontSize: 16.0),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Text(
                        '\$${amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Text(
                        '\$${slashedPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16.0,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 2,
                          decorationColor: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Text(
                        '-$discount%',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16.0,
                          color: Color(0xFFEA580C),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                      height: (10.0 / MediaQuery.of(context).size.height) *
                          MediaQuery.of(context).size.height),
                  // Size Dropdown and Quantity Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Size Dropdown
                      ValueListenableBuilder<String>(
                        valueListenable: selectedSizeNotifier,
                        builder: (context, selectedSize, child) {
                          return Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(20, 0, 0, 0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              children: [
                                DropdownButton<String>(
                                  value: selectedSize,
                                  underline:
                                      SizedBox(), // Remove default underline
                                  items: ['S', 'M', 'L', 'XL', 'XXL']
                                      .map((String size) {
                                    return DropdownMenuItem<String>(
                                      value: size,
                                      child: Text(size),
                                    );
                                  }).toList(),
                                  onChanged: (String? newSize) {
                                    if (newSize != null) {
                                      selectedSizeNotifier.value =
                                          newSize; // Update size
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      // Quantity Selector
                      ValueListenableBuilder<int>(
                        valueListenable: quantityNotifier,
                        builder: (context, quantity, child) {
                          return Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(20, 0, 0, 0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    if (quantity > 1) {
                                      quantityNotifier.value = quantity - 1;
                                      onUpdateQuantity(quantityNotifier.value);
                                    }
                                  },
                                ),
                                Text('$quantity',
                                    style: const TextStyle(fontSize: 18)),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    quantityNotifier.value = quantity + 1;
                                    onUpdateQuantity(quantityNotifier.value);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            onRemove();
          },
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:
                MainAxisAlignment.end, // Align Remove to the right
            children: [
              Spacer(),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: null,
              ),
              Text(
                "Remove",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
