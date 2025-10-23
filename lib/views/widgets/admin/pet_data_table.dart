import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atomepet/controllers/pet_controller.dart';
import 'package:atomepet/models/pet.dart';
import 'package:atomepet/routes/app_routes.dart';

class PetDataTable extends StatefulWidget {
  const PetDataTable({super.key});

  @override
  State<PetDataTable> createState() => _PetDataTableState();
}

class _PetDataTableState extends State<PetDataTable> {
  final PetController _petController = Get.find<PetController>();
  final TextEditingController _searchController = TextEditingController();
  
  String _searchQuery = '';
  String _statusFilter = 'all';
  String _sortColumn = 'id';
  bool _sortAscending = true;
  int _rowsPerPage = 10;
  int _currentPage = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Pet> _getFilteredPets() {
    var pets = _petController.pets.toList();

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      pets = pets.where((pet) {
        return (pet.name?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
               (pet.category?.name?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
               (pet.id?.toString().contains(_searchQuery) ?? false);
      }).toList();
    }

    // Apply status filter
    if (_statusFilter != 'all') {
      final statusEnum = PetStatus.values.firstWhere(
        (e) => e.name == _statusFilter,
        orElse: () => PetStatus.available,
      );
      pets = pets.where((pet) => pet.status == statusEnum).toList();
    }

    // Apply sorting
    pets.sort((a, b) {
      int comparison = 0;
      switch (_sortColumn) {
        case 'id':
          comparison = (a.id ?? 0).compareTo(b.id ?? 0);
          break;
        case 'name':
          comparison = (a.name ?? '').compareTo(b.name ?? '');
          break;
        case 'status':
          comparison = (a.status?.index ?? 0).compareTo(b.status?.index ?? 0);
          break;
        case 'category':
          comparison = (a.category?.name ?? '').compareTo(b.category?.name ?? '');
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });

    return pets;
  }

  List<Pet> _getPaginatedPets(List<Pet> pets) {
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (startIndex + _rowsPerPage).clamp(0, pets.length);
    return pets.sublist(startIndex, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobileScreen = MediaQuery.of(context).size.width < 600;

    return Card(
      elevation: 2,
      margin: isMobileScreen ? const EdgeInsets.all(8) : const EdgeInsets.all(24),
      child: Padding(
        padding: isMobileScreen ? const EdgeInsets.all(12) : const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header and Controls
            isMobileScreen
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pet Management',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () async {
                            await Get.toNamed(AppRoutes.petForm);
                            _petController.fetchPetsByStatus([
                              PetStatus.available,
                              PetStatus.pending,
                              PetStatus.sold,
                            ]);
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add New Pet'),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Text(
                        'Pet Management',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: () async {
                          await Get.toNamed(AppRoutes.petForm);
                          _petController.fetchPetsByStatus([
                            PetStatus.available,
                            PetStatus.pending,
                            PetStatus.sold,
                          ]);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add New Pet'),
                      ),
                    ],
                  ),
            const SizedBox(height: 16),

            // Search and Filters
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by name, category, or ID...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                        _currentPage = 0;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 12),
                isMobileScreen
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: DropdownMenu<String>(
                              label: const Text('Status'),
                              initialSelection: _statusFilter,
                              expandedInsets: EdgeInsets.zero,
                              dropdownMenuEntries: const [
                                DropdownMenuEntry(value: 'all', label: 'All Status'),
                                DropdownMenuEntry(value: 'available', label: 'Available'),
                                DropdownMenuEntry(value: 'pending', label: 'Pending'),
                                DropdownMenuEntry(value: 'sold', label: 'Sold'),
                              ],
                              onSelected: (value) {
                                setState(() {
                                  _statusFilter = value ?? 'all';
                                  _currentPage = 0;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: DropdownMenu<int>(
                              label: const Text('Rows per page'),
                              initialSelection: _rowsPerPage,
                              expandedInsets: EdgeInsets.zero,
                              dropdownMenuEntries: const [
                                DropdownMenuEntry(value: 5, label: '5'),
                                DropdownMenuEntry(value: 10, label: '10'),
                                DropdownMenuEntry(value: 25, label: '25'),
                                DropdownMenuEntry(value: 50, label: '50'),
                              ],
                              onSelected: (value) {
                                setState(() {
                                  _rowsPerPage = value ?? 10;
                                  _currentPage = 0;
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    : Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          DropdownMenu<String>(
                            label: const Text('Status'),
                            initialSelection: _statusFilter,
                            dropdownMenuEntries: const [
                              DropdownMenuEntry(value: 'all', label: 'All Status'),
                              DropdownMenuEntry(value: 'available', label: 'Available'),
                              DropdownMenuEntry(value: 'pending', label: 'Pending'),
                              DropdownMenuEntry(value: 'sold', label: 'Sold'),
                            ],
                            onSelected: (value) {
                              setState(() {
                                _statusFilter = value ?? 'all';
                                _currentPage = 0;
                              });
                            },
                          ),
                          DropdownMenu<int>(
                            label: const Text('Rows per page'),
                            initialSelection: _rowsPerPage,
                            dropdownMenuEntries: const [
                              DropdownMenuEntry(value: 5, label: '5'),
                              DropdownMenuEntry(value: 10, label: '10'),
                              DropdownMenuEntry(value: 25, label: '25'),
                              DropdownMenuEntry(value: 50, label: '50'),
                            ],
                            onSelected: (value) {
                              setState(() {
                                _rowsPerPage = value ?? 10;
                                _currentPage = 0;
                              });
                            },
                          ),
                        ],
                      ),
              ],
            ),
            const SizedBox(height: 24),

            // Data Table
            Obx(() {
              final filteredPets = _getFilteredPets();
              final paginatedPets = _getPaginatedPets(filteredPets);
              final totalPages = (filteredPets.length / _rowsPerPage).ceil();

              if (filteredPets.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.pets_outlined,
                          size: 64,
                          color: theme.colorScheme.onSurface.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No pets found',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchQuery.isNotEmpty || _statusFilter != 'all'
                              ? 'Try adjusting your filters'
                              : 'Add your first pet to get started',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  // Table
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: isMobileScreen
                            ? MediaQuery.of(context).size.width - 40
                            : MediaQuery.of(context).size.width - 96,
                      ),
                      child: DataTable(
                        columnSpacing: isMobileScreen ? 12 : 24,
                        horizontalMargin: isMobileScreen ? 8 : 24,
                        sortColumnIndex: ['id', 'name', 'status', 'category']
                            .indexOf(_sortColumn),
                        sortAscending: _sortAscending,
                        columns: [
                          DataColumn(
                            label: const Text('ID'),
                            onSort: (columnIndex, ascending) {
                              setState(() {
                                _sortColumn = 'id';
                                _sortAscending = ascending;
                              });
                            },
                          ),
                          if (!isMobileScreen)
                            const DataColumn(
                              label: Text('Image'),
                            ),
                          DataColumn(
                            label: const Text('Name'),
                            onSort: (columnIndex, ascending) {
                              setState(() {
                                _sortColumn = 'name';
                                _sortAscending = ascending;
                              });
                            },
                          ),
                          if (!isMobileScreen)
                            DataColumn(
                              label: const Text('Category'),
                              onSort: (columnIndex, ascending) {
                                setState(() {
                                  _sortColumn = 'category';
                                  _sortAscending = ascending;
                                });
                              },
                            ),
                          DataColumn(
                            label: const Text('Status'),
                            onSort: (columnIndex, ascending) {
                              setState(() {
                                _sortColumn = 'status';
                                _sortAscending = ascending;
                              });
                            },
                          ),
                          const DataColumn(
                            label: Text('Actions'),
                          ),
                        ],
                        rows: paginatedPets.map((pet) {
                          return DataRow(
                            cells: [
                              DataCell(Text(
                                pet.id?.toString() ?? 'N/A',
                                style: TextStyle(fontSize: isMobileScreen ? 12 : null),
                              )),
                              if (!isMobileScreen)
                                DataCell(
                                  (pet.photoUrls?.isNotEmpty ?? false)
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: Image.network(
                                            pet.photoUrls!.first,
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(Icons.pets, size: 24),
                                          ),
                                        )
                                      : const Icon(Icons.pets, size: 24),
                                ),
                              DataCell(Text(
                                pet.name ?? 'Unknown',
                                style: TextStyle(
                                  fontSize: isMobileScreen ? 12 : null,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                              if (!isMobileScreen)
                                DataCell(Text(pet.category?.name ?? 'N/A')),
                              DataCell(_buildStatusChip(theme, pet.status, isMobileScreen)),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!isMobileScreen)
                                      IconButton(
                                        icon: const Icon(Icons.visibility),
                                        iconSize: 20,
                                        onPressed: () {
                                          Get.toNamed(
                                            AppRoutes.petDetail
                                                .replaceAll(':id', pet.id.toString()),
                                          );
                                        },
                                        tooltip: 'View',
                                      ),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      iconSize: 20,
                                      onPressed: () async {
                                        await Get.toNamed(
                                          AppRoutes.petForm,
                                          arguments: pet,
                                        );
                                        _petController.fetchPetsByStatus([
                                          PetStatus.available,
                                          PetStatus.pending,
                                          PetStatus.sold,
                                        ]);
                                      },
                                      tooltip: 'Edit',
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: theme.colorScheme.error,
                                      ),
                                      iconSize: 20,
                                      onPressed: () => _showDeleteConfirmation(pet),
                                      tooltip: 'Delete',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Pagination Controls
                  isMobileScreen
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Page ${_currentPage + 1} of ${totalPages > 0 ? totalPages : 1}',
                              style: theme.textTheme.bodySmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Showing ${_currentPage * _rowsPerPage + 1}-${((_currentPage + 1) * _rowsPerPage).clamp(0, filteredPets.length)} of ${filteredPets.length}',
                              style: theme.textTheme.bodySmall,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.first_page),
                                  onPressed: _currentPage > 0
                                      ? () => setState(() => _currentPage = 0)
                                      : null,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.chevron_left),
                                  onPressed: _currentPage > 0
                                      ? () => setState(() => _currentPage--)
                                      : null,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.chevron_right),
                                  onPressed: _currentPage < totalPages - 1
                                      ? () => setState(() => _currentPage++)
                                      : null,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.last_page),
                                  onPressed: _currentPage < totalPages - 1
                                      ? () => setState(() => _currentPage = totalPages - 1)
                                      : null,
                                ),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Showing ${_currentPage * _rowsPerPage + 1}-${((_currentPage + 1) * _rowsPerPage).clamp(0, filteredPets.length)} of ${filteredPets.length} pets',
                              style: theme.textTheme.bodySmall,
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.first_page),
                                  onPressed: _currentPage > 0
                                      ? () => setState(() => _currentPage = 0)
                                      : null,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.chevron_left),
                                  onPressed: _currentPage > 0
                                      ? () => setState(() => _currentPage--)
                                      : null,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    'Page ${_currentPage + 1} of ${totalPages > 0 ? totalPages : 1}',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.chevron_right),
                                  onPressed: _currentPage < totalPages - 1
                                      ? () => setState(() => _currentPage++)
                                      : null,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.last_page),
                                  onPressed: _currentPage < totalPages - 1
                                      ? () => setState(() => _currentPage = totalPages - 1)
                                      : null,
                                ),
                              ],
                            ),
                          ],
                        ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme, PetStatus? status, [bool isMobile = false]) {
    Color color;
    IconData icon;

    switch (status) {
      case PetStatus.available:
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case PetStatus.pending:
        color = Colors.orange;
        icon = Icons.pending;
        break;
      case PetStatus.sold:
        color = Colors.blue;
        icon = Icons.sell;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
    }

    return Chip(
      avatar: isMobile ? null : Icon(icon, size: 16, color: color),
      label: Text(
        isMobile ? status?.name.substring(0, 3).toUpperCase() ?? 'N/A' : status?.name ?? 'Unknown',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: isMobile ? 10 : 12,
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
      visualDensity: VisualDensity.compact,
      padding: isMobile ? const EdgeInsets.symmetric(horizontal: 4) : null,
    );
  }

  Future<void> _showDeleteConfirmation(Pet pet) async {
    final theme = Theme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Pet'),
        content: Text(
          'Are you sure you want to delete "${pet.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && pet.id != null) {
      try {
        await _petController.deletePet(pet.id!);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${pet.name} deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete pet: $e'),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      }
    }
  }
}
