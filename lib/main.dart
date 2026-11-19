import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Formulir Permohonan Surat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const FormPermohonanSuratPage(),
    );
  }
}

class FormPermohonanSuratPage extends StatefulWidget {
  const FormPermohonanSuratPage({super.key});

  @override
  State<FormPermohonanSuratPage> createState() =>
      _FormPermohonanSuratPageState();
}

class _FormPermohonanSuratPageState extends State<FormPermohonanSuratPage> {
  // GlobalKey untuk validasi Form
  final _formKey = GlobalKey<FormState>();

  // Controllers untuk input teks
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _keperluanController = TextEditingController();

  // State untuk visibilitas password
  bool _obscurePassword = true;

  // State untuk Radio Button (Jenis Kelamin)
  String? _jenisKelamin = 'Laki-laki';

  // State untuk Dropdown (Program Studi & Jenis Surat)
  String? _selectedProdi;
  final List<String> _daftarProdi = [
    'Teknik Elektro',
    'Teknik Mesin',
    'Teknik Sipil',
    'Arsitektur',
    'Teknologi Pangan',
    'Informatika',
  ];

  String? _selectedJenisSurat;
  final List<String> _daftarJenisSurat = [
    'Surat Keterangan Aktif Kuliah',
    'Surat Pengantar Magang / Kerja Praktek',
    'Surat Izin Penelitian / Skripsi',
    'Surat Rekomendasi Beasiswa',
    'Surat Izin Cuti Kuliah',
  ];

  // State untuk Checkbox (Lampiran Dokumen Pendukung - boleh lebih dari satu)
  final Map<String, bool> _lampiranDokumen = {
    'Scan KTM (Kartu Tanda Mahasiswa)': false,
    'KRS Semester Aktif': false,
    'Transkrip Nilai Sementara': false,
    'Surat Pengantar Instansi / Perusahaan': false,
    'Surat pernyataan persetujuan orang tua/wali': false,
  };

  // State untuk Checkbox Persetujuan
  bool _setujuSyarat = false;

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _keperluanController.dispose();
    super.dispose();
  }

  // Fungsi memproses dan memvalidasi form
  void _submitForm() {
    // 1. Jalankan validator pada semua TextFormField dan Dropdown
    final isValid = _formKey.currentState!.validate();

    // 2. Validasi manual untuk Checkbox Lampiran (minimal pilih 1)
    final daftarLampiranDipilih = _lampiranDokumen.entries
        .where((item) => item.value)
        .map((item) => item.key)
        .toList();

    if (!isValid) {
      return;
    }

    if (daftarLampiranDipilih.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal satu lampiran dokumen pendukung!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_setujuSyarat) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus menyetujui syarat dan ketentuan!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 3. Jika semua valid, tampilkan Ringkasan Data melalui Dialog
    _tampilkanRingkasanDialog(daftarLampiranDipilih);
  }

  void _tampilkanRingkasanDialog(List<String> lampiran) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Expanded(child: Text('Ringkasan Permohonan')),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoRow('Nama Lengkap', _namaController.text),
              _buildInfoRow('NPM', _nimController.text),
              _buildInfoRow('Jenis Kelamin', _jenisKelamin ?? '-'),
              _buildInfoRow('Program Studi', _selectedProdi ?? '-'),
              _buildInfoRow('Email', _emailController.text),
              const Divider(),
              _buildInfoRow('Jenis Surat', _selectedJenisSurat ?? '-'),
              _buildInfoRow('Keperluan', _keperluanController.text),
              const SizedBox(height: 8),
              const Text(
                'Lampiran Pendukung:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...lampiran.map((item) => Text('• $item')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permohonan Surat Mahasiswa'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === BAGIAN 1: DATA PEMOHON ===
              const Text(
                'Data Pemohon',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // 1. Nama Lengkap
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  hintText: 'Masukkan nama lengkap sesuai KTM',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama lengkap wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // 2. NIM (Angka, minimal 8 digit)
              TextFormField(
                controller: _nimController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'NPM',
                  hintText: 'Contoh: 25670007',
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'NPM wajib diisi';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
                    return 'NPM harus berupa angka';
                  }
                  if (value.trim().length < 8) {
                    return 'NPM minimal 8 digit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // 3. Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'mahasiswa@kampus.ac.id',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email wajib diisi';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value.trim())) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // 4. Password Akun Portal (Minimal 8 karakter)
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password Akun SIMEKAR',
                  hintText: 'Minimal 8 karakter',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password wajib diisi';
                  }
                  if (value.length < 8) {
                    return 'Password minimal 8 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 5. Jenis Kelamin (Radio)
              const Text(
                'Jenis Kelamin',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Laki-laki'),
                      value: 'Laki-laki',
                      // ignore: deprecated_member_use
                      groupValue: _jenisKelamin,
                      // ignore: deprecated_member_use
                      onChanged: (value) {
                        setState(() => _jenisKelamin = value);
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Perempuan'),
                      value: 'Perempuan',
                      // ignore: deprecated_member_use
                      groupValue: _jenisKelamin,
                      // ignore: deprecated_member_use
                      onChanged: (value) {
                        setState(() => _jenisKelamin = value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 6. Program Studi (Dropdown)
              DropdownButtonFormField<String>(
                initialValue: _selectedProdi,
                decoration: const InputDecoration(
                  labelText: 'Program Studi',
                  prefixIcon: Icon(Icons.school),
                  border: OutlineInputBorder(),
                ),
                items: _daftarProdi.map((prodi) {
                  return DropdownMenuItem(value: prodi, child: Text(prodi));
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedProdi = value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Program studi wajib dipilih';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 8),

              // === BAGIAN 2: DETAIL PERMOHONAN SURAT ===
              const Text(
                'Detail Permohonan Surat',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // 7. Jenis Surat (Dropdown)
              DropdownButtonFormField<String>(
                initialValue: _selectedJenisSurat,
                decoration: const InputDecoration(
                  labelText: 'Jenis Surat yang Dimohon',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                items: _daftarJenisSurat.map((surat) {
                  return DropdownMenuItem(value: surat, child: Text(surat));
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedJenisSurat = value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jenis surat wajib dipilih';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // 8. Keperluan Surat (Text Area)
              TextFormField(
                controller: _keperluanController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Keperluan / Tujuan Surat',
                  hintText: 'Jelaskan keperluan pengajuan surat secara singkat...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Keperluan surat wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 9. Lampiran Dokumen Pendukung (Checkbox - boleh lebih dari satu)
              const Text(
                'Lampiran Dokumen (boleh lebih dari satu)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              ..._lampiranDokumen.keys.map((dokumen) {
                return CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(dokumen),
                  value: _lampiranDokumen[dokumen],
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (bool? value) {
                    setState(() {
                      _lampiranDokumen[dokumen] = value ?? false;
                    });
                  },
                );
              }),

              const Divider(),

              // 10. Checkbox Persetujuan Syarat & Ketentuan
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Saya menyatakan data yang diisi benar dan menyetujui syarat & ketentuan.',
                  style: TextStyle(fontSize: 13),
                ),
                value: _setujuSyarat,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    _setujuSyarat = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 16),

              // 11. Tombol Simpan
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.send),
                  label: const Text(
                    'Simpan & Ajukan Surat',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}