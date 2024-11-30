import 'package:flutter/material.dart';
import 'package:gacortask/constants.dart';
import 'package:gacortask/screens/menubarpage/provider/theme_provider.dart';
import 'package:provider/provider.dart';
 
class FaqPage extends StatefulWidget {
  const FaqPage({super.key});
 
  @override
  State<FaqPage> createState() => _FaqPageState();
}
 
class _FaqPageState extends State<FaqPage> {
  final List<Map<String, String>> faqData = [
    {
      'question': 'Bagaimana cara menambahkan tugas baru?',
      'answer':
          'Untuk menambahkan tugas baru, cukup klik tombol "Tambah Tugas" atau ikon "+" di aplikasi Anda, yang biasanya terletak di bagian bawah atau atas layar, tergantung pada desain aplikasi. Setelah itu, Anda akan diminta untuk mengisi rincian tugas, seperti:\n\n- Nama Tugas: Deskripsi singkat tentang tugas yang perlu diselesaikan, misalnya "Beli Bahan Makanan" atau "Tulis Laporan".\n- Tanggal Tenggat: Pilih tanggal dan waktu kapan tugas tersebut harus selesai.\n- Prioritas: Tentukan apakah tugas memiliki prioritas tinggi, sedang, atau rendah.\n- Deskripsi Tambahan: Isikan catatan atau detail tambahan jika perlu.\n\nSetelah selesai mengisi rincian tugas, tekan tombol "Simpan" untuk menyimpannya.'
    },
    {
      'question': 'Bagaimana cara menandai tugas sebagai selesai?',
      'answer':
          'Untuk menandai tugas sebagai selesai, Anda cukup mencentang kotak di sebelah nama tugas, atau ketuk tombol "Selesai" yang biasanya ada di bagian bawah atau samping detail tugas. Ketika Anda menandai tugas sebagai selesai, tugas tersebut akan dipindahkan ke bagian "Tugas Selesai" atau dicoret dengan garis horizontal. Jika Anda ingin membatalkan status selesai, pilih tugas tersebut dan ubah kembali statusnya menjadi "Aktif".'
    },
    {
      'question': 'Bisakah saya mengedit tugas yang sudah ditambahkan?',
      'answer':
          'Ya, Anda bisa mengedit tugas kapan saja. Cukup pilih tugas yang ingin diubah, kemudian klik ikon edit (biasanya berupa pensil) di sebelah tugas tersebut. Anda dapat mengubah nama tugas, tanggal tenggat, prioritas, atau menambah deskripsi tambahan. Setelah selesai mengedit, pastikan untuk menekan tombol "Simpan" untuk memperbarui tugas.'
    },
    {
      'question': 'Bagaimana cara menghapus tugas?',
      'answer':
          'Untuk menghapus tugas, pilih tugas yang ingin dihapus dan cari opsi "Hapus" di menu tindakan (biasanya berupa ikon tiga titik atau ikon sampah). Setelah memilih opsi ini, aplikasi akan meminta konfirmasi sebelum menghapus tugas. Jika Anda mengonfirmasi, tugas akan dihapus secara permanen dan tidak bisa dikembalikan kecuali aplikasi menyediakan opsi "Undo".'
    },
    {
      'question': 'Apakah saya bisa mengatur pengingat untuk tugas?',
      'answer':
          'Ya, aplikasi To-Do List ini memiliki fitur pengingat. Anda dapat mengatur pengingat untuk setiap tugas berdasarkan tanggal, waktu, atau lokasi. Pengingat bisa berupa notifikasi, email, atau pesan teks. Beberapa aplikasi juga menyediakan pengingat berulang atau pengingat snooze untuk menunda tugas jika Anda tidak dapat menyelesaikannya tepat waktu.'
    },
    {
      'question':
          'Apakah tugas yang saya buat akan tersinkronisasi di perangkat lain?',
      'answer':
          'Jika aplikasi Anda mendukung sinkronisasi cloud, maka tugas yang Anda buat di satu perangkat akan otomatis tersinkronisasi ke perangkat lain yang menggunakan akun yang sama. Pastikan Anda terhubung ke internet dan masuk menggunakan akun yang sama di perangkat yang berbeda. Beberapa aplikasi juga memungkinkan Anda untuk mengatur sinkronisasi otomatis atau manual.'
    },
    {
      'question': 'Bagaimana cara membatalkan tugas yang sudah selesai?',
      'answer':
          'Jika Anda ingin membatalkan status tugas yang sudah selesai, buka tugas tersebut dan pilih opsi untuk mengubah statusnya kembali ke "Belum Selesai". Setelah diperbarui, tugas tersebut akan muncul kembali di daftar tugas aktif, dan Anda bisa melanjutkan pengerjaannya.'
    },
    {
      'question': 'Apakah saya bisa mengelompokkan tugas berdasarkan kategori?',
      'answer':
          'Ya, banyak aplikasi To-Do List memungkinkan Anda untuk mengelompokkan tugas berdasarkan kategori atau label tertentu, seperti "Pekerjaan", "Pribadi", atau "Belanja". Anda dapat memilih kategori saat membuat atau mengedit tugas, dan aplikasi akan memungkinkan Anda untuk memfilter atau menyaring tugas berdasarkan kategori tersebut.'
    },
    {
      'question': 'Bagaimana cara mengatur prioritas untuk tugas?',
      'answer':
          'Anda dapat mengatur prioritas untuk setiap tugas dengan memilih tingkat prioritas seperti "Tinggi", "Sedang", atau "Rendah". Ini membantu Anda untuk fokus pada tugas yang lebih mendesak. Beberapa aplikasi juga memungkinkan Anda untuk menandai tugas dengan warna atau ikon tertentu untuk membedakan tingkat prioritasnya.'
    },
  ];
 
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('FAQ'),
          backgroundColor: themeProvider.primaryColor,
          foregroundColor: themeProvider.secondaryColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: List.generate(
                faqData.length,
                (index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 5.0,
                    child: ExpansionTile(
                      title: Text(
                        faqData[index]['question']!,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            faqData[index]['answer']!,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Constants.colorBlack,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}