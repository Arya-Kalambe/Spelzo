import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spelzo_app/Widgets/uihelper.dart';
import 'package:spelzo_app/Pages/screens/signup_screen.dart';

class CartManager {
  static final List<Map<String, dynamic>> _cartItems = [];

  static void addToCart(Map<String, dynamic> product, int quantity) {
    final index = _cartItems.indexWhere((item) => item['title'] == product['title']);
    if (index != -1) {
      _cartItems[index]['quantity'] += quantity;
    } else {
      _cartItems.add({...product, 'quantity': quantity});
    }
  }

  static List<Map<String, dynamic>> get items => _cartItems;

  static void removeFromCart(String title) {
    _cartItems.removeWhere((item) => item['title'] == title);
  }

  static void clearCart() {
    _cartItems.clear();
  }
}

class WishlistManager {
  static final List<Map<String, dynamic>> _wishlistItems = [];

  static void addToWishlist(Map<String, dynamic> product) {
    if (!_wishlistItems.any((item) => item['title'] == product['title'])) {
      _wishlistItems.add(product);
    }
  }

  static void removeFromWishlist(String title) {
    _wishlistItems.removeWhere((item) => item['title'] == title);
  }

  static List<Map<String, dynamic>> get items => _wishlistItems;
}

class Details extends StatefulWidget {
  final Map<String, dynamic> product;

  const Details({super.key, required this.product});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> with TickerProviderStateMixin {
  int quantity = 1;
  int selectedColorIndex = 0;
  int selectedRating = 0;
  bool isWishlisted = false;
  final TextEditingController _reviewController = TextEditingController();
  final List<Map<String, String>> userReviews = [];
  final List<Color> colorOptions = [Colors.red, Colors.blue, Colors.green, Colors.orange];
  final PageController _imageController = PageController();

  late AnimationController _slideController;
  late AnimationController _cartBounceController;
  late AnimationController _wishlistBounceController;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _cartBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.9,
      upperBound: 1.0,
    )..forward();

    _wishlistBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.9,
      upperBound: 1.0,
    )..forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _cartBounceController.dispose();
    _wishlistBounceController.dispose();
    _imageController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final double pricePerUnit = double.tryParse(product['price']?.replaceAll(RegExp(r'[^0-9.]'), '') ?? '0') ?? 0;
    final double totalPrice = pricePerUnit * quantity;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF6FB),
      body: SafeArea(
        child: Stack(
          children: [
            // Image Carousel with Zoom and Swipe
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Hero(
                tag: product['img'],
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 3.5,
                  child: PageView.builder(
                    controller: _imageController,
                    itemCount: 3, // 👈 change this to real number of images
                    itemBuilder: (context, index) {
                      return InteractiveViewer(
                        panEnabled: true,
                        minScale: 1,
                        maxScale: 4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/images/${product['img']}',
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // SmoothPageIndicator
            Positioned(
              top: MediaQuery.of(context).size.height / 3.5 - 20,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _imageController,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 10,
                    activeDotColor: Colors.deepOrange,
                    dotColor: Colors.grey.shade300,
                  ),
                ),
              ),
            ),

            // Sliding Details Card
            AnimatedBuilder(
              animation: _slideController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 80 * (1 - _slideController.value)),
                  child: child!,
                );
              },
              child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(product['title'], style: UiHelper.boldTextFieldStyle().copyWith(fontSize: 24)),
                                    ScaleTransition(
                                      scale: _wishlistBounceController,
                                      child: IconButton(
                                        icon: Icon(
                                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                                          color: isWishlisted ? Colors.red : Colors.grey,
                                        ),
                                        onPressed: () {
                                          _wishlistBounceController.forward(from: 0.9);
                                          setState(() {
                                            isWishlisted = !isWishlisted;
                                            if (isWishlisted) {
                                              WishlistManager.addToWishlist(product);
                                            } else {
                                              WishlistManager.removeFromWishlist(product['title']);
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Text(product['subtitle'] ?? '', style: UiHelper.semiBoldTextFieldStyle()),
                                const SizedBox(height: 8),
                                Text('₹${totalPrice.toStringAsFixed(2)}', style: UiHelper.HeaderTextFieldStyle()),
                                const SizedBox(height: 12),
                                Row(
                                  children: List.generate(5, (index) {
                                    return GestureDetector(
                                      onTap: () => setState(() => selectedRating = index + 1),
                                      child: Icon(
                                        Icons.star,
                                        color: index < selectedRating ? Colors.amber : Colors.grey.shade300,
                                        size: 26,
                                      ),
                                    );
                                  }),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Text("Quantity", style: UiHelper.semiBoldTextFieldStyle()),
                                    const Spacer(),
                                    _qtyButton(Icons.remove, () {
                                      if (quantity > 1) setState(() => quantity--);
                                    }),
                                    const SizedBox(width: 12),
                                    Text(quantity.toString(), style: UiHelper.boldTextFieldStyle()),
                                    const SizedBox(width: 12),
                                    _qtyButton(Icons.add, () {
                                      setState(() => quantity++);
                                    }),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Text("Choose Color", style: UiHelper.semiBoldTextFieldStyle()),
                                const SizedBox(height: 10),
                                Row(
                                  children: List.generate(colorOptions.length, (index) {
                                    return GestureDetector(
                                      onTap: () => setState(() => selectedColorIndex = index),
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 12),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: selectedColorIndex == index ? Colors.black : Colors.grey.shade300,
                                            width: 2,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(2),
                                        child: CircleAvatar(
                                          radius: 12,
                                          backgroundColor: colorOptions[index],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                                const SizedBox(height: 20),
                                Text("Description", style: UiHelper.semiBoldTextFieldStyle()),
                                const SizedBox(height: 8),
                                Text(product['description'] ?? '', style: UiHelper.LightTextFieldStyle()),
                                const SizedBox(height: 20),
                                Text("Leave a Review", style: UiHelper.semiBoldTextFieldStyle()),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _reviewController,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    hintText: "Write your review here...",
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_reviewController.text.isNotEmpty) {
                                        setState(() {
                                          userReviews.add({'user': 'Guest', 'review': _reviewController.text});
                                          _reviewController.clear();
                                        });
                                      }
                                    },
                                    child: const Text("Submit Review"),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                if (userReviews.isNotEmpty) ...[
                                  Text("User Reviews", style: UiHelper.semiBoldTextFieldStyle()),
                                  const SizedBox(height: 10),
                                  ...userReviews.map((rev) => ListTile(
                                    leading: const CircleAvatar(child: Icon(Icons.person)),
                                    title: Text(rev['user'] ?? ''),
                                    subtitle: Text(rev['review'] ?? ''),
                                  ))
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                bool isUserLoggedIn = false;
                                if (!isUserLoggedIn) {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen()));
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text("Buy Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ScaleTransition(
                              scale: _cartBounceController,
                              child: GestureDetector(
                                onTap: () {
                                  _cartBounceController.forward(from: 0.9);
                                  CartManager.addToCart(widget.product, quantity);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Added ${widget.product['title']} (x$quantity) to cart.")),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text("Add to Cart", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Back Button
            Positioned(
              top: 20,
              left: 10,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}