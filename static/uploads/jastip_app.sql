-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 22, 2025 at 05:20 AM
-- Server version: 8.4.3
-- PHP Version: 8.3.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
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
  `id` int NOT NULL,
  `name` varchar(120) NOT NULL,
  `email` varchar(120) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jastippers`
--

INSERT INTO `jastippers` (`id`, `name`, `email`, `created_at`, `password_hash`) VALUES
(10, 'Noufal', 'noufaldzaky271104@gmail.com', '2025-11-18 17:18:23', 'scrypt:32768:8:1$L9VOwxIO0tyDZggP$e1f15531c459b21fb5061e63ff805438dddf76d5f9dfcbe9c7274aac62fcfee14947afc39b29edda566d9a31bc66ef2e90443bb2382dcad3d68e333cbb33500b');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `request_id` int NOT NULL,
  `quantity` int DEFAULT '1',
  `status` enum('Pending','Paid','Shipped','Completed') DEFAULT 'Pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `request_id`, `quantity`, `status`, `created_at`) VALUES
(1, 1, 6, 2, 'Pending', '2025-11-18 10:10:27'),
(2, 1, 3, 1, 'Pending', '2025-11-21 21:06:46'),
(3, 2, 5, 1, 'Pending', '2025-11-21 21:14:41'),
(4, 3, 3, 1, 'Pending', '2025-11-21 21:21:01'),
(5, 3, 14, 1, 'Pending', '2025-11-21 21:33:23');

-- --------------------------------------------------------

--
-- Table structure for table `product_requests`
--

CREATE TABLE `product_requests` (
  `id` int NOT NULL,
  `jastipper_id` int NOT NULL,
  `item_name` varchar(150) NOT NULL,
  `category` varchar(100) DEFAULT NULL,
  `base_price` decimal(12,2) NOT NULL,
  `fee_percent` int DEFAULT '10',
  `description` text,
  `image_url` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_requests`
--

INSERT INTO `product_requests` (`id`, `jastipper_id`, `item_name`, `category`, `base_price`, `fee_percent`, `description`, `image_url`, `created_at`) VALUES
(2, 10, 'Nintendo Switch OLED', 'Elektronik', 4500000.00, 15, 'Console game Nintendo Switch versi OLED dengan layar lebih jernih dan storage 64GB. Brand new sealed!', '', '2025-11-18 09:55:51'),
(3, 10, 'Uniqlo Heattech Innerwear', 'Fashion', 250000.00, 10, 'Baju dalam Heattech dari Uniqlo yang super hangat dan nyaman. Cocok untuk musim dingin atau ruangan ber-AC.', '', '2025-11-18 09:55:51'),
(4, 10, 'Shiseido Perfect Whip Foam', 'Kosmetik', 150000.00, 12, 'Sabun wajah foam dari Shiseido yang lembut dan membersihkan sempurna. Best seller di Jepang!', '', '2025-11-18 09:55:51'),
(5, 10, 'Tokyo Banana Original', 'Makanan', 180000.00, 20, 'Oleh-oleh khas Tokyo yang terkenal! Kue lembut dengan isian krim pisang yang manis dan lezat.', '', '2025-11-18 09:55:51'),
(6, 10, 'Samsung Galaxy Buds Pro', 'Elektronik', 2800000.00, 15, 'Earbuds wireless premium dari Samsung dengan noise cancellation terbaik. Original product!', '', '2025-11-18 09:55:51'),
(7, 10, 'COSRX Snail Mucin Essence', 'Kosmetik', 180000.00, 10, 'Essence wajah dengan snail mucin 96% yang viral di seluruh dunia. Bikin kulit glowing dan lembab!', '', '2025-11-18 09:55:51'),
(8, 10, 'Korean Hanbok Modern', 'Fashion', 850000.00, 18, 'Hanbok modern style yang trendy dan comfortable. Perfect untuk photoshoot atau acara khusus!', '', '2025-11-18 09:55:51'),
(9, 10, 'Samyang Hot Chicken Ramen Bundle', 'Makanan', 120000.00, 15, 'Paket isi 10 bungkus mie pedas Samyang dengan berbagai varian rasa. Challenge accepted?', '', '2025-11-18 09:55:51'),
(10, 10, 'Apple AirPods Pro 2', 'Elektronik', 3500000.00, 12, 'AirPods Pro generasi 2 dengan H2 chip dan USB-C charging. Noise cancellation terbaik dari Apple!', '', '2025-11-18 09:55:51'),
(11, 10, 'Levi\'s 501 Original Jeans', 'Fashion', 1200000.00, 15, 'Celana jeans klasik Levi\'s 501 original fit. Timeless style yang tidak pernah ketinggalan zaman.', '', '2025-11-18 09:55:51'),
(12, 10, 'Bath & Body Works Candle Set', 'Lainnya', 450000.00, 20, 'Set 3 lilin aromaterapi dari Bath & Body Works dengan wangi yang tahan lama dan menenangkan.', '', '2025-11-18 09:55:51'),
(13, 10, 'Hershey\'s Chocolate Gift Box', 'Makanan', 250000.00, 18, 'Gift box cokelat Hershey\'s dengan berbagai varian rasa. Perfect untuk hadiah atau cemilan!', '', '2025-11-18 09:55:51'),
(14, 10, 'Xiaomi 17 Pro Max', 'Elektronik', 21400000.00, 10, 'Layar Depan:\r\n– LTPO AMOLED 6,9 inci\r\n– Resolusi 2K (sekitar 1200 × 2608)\r\n– Refresh rate 120 Hz', '/static/uploads/20251119_002818_063096200_1758870762-image_2025-09-26_134529571.jpg', '2025-11-18 10:28:19');

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `id` int NOT NULL,
  `order_id` int NOT NULL,
  `user_id` int NOT NULL,
  `rating` int DEFAULT NULL,
  `comment` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password_hash`, `role`, `created_at`) VALUES
(1, 'Noufal', 'noufaldzaky74@gmail.com', 'scrypt:32768:8:1$t9dOWqKb2ywRMrZs$29d38a9057e87a5fb3e8143da253fa6615643d503dc2c93c80ce2255e9572568d68fb06ab4cfc61621442f4297804d5b30c1002d70cab14fa4d27adc0c6934d4', 'buyer', '2025-11-18 09:24:04'),
(2, 'Setio', 'setio@gmail.com', 'scrypt:32768:8:1$vrhAtMMkHcrrRLm3$0ebd30bb96edef7687e5bca16195ce6925f664a531f2c5099ce957fb6937392fdffca698479fccdbd95e9537c652ee472d878e9875667fb5706c947180bdb7d4', 'buyer', '2025-11-21 21:13:43'),
(3, 'dendi', 'dendi@gmail.com', 'scrypt:32768:8:1$vef1r3LUImLZcPVt$1cfcde0d45cf7a282b22ef8198ade83f34fb701342d41d66f22bcf9d8e7b76c179f3582df256fd39c73ce5329dae1ff65540e80228dd984eb0cbfbbc003072c4', 'buyer', '2025-11-21 21:20:50');

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
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `product_requests`
--
ALTER TABLE `product_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_request_jastipper` (`jastipper_id`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_review_order` (`order_id`),
  ADD KEY `fk_review_user` (`user_id`);

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
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `product_requests`
--
ALTER TABLE `product_requests`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
