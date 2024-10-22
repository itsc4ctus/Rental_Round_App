import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FAQ"),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: double.infinity,
            child: ListView(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Frequently Asked Questions",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: "jaro",
                    color: Colors.blue.shade900,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text("""
Q: What is Rental Round?
A: Rental Round is a car rental app designed for shop owners to manage vehicle rentals efficiently. It simplifies the process of renting vehicles for various business needs like deliveries or transportation.

Q: How do I set up my account on Rental Round?
A: Setting up an account is easy. Shop owners simply provide their business details during registration and gain immediate access to the app's rental management features.later you can edit if you want.

Q: What vehicles can I rent on the app?
A: The app allows shop owners to browse through a variety of vehicles, with filters available for fuel type (petrol, diesel, electric), making it easy to find the right vehicle for your business.

Q: Can I manage customer details on Rental Round?
A: Yes, you can add and manage customer details in the app, helping you keep track of who has rented a vehicle and for how long.

Q: Does Rental Round include a booking or payment system?
A: No, Rental Round does not have a built-in booking or payment system. Its focus is on streamlining vehicle selection, customer management, and tracking rental details.

Q: How does the budget tracking feature work?
A: Rental Round has a built-in budget tracker to help shop owners monitor income and expenses related to rentals, providing an overview of profitability.

Q: What kind of customer support is available?
A: Our support team is ready to assist with any issues you encounter while using the app, ensuring a smooth experience.
                  """),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
