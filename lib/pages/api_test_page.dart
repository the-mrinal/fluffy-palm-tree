import 'package:flutter/material.dart';
import 'package:paper_bulls/services/api/api_client.dart';

/// A test page to verify that the mock API is working correctly
class ApiTestPage extends StatefulWidget {
  const ApiTestPage({super.key});

  @override
  State<ApiTestPage> createState() => _ApiTestPageState();
}

class _ApiTestPageState extends State<ApiTestPage> {
  final ApiClient _apiClient = ApiClient();
  final TextEditingController _phoneController = TextEditingController(text: '9090909009');
  final TextEditingController _otpController = TextEditingController(text: '123456');
  final TextEditingController _capitalController = TextEditingController(text: '400000');
  
  String _responseText = 'Response will appear here';
  String? _hash;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  
  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _capitalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Test Page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAuthSection(),
            const Divider(height: 32),
            _buildTradingSection(),
            const Divider(height: 32),
            _buildPnLSection(),
            const Divider(height: 32),
            _buildResponseSection(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAuthSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Authentication',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : _requestOtp,
              child: const Text('Request OTP'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _otpController,
              decoration: const InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading || _hash == null ? null : _verifyOtp,
              child: const Text('Verify OTP'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading || !_isAuthenticated ? null : _getUserProfile,
              child: const Text('Get User Profile'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTradingSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trading',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _capitalController,
              decoration: const InputDecoration(
                labelText: 'Capital Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading || !_isAuthenticated ? null : _allocateCapital,
              child: const Text('Allocate Capital'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading || !_isAuthenticated ? null : _startForwardTest,
              child: const Text('Start Forward Test'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading || !_isAuthenticated ? null : _getFundDetails,
              child: const Text('Get Fund Details'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading || !_isAuthenticated ? null : _getTradingStatus,
              child: const Text('Get Trading Status'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPnLSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PnL Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading || !_isAuthenticated ? null : _getBacktestPnLSummary,
              child: const Text('Get Backtest PnL Summary'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading || !_isAuthenticated ? null : _getForwardPnLSummary,
              child: const Text('Get Forward PnL Summary'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading || !_isAuthenticated ? null : _getPnLDetailed,
              child: const Text('Get PnL Detailed Data'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading || !_isAuthenticated ? null : _calculatePnL,
              child: const Text('Calculate PnL'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildResponseSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Response',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              width: double.infinity,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Text(_responseText),
            ),
          ],
        ),
      ),
    );
  }
  
  // API call methods
  
  Future<void> _requestOtp() async {
    setState(() {
      _isLoading = true;
      _responseText = 'Requesting OTP...';
    });
    
    try {
      final response = await _apiClient.requestOtp(_phoneController.text);
      
      setState(() {
        _responseText = 'Response: ${_formatResponse(response)}';
        if (response['success'] == true && response['data'] != null) {
          _hash = response['data']['hash'];
        }
      });
    } catch (e) {
      setState(() {
        _responseText = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
      _responseText = 'Verifying OTP...';
    });
    
    try {
      final response = await _apiClient.verifyOtp(_otpController.text, _hash!);
      
      setState(() {
        _responseText = 'Response: ${_formatResponse(response)}';
        if (response['success'] == true) {
          _isAuthenticated = true;
        }
      });
    } catch (e) {
      setState(() {
        _responseText = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _getUserProfile() async {
    setState(() {
      _isLoading = true;
      _responseText = 'Getting user profile...';
    });
    
    try {
      final response = await _apiClient.getUserProfile();
      
      setState(() {
        _responseText = 'Response: ${_formatResponse(response)}';
      });
    } catch (e) {
      setState(() {
        _responseText = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _allocateCapital() async {
    setState(() {
      _isLoading = true;
      _responseText = 'Allocating capital...';
    });
    
    try {
      final capital = double.tryParse(_capitalController.text) ?? 400000.0;
      final response = await _apiClient.allocateCapital(capital);
      
      setState(() {
        _responseText = 'Response: ${_formatResponse(response)}';
      });
    } catch (e) {
      setState(() {
        _responseText = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _startForwardTest() async {
    setState(() {
      _isLoading = true;
      _responseText = 'Starting forward test...';
    });
    
    try {
      final response = await _apiClient.startForwardTest();
      
      setState(() {
        _responseText = 'Response: ${_formatResponse(response)}';
      });
    } catch (e) {
      setState(() {
        _responseText = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _getFundDetails() async {
    setState(() {
      _isLoading = true;
      _responseText = 'Getting fund details...';
    });
    
    try {
      final response = await _apiClient.getFundDetails();
      
      setState(() {
        _responseText = 'Response: ${_formatResponse(response)}';
      });
    } catch (e) {
      setState(() {
        _responseText = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _getTradingStatus() async {
    setState(() {
      _isLoading = true;
      _responseText = 'Getting trading status...';
    });
    
    try {
      final response = await _apiClient.getTradingStatus();
      
      setState(() {
        _responseText = 'Response: ${_formatResponse(response)}';
      });
    } catch (e) {
      setState(() {
        _responseText = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _getBacktestPnLSummary() async {
    setState(() {
      _isLoading = true;
      _responseText = 'Getting backtest PnL summary...';
    });
    
    try {
      final response = await _apiClient.getPnLSummary(
        userType: 'backtest',
        fromDate: DateTime(2023, 1, 1),
        toDate: DateTime(2023, 12, 31),
      );
      
      setState(() {
        _responseText = 'Response: ${_formatResponse(response)}';
      });
    } catch (e) {
      setState(() {
        _responseText = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _getForwardPnLSummary() async {
    setState(() {
      _isLoading = true;
      _responseText = 'Getting forward PnL summary...';
    });
    
    try {
      final response = await _apiClient.getPnLSummary(
        userType: 'forward',
      );
      
      setState(() {
        _responseText = 'Response: ${_formatResponse(response)}';
      });
    } catch (e) {
      setState(() {
        _responseText = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _getPnLDetailed() async {
    setState(() {
      _isLoading = true;
      _responseText = 'Getting detailed PnL data...';
    });
    
    try {
      final response = await _apiClient.getPnLDetailed(period: '1M');
      
      setState(() {
        _responseText = 'Response: ${_formatResponse(response)}';
      });
    } catch (e) {
      setState(() {
        _responseText = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _calculatePnL() async {
    setState(() {
      _isLoading = true;
      _responseText = 'Calculating PnL...';
    });
    
    try {
      final response = await _apiClient.calculatePnL(
        fromDate: DateTime(2023, 1, 1),
        toDate: DateTime(2023, 12, 31),
        bundleId: 'bundle_123',
      );
      
      setState(() {
        _responseText = 'Response: ${_formatResponse(response)}';
      });
    } catch (e) {
      setState(() {
        _responseText = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  // Helper method to format the response for display
  String _formatResponse(Map<String, dynamic> response) {
    // Limit the response to avoid overwhelming the UI
    final truncatedResponse = Map<String, dynamic>.from(response);
    
    // Truncate data points if they exist
    if (truncatedResponse['data'] is Map && 
        truncatedResponse['data'].containsKey('dataPoints') && 
        truncatedResponse['data']['dataPoints'] is List) {
      final dataPoints = truncatedResponse['data']['dataPoints'] as List;
      if (dataPoints.length > 3) {
        truncatedResponse['data']['dataPoints'] = [
          ...dataPoints.take(3),
          '... (${dataPoints.length - 3} more items)'
        ];
      }
    }
    
    return truncatedResponse.toString();
  }
}
