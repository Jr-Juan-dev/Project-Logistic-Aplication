import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  static const String name = 'HistoryScreen';

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // --- ESTADO Y DATOS DE EJEMPLO ---
  
  // En una app real, estos serían streams o futures de tu backend.
  final List<Map<String, dynamic>> _allEvents = [
    {'type': 'Entrega', 'id': '#XYZ-789', 'details': 'Destino: Oficina Gerencia', 'date': '2023-10-14 14:32:00'},
    {'type': 'Escaneo', 'id': '#ABC-123', 'details': 'Estado: En tránsito', 'date': '2023-10-14 11:15:00'},
    {'type': 'Incidencia', 'id': '#LMN-456', 'details': 'Paquete dañado', 'date': '2023-10-14 09:45:00'},
    {'type': 'Entrega', 'id': '#PQR-456', 'details': 'Destino: Recepción', 'date': '2023-10-13 17:01:00'},
    {'type': 'Escaneo', 'id': '#DEF-789', 'details': 'Estado: Recolectado', 'date': '2023-10-13 10:20:00'},
    {'type': 'Escaneo', 'id': '#GHI-123', 'details': 'Estado: En bodega', 'date': '2023-10-12 15:00:00'},
  ];
  
  List<Map<String, dynamic>> _filteredEvents = [];
  String _selectedDateFilter = 'Hoy';
  String? _selectedTypeFilter = 'Todos';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Al iniciar, aplicamos los filtros por defecto.
    _applyFilters();
    _searchController.addListener(() {
      _applyFilters();
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    // Lógica de filtrado (puedes adaptarla a tus necesidades).
    // En una app real, las queries se harían al backend.
    List<Map<String, dynamic>> events = List.from(_allEvents);

    // Filtrar por fecha
    final now = DateTime.now();
    if (_selectedDateFilter == 'Hoy') {
      events = events.where((e) => DateTime.parse(e['date']).day == now.day).toList();
    } else if (_selectedDateFilter == 'Ayer') {
      events = events.where((e) => DateTime.parse(e['date']).day == now.day - 1).toList();
    }

    // Filtrar por tipo
    if (_selectedTypeFilter != 'Todos') {
      events = events.where((e) => e['type'] == _selectedTypeFilter).toList();
    }
    
    // Filtrar por búsqueda
    if (_searchController.text.isNotEmpty) {
      events = events.where((e) => e['id'].toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    }

    setState(() {
      _filteredEvents = events;
    });
  }

  Map<String, List<Map<String, dynamic>>> _groupEventsByDate() {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var event in _filteredEvents) {
      final date = DateTime.parse(event['date']);
      final dayKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'; // Formato YYYY-MM-DD
      if (grouped[dayKey] == null) {
        grouped[dayKey] = [];
      }
      grouped[dayKey]!.add(event);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedEvents = _groupEventsByDate();
    final dateKeys = groupedEvents.keys.toList();

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50,),
          // --- Barra de Filtros ---
          _buildFilterBar(),
          // --- Lista de Eventos ---
          Expanded(
            child: _filteredEvents.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: dateKeys.length,
                    itemBuilder: (context, index) {
                      final dateKey = dateKeys[index];
                      final eventsOnDate = groupedEvents[dateKey]!;
                      return StickyHeader(
                        header: _buildDateHeader(dateKey),
                        content: Column(
                          children: eventsOnDate.map((event) => _EventListItem(event: event)).toList(),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS DE LA UI ---

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Campo de búsqueda
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar por ID de paquete...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: EdgeInsets.zero
            ),
          ),
          const SizedBox(height: 12),
          // Filtros
          Row(
            children: [
              // Filtro de Fecha
              Wrap(
                spacing: 8.0,
                children: ['Hoy', 'Ayer', 'Semana'].map((label) {
                  return ChoiceChip(
                    label: Text(label),
                    selected: _selectedDateFilter == label,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedDateFilter = label;
                          _applyFilters();
                        });
                      }
                    },
                  );
                }).toList(),
              ),
              const Spacer(),
              // Filtro de Tipo
              DropdownButton<String>(
                value: _selectedTypeFilter,
                underline: const SizedBox(),
                items: ['Todos', 'Escaneo', 'Entrega', 'Incidencia'].map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedTypeFilter = newValue;
                    _applyFilters();
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
  
  Widget _buildDateHeader(String dateKey) {
    // Lógica para mostrar 'Hoy', 'Ayer' o la fecha.
    final now = DateTime.now();
    final date = DateTime.parse(dateKey);
    String displayDate;
    if (date.day == now.day) {
      displayDate = 'Hoy';
    } else if (date.day == now.day - 1) {
      displayDate = 'Ayer';
    } else {
      displayDate = dateKey; // Puedes formatear esto mejor si quieres.
    }
    
    return Container(
      height: 40.0,
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.centerLeft,
      child: Text(
        displayDate,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'No se encontraron eventos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Prueba a cambiar los filtros o el término de búsqueda.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

// Widget para un ítem individual en la lista de historial.
class _EventListItem extends StatelessWidget {
  final Map<String, dynamic> event;

  const _EventListItem({required this.event});

  IconData _getIconForType(String type) {
    switch (type) {
      case 'Escaneo': return Icons.qr_code_scanner;
      case 'Entrega': return Icons.check_circle_outline;
      case 'Incidencia': return Icons.warning_amber_rounded;
      default: return Icons.help_outline;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'Escaneo': return Colors.blue;
      case 'Entrega': return Colors.green;
      case 'Incidencia': return Colors.orange;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(event['date']);
    final time = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey[200]!)
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getColorForType(event['type']).withOpacity(0.1),
          child: Icon(_getIconForType(event['type']), color: _getColorForType(event['type'])),
        ),
        title: Text('${event['type']}: ${event['id']}', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(event['details']),
        trailing: Text(time, style: const TextStyle(color: Colors.grey)),
        onTap: () {
          // TODO: Navegar al detalle completo del evento si es necesario.
        },
      ),
    );
  }
}