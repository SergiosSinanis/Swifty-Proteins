import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

// it represents 1 row in the ligand list = 1 protein = better to keep this as its own widget so the list screen file does not grow huge
// The row is its own Material (a see-through rounded card) : a ListTile draws its tap ripple on the nearest Material,
// and this one clips the ripple to the row's rounded shape and scrolls with the row

class LigandTile extends StatelessWidget {
  final String code;
  final VoidCallback onTap;

  const LigandTile({super.key, required this.code, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4), // the gap between 2 rows
      child: Material(
        color: AppColors.glassFill,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: Icon(Icons.hub_outlined, color: Theme.of(context).colorScheme.primary), // a small molecule-like icon in teal
          title: Text(code, style: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 1.2)),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: onTap,
        ),
      ),
    );
  }
}
