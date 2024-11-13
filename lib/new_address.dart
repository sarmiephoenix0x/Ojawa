import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class NewAddress extends StatefulWidget {
  const NewAddress({super.key});

  @override
  _NewAddressState createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddress> {
  bool isLoading = false;
  int? _selectedRadioValue;
  bool _useDefault = false;
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _streetFocusNode = FocusNode();
  final FocusNode _landmarkFocusNode = FocusNode();
  final FocusNode _stateFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _postalFocusNode = FocusNode();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController postalController = TextEditingController();
  String phoneNumber = '';

  void _submittedAddress() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/Tick.png', // Replace with the item's image asset or network path
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
            SizedBox(
                height: (28 / MediaQuery.of(context).size.height) *
                    MediaQuery.of(context).size.height),
            const Center(
              child: Text(
                'Address Submitted Successfully',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(
                height: (28 / MediaQuery.of(context).size.height) *
                    MediaQuery.of(context).size.height),
            Container(
              width: double.infinity,
              height: (60 / MediaQuery.of(context).size.height) *
                  MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.white;
                      }
                      return const Color(0xFF1D4ED8);
                    },
                  ),
                  foregroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return const Color(0xFF1D4ED8);
                      }
                      return Colors.white;
                    },
                  ),
                  elevation: WidgetStateProperty.all<double>(4.0),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Done',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Address',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: nameController,
                      focusNode: _nameFocusNode,
                      style: const TextStyle(
                        fontSize: 16.0,
                        decoration: TextDecoration.none,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Poppins',
                          fontSize: 16.0,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      cursorColor: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: IntlPhoneField(
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        counterText: '',
                      ),
                      initialCountryCode: 'NG',
                      // Set initial country code
                      onChanged: (phone) {
                        setState(() {
                          phoneNumber = phone.completeNumber;
                        });
                      },
                      onCountryChanged: (country) {
                        print('Country changed to: ${country.name}');
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: streetController,
                      focusNode: _streetFocusNode,
                      style: const TextStyle(
                        fontSize: 16.0,
                        decoration: TextDecoration.none,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Flat No. Street Address',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Poppins',
                          fontSize: 16.0,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      cursorColor: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: landmarkController,
                      focusNode: _landmarkFocusNode,
                      style: const TextStyle(
                        fontSize: 16.0,
                        decoration: TextDecoration.none,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Landmark',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Poppins',
                          fontSize: 16.0,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      cursorColor: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: stateController,
                      focusNode: _stateFocusNode,
                      style: const TextStyle(
                        fontSize: 16.0,
                        decoration: TextDecoration.none,
                      ),
                      decoration: InputDecoration(
                        labelText: 'State',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Poppins',
                          fontSize: 16.0,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      cursorColor: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: cityController,
                      focusNode: _cityFocusNode,
                      style: const TextStyle(
                        fontSize: 16.0,
                        decoration: TextDecoration.none,
                      ),
                      decoration: InputDecoration(
                        labelText: 'City/District',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Poppins',
                          fontSize: 16.0,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      cursorColor: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: postalController,
                      focusNode: _postalFocusNode,
                      style: const TextStyle(
                        fontSize: 16.0,
                        decoration: TextDecoration.none,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Postal Code',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Poppins',
                          fontSize: 16.0,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      cursorColor: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Text(
                          "Address Type",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Row(
                    children: [
                      addressType("Home", 1),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                      addressType("Office", 2),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        activeColor: const Color(0xFF1D4ED8),
                        checkColor: Colors.white,
                        value: _useDefault,
                        onChanged: (bool? value) {
                          setState(() {
                            _useDefault = value!;
                          });
                        },
                      ),
                      Text(
                        "Use as default",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontFamily: 'Poppins',
                          fontSize: 16.0,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      width: double.infinity,
                      height: (60 / MediaQuery.of(context).size.height) *
                          MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (nameController.text.isNotEmpty &&
                              phoneNumber.isNotEmpty &&
                              streetController.text.isNotEmpty &&
                              landmarkController.text.isNotEmpty &&
                              stateController.text.isNotEmpty &&
                              cityController.text.isNotEmpty &&
                              postalController.text.isNotEmpty &&
                              _selectedRadioValue != null) {
                            _submittedAddress();
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (nameController.text.isNotEmpty &&
                                  phoneNumber.isNotEmpty &&
                                  streetController.text.isNotEmpty &&
                                  landmarkController.text.isNotEmpty &&
                                  stateController.text.isNotEmpty &&
                                  cityController.text.isNotEmpty &&
                                  postalController.text.isNotEmpty &&
                                  _selectedRadioValue != null) {
                                if (states.contains(WidgetState.pressed)) {
                                  return Colors.white;
                                }
                                return const Color(0xFF1D4ED8);
                              } else {
                                return Colors.grey;
                              }
                            },
                          ),
                          foregroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (nameController.text.isNotEmpty &&
                                  phoneNumber.isNotEmpty &&
                                  streetController.text.isNotEmpty &&
                                  landmarkController.text.isNotEmpty &&
                                  stateController.text.isNotEmpty &&
                                  cityController.text.isNotEmpty &&
                                  postalController.text.isNotEmpty &&
                                  _selectedRadioValue != null) {
                                if (states.contains(WidgetState.pressed)) {
                                  return const Color(0xFF1D4ED8);
                                }
                                return Colors.white;
                              } else {
                                return Colors.white;
                              }
                            },
                          ),
                          elevation: WidgetStateProperty.all<double>(4.0),
                          shape: WidgetStateProperty.resolveWith<
                              RoundedRectangleBorder>(
                            (Set<WidgetState> states) {
                              final bool isFilled =
                                  nameController.text.isNotEmpty &&
                                      phoneNumber.isNotEmpty &&
                                      streetController.text.isNotEmpty &&
                                      landmarkController.text.isNotEmpty &&
                                      stateController.text.isNotEmpty &&
                                      cityController.text.isNotEmpty &&
                                      postalController.text.isNotEmpty &&
                                      _selectedRadioValue != null;

                              return RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 3,
                                  color: isFilled
                                      ? const Color(0xFF1D4ED8)
                                      : Colors.grey,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                              );
                            },
                          ),
                        ),
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Continue',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget addressType(String text, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _selectedRadioValue = value; // Update selected value
              });
            },
            child: Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(55.0),
                border: Border.all(
                  width: _selectedRadioValue == value ? 3 : 0.8,
                  color: _selectedRadioValue == value
                      ? const Color(0xFF1D4ED8)
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16.0,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
