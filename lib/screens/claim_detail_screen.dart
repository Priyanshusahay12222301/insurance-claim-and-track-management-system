import 'package:flutter/material.dart';
import '../models/claim.dart';
import '../utils/calculations.dart';
import '../widgets/status_badge.dart';
import '../widgets/confirm_dialog.dart';

class ClaimDetailScreen extends StatefulWidget {
  final Claim claim;
  final Function(Claim) onUpdate;

  const ClaimDetailScreen({
    Key? key,
    required this.claim,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<ClaimDetailScreen> createState() => _ClaimDetailScreenState();
}

class _ClaimDetailScreenState extends State<ClaimDetailScreen> {
  late Claim _claim;
  Bill? _editingBill;
  Bill? _newBill;
  final _billDescController = TextEditingController();
  final _billAmountController = TextEditingController();
  final _advancesController = TextEditingController();
  final _settlementsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _claim = widget.claim;
    _advancesController.text = _claim.advances.toString();
    _settlementsController.text = _claim.settlements.toString();
  }

  @override
  void dispose() {
    _billDescController.dispose();
    _billAmountController.dispose();
    _advancesController.dispose();
    _settlementsController.dispose();
    super.dispose();
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addBill() {
    setState(() {
      _newBill = Bill(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        description: '',
        amount: 0,
        date: DateTime.now(),
      );
      _billDescController.text = '';
      _billAmountController.text = '';
    });
  }

  void _saveNewBill() {
    if (_billDescController.text.isNotEmpty && 
        double.tryParse(_billAmountController.text) != null &&
        double.parse(_billAmountController.text) > 0) {
      final newBill = Bill(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        description: _billDescController.text,
        amount: double.parse(_billAmountController.text),
        date: DateTime.now(),
      );
      
      setState(() {
        _claim = _claim.copyWith(bills: [..._claim.bills, newBill]);
        _newBill = null;
      });
      widget.onUpdate(_claim);
      _showToast('Bill added successfully');
    }
  }

  void _deleteBill(String billId) {
    ConfirmDialog.show(
      context: context,
      title: 'Delete Bill?',
      message: 'Are you sure you want to delete this bill? This action cannot be undone.',
      isDanger: true,
      onConfirm: () {
        setState(() {
          _claim = _claim.copyWith(
            bills: _claim.bills.where((b) => b.id != billId).toList(),
          );
        });
        widget.onUpdate(_claim);
        _showToast('Bill deleted successfully');
      },
    );
  }

  void _updateAdvances() {
    final value = double.tryParse(_advancesController.text) ?? 0;
    setState(() {
      _claim = _claim.copyWith(advances: value);
    });
    widget.onUpdate(_claim);
    Navigator.pop(context);
    _showToast('Advances updated successfully');
  }

  void _updateSettlements() {
    final value = double.tryParse(_settlementsController.text) ?? 0;
    setState(() {
      _claim = _claim.copyWith(settlements: value);
    });
    widget.onUpdate(_claim);
    Navigator.pop(context);
    _showToast('Settlements updated successfully');
  }

  void _changeStatus(ClaimStatus newStatus) {
    setState(() {
      _claim = _claim.copyWith(status: newStatus);
    });
    widget.onUpdate(_claim);
    Navigator.pop(context);
    _showToast('Status updated to ${newStatus.displayName}');
  }

  @override
  Widget build(BuildContext context) {
    final summary = calculateClaimSummary(_claim);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Claim Details',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
          PopupMenuButton<ClaimStatus>(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onSelected: _changeStatus,
            itemBuilder: (context) => ClaimStatus.values.map((status) {
              return PopupMenuItem(
                value: status,
                child: Text(status.displayName),
              );
            }).toList(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[700]!, Colors.indigo[700]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _claim.patientName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _claim.id,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _claim.status.displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.local_hospital, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        _claim.hospitalName,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        '${formatDate(_claim.admissionDate)} - ${formatDate(_claim.dischargeDate)}',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Bills',
                    formatCurrency(summary.totalBills),
                    Icons.receipt,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Pending',
                    formatCurrency(summary.pendingAmount),
                    Icons.pending_actions,
                    summary.pendingAmount > 0 ? Colors.orange : Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildEditableSummaryCard(
                    'Advances',
                    formatCurrency(_claim.advances),
                    Icons.arrow_downward,
                    Colors.purple,
                    () => _showEditDialog('Advances', _advancesController, _updateAdvances),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildEditableSummaryCard(
                    'Settlements',
                    formatCurrency(_claim.settlements),
                    Icons.check_circle,
                    Colors.green,
                    () => _showEditDialog('Settlements', _settlementsController, _updateSettlements),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Bills Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bills',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _addBill,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Bill'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // New Bill Form
            if (_newBill != null)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _billDescController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _billAmountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        prefixText: '₹ ',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => setState(() => _newBill = null),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _saveNewBill,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // Bills List
            ..._claim.bills.map((bill) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.receipt, color: Colors.blue[700], size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bill.description,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatDate(bill.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatCurrency(bill.amount),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => _deleteBill(bill.id),
                      ),
                    ],
                  ),
                ],
              ),
            )).toList(),

            if (_claim.bills.isEmpty && _newBill == null)
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.receipt_long, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 12),
                      Text(
                        'No bills added yet',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableSummaryCard(
    String label,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Icon(Icons.edit, color: Colors.grey[400], size: 16),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(
    String title,
    TextEditingController controller,
    VoidCallback onSave,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Edit $title'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Amount',
            prefixText: '₹ ',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
