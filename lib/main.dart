import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';

// --- IMPORTS DES MODULES DE DIAGNOSTIC ---
// scan.dart et socket.dart vivent dans lib/module/ et sont importés comme
// de vrais modules Dart : leurs fonctions sont appelées directement,
// dans le même process que l'UI Flutter (pas de sous-process Dart séparé).
import 'module/scan.dart' as scanner;
import 'module/socket.dart' as analyzer;

void main() {
  runApp(const DiagnosticDashboard());
}

class DiagnosticDashboard extends StatelessWidget {
  const DiagnosticDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Network Diagnostic Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: const DashboardScreen(),
    );
  }
}

// ==========================================================
// L'Écran Principal (Dashboard)
// ==========================================================

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String diagnosisReport = "Cliquez sur 'Lancer le Scan' pour générer les rapports.";
  bool isLoading = false;
  String currentStep = "";

  /// Résultats structurés du dernier scan, affichés dans le tableau.
  /// Une Map IP -> HostResult permet de mettre à jour une seule ligne
  /// (rescan ciblé) sans perdre l'état des autres lignes.
  final Map<String, scanner.HostResult> hostResults = {};

  /// IP en cours de rescan individuel (pour afficher un petit loader sur la ligne).
  String? rescanningIp;

  /// Progression du scan global : (terminés, total). Null si aucun scan en cours.
  (int, int)? scanProgress;

  /// Dossier où vivent config.json, scan.dart et socket.dart (lib/module/),
  /// et où seront écrits scan_raw_results.txt / final_diagnosis.txt.
  /// Construit depuis la racine du projet (répertoire courant au lancement de l'app).
  String get _moduleDir => '${Directory.current.path}/lib/module';

  String get _configPath => '$_moduleDir/config.json';
  String get _rawReportPath => '$_moduleDir/scan_raw_results.txt';
  String get _finalDiagnosisPath => '$_moduleDir/final_diagnosis.txt';

  /// Fonction appelée pour lancer le processus complet : SCAN -> ANALYSE -> AFFICHAGE.
  /// Les deux étapes s'exécutent directement dans ce process (vrais appels de fonctions
  /// importées), donc pas de souci d'environnement graphique GTK/X11 lié à un sous-process
  /// élevé. Seule la commande système `arp -a`, si elle échoue par manque de permission,
  /// retentera une fois via pkexec (voir executeSystemCommand dans scan.dart).
  Future<void> runScanCycle() async {
    setState(() {
      isLoading = true;
      currentStep = "Scan réseau en cours (ping/arp)...";
      diagnosisReport = "🚀 Démarrage du cycle de scan... (Veuillez attendre)";
      hostResults.clear();
      scanProgress = null;
    });

    try {
      // 1. SCAN : appel direct de la fonction importée depuis scan.dart.
      // onProgress et onHostResult permettent de mettre à jour l'UI en direct,
      // hôte par hôte, plutôt qu'attendre la fin complète du cycle.
      await scanner.runTechnicianScan(
        configPath: _configPath,
        outputPath: _rawReportPath,
        onProgress: (done, total) {
          setState(() => scanProgress = (done, total));
        },
        onHostResult: (result) {
          setState(() => hostResults[result.ip] = result);
        },
      );

      // 2. ANALYSE : appel direct de la fonction importée depuis socket.dart
      setState(() => currentStep = "Analyse des résultats...");
      final finalContent = await analyzer.runDiagnosticAnalysis(
        inputPath: _rawReportPath,
        outputPath: _finalDiagnosisPath,
      );

      setState(() {
        diagnosisReport = finalContent;
      });
    } catch (e) {
      setState(() {
        diagnosisReport = "❌ ÉCHEC: Une erreur est survenue pendant le cycle de scan : $e";
      });
    } finally {
      setState(() {
        isLoading = false;
        currentStep = "";
        scanProgress = null;
      });
    }
  }

  /// Relance un ping sur une seule IP (ligne du tableau tapée), sans relancer
  /// tout le cycle scan + analyse. Met à jour uniquement cette ligne.
  Future<void> rescanSingleHost(String ip) async {
    if (rescanningIp != null) return; // évite les double-taps pendant un rescan
    final wasCritical = hostResults[ip]?.isCritical ?? false;

    setState(() => rescanningIp = ip);
    try {
      // Rescan individuel : 4 paquets pour un diagnostic plus fiable qu'un
      // simple test de présence, avec un timeout proportionnel (4 paquets
      // prennent ~4s sur la plupart des systèmes, donc on prévoit une marge).
      final result = await scanner.pingHost(
        ip,
        pingCount: 4,
        timeout: const Duration(seconds: 6),
        isCritical: wasCritical,
      );
      setState(() {
        hostResults[ip] = result;
      });
    } finally {
      setState(() => rescanningIp = null);
    }
  }

  Color _statusColor(scanner.HostStatus status) {
    switch (status) {
      case scanner.HostStatus.reachable:
        return Colors.green;
      case scanner.HostStatus.unreachable:
        return Colors.red;
      case scanner.HostStatus.error:
        return Colors.orange;
    }
  }

  IconData _statusIcon(scanner.HostStatus status) {
    switch (status) {
      case scanner.HostStatus.reachable:
        return Icons.check_circle;
      case scanner.HostStatus.unreachable:
        return Icons.cancel;
      case scanner.HostStatus.error:
        return Icons.warning_amber_rounded;
    }
  }

  String _statusLabel(scanner.HostStatus status) {
    switch (status) {
      case scanner.HostStatus.reachable:
        return "Joignable";
      case scanner.HostStatus.unreachable:
        return "Injoignable";
      case scanner.HostStatus.error:
        return "Erreur système";
    }
  }

  @override
  Widget build(BuildContext context) {
    final results = hostResults.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Diagnostic Dashboard'),
        centerTitle: true,
        elevation: 4.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Zone de Contrôle (Le Bouton + Progression) ---
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      icon: isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.search_off, size: 30),
                      label: Text(isLoading ? "SCAN EN COURS..." : "🚀 LANCER LE SCAN DIAGNOSTIQUE"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: isLoading ? Colors.grey : Colors.red[700],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: isLoading ? null : runScanCycle,
                    ),
                    if (isLoading) ...[
                      const SizedBox(height: 12),
                      if (scanProgress != null) ...[
                        LinearProgressIndicator(
                          value: scanProgress!.$2 > 0 ? scanProgress!.$1 / scanProgress!.$2 : null,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${scanProgress!.$1} / ${scanProgress!.$2} IPs scannées",
                          style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                        ),
                      ] else if (currentStep.isNotEmpty)
                        Text(currentStep, style: const TextStyle(color: Colors.grey)),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // --- Tableau des hôtes (vue structurée, colorée) ---
            if (results.isNotEmpty) ...[
              Text("📋 État des hôtes",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text(
                "Touchez une ligne pour rescanner cette IP individuellement.",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const Divider(),
              const SizedBox(height: 10),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    for (final result in results)
                      _HostRow(
                        result: result,
                        isRescanning: rescanningIp == result.ip,
                        color: _statusColor(result.status),
                        icon: _statusIcon(result.status),
                        label: _statusLabel(result.status),
                        onTap: () => rescanSingleHost(result.ip),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],

            // --- Zone du Rapport (Le Résultat texte de l'analyse) ---
            Text("🔎 Résumé des Conclusions Diagnostiques",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const Divider(),
            const SizedBox(height: 10),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  child: SelectableText(
                    diagnosisReport,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                ),
              ),
            ),

            // --- Conseils Utilisateur ---
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.yellow[50],
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                border: Border.all(color: Colors.amber),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("💡 Guide d'Utilisation du Dashboard:", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text("1. Mettez à jour `lib/module/config.json` pour définir la plage IP et les équipements critiques."),
                  SizedBox(height: 5),
                  Text("   (clé optionnelle \"max_concurrent_pings\": 10 pour limiter le nombre de pings simultanés)"),
                  SizedBox(height: 5),
                  Text("2. Cliquez sur le bouton : le scan et l'analyse sont lancés automatiquement, dans l'app."),
                  SizedBox(height: 5),
                  Text("3. Touchez une ligne du tableau pour rescanner uniquement cette IP."),
                  SizedBox(height: 5),
                  Text("4. Si une commande système nécessite des droits admin, une invite système peut apparaître ponctuellement."),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Une ligne du tableau d'état des hôtes : IP, statut coloré, et tap pour rescan.
class _HostRow extends StatelessWidget {
  final scanner.HostResult result;
  final bool isRescanning;
  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HostRow({
    required this.result,
    required this.isRescanning,
    required this.color,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isRescanning ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            if (isRescanning)
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(icon, color: color, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                result.ip,
                style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'monospace'),
              ),
            ),
            if (result.isCritical)
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Tooltip(
                  message: 'Équipement critique',
                  child: Icon(Icons.star, size: 16, color: Colors.amber),
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.refresh, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}