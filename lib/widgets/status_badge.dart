import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(status);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: config['bg'],
        border: Border.all(color: config['border']!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config['icon'], size: 14, color: config['text']),
          const SizedBox(width: 6),
          Text(
            config['label']!,
            style: TextStyle(
              color: config['text'],
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getStatusConfig(String status) {
    switch (status) {
      case 'Draft':
        return {
          'bg': Colors.grey[100],
          'text': Colors.grey[700],
          'border': Colors.grey[300],
          'icon': Icons.description,
          'label': 'Draft',
        };
      case 'Submitted':
        return {
          'bg': Colors.blue[50],
          'text': Colors.blue[700],
          'border': Colors.blue[200],
          'icon': Icons.access_time,
          'label': 'Submitted',
        };
      case 'Approved':
        return {
          'bg': Colors.green[50],
          'text': Colors.green[700],
          'border': Colors.green[200],
          'icon': Icons.check_circle,
          'label': 'Approved',
        };
      case 'Rejected':
        return {
          'bg': Colors.red[50],
          'text': Colors.red[700],
          'border': Colors.red[200],
          'icon': Icons.cancel,
          'label': 'Rejected',
        };
      case 'Partially Settled':
        return {
          'bg': Colors.amber[50],
          'text': Colors.amber[700],
          'border': Colors.amber[200],
          'icon': Icons.warning,
          'label': 'Partial',
        };
      default:
        return {
          'bg': Colors.grey[100],
          'text': Colors.grey[700],
          'border': Colors.grey[300],
          'icon': Icons.help,
          'label': status,
        };
    }
  }
}
