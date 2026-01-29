import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'screens/dashboard_screen.dart';
import 'screens/create_claim_screen.dart';
import 'screens/claim_detail_screen.dart';
import 'models/claim.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insurance Claims',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const ClaimManagementApp(),
    );
  }
}

class ClaimManagementApp extends StatefulWidget {
  const ClaimManagementApp({Key? key}) : super(key: key);

  @override
  State<ClaimManagementApp> createState() => _ClaimManagementAppState();
}

class _ClaimManagementAppState extends State<ClaimManagementApp> {
  List<Claim> _claims = [];
  String? _selectedClaimId;
  String _currentView = 'dashboard'; // 'dashboard', 'create', 'detail'

  @override
  void initState() {
    super.initState();
    _initializeSampleData();
  }

  void _initializeSampleData() {
    _claims = [
      Claim(
        id: 'CLM-L8PX9K2-A7F3D',
        patientName: 'Rajesh Kumar',
        hospitalName: 'Apollo Hospital',
        admissionDate: DateTime(2026, 1, 15),
        dischargeDate: DateTime(2026, 1, 20),
        status: ClaimStatus.submitted,
        bills: [
          Bill(
            id: '1',
            description: 'Room Charges',
            amount: 25000,
            date: DateTime(2026, 1, 20),
          ),
          Bill(
            id: '2',
            description: 'Surgery Costs',
            amount: 150000,
            date: DateTime(2026, 1, 18),
          ),
          Bill(
            id: '3',
            description: 'Medicines',
            amount: 12000,
            date: DateTime(2026, 1, 20),
          ),
        ],
        advances: 50000,
        settlements: 0,
        createdAt: DateTime(2026, 1, 15, 10, 0),
      ),
      Claim(
        id: 'CLM-L8PX9K2-B8G4E',
        patientName: 'Priya Sharma',
        hospitalName: 'Fortis Hospital',
        admissionDate: DateTime(2026, 1, 10),
        dischargeDate: DateTime(2026, 1, 25),
        status: ClaimStatus.approved,
        bills: [
          Bill(
            id: '4',
            description: 'ICU Charges',
            amount: 80000,
            date: DateTime(2026, 1, 25),
          ),
          Bill(
            id: '5',
            description: 'Diagnostic Tests',
            amount: 15000,
            date: DateTime(2026, 1, 12),
          ),
        ],
        advances: 30000,
        settlements: 65000,
        createdAt: DateTime(2026, 1, 10, 9, 30),
      ),
      Claim(
        id: 'CLM-L8PX9K2-C9H5F',
        patientName: 'Amit Patel',
        hospitalName: 'Max Healthcare',
        admissionDate: DateTime(2026, 1, 20),
        dischargeDate: DateTime(2026, 1, 23),
        status: ClaimStatus.draft,
        bills: [
          Bill(
            id: '6',
            description: 'Consultation Fee',
            amount: 5000,
            date: DateTime(2026, 1, 20),
          ),
        ],
        advances: 0,
        settlements: 0,
        createdAt: DateTime(2026, 1, 20, 14, 0),
      ),
    ];
  }

  void _handleCreateClaim(Claim newClaim) {
    setState(() {
      _claims.add(newClaim);
      _currentView = 'dashboard';
    });
  }

  void _handleUpdateClaim(Claim updatedClaim) {
    setState(() {
      final index = _claims.indexWhere((c) => c.id == updatedClaim.id);
      if (index != -1) {
        _claims[index] = updatedClaim;
      }
    });
  }

  void _handleViewClaim(String claimId) {
    setState(() {
      _selectedClaimId = claimId;
      _currentView = 'detail';
    });
  }

  void _navigateToDashboard() {
    setState(() {
      _currentView = 'dashboard';
      _selectedClaimId = null;
    });
  }

  void _navigateToCreate() {
    setState(() {
      _currentView = 'create';
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildCurrentScreen();
  }

  Widget _buildCurrentScreen() {
    switch (_currentView) {
      case 'create':
        return CreateClaimScreen(
          onSave: _handleCreateClaim,
          onCancel: _navigateToDashboard,
        );
      case 'detail':
        if (_selectedClaimId != null) {
          final claim = _claims.firstWhere((c) => c.id == _selectedClaimId);
          return ClaimDetailScreen(
            claim: claim,
            onUpdate: _handleUpdateClaim,
          );
        }
        return DashboardScreen(
          claims: _claims,
          onCreateClaim: _navigateToCreate,
          onViewClaim: _handleViewClaim,
        );
      default:
        return DashboardScreen(
          claims: _claims,
          onCreateClaim: _navigateToCreate,
          onViewClaim: _handleViewClaim,
        );
    }
  }
}
