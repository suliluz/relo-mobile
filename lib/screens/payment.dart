import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  height: 200,
                  // Gradient of 591da9, 051960
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF591da9),
                        Color(0xFF051960),
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Wallet", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                      const SizedBox(height: 10,),
                      // Format number into currency
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("MYR ${1000.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 22,),),
                              Text("USD ${200.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 16,),),
                            ],
                          ),
                          // Big wallet icon with rounded corners
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: const Icon(Icons.account_balance_wallet, color: Color(0xFF051960), size: 30,),
                          )
                        ],
                      ),
                      const SizedBox(height: 20,),
                      // Top up and withdraw buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: const Text("Top Up"),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: const Text("Withdraw"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                // Verify status
                const Text("Account Status", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Icon(Icons.verified, color: Theme.of(context).primaryColor,),
                    const SizedBox(width: 10,),
                    Text("Verified", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16, fontWeight: FontWeight.bold),),
                  ],
                ),
                const SizedBox(height: 20,),
                // Payment methods
                const Text("Payment Methods", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10,),
                // List of payment methods
                ListView(
                  shrinkWrap: true,
                  children: const [
                    ListTile(
                      leading: Icon(Icons.credit_card),
                      title: Text('Mastercard *-4098'),
                      subtitle: Text("PRIMARY", style: TextStyle(color: Colors.green),),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                    ListTile(
                      leading: Icon(Icons.account_balance),
                      title: Text('Maybank *-1123'),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
                // Add payment method text button
                const SizedBox(height: 10,),
                TextButton(
                  onPressed: () {},
                  child: const Text("Add Payment Method", style: TextStyle(color: Colors.blue),),
                ),
                const SizedBox(height: 20,),
                // Payment history
                const Text("Payment History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10,),
                // List of payment history
                ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.arrow_upward),
                      title: const Text('Top Up', style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: const Text("MYR 1000"),
                      trailing: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Column(
                          children: [
                            const Text("2021-09-01", style: TextStyle(color: Colors.grey, fontSize: 12),),
                            const SizedBox(height: 5,),
                            Icon(Icons.arrow_forward_ios, color: Theme.of(context).primaryColor, size: 15,)
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.arrow_downward),
                      title: const Text('Withdraw', style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: const Text("MYR 1000"),
                      trailing: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Column(
                          children: [
                            const Text("2021-09-01", style: TextStyle(color: Colors.grey, fontSize: 12),),
                            const SizedBox(height: 5,),
                            Icon(Icons.arrow_forward_ios, color: Theme.of(context).primaryColor, size: 15,)
                          ],
                        ),
                      ),
                    ),
                    // Payment
                    ListTile(
                      leading: const Icon(Icons.shopping_bag_outlined),
                      title: const Text('Payment', style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: const Text("MYR 1000"),
                      trailing: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Column(
                          children: [
                            const Text("2021-09-01", style: TextStyle(color: Colors.grey, fontSize: 12),),
                            const SizedBox(height: 5,),
                            Icon(Icons.arrow_forward_ios, color: Theme.of(context).primaryColor, size: 15,)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
}
