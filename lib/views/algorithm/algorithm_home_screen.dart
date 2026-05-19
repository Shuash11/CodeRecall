import 'package:flutter/material.dart';
import 'package:coderecall/constants/app_colors.dart';
import 'package:coderecall/constants/app_strings.dart';
import 'package:coderecall/constants/app_text_styles.dart';
import 'package:coderecall/routes/app_routes.dart';

/// Screen for selecting which algorithm to visualize.
class AlgorithmHomeScreen extends StatelessWidget {
  const AlgorithmHomeScreen({super.key});

  static const List<Map<String, dynamic>> algorithms = [
    {'name': 'Bubble Sort', 'icon': Icons.swap_vert, 'desc': 'Compare and swap adjacent elements', 'id': 'bubble_sort'},
    {'name': 'Insertion Sort', 'icon': Icons.playlist_add, 'desc': 'Insert elements into sorted portion', 'id': 'insertion_sort'},
    {'name': 'Selection Sort', 'icon': Icons.low_priority, 'desc': 'Select minimum and swap', 'id': 'selection_sort'},
    {'name': 'Merge Sort', 'icon': Icons.call_split, 'desc': 'Divide-and-conquer sorting', 'id': 'merge_sort'},
    {'name': 'Linear Search', 'icon': Icons.arrow_forward, 'desc': 'Sequentially check each element', 'id': 'linear_search'},
    {'name': 'Binary Search', 'icon': Icons.compare_arrows, 'desc': 'Divide and conquer search', 'id': 'binary_search'},
    {'name': 'Stack (Push/Pop)', 'icon': Icons.vertical_align_top, 'desc': 'LIFO data structure', 'id': 'stack'},
    {'name': 'Queue (Enqueue/Dequeue)', 'icon': Icons.vertical_align_bottom, 'desc': 'FIFO data structure', 'id': 'queue'},
    {'name': 'DFS (Pre-order)', 'icon': Icons.account_tree, 'desc': 'Depth-first tree traversal', 'id': 'dfs'},
    {'name': 'BFS (Level-order)', 'icon': Icons.horizontal_split, 'desc': 'Breadth-first tree traversal', 'id': 'bfs'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text(AppStrings.algorithmVisualizer),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: algorithms.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final algo = algorithms[index];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.algorithmVisualizer,
              arguments: {'algorithm': algo['id']},
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.textMuted.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(algo['icon'] as IconData, color: AppColors.accent, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(algo['name'] as String, style: AppTextStyles.subheading),
                        const SizedBox(height: 4),
                        Text(algo['desc'] as String, style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.textMuted),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
