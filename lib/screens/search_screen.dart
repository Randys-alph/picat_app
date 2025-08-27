import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../theme_provider.dart';
import '../services/api_service.dart';

class SearchScreen extends StatefulWidget {
  final String category;

  const SearchScreen({super.key, required this.category});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ApiService _apiService = ApiService();

  // State untuk UI
  bool _isLoading = false;
  String _displayTitle = '';
  String _displayDescription = '';
  List<String> _predictedGenres = [];
  double _thresholdValue = 0.5;
  bool _isDescriptionVisible = false;

  // Fungsi untuk membersihkan input
  void _clearInputs() {
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
      _displayTitle = '';
      _isDescriptionVisible = false;
    });
  }

  // Fungsi untuk memanggil API
  void _performSearch() async {
    // 1. Validasi input agar tidak kosong
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty!')),
      );
      return;
    }

    // 2. Sembunyikan keyboard untuk pengalaman pengguna yang lebih baik
    FocusScope.of(context).unfocus();

    // 3. Atur state ke mode loading dan bersihkan hasil sebelumnya
    setState(() {
      _isLoading = true;
      _displayTitle = '';
      _displayDescription = '';
      _predictedGenres = [];
    });

    // 4. Gunakan try-catch untuk menangani kemungkinan error dari API
    try {
      // 5. Panggil API dengan semua parameter yang dibutuhkan
      final result = await _apiService.predictGenre(
        category: widget.category,
        title: _titleController.text,
        description: _descriptionController.text,
        threshold: _thresholdValue,
      );

      // 6. Jika berhasil, update state dengan data dari API
      setState(() {
        _displayTitle = result['title'];
        _displayDescription = result['description'];
        _predictedGenres = List<String>.from(result['predicted_genres']);
        _isLoading = false;
      });

    } catch (e) {
      // 7. Jika gagal, update state dengan pesan error yang jelas
      setState(() {
        _displayTitle = "Error";
        _predictedGenres = [e.toString().replaceAll('Exception: ', '')];
        _displayDescription = "Failed to process request.";
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final String dynamicDescription =
        "This app is a tool for predicting the genre of a ${widget.category.toLowerCase()} based on the title or description you provide.";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        title: Text(
          'PiCat',
          style: TextStyle(
            fontFamily: 'Jersey20',
            fontSize: 40,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          CupertinoSwitch(
            value: isDarkMode,
            onChanged: (value) {
              final provider = Provider.of<ThemeProvider>(context, listen: false);
              provider.toggleTheme(value);
            },
            activeColor: Colors.orange,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            // Animasi fade in dari atas untuk header
            FadeInDown(
              child: Column(
                children: [
                  Image.asset(
                    isDarkMode ? 'assets/images/dark_logo.png' : 'assets/images/logo.png',
                    width: 80,
                  ),
                  Text(
                    'PiCat',
                    style: TextStyle(
                      fontFamily: 'Jersey20',
                      fontSize: 60,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    dynamicDescription,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Input Area
            _buildSearchBar(isDarkMode),
            
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Visibility(
                visible: _isDescriptionVisible,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: _buildDescriptionInput(isDarkMode),
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            _buildSlider(),
            const SizedBox(height: 30),

            // Tampilan Kondisional untuk Loading atau Hasil
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_displayTitle.isNotEmpty)
              // Animasi fade in untuk kartu hasil
              FadeInUp(
                child: _buildResultCard(isDarkMode),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              widget.category.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
          const SizedBox(height: 30, child: VerticalDivider(color: Colors.grey)),
          Expanded(
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Input Title',
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 8),
              ),
              onSubmitted: (_) => _performSearch(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _performSearch,
          ),
          IconButton(
            icon: Icon(_isDescriptionVisible ? Icons.remove : Icons.add),
            onPressed: () {
              setState(() {
                _isDescriptionVisible = !_isDescriptionVisible;
                if (!_isDescriptionVisible) {
                  _descriptionController.clear();
                }
              });
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildDescriptionInput(bool isDarkMode) {
    return TextField(
      controller: _descriptionController,
      decoration: InputDecoration(
        hintText: 'Input Description (Optional)',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        filled: true,
        fillColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      maxLines: 1,
    );
  }

  Widget _buildSlider() {
    return Column(
      children: [
        Text('Threshold: ${_thresholdValue.toStringAsFixed(1)}'),
        Slider(
          value: _thresholdValue,
          min: 0.0,
          max: 1.0,
          divisions: 10,
          label: _thresholdValue.toStringAsFixed(1),
          activeColor: Colors.orange,
          onChanged: (double value) {
            setState(() {
              _thresholdValue = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildResultCard(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800.withOpacity(0.5) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text('Title', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                    Text(_displayTitle, textAlign: TextAlign.center),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                    Text(_displayDescription, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Categories', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black.withOpacity(0.5) : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _predictedGenres.join(', '),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}