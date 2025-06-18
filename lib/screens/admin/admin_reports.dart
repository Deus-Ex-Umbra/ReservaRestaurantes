import 'package:flutter/material.dart';

class AdminReportsScreen extends StatefulWidget {
  @override
  _AdminReportsScreenState createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Este mes';
  List<String> _activeFilters = ['confirmadas', 'pendientes'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Column(
          children: [
            const Text(
              'Panel de Administración',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              _getPageTitle(),
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.indigo[700],

        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'Resumen', icon: Icon(Icons.dashboard, size: 18)),
            Tab(text: 'Análisis', icon: Icon(Icons.analytics, size: 18)),
            Tab(text: 'Histórico', icon: Icon(Icons.history, size: 18)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Panel superior con filtros
          _buildTopFiltersPanel(),
          // Contenido principal con tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSummaryTab(),
                _buildAnalyticsTab(),
                _buildHistoryTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }

  String _getPageTitle() {
    switch (_tabController.index) {
      case 0:
        return 'Resumen general de reportes';
      case 1:
        return 'Análisis y métricas avanzadas';
      case 2:
        return 'Historial y exportación de reportes';
      default:
        return '';
    }
  }

  Widget _buildTopFiltersPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Selector de período mejorado
            Expanded(flex: 2, child: _buildPeriodSelector()),
            SizedBox(width: 12),
            // Botón de filtros
            _buildFilterButton(),
            SizedBox(width: 12),
            // Botón de actualizar
            _buildRefreshButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedPeriod,
          isExpanded: true,
          icon: Icon(Icons.calendar_today, size: 18),
          items:
              [
                'Hoy',
                'Ayer',
                'Esta semana',
                'Semana pasada',
                'Este mes',
                'Mes pasado',
                'Este año',
                'Personalizado',
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedPeriod = value!;
            });
            if (value == 'Personalizado') {
              _showCustomDatePicker();
            }
          },
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return Container(
      decoration: BoxDecoration(
        color: _activeFilters.isNotEmpty ? Colors.indigo[50] : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              _activeFilters.isNotEmpty
                  ? Colors.indigo[300]!
                  : Colors.grey[300]!,
        ),
      ),
      child: IconButton(
        icon: Stack(
          children: [
            Icon(
              Icons.filter_list,
              color:
                  _activeFilters.isNotEmpty
                      ? Colors.indigo[700]
                      : Colors.grey[600],
            ),
            if (_activeFilters.isNotEmpty)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(minWidth: 12, minHeight: 12),
                  child: Text(
                    '${_activeFilters.length}',
                    style: TextStyle(color: Colors.white, fontSize: 8),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        onPressed: () => _showAdvancedFilters(),
        tooltip: 'Filtros avanzados',
      ),
    );
  }

  Widget _buildRefreshButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[300]!),
      ),
      child: IconButton(
        icon: Icon(Icons.refresh, color: Colors.green[700]),
        onPressed: () => _refreshData(),
        tooltip: 'Actualizar datos',
      ),
    );
  }

  Widget _buildSummaryTab() {
    return RefreshIndicator(
      onRefresh: () async => _refreshData(),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPIs principales
            _buildKPISection(),
            SizedBox(height: 24),

            // Métricas rápidas
            _buildQuickMetrics(),
            SizedBox(height: 24),

            // Alertas importantes
            _buildAlertsSection(),
            SizedBox(height: 24),

            // Acciones rápidas
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildKPISection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Indicadores Clave',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildKPICard(
              'Reservaciones Hoy',
              '127',
              '+12%',
              true,
              Icons.today,
              Colors.blue,
              onTap: () => _showDetailedReport('reservaciones_hoy'),
            ),
            _buildKPICard(
              'Tasa de Ocupación',
              '78%',
              '+5%',
              true,
              Icons.people,
              Colors.green,
              onTap: () => _showDetailedReport('ocupacion'),
            ),
            _buildKPICard(
              'Ingresos del Día',
              '\$2,845',
              '-3%',
              false,
              Icons.attach_money,
              Colors.orange,
              onTap: () => _showDetailedReport('ingresos'),
            ),
            _buildKPICard(
              'Cancelaciones',
              '8',
              '+2',
              false,
              Icons.cancel_outlined,
              Colors.red,
              onTap: () => _showDetailedReport('cancelaciones'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKPICard(
    String title,
    String value,
    String change,
    bool isPositive,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isPositive ? Colors.green[50] : Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositive ? Icons.trending_up : Icons.trending_down,
                          size: 12,
                          color:
                              isPositive ? Colors.green[600] : Colors.red[600],
                        ),
                        SizedBox(width: 2),
                        Text(
                          change,
                          style: TextStyle(
                            fontSize: 10,
                            color:
                                isPositive
                                    ? Colors.green[600]
                                    : Colors.red[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Métricas Rápidas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 12),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildMetricRow('Restaurantes activos', '24/28', 0.86),
                Divider(height: 24),
                _buildMetricRow('Usuarios nuevos', '45', null),
                Divider(height: 24),
                _buildMetricRow('Tiempo promedio reserva', '2.5 min', null),
                Divider(height: 24),
                _buildMetricRow('Satisfacción cliente', '4.6/5', 0.92),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricRow(String label, String value, double? progress) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              if (progress != null) ...[
                SizedBox(height: 4),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress > 0.8 ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAlertsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alertas y Notificaciones',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 12),
        _buildAlertCard(
          'Pico de cancelaciones detectado',
          'Restaurante "La Bella Vista" tiene 15% más cancelaciones hoy',
          Colors.orange,
          Icons.warning,
          () => _handleAlert('cancelaciones_pico'),
        ),
        SizedBox(height: 8),
        _buildAlertCard(
          'Nuevo récord de reservaciones',
          'Se han realizado 127 reservaciones hoy, superando el récord anterior',
          Colors.green,
          Icons.celebration,
          () => _handleAlert('record_reservaciones'),
        ),
      ],
    );
  }

  Widget _buildAlertCard(
    String title,
    String description,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones Rápidas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildActionButton(
              'Exportar Excel',
              Icons.table_chart,
              Colors.green,
              () => _exportToExcel(),
            ),
            _buildActionButton(
              'Enviar Reporte',
              Icons.email,
              Colors.blue,
              () => _sendReport(),
            ),
            _buildActionButton(
              'Ver Gráficos',
              Icons.bar_chart,
              Colors.purple,
              () => _showCharts(),
            ),
            _buildActionButton(
              'Configurar',
              Icons.settings,
              Colors.grey,
              () => _showSettings(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Análisis Detallado',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
          _buildAnalyticsOptions(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsOptions() {
    final analytics = [
      {
        'title': 'Reservaciones por Restaurante',
        'description': 'Análisis comparativo de rendimiento',
        'icon': Icons.restaurant,
        'color': Colors.blue,
        'trend': '+15%',
      },
      {
        'title': 'Horarios Más Solicitados',
        'description': 'Patrones de demanda por hora',
        'icon': Icons.access_time,
        'color': Colors.green,
        'trend': '+8%',
      },
      {
        'title': 'Análisis de Usuarios',
        'description': 'Comportamiento y preferencias',
        'icon': Icons.people_alt,
        'color': Colors.purple,
        'trend': '+12%',
      },
      {
        'title': 'Tendencias de Cancelación',
        'description': 'Patrones y motivos principales',
        'icon': Icons.trending_down,
        'color': Colors.red,
        'trend': '-5%',
      },
      {
        'title': 'Análisis de Ingresos',
        'description': 'Proyecciones y comparativas',
        'icon': Icons.monetization_on,
        'color': Colors.orange,
        'trend': '+7%',
      },
      {
        'title': 'Satisfacción del Cliente',
        'description': 'Métricas de calidad del servicio',
        'icon': Icons.star,
        'color': Colors.amber,
        'trend': '+3%',
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: analytics.length,
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = analytics[index];
        return Card(
          elevation: 2,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => _showAnalyticsDetail(item['title'] as String),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (item['color'] as Color).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: item['color'] as Color,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          item['description'] as String,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item['trend'] as String,
                      style: TextStyle(
                        color: Colors.green[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.chevron_right, color: Colors.grey[400]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistoryTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Historial de Reportes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
          _buildHistoryList(),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    final history = [
      {
        'title': 'Reporte Mensual - Mayo 2024',
        'date': '1 Jun 2024',
        'type': 'Completo',
        'status': 'Completado',
        'size': '2.4 MB',
      },
      {
        'title': 'Análisis Semanal - Sem 22',
        'date': '27 May 2024',
        'type': 'Semanal',
        'status': 'Completado',
        'size': '856 KB',
      },
      {
        'title': 'Reporte de Cancelaciones',
        'date': '25 May 2024',
        'type': 'Específico',
        'status': 'Completado',
        'size': '445 KB',
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: history.length,
      separatorBuilder: (context, index) => SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = history[index];
        return Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['title'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item['status'] as String,
                        style: TextStyle(
                          color: Colors.green[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: 4),
                    Text(
                      item['date'] as String,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.folder, size: 14, color: Colors.grey[500]),
                    SizedBox(width: 4),
                    Text(
                      item['type'] as String,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    SizedBox(width: 16),
                    Icon(
                      Icons.file_download,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: 4),
                    Text(
                      item['size'] as String,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => _downloadReport(item['title'] as String),
                      icon: Icon(Icons.download, size: 16),
                      label: Text('Descargar'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.indigo[700],
                      ),
                    ),
                    SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () => _shareReport(item['title'] as String),
                      icon: Icon(Icons.share, size: 16),
                      label: Text('Compartir'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingActionButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: "new_report",
          mini: true,
          backgroundColor: Colors.indigo[600],
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () => _createNewReport(),
          tooltip: 'Crear nuevo reporte',
        ),
        SizedBox(height: 8),
        FloatingActionButton(
          heroTag: "quick_export",
          backgroundColor: Colors.green[600],
          child: Icon(Icons.file_download, color: Colors.white),
          onPressed: () => _quickExport(),
          tooltip: 'Exportación rápida',
        ),
      ],
    );
  }

  // Métodos de funcionalidad
  void _handleMenuAction(String action) {
    switch (action) {
      case 'export_all':
        _exportAllReports();
        break;
      case 'schedule_report':
        _scheduleReport();
        break;
      case 'settings':
        _showReportsSettings();
        break;
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Búsqueda Rápida'),
            content: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar reportes, métricas, restaurantes...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                Navigator.pop(context);
                _performSearch(value);
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
            ],
          ),
    );
  }

  void _showCustomDatePicker() {
    showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((range) {
      if (range != null) {
        // Aplicar rango personalizado
        _applyCustomDateRange(range);
      }
    });
  }

  void _showAdvancedFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            builder:
                (context, scrollController) => Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header del modal
                      Row(
                        children: [
                          Text(
                            'Filtros Avanzados',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close),
                          ),
                        ],
                      ),
                      Divider(),

                      // Contenido scrolleable
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          children: [
                            // Filtro por estado
                            _buildFilterSection('Estado de Reservaciones', [
                              _buildFilterChip(
                                'Confirmadas',
                                _activeFilters.contains('confirmadas'),
                              ),
                              _buildFilterChip(
                                'Pendientes',
                                _activeFilters.contains('pendientes'),
                              ),
                              _buildFilterChip(
                                'Canceladas',
                                _activeFilters.contains('canceladas'),
                              ),
                              _buildFilterChip(
                                'Completadas',
                                _activeFilters.contains('completadas'),
                              ),
                            ]),

                            // Filtro por restaurante
                            _buildFilterSection('Restaurantes', [
                              _buildFilterChip(
                                'Todos',
                                _activeFilters.contains('todos_restaurantes'),
                              ),
                              _buildFilterChip(
                                'Top 10',
                                _activeFilters.contains('top_restaurantes'),
                              ),
                              _buildFilterChip(
                                'Nuevos',
                                _activeFilters.contains('nuevos_restaurantes'),
                              ),
                            ]),

                            // Filtro por horario
                            _buildFilterSection('Horarios', [
                              _buildFilterChip(
                                'Desayuno (6-11)',
                                _activeFilters.contains('desayuno'),
                              ),
                              _buildFilterChip(
                                'Almuerzo (11-15)',
                                _activeFilters.contains('almuerzo'),
                              ),
                              _buildFilterChip(
                                'Cena (18-23)',
                                _activeFilters.contains('cena'),
                              ),
                            ]),

                            // Filtro por monto
                            _buildRangeFilterSection(
                              'Rango de Montos',
                              '\$0',
                              '\$500',
                            ),
                          ],
                        ),
                      ),

                      // Botones de acción
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _clearAllFilters(),
                                child: Text('Limpiar Todo'),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _applyFilters();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo[700],
                                ),
                                child: Text(
                                  'Aplicar Filtros',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  Widget _buildFilterSection(String title, List<Widget> chips) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        Wrap(spacing: 8, runSpacing: 8, children: chips),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            _activeFilters.add(label.toLowerCase().replaceAll(' ', '_'));
          } else {
            _activeFilters.remove(label.toLowerCase().replaceAll(' ', '_'));
          }
        });
      },
      selectedColor: Colors.indigo[100],
      checkmarkColor: Colors.indigo[700],
    );
  }

  Widget _buildRangeFilterSection(String title, String min, String max) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Mínimo',
                  hintText: min,
                  border: OutlineInputBorder(),
                  prefixText: '\\',
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Máximo',
                  hintText: max,
                  border: OutlineInputBorder(),
                  prefixText: '\\',
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }

  // Métodos de funcionalidad implementados
  void _refreshData() {
    // Simular actualización de datos
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(width: 16),
            Text('Actualizando datos...'),
          ],
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.indigo[700],
      ),
    );
  }

  void _showDetailedReport(String reportType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailedReportScreen(reportType: reportType),
      ),
    );
  }

  void _handleAlert(String alertType) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Detalle de Alerta'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tipo: $alertType'),
                SizedBox(height: 8),
                Text('Se ha detectado una anomalía que requiere atención.'),
                SizedBox(height: 16),
                Text(
                  '¿Qué deseas hacer?',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Ignorar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showDetailedReport(alertType);
                },
                child: Text('Ver Detalle'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _createActionPlan(alertType);
                },
                child: Text('Crear Plan de Acción'),
              ),
            ],
          ),
    );
  }

  void _exportToExcel() {
    _showExportDialog('Excel');
  }

  void _sendReport() {
    _showSendReportDialog();
  }

  void _showCharts() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChartsScreen()),
    );
  }

  void _showSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReportsSettingsScreen()),
    );
  }

  void _showAnalyticsDetail(String analyticsType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnalyticsDetailScreen(type: analyticsType),
      ),
    );
  }

  void _downloadReport(String reportTitle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Descargando: $reportTitle'),
        action: SnackBarAction(label: 'Ver', onPressed: () {}),
      ),
    );
  }

  void _createNewReport() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Crear Nuevo Reporte',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                ListTile(
                  leading: Icon(Icons.flash_on, color: Colors.orange),
                  title: Text('Reporte Rápido'),
                  subtitle: Text('Generar reporte con datos actuales'),
                  onTap: () {
                    Navigator.pop(context);
                    _generateQuickReport();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.tune, color: Colors.blue),
                  title: Text('Reporte Personalizado'),
                  subtitle: Text('Configurar parámetros específicos'),
                  onTap: () {
                    Navigator.pop(context);
                    _showCustomReportBuilder();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.schedule, color: Colors.green),
                  title: Text('Reporte Programado'),
                  subtitle: Text('Configurar generación automática'),
                  onTap: () {
                    Navigator.pop(context);
                    _scheduleReport();
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _quickExport() {
    _showExportDialog('Quick');
  }

  void _showExportDialog(String type) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Exportar Reporte'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Selecciona el formato de exportación:'),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildExportOption(
                      'Excel',
                      Icons.table_chart,
                      Colors.green,
                    ),
                    _buildExportOption('PDF', Icons.picture_as_pdf, Colors.red),
                    _buildExportOption('CSV', Icons.description, Colors.blue),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
            ],
          ),
    );
  }

  Widget _buildExportOption(String format, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        _performExport(format);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 8),
            Text(
              format,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void _showSendReportDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Enviar Reporte'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Destinatarios',
                    hintText: 'correo1@ejemplo.com, correo2@ejemplo.com',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Asunto',
                    hintText:
                        'Reporte de Reservaciones - ${DateTime.now().day}/${DateTime.now().month}',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Mensaje (opcional)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _sendReportByEmail();
                },
                child: Text('Enviar'),
              ),
            ],
          ),
    );
  }

  void _performSearch(String query) {
    // Implementar lógica de búsqueda
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Buscando: $query')));
  }

  void _applyCustomDateRange(DateTimeRange range) {
    setState(() {
      _selectedPeriod =
          'Personalizado (${range.start.day}/${range.start.month} - ${range.end.day}/${range.end.month})';
    });
  }

  void _clearAllFilters() {
    setState(() {
      _activeFilters.clear();
    });
  }

  void _applyFilters() {
    // Implementar aplicación de filtros
    _refreshData();
  }

  void _createActionPlan(String alertType) {
    // Implementar creación de plan de acción
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Creando plan de acción para: $alertType')),
    );
  }

  void _generateQuickReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generando reporte rápido...'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showCustomReportBuilder() {
    // Navegar a pantalla de constructor de reportes personalizados
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomReportBuilderScreen()),
    );
  }

  void _scheduleReport() {
    // Implementar programación de reportes
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Programar Reporte'),
            content: Text('Función de programación en desarrollo'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cerrar'),
              ),
            ],
          ),
    );
  }

  void _performExport(String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exportando en formato $format...'),
        action: SnackBarAction(label: 'Ver progreso', onPressed: () {}),
      ),
    );
  }

  void _sendReportByEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Enviando reporte por correo...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _exportAllReports() {
    // Implementar exportación masiva
  }

  void _showReportsSettings() {
    // Implementar configuración de reportes
  }

  void _shareReport(String reportTitle) {
    _showShareDialog(reportTitle);
  }

  void _showShareDialog(String reportTitle) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Compartir Reporte',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                ListTile(
                  leading: Icon(Icons.email, color: Colors.blue),
                  title: Text('Enviar por correo'),
                  onTap: () {
                    Navigator.pop(context);
                    _showSendReportDialog();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.link, color: Colors.green),
                  title: Text('Copiar enlace'),
                  onTap: () {
                    Navigator.pop(context);
                    _copyReportLink(reportTitle);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.qr_code, color: Colors.purple),
                  title: Text('Generar código QR'),
                  onTap: () {
                    Navigator.pop(context);
                    _generateQRCode(reportTitle);
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _copyReportLink(String reportTitle) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Enlace copiado al portapapeles')));
  }

  void _generateQRCode(String reportTitle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Generando código QR para: $reportTitle')),
    );
  }
}

// Pantallas auxiliares (placeholders)
class DetailedReportScreen extends StatelessWidget {
  final String reportType;

  DetailedReportScreen({required this.reportType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reporte Detallado'),
        backgroundColor: Colors.indigo[700],
      ),
      body: Center(child: Text('Reporte detallado de: $reportType')),
    );
  }
}

class ChartsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráficos y Visualizaciones'),
        backgroundColor: Colors.indigo[700],
      ),
      body: Center(child: Text('Pantalla de gráficos')),
    );
  }
}

class ReportsSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración de Reportes'),
        backgroundColor: Colors.indigo[700],
      ),
      body: Center(child: Text('Configuración de reportes')),
    );
  }
}

class AnalyticsDetailScreen extends StatelessWidget {
  final String type;

  AnalyticsDetailScreen({required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Análisis Detallado'),
        backgroundColor: Colors.indigo[700],
      ),
      body: Center(child: Text('Análisis detallado de: $type')),
    );
  }
}

class CustomReportBuilderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Constructor de Reportes'),
        backgroundColor: Colors.indigo[700],
      ),
      body: Center(child: Text('Constructor de reportes personalizados')),
    );
  }
}
