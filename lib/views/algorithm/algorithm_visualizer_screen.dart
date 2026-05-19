import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coderecall/constants/app_colors.dart';
import 'package:coderecall/constants/app_text_styles.dart';
import 'package:coderecall/controllers/algorithm_controller.dart';

/// Simple tree node for DFS/BFS visualization.
class _TreeNode {
  final int value;
  _TreeNode? left;
  _TreeNode? right;
  _TreeNode(this.value);
}

/// Screen with step-by-step animated algorithm visualization.
class AlgorithmVisualizerScreen extends StatefulWidget {
  const AlgorithmVisualizerScreen({super.key});

  @override
  State<AlgorithmVisualizerScreen> createState() =>
      _AlgorithmVisualizerScreenState();
}

class _AlgorithmVisualizerScreenState
    extends State<AlgorithmVisualizerScreen>
    with TickerProviderStateMixin {
  String _algorithm = '';
  late AnimationController _animController;
  int _currentStep = 0;
  List<double> _array = [];
  List<int> _highlighted = [];
  String _stepExplanation = 'Press Start to begin';
  int _searchTarget = 0;
  List<String> _stackItems = [];
  List<String> _queueItems = [];
  final Random _random = Random();
  bool _isAnimating = false;

  // Auto-play
  Timer? _autoTimer;
  bool _isPlaying = false;

  // Sorting algorithm state
  int _sortI = 0;
  int _sortJ = 0;
  int _sortMinIdx = 0;

  // Tree for DFS/BFS
  _TreeNode? _treeRoot;
  List<_TreeNode> _treeTraversalOrder = [];
  int _treeTraversalIndex = 0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Read route arguments after the first frame
    // (ModalRoute is fully available by this point)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      final algo = (args?['algorithm'] as String?) ?? '';
      if (algo.isNotEmpty && _algorithm.isEmpty) {
        _algorithm = algo;
        _initData(algo);
      }
    });
  }

  void _initData(String algo) {
    _stopAutoPlay();
    setState(() {
      _currentStep = 0;
      _highlighted = [];
      _isAnimating = false;
      _isPlaying = false;
      _sortI = 0;
      _sortJ = 0;
      _sortMinIdx = 0;
      _treeRoot = null;
      _treeTraversalOrder = [];
      _treeTraversalIndex = 0;
      switch (algo) {
        case 'bubble_sort':
        case 'linear_search':
        case 'binary_search':
        case 'insertion_sort':
        case 'selection_sort':
          _array = List.generate(8, (_) => _random.nextInt(50) + 5)
              .map((e) => e.toDouble())
              .toList();
          _searchTarget = _array.isNotEmpty
              ? _array[_random.nextInt(_array.length)].toInt()
              : 25;
          break;
        case 'merge_sort':
          _array = List.generate(8, (_) => _random.nextInt(50) + 5)
              .map((e) => e.toDouble())
              .toList();
          break;
        case 'stack':
          _stackItems = [];
          break;
        case 'queue':
          _queueItems = [];
          break;
        case 'dfs':
        case 'bfs':
          _treeRoot = _buildRandomTree(4);
          _treeTraversalOrder = (algo == 'dfs')
              ? _dfsOrder(_treeRoot!)
              : _bfsOrder(_treeRoot!);
          break;
      }
      _stepExplanation = (_algorithm == 'dfs' || _algorithm == 'bfs')
          ? 'Ready. Press Next Step to traverse.'
          : 'Ready. Press Start or Next Step.';
    });
  }

  _TreeNode _buildRandomTree(int depth) {
    if (depth <= 0) return _TreeNode(_random.nextInt(90) + 10);
    final node = _TreeNode(_random.nextInt(90) + 10);
    if (depth > 1) {
      node.left = _buildRandomTree(depth - 1);
      if (_random.nextBool()) {
        node.right = _buildRandomTree(depth - 1);
      }
    }
    return node;
  }

  List<_TreeNode> _dfsOrder(_TreeNode node) {
    final result = <_TreeNode>[];
    void dfs(_TreeNode? n) {
      if (n == null) return;
      result.add(n);
      dfs(n.left);
      dfs(n.right);
    }
    dfs(node);
    return result;
  }

  List<_TreeNode> _bfsOrder(_TreeNode root) {
    final result = <_TreeNode>[];
    final queue = <_TreeNode?>[root];
    while (queue.isNotEmpty) {
      final node = queue.removeAt(0);
      if (node == null) continue;
      result.add(node);
      queue.add(node.left);
      queue.add(node.right);
    }
    return result;
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _stopAutoPlay();
    if (!mounted) return;
    setState(() => _isPlaying = true);
    final interval = Duration(
      milliseconds:
          (1500 / (context.read<AlgorithmController>().speed))
              .round()
              .clamp(200, 3000),
    );
    _autoTimer = Timer.periodic(interval, (_) {
      if (!mounted) {
        _stopAutoPlay();
        return;
      }
      final prevStep = _currentStep;
      _nextStep();
      // If algorithm completed (reset to 0), stop auto-play
      if (_currentStep == 0 && prevStep > 0) {
        _stopAutoPlay();
      }
    });
  }

  void _stopAutoPlay() {
    _autoTimer?.cancel();
    _autoTimer = null;
    if (mounted) {
      setState(() => _isPlaying = false);
    }
  }

  void _togglePlay() {
    if (_isPlaying) {
      _stopAutoPlay();
    } else {
      _startAutoPlay();
    }
  }

  void _nextStep() {
    if (_isAnimating) return;

    setState(() => _currentStep++);
    _highlighted = [];

    switch (_algorithm) {
      case 'bubble_sort':
        _bubbleSortStep();
        break;
      case 'linear_search':
        _linearSearchStep();
        break;
      case 'binary_search':
        _binarySearchStep();
        break;
      case 'insertion_sort':
        _insertionSortStep();
        break;
      case 'selection_sort':
        _selectionSortStep();
        break;
      case 'merge_sort':
        _mergeSortStep();
        break;
      case 'stack':
        _stackStep();
        break;
      case 'queue':
        _queueStep();
        break;
      case 'dfs':
      case 'bfs':
        _treeTraversalStep();
        break;
    }

    _isAnimating = true;
    _animController.forward(from: 0).then((_) => _isAnimating = false);
  }

  void _reset() {
    _stopAutoPlay();
    context.read<AlgorithmController>().reset();
    _initData(_algorithm);
  }

  // ─── Algorithm Step Methods ─────────────────────────────────

  void _bubbleSortStep() {
    if (_array.length < 2) {
      _stepExplanation = 'Not enough elements to sort. Please reset.';
      setState(() => _currentStep = 0);
      return;
    }
    final n = _array.length;
    final pass = _currentStep ~/ (n - 1);
    final comparison = _currentStep % (n - 1);

    if (pass >= n - 1 || _currentStep >= n * (n - 1)) {
      _stepExplanation = 'Array is sorted!';
      setState(() => _currentStep = 0);
      return;
    }

    final i = comparison;
    if (_array[i] > _array[i + 1]) {
      final temp = _array[i];
      _array[i] = _array[i + 1];
      _array[i + 1] = temp;
      _stepExplanation =
          'Swapped arr[$i] and arr[${i + 1}]';
    } else {
      _stepExplanation =
          'arr[$i] (${_array[i].toInt()}) <= arr[${i + 1}] (${_array[i + 1].toInt()}) — no swap';
    }
    _highlighted = [i, i + 1];
  }

  void _linearSearchStep() {
    if (_array.isEmpty) {
      _stepExplanation = 'Array is empty. Please reset.';
      setState(() => _currentStep = 0);
      return;
    }
    final idx = _currentStep - 1;
    if (idx >= _array.length) {
      _stepExplanation = 'Element $_searchTarget not found in array';
      setState(() => _currentStep = 0);
      return;
    }
    if (_array[idx].toInt() == _searchTarget) {
      _stepExplanation = 'Found $_searchTarget at index $idx!';
    } else {
      _stepExplanation =
          'Checking index $idx: ${_array[idx].toInt()} != $_searchTarget';
    }
    _highlighted = [idx];
  }

  void _binarySearchStep() {
    if (_array.isEmpty) {
      _stepExplanation = 'Array is empty. Please reset.';
      setState(() => _currentStep = 0);
      return;
    }
    final sorted = List<double>.from(_array)..sort();
    _array = sorted;

    final n = _array.length;
    final stepsNeeded = (log(n) / log(2)).ceil() + 1;
    if (_currentStep > stepsNeeded) {
      _stepExplanation = 'Element $_searchTarget not found';
      setState(() => _currentStep = 0);
      return;
    }

    int low = 0, high = n - 1;
    int step = _currentStep - 1;
    while (low <= high && step > 0) {
      final mid = low + (high - low) ~/ 2;
      step--;
      if (step == 0) {
        _highlighted = [mid];
        if (_array[mid].toInt() == _searchTarget) {
          _stepExplanation = 'Found $_searchTarget at index $mid!';
        } else if (_array[mid].toInt() > _searchTarget) {
          high = mid - 1;
          _stepExplanation =
              'Search left half (low=$low, high=$high) — ${_array[mid].toInt()} > $_searchTarget';
        } else {
          low = mid + 1;
          _stepExplanation =
              'Search right half (low=$low, high=$high) — ${_array[mid].toInt()} < $_searchTarget';
        }
        return;
      } else {
        if (_array[mid].toInt() == _searchTarget) {
          break;
        }
        if (_array[mid].toInt() > _searchTarget) {
          high = mid - 1;
        } else {
          low = mid + 1;
        }
      }
    }
    if (step <= 0) {
      _stepExplanation = 'Checking midpoint...';
    }
  }

  void _insertionSortStep() {
    final n = _array.length;
    if (n < 2) {
      _stepExplanation = 'Array already sorted.';
      setState(() => _currentStep = 0);
      return;
    }

    if (_sortI == 0) _sortI = 1;

    if (_sortI >= n) {
      _stepExplanation = 'Array sorted!';
      setState(() => _currentStep = 0);
      return;
    }

    if (_sortJ == 0) _sortJ = _sortI;

    if (_sortJ > 0 && _array[_sortJ - 1] > _array[_sortJ]) {
      final temp = _array[_sortJ];
      _array[_sortJ] = _array[_sortJ - 1];
      _array[_sortJ - 1] = temp;
      _sortJ--;
      _highlighted = [_sortJ, _sortJ + 1];
      _stepExplanation =
          'Moved ${_array[_sortJ].toInt()} left (inserting into sorted portion)';
    } else {
      _sortI++;
      _sortJ = 0;
      if (_sortI >= n) {
        _stepExplanation = 'Array sorted!';
        setState(() {
          _currentStep = 0;
          _sortI = 0;
        });
      } else {
        _stepExplanation =
            'Inserted element. Moving to index $_sortI';
        _highlighted = [_sortI];
      }
    }
  }

  void _selectionSortStep() {
    final n = _array.length;
    if (n < 2) {
      _stepExplanation = 'Array already sorted.';
      setState(() => _currentStep = 0);
      return;
    }

    if (_sortI >= n - 1) {
      _stepExplanation = 'Array sorted!';
      setState(() {
        _currentStep = 0;
        _sortI = 0;
        _sortJ = 0;
      });
      return;
    }

    if (_sortJ <= _sortI) {
      _sortMinIdx = _sortI;
      _sortJ = _sortI + 1;
    }

    if (_sortJ < n) {
      if (_array[_sortJ] < _array[_sortMinIdx]) {
        _sortMinIdx = _sortJ;
      }
      _highlighted = [_sortJ, _sortMinIdx];
      _stepExplanation =
          'Checking index $_sortJ, current min at $_sortMinIdx (${_array[_sortMinIdx].toInt()})';
      _sortJ++;
    } else {
      if (_sortMinIdx != _sortI) {
        final temp = _array[_sortI];
        _array[_sortI] = _array[_sortMinIdx];
        _array[_sortMinIdx] = temp;
        _stepExplanation =
            'Swapped minimum ${_array[_sortI].toInt()} to position $_sortI';
      } else {
        _stepExplanation =
            'Element at $_sortI is already the minimum';
      }
      _highlighted = [_sortI, _sortMinIdx];
      _sortI++;
      _sortJ = _sortI;
    }
  }

  void _mergeSortStep() {
    final n = _array.length;
    if (n < 2) {
      _stepExplanation = 'Array already sorted.';
      setState(() => _currentStep = 0);
      return;
    }

    // _sortI = current subarray size being merged (1, 2, 4, 8...)
    // _sortJ = start index of current merge
    if (_sortI == 0) {
      _sortI = 1;
      _sortJ = 0;
    }

    if (_sortI >= n) {
      _stepExplanation = 'Array sorted!';
      setState(() {
        _currentStep = 0;
        _sortI = 0;
        _sortJ = 0;
      });
      return;
    }

    // If we've merged all subarrays of this size, double the size
    if (_sortJ >= n) {
      _sortI *= 2;
      _sortJ = 0;
      if (_sortI >= n) {
        _stepExplanation = 'Array sorted!';
        setState(() {
          _currentStep = 0;
          _sortI = 0;
          _sortJ = 0;
        });
        return;
      }
    }

    // Merge subarrays of size _sortI starting at _sortJ
    final mid = min(_sortJ + _sortI, n);
    final end = min(_sortJ + _sortI * 2, n);

    int i = _sortJ, j = mid, k = _sortJ;
    final temp = List<double>.from(_array);
    while (i < mid && j < end) {
      if (temp[i] <= temp[j]) {
        _array[k++] = temp[i++];
      } else {
        _array[k++] = temp[j++];
      }
    }
    while (i < mid) {
      _array[k++] = temp[i++];
    }
    while (j < end) {
      _array[k++] = temp[j++];
    }

    _highlighted = List.generate(end - _sortJ, (idx) => _sortJ + idx);
    _stepExplanation =
        'Merged subarrays into [${_array.sublist(_sortJ, end).map((e) => e.toInt()).join(', ')}]';

    _sortJ += _sortI * 2;
  }

  void _stackStep() {
    final actions = ['push', 'push', 'pop', 'push', 'pop', 'pop', 'push'];
    if (_currentStep > actions.length) {
      _stepExplanation = 'Stack is empty. Demo complete!';
      setState(() => _currentStep = 0);
      return;
    }
    final action = actions[(_currentStep - 1) % actions.length];
    if (action == 'push') {
      final items = ['10', '20', '30', '40', '50'];
      final item = items[_stackItems.length % items.length];
      _stackItems.add(item);
      _stepExplanation = 'Pushed $item onto stack';
    } else {
      if (_stackItems.isNotEmpty) {
        final item = _stackItems.removeLast();
        _stepExplanation = 'Popped $item from stack';
      } else {
        _stepExplanation = 'Stack is empty — cannot pop';
      }
    }
  }

  void _queueStep() {
    final actions = [
      'enqueue',
      'enqueue',
      'dequeue',
      'enqueue',
      'dequeue',
      'enqueue',
      'dequeue'
    ];
    if (_currentStep > actions.length) {
      _stepExplanation = 'Queue demo complete!';
      setState(() => _currentStep = 0);
      return;
    }
    final action = actions[(_currentStep - 1) % actions.length];
    if (action == 'enqueue') {
      final items = ['5', '15', '25', '35', '45'];
      final item = items[_queueItems.length % items.length];
      _queueItems.add(item);
      _stepExplanation = 'Enqueued $item to the back of queue';
    } else {
      if (_queueItems.isNotEmpty) {
        final item = _queueItems.removeAt(0);
        _stepExplanation = 'Dequeued $item from the front of queue';
      } else {
        _stepExplanation = 'Queue is empty — cannot dequeue';
      }
    }
  }

  void _treeTraversalStep() {
    if (_treeTraversalOrder.isEmpty) {
      _stepExplanation = 'No nodes to traverse. Please reset.';
      setState(() => _currentStep = 0);
      return;
    }

    final idx = _currentStep - 1;
    if (idx >= _treeTraversalOrder.length) {
      _stepExplanation = 'Traversal complete! Visited all ${_treeTraversalOrder.length} nodes.';
      setState(() => _currentStep = 0);
      return;
    }

    _treeTraversalIndex = idx;
    final node = _treeTraversalOrder[idx];
    _stepExplanation = 'Visited node with value ${node.value} (step ${idx + 1} of ${_treeTraversalOrder.length})';
  }

  // ─── Build ─────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final algoCtrl = context.watch<AlgorithmController>();

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: Text(
          _algorithm.isEmpty
              ? 'Algorithm Visualizer'
              : _algorithm
                  .replaceAll('_', ' ')
                  .split(' ')
                  .map((w) => w[0].toUpperCase() + w.substring(1))
                  .join(' ')),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          // Visualization + controls
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Visualization area
                  Container(
                    width: double.infinity,
                    height: 300,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.textMuted.withValues(alpha: 0.2)),
                    ),
                    child: _buildVisualization(),
                  ),
                  const SizedBox(height: 16),

                  // Step explanation
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: AppColors.textMuted.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      _stepExplanation,
                      style: AppTextStyles.bodyMuted.copyWith(fontSize: 14),
                    ),
                  ),

                  // Speed control
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text('Slow', style: AppTextStyles.caption),
                      Expanded(
                        child: Slider(
                          value: algoCtrl.speed,
                          min: 0.5,
                          max: 3.0,
                          divisions: 5,
                          activeColor: AppColors.accent,
                          inactiveColor:
                              AppColors.textMuted.withValues(alpha: 0.3),
                          onChanged: (val) {
                            algoCtrl.setSpeed(val);
                            // Restart timer if playing
                            if (_isPlaying) {
                              _startAutoPlay();
                            }
                          },
                        ),
                      ),
                      const Text('Fast', style: AppTextStyles.caption),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom controls
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                // Reset
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accent,
                      side: const BorderSide(color: AppColors.accent),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Play / Pause
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _togglePlay,
                    icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow),
                    label: Text(_isPlaying ? 'Pause' : 'Play'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isPlaying ? AppColors.xpGold : AppColors.correct,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Next Step
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _isPlaying ? null : _nextStep,
                    icon: const Icon(Icons.skip_next),
                    label: const Text('Next Step'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Visualization Widgets ─────────────────────────────────

  Widget _buildVisualization() {
    switch (_algorithm) {
      case 'bubble_sort':
      case 'insertion_sort':
      case 'selection_sort':
      case 'merge_sort':
        return _buildSortVisualization();
      case 'linear_search':
      case 'binary_search':
        return _buildSearchVisualization();
      case 'stack':
        return _buildStackVisualization();
      case 'queue':
        return _buildQueueVisualization();
      case 'dfs':
      case 'bfs':
        return _buildTreeVisualization();
      case '':
        return const Center(
            child: Text('Press Next Step to begin',
                style: AppTextStyles.bodyMuted));
      default:
        return const Center(
            child: Text('Select an algorithm',
                style: AppTextStyles.bodyMuted));
    }
  }

  Widget _buildSortVisualization() {
    if (_array.isEmpty) return const SizedBox.shrink();
    final maxVal = _array.reduce(max);
    final label = _algorithm == 'bubble_sort'
        ? 'Bubble Sort'
        : _algorithm == 'insertion_sort'
            ? 'Insertion Sort'
            : _algorithm == 'selection_sort'
                ? 'Selection Sort'
                : 'Merge Sort';

    // For selection sort, show sorted/unsorted boundaries
    final sortedCount = _algorithm == 'selection_sort'
        ? _sortI
        : _algorithm == 'insertion_sort'
            ? (_sortI > 0 ? _sortI : 0)
            : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 8),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _array.asMap().entries.map((entry) {
              final idx = entry.key;
              final val = entry.value;
              final isHighlighted = _highlighted.contains(idx);
              final isSorted = idx < sortedCount &&
                  _algorithm != 'bubble_sort' &&
                  _algorithm != 'merge_sort';

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: (val / maxVal) * 220,
                    decoration: BoxDecoration(
                      color: isHighlighted
                          ? AppColors.accent
                          : isSorted
                              ? AppColors.correct.withValues(alpha: 0.5)
                              : AppColors.accent.withValues(alpha: 0.4),
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4)),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        '${val.toInt()}',
                        style:
                            AppTextStyles.caption.copyWith(fontSize: 10),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchVisualization() {
    if (_array.isEmpty) return const SizedBox.shrink();
    final maxVal = _array.reduce(max);
    final isBinary = _algorithm == 'binary_search';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(isBinary ? 'Binary Search' : 'Linear Search',
                style: AppTextStyles.caption),
            Text('Target: $_searchTarget',
                style: AppTextStyles.caption.copyWith(
                    color: AppColors.xpGold,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _array.asMap().entries.map((entry) {
              final idx = entry.key;
              final val = entry.value;
              final isHighlighted = _highlighted.contains(idx);
              final isTarget = val.toInt() == _searchTarget;
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: (val / maxVal) * 220,
                    decoration: BoxDecoration(
                      color: isHighlighted && isTarget
                          ? AppColors.correct
                          : isHighlighted
                              ? AppColors.xpGold
                              : isTarget
                                  ? AppColors.correct.withValues(alpha: 0.3)
                                  : AppColors.accent.withValues(alpha: 0.4),
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4)),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        '${val.toInt()}',
                        style:
                            AppTextStyles.caption.copyWith(fontSize: 10),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStackVisualization() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Stack (LIFO)', style: AppTextStyles.caption),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                  color: AppColors.textMuted.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(4),
                  child: Text('Top',
                      style: TextStyle(
                          color: AppColors.textMuted, fontSize: 10)),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _stackItems.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 16),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.accent),
                        ),
                        child: Center(
                          child: Text(
                            _stackItems[
                                _stackItems.length - 1 - index],
                            style: AppTextStyles.body
                                .copyWith(fontSize: 14),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (_stackItems.isEmpty)
                  const Expanded(
                    child: Center(
                        child: Text('Stack is empty',
                            style: AppTextStyles.caption)),
                  ),
                const Padding(
                  padding: EdgeInsets.all(4),
                  child: Text('Bottom',
                      style: TextStyle(
                          color: AppColors.textMuted, fontSize: 10)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQueueVisualization() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Queue (FIFO)', style: AppTextStyles.caption),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                  color: AppColors.textMuted.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(4),
                  child: Text('Front (Dequeue)',
                      style: TextStyle(
                          color: AppColors.textMuted, fontSize: 10)),
                ),
                Expanded(
                  child: _queueItems.isEmpty
                      ? const Center(
                          child: Text('Queue is empty',
                              style: AppTextStyles.caption))
                      : ListView.builder(
                          itemCount: _queueItems.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 16),
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.accent
                                    .withValues(alpha: 0.2),
                                borderRadius:
                                    BorderRadius.circular(6),
                                border:
                                    Border.all(color: AppColors.accent),
                              ),
                              child: Center(
                                child: Text(
                                  _queueItems[index],
                                  style: AppTextStyles.body
                                      .copyWith(fontSize: 14),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const Padding(
                  padding: EdgeInsets.all(4),
                  child: Text('Back (Enqueue)',
                      style: TextStyle(
                          color: AppColors.textMuted, fontSize: 10)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTreeVisualization() {
    if (_treeRoot == null) return const SizedBox.shrink();

    final isDfs = _algorithm == 'dfs';
    final label = isDfs ? 'DFS (Depth-First)' : 'BFS (Breadth-First)';

    // Collect visited nodes up to current index
    final visited = <int>{};
    for (int i = 0; i <= _treeTraversalIndex && i < _treeTraversalOrder.length; i++) {
      visited.add(_treeTraversalOrder[i].hashCode);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.caption),
            Text(
              'Step ${min(_treeTraversalIndex + 1, _treeTraversalOrder.length)} / ${_treeTraversalOrder.length}',
              style: AppTextStyles.caption.copyWith(color: AppColors.xpGold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _buildTreeLayout(
            _treeRoot!,
            0,
            visited,
          ),
        ),
      ],
    );
  }

  Widget _buildTreeLayout(
      _TreeNode node, int depth, Set<int> visited) {
    final isCurrent = _treeTraversalIndex < _treeTraversalOrder.length &&
        _treeTraversalOrder[_treeTraversalIndex] == node;
    final wasVisited = visited.contains(node.hashCode);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Current node
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCurrent
                ? AppColors.accent
                : wasVisited
                    ? AppColors.correct.withValues(alpha: 0.7)
                    : AppColors.textMuted.withValues(alpha: 0.2),
            border: Border.all(
              color: isCurrent
                  ? AppColors.accent
                  : wasVisited
                      ? AppColors.correct
                      : AppColors.textMuted.withValues(alpha: 0.4),
              width: isCurrent ? 3 : 1.5,
            ),
          ),
          child: Center(
            child: Text(
              '${node.value}',
              style: AppTextStyles.caption.copyWith(
                fontSize: 12,
                color: isCurrent || wasVisited
                    ? AppColors.textPrimary
                    : AppColors.textMuted,
                fontWeight:
                    isCurrent ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Children
        if (node.left != null || node.right != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (node.left != null)
                Expanded(
                    child: _buildTreeLayout(
                        node.left!, depth + 1, visited)),
              if (node.right != null &&
                  node.left != null &&
                  depth < 4)
                const SizedBox(width: 12),
              if (node.right != null)
                Expanded(
                    child: _buildTreeLayout(
                        node.right!, depth + 1, visited)),
            ],
          ),
      ],
    );
  }
}
