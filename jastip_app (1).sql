-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jan 06, 2026 at 02:31 PM
-- Server version: 10.1.36-MariaDB
-- PHP Version: 5.6.38

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jastip_app`
--

-- --------------------------------------------------------

--
-- Table structure for table `jastippers`
--

CREATE TABLE `jastippers` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `email` varchar(120) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `jastippers`
--

INSERT INTO `jastippers` (`id`, `name`, `email`, `created_at`, `password_hash`) VALUES
(1, 'setio', 'setioprmd@gmail.com', '2025-12-13 10:11:21', 'scrypt:32768:8:1$MkRVfBFa717yrygH$359c88449e6e3ce0884222cd0173592035fe3a93c8e0ebf35c8af9a9999cf1c0ec4f31f73f5479b7dbe66c57b87febf0c1b9772d4639793029a30600c5e8781c'),
(2, 'Noufal', 'noufaldzaky74@gmail.com', '2025-12-13 10:37:21', 'scrypt:32768:8:1$pqV72ikUv01vl0zk$4f8f57db9229594805569cbba067d3b60578c92aeab8fbc370c789f907ea3fadd37e47f8fe55a6126b71706026ba9536f5b066ca94c1327d2535fd199c13bd96');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `buyer_id` int(11) NOT NULL,
  `product_request_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `total` decimal(20,2) NOT NULL,
  `status` varchar(20) NOT NULL,
  `payment_proof_url` varchar(500) DEFAULT NULL,
  `payment_verified` tinyint(1) DEFAULT NULL,
  `payment_uploaded_at` datetime DEFAULT NULL,
  `cancel_reason` text,
  `shipping_courier` varchar(100) DEFAULT NULL,
  `tracking_number` varchar(100) DEFAULT NULL,
  `reviewed` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `buyer_id`, `product_request_id`, `quantity`, `total`, `status`, `payment_proof_url`, `payment_verified`, `payment_uploaded_at`, `cancel_reason`, `shipping_courier`, `tracking_number`, `reviewed`, `created_at`, `updated_at`) VALUES
(1, 3, 1, 1, '28323900.00', 'Completed', '/static/payments/payment_1_20251213_112901_3.jpg', 1, '2025-12-13 11:29:01', NULL, 'JNE', 'JP23111232132', 1, '2025-12-13 11:28:05', '2025-12-13 12:02:10'),
(2, 3, 2, 1, '218900.00', 'Completed', '/static/payments/payment_2_20251216_191609_3.jpg', 1, '2025-12-16 19:16:09', NULL, 'JNE', 'J000001', 1, '2025-12-16 19:14:24', '2025-12-16 21:11:05'),
(3, 3, 1, 1, '28323900.00', 'Completed', '/static/payments/payment_3_20251216_211040_Bukti_Bayar.jpg', 1, '2025-12-16 21:10:40', NULL, 'JNE', 'J0000002', 0, '2025-12-16 21:10:08', '2025-12-16 21:15:55'),
(4, 3, 6, 1, '2143900.00', 'Completed', '/static/payments/payment_4_20260104_055039_Bukti_Bayar.jpg', 1, '2026-01-04 05:50:39', NULL, 'JNE', 'JP23111232133', 0, '2026-01-04 05:49:17', '2026-01-04 05:57:28'),
(5, 3, 3, 1, '3477177.00', 'Pending', NULL, 0, NULL, NULL, NULL, NULL, 0, '2026-01-04 05:58:15', '2026-01-04 05:58:50');

-- --------------------------------------------------------

--
-- Table structure for table `product_requests`
--

CREATE TABLE `product_requests` (
  `id` int(11) NOT NULL,
  `item_name` varchar(200) NOT NULL,
  `description` text,
  `category` varchar(100) DEFAULT NULL,
  `base_price` decimal(20,2) NOT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `fee_percent` int(11) NOT NULL,
  `jastipper_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `product_requests`
--

INSERT INTO `product_requests` (`id`, `item_name`, `description`, `category`, `base_price`, `image_url`, `created_at`, `fee_percent`, `jastipper_id`) VALUES
(1, 'Apple iPhone 17 Pro Max', 'iPhone 17 Pro Max. iPhone paling andal yang pernah ada. Layar 6,9 inci yang cemerlang(1), desain unibody aluminium, chip A19 Pro, semua kamera belakang 48 MP, dan kekuatan baterai terbaik.\r\n\r\n\r\n\r\nPoin-poin fitur utama \r\n\r\n·   DESAIN UNIBODY. UNTUK KEANDALAN MENGAGUMKAN. — Desain unibody aluminium, ditempa dalam suhu tinggi, untuk iPhone paling andal yang pernah dibuat.\r\n\r\n·   CERAMIC SHIELD TANGGUH. DEPAN DAN BELAKANG. — Ceramic Shield melindungi bagian belakang iPhone 17 Pro Max, membuatnya 4x lipat lebih tahan retak.(2) Dan Ceramic Shield 2 baru di bagian depan 3x lipat lebih tahan gores.(3)\r\n\r\n·   SISTEM KAMERA PRO PALING MAKSIMAL — Dengan semua kamera belakang 48 MP dan 8x zoom kualitas optik — rentang zoom terluas yang pernah ada di iPhone. Seperti membawa 8 lensa pro di saku Anda.\r\n\r\n·   KAMERA DEPAN 18MP CENTER STAGE — Berbagai cara fleksibel untuk mengatur framing. Selfie grup lebih pintar, video Dual Capture untuk perekaman depan dan belakang secara bersamaan, dan banyak lagi.\r\n\r\n·   CHIP A19 PRO. PENDINGINAN UAP. SECEPAT KILAT. — A19 Pro adalah chip iPhone paling andal yang pernah ada, menghadirkan performa berkelanjutan hingga 40 persen lebih baik.\r\n\r\n·   KEKUATAN BATERAI TERBAIK YANG PERNAH ADA DI IPHONE — Desain unibody menghasilkan tambahan kapasitas baterai yang besar, untuk pemutaran video hingga 39 jam.(4) Isi daya hingga 50% dalam 20 menit.(5)\r\n\r\n·   iOS 26. TAMPILAN BARU. LEBIH BANYAK KEAJAIBAN. — Desain baru dengan Liquid Glass. Indah, menyenangkan, dan tetap familier. Dengan Layar Terkunci yang lebih terang, voting dan latar belakang di Pesan yang dapat disesuaikan, Penyaringan Panggilan, dan banyak lagi.(6)\r\n\r\n·   FITUR KESELAMATAN PENTING — Dengan Deteksi Tabrakan, iPhone bisa mendeteksi tabrakan mobil yang parah dan memanggil bantuan saat Anda tak bisa.(7)\r\n\r\n·   KONEKTIVITAS MAKIN KUAT. KECEPATAN MAKIN UNGGUL. — Tetap terhubung lebih cepat dengan koneksi aman ke Wi-Fi 7,(8) jaringan 5G,(9) dan Bluetooth 6, plus eSIM.(10)\r\n\r\n·   eSIM, FLEKSIBEL. AMAN. LANCAR — Dengan eSIM, Anda menikmati lebih banyak fleksibilitas, kemudahan yang disempurnakan, keamanan yang ditingkatkan, dan konektivitas lancar, terutama saat bepergian ke luar negeri.(10)\r\n\r\n·   PRIVASI — Level privasi dan keamanan yang benar-benar baru. Terpasang di dalamnya.\r\n\r\n', 'Elektronik', '25749000.00', '/static/uploads/20251213_105618_id-11134207-81ztf-mfklf0di6ia507.webp', '2025-12-13 10:54:25', 10, 2),
(2, 'POP MART Hirono Monsters\' Carnival Series Action Figures Blind Box Birthday Gift Kid Toys', 'Informasi Produk\r\nNama Merek: POP MART\r\nInformasi Produk: Hirono Monsters\' Carnival Series Figures\r\nUkuran Produk: Tinggi sekitar 6 - 9 cm\r\n?Bahan Produk: PVC / ABS / Hardware / Magnet / Electronic Component\r\nDeskripsi Produk\r\nApa itu Kotak Misteri?\r\nKotak misteri adalah kemasan yang tidak diketahui isinya hingga dibuka, sehingga isinya menjadi misteri.\r\nKotak misteri mainan desainer biasanya hadir dalam seri bertema dengan menampilkan gambar dari keseluruhan item secara lengkap pada kemasan. Beberapa item mungkin lebih jarang ditemukan daripada yang lain, dan yang paling jarang disebut sebagai item \"rahasia\". Figur rahasia di dalam kotak dimasukkan secara acak.', 'Fashion', '199000.00', '/static/uploads/20251213_113225_id-11134207-82251-mft9lt3a2gwe2b.webp', '2025-12-13 11:31:48', 10, 2),
(3, 'ASICS Unisex Gel-Nimbus 10.1 Standard -1203A673.100', 'Variasi ukuran yang digunakan merupakan variasi US, mohon memilih size chart di bawah berdasarkan variasi US ukuran kamu.\r\nSize Chart:\r\nUS 4 / UK 3 = EUR 36 (22,5 CM)\r\nUS 4,5 / UK 3,5 = EUR 37 (23 CM)\r\nUS 5 / UK 4 = EUR 37,5 (23,5 CM)\r\nUS 5,5 / UK 4,5 = EUR 38 (24 CM)\r\nUS 6 / UK 5 = EUR 39 (24,5 CM)\r\nUS 6,5 / UK 5,5 = EUR 39,5 (25 CM)\r\nUS 7 / UK 6 = EUR 40 (25,25 CM)\r\nUS 7,5 / UK 6,5 = EUR 40,5 (25,5 CM)\r\nUS 8 / UK 7 = EUR 41,5 (26 CM)\r\nUS 8,5 / UK 7,5 = EUR 42 (26,5 CM)\r\nUS 9 / UK 8 = EUR 42,5 (27 CM)\r\nUS 9,5 / UK 8,5 = EUR 43,5 (27,5 CM)\r\nUS 10 / UK 9 = EUR 44 (28 CM)\r\nUS 10,5 / UK 9,5 = EUR 44,5 (28,25 CM)\r\nUS 11 / UK 10 = EUR 45 (28,5 CM)\r\nUS 11,5 / UK 10,5 = EUR 46 (29 CM)\r\nUS 12 / UK 11 = EUR 46,5 (29,5 CM)\r\nUS 12,5 / UK 11,5 = EUR 47 (30 CM)\r\nUS 13 / UK 12 = EUR 48 (30.5CM)\r\nUS 14 / UK 13,5 = EUR 49 (31 CM)\r\nUS 15 / UK 14 = EUR 50,5 (32 CM)\r\nUS 16 / UK 15 = EUR 51,5 (33CM)\r\nUS 17 / UK 16 = EUR 53 (34 CM)', 'Fashion', '3161070.00', '/static/uploads/20251213_113633_id-11134207-7rbk6-m6m8nawd6yzr07.webp', '2025-12-13 11:36:33', 10, 2),
(4, 'Chanel Bleu De Chanel Man EDP 100 ml', 'BPOM NC14230600497\r\nFor: Man\r\nType: Eau De Parfum\r\nSize: 100 ml\r\nWhat it is:\r\nBleu de Chanel Eau de Parfum is a refined and powerful scent that blends freshness with depth. With a clean, aromatic character and a warm, woody trail, it expresses confidence and timeless elegance. Ideal for the modern man who moves with quiet strength and purpose—perfect for day-to-night wear.\r\nFragrance Notes:\r\nTop notes : Grapefruit, Lemon, Mint, Bergamot, Pink Pepper, Aldehydes, Coriander\r\nMiddle notes: Ginger, Nutmeg, Jasmine, Melon\r\nBase notes: Incense, Amber, Cedar, Sandalwood, Patchouli, Amberwood, Labdanum', 'Kosmetik', '3637000.00', '/static/uploads/20251213_113948_id-11134207-81ztc-mepf62kosr2e38.webp', '2025-12-13 11:39:48', 10, 2),
(5, 'Osprey Kestrel 48 S23 Carrier', 'If you need a pack that can handle scraping through sandstone canyons, scrambling up snow-covered peaks, or hauling your gear for a day of trail work, the Kestrel can manage all that and more. For light weekends or big days out, the 48-liter Kestrel is a rucksack style pack made to haul heavy gear through challenging environments.\r\nDimension: 74H X 40W X 30D CM\r\nMaterial:\r\nMAIN: bluesign approved 100% recycled 420D nylon, DWR treatments made without PFAS\r\nACCENT: bluesign approved 100% recycled 500D high-tenacity nylon, DWR treatments made without PFAS\r\nFitur:\r\nIncluded raincover made with bluesign approved fabrics and DWR treatments made without PFAS, stored in zippered pocket at base of pack\r\nTop lid with large, zippered pocket; top panel lash points and under lid zippered mesh pocket with key clip\r\nInternal reservoir sleeve with Hydraclip for easier reservoir hanging\r\nFront panel shove-it pocket with stretch mesh gussets\r\nDual front panel daisy chains\r\nDual quick release upper side compression straps with axe/trekking pole capture\r\nDual lower side compression straps\r\nZippered sleeping bag compartment with floating divider\r\nRemovable sleeping pad straps\r\nDual ice tool loops\r\nStow-on-the-Go trekking pole attachment', 'Fashion', '3999000.00', '/static/uploads/20251213_114307_id-11134201-7r990-lo3h8t76xm2p33resize_w900_nl.webp', '2025-12-13 11:43:07', 10, 2),
(6, 'Decathlon OXELO Adult Freeride Inline Skates Grey/Yellow - 8738742', 'KENYAMANAN PAKAI\r\nLiner busa tebal dengan interior nilon dan lycra.\r\n\r\nKEMAMPUAN MELUNCUR\r\nRoda freeride 80 mm (atau 76 mm) 86A, bearing ABEC7.\r\nPelat aluminium ekstrusi.\r\n\r\nPAS\r\nStruktur kokoh & tiga sistem pengencang (2 pengunci mikrometrik & tali sepatu).\r\n\r\nMUDAH DIKONTROL\r\nFrame aluminium ekstrusi 243 mm dengan roda 80 mm atau 231 mm dengan roda 76 mm\r\n\r\nTAHAN TERHADAP ABRASI\r\nPenguat: perlindungan yang bisa dilepas di sisi kaki.', 'Fashion', '1949000.00', '/static/uploads/20251213_114755_sg-11134201-22100-748h0hgovsiv89.webp', '2025-12-13 11:47:55', 10, 2),
(7, 'Samsung Galaxy S25 FE 5G 8GB+512GB Display Dynamic LTPO AMOLED 6.7 inches - Exynos 2400 - Camera 50MP - 4900mAh', 'Samsung Galaxy S25 FE 5G 8GB+512GB Display Dynamic LTPO AMOLED 6.7 inches - Exynos 2400 - Camera 50MP - 4900mAh\r\n\r\nKelengkapan Dalam Kotak :\r\n1 x Unit Samsung Galaxy S25 FE\r\n1 x USB Type C Cable Data\r\n1 x SIM Ejector\r\n1 x User Guide\r\n\r\nPerforma\r\n- Prosesor : Exynos 2400 (4nm)\r\n- RAM: 8GB\r\n- Storage: 512\r\n- Network: 5G Ready\r\n\r\nDisplay\r\n- Ukuran: 6,7 inch\r\n- Teknologi: Dynamic AMOLED 2X, 60/120Hz Adaptive\r\n- Resolusi: FHD+\r\n\r\nKamera\r\n- Kamera Belakang: 50 MP + 12 MP + 8 MP\r\n- Auto Focus Kamera Utama: Ya\r\n- Kamera Belakang\r\n- OIS: Ya\r\n- Kamera Depan: 12 MP\r\n- Auto Focus Kamera Belakang: Ya\r\n- Resolusi Video: UHD 8K (7680 X 4320) l @24fps\r\n\r\nBaterai\r\n- Kapasitas: 4900mAh\r\n- Jenis Pengisian Daya: Super Fast Charging 45W, Fast Wireless Charging 15W, Wireless PowerShare\r\n\r\nKetangguhan\r\n- Corning Gorilla Glass Victus+ & Armor Aluminum frame\r\n- IP68 Water and Dust Resistant', 'Elektronik', '9848999.99', '/static/uploads/20251213_115213_sg-11134201-821d5-mh8xe3ks426l9d.webp', '2025-12-13 11:52:13', 10, 2),
(8, 'PUMA Sepatu Lari MagMax NITRO™ Wanita', 'FITUR & KEUNGGULAN \r\n• Bagian atas sepatu ini terbuat dari setidaknya 20% bahan daur ulang\r\n• NITROFOAM™: Busa injeksi nitrogen canggih yang dirancang untuk memberikan respons dan bantalan superior dalam kemasan yang ringan\r\n• PUMAGRIP: Sol luar karet tahan lama yang memberikan traksi di berbagai jenis permukaan.?? \r\n\r\nDETAIL \r\n• Regular fit\r\n• Bagian atas berbahan jaring rekayasa\r\n• Tinggi stack: 46 mm/38 mm\r\n• Berat: 300 g (UK 8)\r\n• Heel-to-toe drop: 8 mm\r\n• Direkomendasikan untuk: pronasi netral\r\n\r\nSPESIFIKASI\r\n• Brand: Puma\r\n• Color: Mintmelt-Speedblue\r\n• Gender: Female\r\n• Activity Group: Running\r\n• Fastner: Laces\r\n• Material: Textile\r\n• Style No: 310089', 'Fashion', '2684000.00', '/static/uploads/20251213_115457_id-11134207-7ra0p-mck4a098f3g7e2.webp', '2025-12-13 11:54:57', 10, 2),
(9, 'Dhaulagiri Delta Pro 4 Black & Grey / Tenda Double Layer Kapasitas 4 Orang', 'Fitur Unggulan:\r\n1. Spacious Vestibule & 3 Doors\r\nRuang depan yang lega untuk simpan perlengkapan, plus 3 pintu yang memudahkan akses keluar-masuk.\r\n2. Good Air Circulation & Aerodynamic Design*\r\nDilengkapi 4 jendela ventilasi untuk sirkulasi udara optimal dan bentuk aerodinamis agar stabil di angin kencang.\r\n3. Walled & Integrated Vestibule Floor\r\nLantai menyatu di area vestibule — menjaga area depan tetap bersih dan kering.\r\n4. Waterproof & Windproof Material\r\nTerbuat dari bahan 210T Polyester Ripstop PU 3000mm (UPF 50+), tahan hujan deras dan sinar UV.\r\n5. Multifunction Storage Pocket & Mesh Ceiling Pocket\r\nSimpan barang kecil dengan rapi di berbagai kantong penyimpanan yang tersedia.\r\n6. Reflective Guylines\r\nTali reflektif untuk keamanan malam hari agar tetap terlihat.', 'Lainnya', '2199999.99', '/static/uploads/20251213_115737_id-11134207-8224s-mgqautzt02yy92.webp', '2025-12-13 11:57:37', 10, 2),
(10, 'CLEANSING TO CALMING SET (CENTELLA AMPOULE 100ML+ TONING TONER 210ML+ CENTELLA CREAM 75ML+CLEANSING OIL', 'SKIN1004 Centella Basic 4 terdiri dari Toning Toner, Ampoule, Light Cleansing Oil, dan Soothing Cream or Cream. Keempat produk ini dipilih bertujuan untuk mempersingkat waktu durasi skincare routine namun menjaga agar tetap efektif dan efisien. Penggunaan Centella Basic 4 Set dengan rutin setiap hari akan menjaga kelembaban kulit bahkan yang sensitif sekalipun.\r\nToning Toner adalah toner eksfoliasi yang tidak mengiritasi terbaik untuk kulit sensitif.\r\nAmpoule dibuat khusus untuk kulit sensitif dengan satu kandungan penting, yaitu ekstrak Centella Asiatica. Produk ini memberikan efek menenangkan dan melembabkan.\r\nLight Cleansing Oil produk pembersih wajah All-In-One yang dibuat untuk membersihkan makeup dan sisa kotoran dengan praktis. Centella Light Cleansing Oil diproduksi dengan metode miscella yang terkenal sangat efektif untuk membersihkan makeup, sisa kotoran dan polusi yang menempel di kulit wajah.\r\nCream memiliki dua fungsi: mencerahkan dan anti keriput. Centella Cream sangat penting dalam melindungi kelembaban kulit karena dapat melapisi kulit dengan kelembaban untuk mengurangi dehidrasi sepanjang hari.', 'Kosmetik', '571500.00', '/static/uploads/20251213_120108_id-11134207-8224y-mhzd2sj87u2u60resize_w900_nl.webp', '2025-12-13 12:01:08', 10, 2),
(11, 'POP MART MEGA SPACE MOLLY 1000% BUZZ LIGHTYEAR Limited Edition', 'Ukuran: 700 mm\r\nBahan: PVC / ABS / PC / Electronic Component\r\nProduk MEGA tidak mengikuti promosi apapun.\r\nMaks. 1 pc per orang, jumlah atau pesanan tambahan akan dibatalkan oleh sistem, akun yang sama atau alamat yang sama akan dianggap sebagai satu orang.\r\nPelanggan harus menanggung tarif dan pajak pertambahan nilai yang berlaku di negara tujuan.\r\nTidak menerima pembatalan setelah konfirmasi.', 'Fashion', '14730000.00', '/static/uploads/20251213_120327_id-11134207-81ztj-mf2cuacjttzhf3resize_w900_nl.webp', '2025-12-13 12:03:27', 10, 2);

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `jastipper_id` int(11) NOT NULL,
  `rating` int(11) NOT NULL,
  `comment` text,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `reviews`
--

INSERT INTO `reviews` (`id`, `order_id`, `user_id`, `jastipper_id`, `rating`, `comment`, `created_at`) VALUES
(1, 1, 3, 2, 5, 'Keren adminnya,cepet banget pengirimannya,Makasih banyak min', '2025-12-13 12:02:10'),
(2, 2, 3, 2, 5, 'Bagus', '2025-12-16 21:11:05');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(80) NOT NULL,
  `email` varchar(120) NOT NULL,
  `address` text NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `role` varchar(20) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `address`, `phone`, `created_at`, `role`, `password_hash`) VALUES
(1, 'ponyrusher_', '411232072@mahasiswa.undira.ac.id', 'lenteng agung', '081365891964', '2025-12-13 10:10:27', 'buyer', 'scrypt:32768:8:1$2Eibtgn0rVsPJIca$91485c59038988219f359ac439b3357bed7dbf60721058c8bf815300aed3720da4c3f2f43dc14c6761131027a7e0350241cb085ceffe769dc61d7e656e540f71'),
(2, 'reza', 'rezaarap@gmail.com', 'Taman Alamanda Blok E9 No.15', '081293145062', '2025-12-13 10:57:00', 'buyer', 'scrypt:32768:8:1$IdCzmFgt48nx42XF$20766089d97a595ab05f91b430584d3b9cfa2a877f44555b18a9231531689a4a8e2a582dcf370128d2ab19de2ff3d2e9396b7a8fa78e7b74aa04ba63cb4b5550'),
(3, 'dudung', '411232068@mahasiswa.undira.ac.id', 'Perum Bumi Anggrek Blok e12 no 36, Kab.Bekasi, Tambun Utara, Karang Satria', '08213321321', '2025-12-13 11:27:52', 'buyer', 'scrypt:32768:8:1$t4WqI4UVISqhpbKV$bf4edffc67ce81d3ac0ba3bb73972699666661292fecb646397338279adfaae482b436dc48e7c90cfc40e744866f656187c59f14824712a9dd9338d33138ebdc');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `jastippers`
--
ALTER TABLE `jastippers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `buyer_id` (`buyer_id`),
  ADD KEY `product_request_id` (`product_request_id`);

--
-- Indexes for table `product_requests`
--
ALTER TABLE `product_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jastipper_id` (`jastipper_id`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_id` (`order_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `jastipper_id` (`jastipper_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `jastippers`
--
ALTER TABLE `jastippers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `product_requests`
--
ALTER TABLE `product_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`buyer_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`product_request_id`) REFERENCES `product_requests` (`id`);

--
-- Constraints for table `product_requests`
--
ALTER TABLE `product_requests`
  ADD CONSTRAINT `product_requests_ibfk_1` FOREIGN KEY (`jastipper_id`) REFERENCES `jastippers` (`id`);

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `reviews_ibfk_3` FOREIGN KEY (`jastipper_id`) REFERENCES `jastippers` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
