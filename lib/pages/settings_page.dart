
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  PermissionStatus? _camera;
  PermissionStatus? _photos;
  PermissionStatus? _storage;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final cam = await Permission.camera.status;
    final photos = await Permission.photos.status;
    final storage = await Permission.storage.status;
    if (!mounted) return;
    setState(() {
      _camera = cam;
      _photos = photos;
      _storage = storage;
    });
  }

  Widget _statusRow(
    String label,
    PermissionStatus? status,
    VoidCallback onRequest,
  ) {
    return ListTile(
      title: Text(label),
      subtitle: Text(_statusText(status)),
      trailing: ElevatedButton(
        onPressed: onRequest,
        child: const Text('Solicitar'),
      ),
    );
  }

  String _statusText(PermissionStatus? status) {
    if (status == null) return 'desconecido';
    if (status.isGranted) return 'concedida';
    if (status.isDenied) return 'negada';
    if (status.isPermanentlyDenied) return 'permanentemente negada';
    if (status.isRestricted) return 'restrita';
    if (status.isLimited) return 'limitada';
    return status.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permissões')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          children: [
            _statusRow('Câmera', _camera, () async {
              await Permission.camera.request();
              await _refresh();
            }),
            _statusRow('Fotos', _photos, () async {
              await Permission.photos.request();
              await _refresh();
            }),
            _statusRow('Armazenamento', _storage, () async {
              await Permission.storage.request();
              await _refresh();
            }),
            ListTile(
              title: const Text('Abrir Configurações do App'),
              trailing: ElevatedButton(
                onPressed: () => openAppSettings(),
                child: const Text('Abrir'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Se as Configurações do app mostrarem apenas Siri e Busca, o app pode não ter solicitado a permissão correta ou o sistema operacional pode estar agrupando as configurações de forma diferente. Use os botões de solicitação acima para acionar as caixas de diálogo do sistema, quando possível.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
