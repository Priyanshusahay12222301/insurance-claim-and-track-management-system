import 'package:intl/intl.dart';
import '../models/claim.dart';

ClaimSummary calculateClaimSummary(Claim claim) {
  final totalBills = claim.bills.fold<double>(
    0.0,
    (sum, bill) => sum + bill.amount,
  );
  final advances = claim.advances;
  final settlements = claim.settlements;
  final pendingAmount = totalBills - advances - settlements;

  return ClaimSummary(
    totalBills: totalBills,
    advances: advances,
    settlements: settlements,
    pendingAmount: pendingAmount,
  );
}

String formatCurrency(double amount) {
  final formatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );
  return formatter.format(amount);
}

String formatDate(DateTime date) {
  final formatter = DateFormat('dd MMM yyyy');
  return formatter.format(date);
}

String generateClaimId() {
  final timestamp = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
  final random = (DateTime.now().microsecondsSinceEpoch % 100000).toRadixString(36);
  return 'CLM-$timestamp-$random'.toUpperCase();
}
