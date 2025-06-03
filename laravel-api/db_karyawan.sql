-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 03, 2025 at 03:12 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_karyawan`
--

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `karyawans`
--

CREATE TABLE `karyawans` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nama` varchar(255) NOT NULL,
  `harga_jual` decimal(10,2) NOT NULL,
  `modal` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `total_profit` double NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `karyawans`
--

INSERT INTO `karyawans` (`id`, `nama`, `harga_jual`, `modal`, `created_at`, `updated_at`, `total_profit`) VALUES
(3, 'Karyawan B', 50000.00, 25000.00, '2025-05-30 18:09:33', '2025-05-31 19:26:28', 25000),
(4, 'Karyawan C', 100000.00, 75000.00, '2025-05-30 18:17:27', '2025-05-31 19:26:28', 25000),
(5, 'Karyawan D', 85000.00, 65000.00, '2025-05-30 18:22:48', '2025-05-31 19:26:28', 20000),
(6, 'Karyawan A', 75000.00, 50000.00, '2025-05-30 18:24:43', '2025-05-31 19:26:28', 25000),
(7, 'Karyawan D', 200000.00, 170000.00, '2025-05-30 18:56:03', '2025-05-31 19:26:28', 30000),
(8, 'Karyawan E', 215000.00, 185000.00, '2025-05-31 19:29:12', '2025-05-31 19:29:12', 30000),
(9, 'Karyawan A', 250000.00, 237500.00, '2025-06-03 03:12:36', '2025-06-03 03:20:12', 12500),
(10, 'Karyawan F', 111000.00, 97500.00, '2025-06-03 04:35:56', '2025-06-03 04:35:56', 13500);

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_05_30_023300_create_karyawans_table', 1),
(5, '2025_05_30_132116_create_personal_access_tokens_table', 1),
(6, '2025_06_01_022158_add_total_profit_to_karyawans_table', 2),
(7, '2025_06_02_043337_add_role_to_users_table', 3);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 1, 'api-token', 'd9de479a76aca7ac3f6f413d07f3b8464a1954a62f4edb9c8c0c4f3d4cfcc112', '[\"*\"]', NULL, NULL, '2025-06-01 18:21:46', '2025-06-01 18:21:46'),
(2, 'App\\Models\\User', 1, 'api-token', '56dd86fb1b3005edebeb1aeca6c43ceb2e38e2c275b588ea432668d66f6d005d', '[\"*\"]', NULL, NULL, '2025-06-01 18:29:26', '2025-06-01 18:29:26'),
(3, 'App\\Models\\User', 1, 'api-token', '783d275594cffa3bc50fe1df0b9364f95e74af891d458b79459dd450642d42cf', '[\"*\"]', NULL, NULL, '2025-06-01 18:32:03', '2025-06-01 18:32:03'),
(4, 'App\\Models\\User', 1, 'flutter_token', 'ba9f1658111aea950d45dccd4ff5bb5544d5b9285fb90376e6d3f28a08d0c7ad', '[\"*\"]', NULL, NULL, '2025-06-01 19:25:56', '2025-06-01 19:25:56'),
(5, 'App\\Models\\User', 1, 'flutter_token', '6e83a66feb0c4cc5be97a38efdb2a94c43213872b0b5875bcc2ebe2706ba2474', '[\"*\"]', NULL, NULL, '2025-06-01 19:27:00', '2025-06-01 19:27:00'),
(6, 'App\\Models\\User', 1, 'api-token', 'd8a226fb7ad64e7202609ccde9a3feafbf8a7c69db9673673eefbde86f9e189c', '[\"*\"]', NULL, NULL, '2025-06-01 21:36:10', '2025-06-01 21:36:10'),
(7, 'App\\Models\\User', 1, 'api-token', 'c7abb3c618d67dc104a82e1acf73605faafe38b8f51f6b17df8f67b3c1f01190', '[\"*\"]', NULL, NULL, '2025-06-02 06:06:43', '2025-06-02 06:06:43'),
(8, 'App\\Models\\User', 1, 'api-token', 'be4f608129836f40a14ade3f1262cc0d070079b87b277c433e5e76e8a9bdb7ce', '[\"*\"]', NULL, NULL, '2025-06-02 06:10:55', '2025-06-02 06:10:55'),
(9, 'App\\Models\\User', 1, 'api-token', '869ebdcd58bc617eb1f55966087909141767b879ad7e24dfc5f26825910c8061', '[\"*\"]', NULL, NULL, '2025-06-02 06:42:27', '2025-06-02 06:42:27'),
(10, 'App\\Models\\User', 1, 'api-token', '03554af9921a5f79701ba5d8c576c1bc9c18c02987f804c5b68295606cfe3cc2', '[\"*\"]', NULL, NULL, '2025-06-02 06:57:50', '2025-06-02 06:57:50'),
(11, 'App\\Models\\User', 1, 'api-token', 'bfb55cbec4465d34c5838f758a1d1a44aafb9ad094f822de45984e4a603d227f', '[\"*\"]', NULL, NULL, '2025-06-02 07:04:02', '2025-06-02 07:04:02'),
(12, 'App\\Models\\User', 1, 'api-token', 'ec4e895f32a00416d524dbe0bb726d980f729e075f698745e5a1076b7598b35e', '[\"*\"]', NULL, NULL, '2025-06-02 07:04:47', '2025-06-02 07:04:47'),
(13, 'App\\Models\\User', 1, 'api-token', 'd0fc389552314b9eeef64e61af6e6e4d2db896fc0704d723e7487ce16f9fb4d3', '[\"*\"]', NULL, NULL, '2025-06-02 07:10:55', '2025-06-02 07:10:55'),
(14, 'App\\Models\\User', 1, 'api-token', '6584b705710e3b8d61805d511f7bcb319edc2dc9ee00b50c152ae914e27bde83', '[\"*\"]', NULL, NULL, '2025-06-02 07:12:23', '2025-06-02 07:12:23'),
(15, 'App\\Models\\User', 1, 'api-token', 'ddab8bd2d4134e28b994cad586300f8f9888720ebe20a1574dd6e2c2f8d9e271', '[\"*\"]', NULL, NULL, '2025-06-02 18:24:48', '2025-06-02 18:24:48'),
(16, 'App\\Models\\User', 1, 'api-token', '84de2197d0cf05851cadb5502795f10869ac29d4f987106f56f67a2ddc6f261c', '[\"*\"]', NULL, NULL, '2025-06-02 18:26:26', '2025-06-02 18:26:26'),
(17, 'App\\Models\\User', 1, 'api-token', '9a88f05a936cf1f3d69aa489328fc8ce3ece1d98da1082a7788dce109f3d4d6f', '[\"*\"]', NULL, NULL, '2025-06-02 18:27:22', '2025-06-02 18:27:22'),
(18, 'App\\Models\\User', 1, 'api-token', 'f49c0c6b37e72651e0baec55d62b59e848bda49957212e3092bf8a67a141d577', '[\"*\"]', NULL, NULL, '2025-06-02 18:28:09', '2025-06-02 18:28:09'),
(19, 'App\\Models\\User', 1, 'api-token', '1650135651b7d3d70a8dda594d0d6cc09b4da17a7759a68132e1b5385fe755b9', '[\"*\"]', NULL, NULL, '2025-06-02 18:30:23', '2025-06-02 18:30:23'),
(20, 'App\\Models\\User', 1, 'api-token', '8e0000f6e3e6bde6069547c7a8a02869c47e398122cd46e4f754700d3e420bf1', '[\"*\"]', NULL, NULL, '2025-06-02 18:41:33', '2025-06-02 18:41:33'),
(21, 'App\\Models\\User', 1, 'flutter-token', '18da2e1e5dbe959c449ffedc7bf4a897487d75edaa7b01194d9db68469887308', '[\"*\"]', '2025-06-02 19:09:23', NULL, '2025-06-02 19:09:23', '2025-06-02 19:09:23'),
(22, 'App\\Models\\User', 1, 'flutter-token', '6e59393cfe8136f6e0e2c7fd43a79f865b6e1ff8d34cbf6bab5b64ce1625a936', '[\"*\"]', '2025-06-02 19:18:53', NULL, '2025-06-02 19:18:52', '2025-06-02 19:18:53'),
(23, 'App\\Models\\User', 1, 'flutter-token', '057834705246b64788752ecc8c4988d3bb35f1240b69dc9bc58c04a6c5036950', '[\"*\"]', '2025-06-02 19:20:52', NULL, '2025-06-02 19:20:52', '2025-06-02 19:20:52'),
(24, 'App\\Models\\User', 1, 'flutter-token', '261566aa0397bbabbc8671205975ef5b622321a92e33e20eec18fcefb24be0e9', '[\"*\"]', '2025-06-02 19:35:27', NULL, '2025-06-02 19:35:26', '2025-06-02 19:35:27'),
(25, 'App\\Models\\User', 1, 'flutter-token', '1884678f951418b83a05853cf6f11a43138db862037e52c56818d48c5f67742e', '[\"*\"]', '2025-06-02 19:38:37', NULL, '2025-06-02 19:38:37', '2025-06-02 19:38:37'),
(26, 'App\\Models\\User', 1, 'flutter-token', 'e4962650cc669c503c2fe8f9c68e9c4ab6a9254b6af03ff5428c4e1837ca5d94', '[\"*\"]', '2025-06-02 19:42:29', NULL, '2025-06-02 19:42:28', '2025-06-02 19:42:29'),
(27, 'App\\Models\\User', 1, 'flutter-token', '1c927a30e604985a78c4b842081ee689c8700ace77cbcc4bc3dd793c7ae0e951', '[\"*\"]', '2025-06-02 19:48:29', NULL, '2025-06-02 19:48:28', '2025-06-02 19:48:29'),
(28, 'App\\Models\\User', 1, 'flutter-token', '859f23f343630be5575f29e08c511693a52eae85e75205c130413c21e32b4901', '[\"*\"]', '2025-06-03 04:39:42', NULL, '2025-06-03 04:39:41', '2025-06-03 04:39:42');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('95X8UBtHDMK3EHALv1KguQWEFoCgxAidn6cRZtYI', NULL, '192.168.1.5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYThrMkRCYnJNcG8zZkpDaDNnSTA2RnlnOXYzamZCZFEzOUFCemR6ViI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly8xOTIuMTY4LjEuNTo4MDAwIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1748827061),
('B0kzb2qrJDLX9xhKvpZgjyeu1pS1aGxtlIYpwIUC', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoic0IzZmx0b1JJY2tmYUgxT1ZmOG5TZjhyUmppZWg2TzFWWUhYTDBMSyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1748653066),
('OmH0xfZZcOiQREnc4MG9E6LMINOvdxD4LoGUVzjm', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYjhPSUpIUjlKVjFQbXNQb0RMQkVSTXFKdE92NDRWR1VKZGp5b3RVeiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1748612589);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `role` varchar(255) NOT NULL DEFAULT 'user'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`, `role`) VALUES
(1, 'Admin', 'admin@example.com', NULL, '$2y$12$w0M0Czd0v5aOxJCBudzlOu/EDdWTeINZsKWOXwKqaiENtmfZ5MaZq', NULL, '2025-06-01 03:19:05', '2025-06-01 03:19:05', 'admin');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `karyawans`
--
ALTER TABLE `karyawans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `karyawans`
--
ALTER TABLE `karyawans`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
