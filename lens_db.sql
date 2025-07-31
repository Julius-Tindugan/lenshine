-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 28, 2025 at 04:16 PM
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
-- Database: `lens_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `addons`
--

CREATE TABLE `addons` (
  `addon_id` int(11) NOT NULL,
  `addon_name` varchar(100) NOT NULL,
  `addon_price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `addons`
--

INSERT INTO `addons` (`addon_id`, `addon_name`, `addon_price`) VALUES
(1, 'Additional Person', 149.00),
(2, '4R Photo Print', 49.00),
(3, 'Plus 1 Backdrop', 49.00),
(4, 'Lighting Effect', 99.00),
(5, '32in number Balloon', 49.00),
(6, '5mins Extension', 99.00),
(7, 'Charge for Pets', 149.00),
(8, 'A4 Photo Print', 100.00);

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `booking_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `package_id` int(11) NOT NULL,
  `booking_label` varchar(50) DEFAULT NULL,
  `booking_date` date NOT NULL,
  `booking_time` time NOT NULL,
  `backdrop` varchar(50) DEFAULT NULL,
  `status` enum('pending','confirmed','paid','cancelled') DEFAULT 'pending',
  `created_at` datetime DEFAULT current_timestamp(),
  `total_amount` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`booking_id`, `user_id`, `package_id`, `booking_label`, `booking_date`, `booking_time`, `backdrop`, `status`, `created_at`, `total_amount`) VALUES
(1, 12, 1, 'Self-Shoot', '2025-07-29', '06:00:00', 'Sky Blue', 'paid', '2025-07-26 13:42:46', 546.00),
(2, 10, 1, 'Self-Shoot', '2025-07-30', '06:00:00', 'Sky Blue', 'paid', '2025-07-26 15:10:37', 696.00),
(3, 13, 1, 'Self-Shoot', '2025-07-28', '02:00:00', 'Light Yellow', 'paid', '2025-07-26 15:14:07', 794.00),
(4, 15, 1, 'Self-Shoot', '2025-07-26', '02:00:00', 'Sky Blue', 'paid', '2025-07-26 16:10:16', 597.00),
(5, 12, 1, 'Self-Shoot', '2025-07-27', '10:00:00', 'Sky Blue', 'pending', '2025-07-26 16:29:06', 399.00);

-- --------------------------------------------------------

--
-- Table structure for table `booking_addons`
--

CREATE TABLE `booking_addons` (
  `booking_id` int(11) NOT NULL,
  `addon_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `booking_addons`
--

INSERT INTO `booking_addons` (`booking_id`, `addon_id`) VALUES
(1, 2),
(1, 3),
(1, 5),
(2, 4),
(2, 5),
(2, 7),
(3, 1),
(3, 2),
(3, 3),
(3, 5),
(3, 6),
(4, 1),
(4, 2);

-- --------------------------------------------------------

--
-- Table structure for table `chat_messages`
--

CREATE TABLE `chat_messages` (
  `message_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `message_text` text NOT NULL,
  `is_bot` tinyint(1) NOT NULL,
  `sent_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `packages`
--

CREATE TABLE `packages` (
  `package_id` int(11) NOT NULL,
  `package_type` enum('Self-Shoot','Party','Wedding','Christening') NOT NULL,
  `title` varchar(100) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `image_asset` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `packages`
--

INSERT INTO `packages` (`package_id`, `package_type`, `title`, `price`, `image_asset`, `description`) VALUES
(1, 'Self-Shoot', 'Solo Package', 399.00, 'assets/images/solo.png', NULL),
(2, 'Self-Shoot', 'Kids Package', 499.00, 'assets/images/kid.png', NULL),
(3, 'Self-Shoot', 'Graduation Package', 499.00, 'assets/images/grad.jpg', NULL),
(4, 'Self-Shoot', 'Duo Package', 599.00, 'assets/images/duo.jpg', NULL),
(5, 'Self-Shoot', 'Barkada Package', 799.00, 'assets/images/group.jpg', NULL),
(6, 'Self-Shoot', 'Fam One Package', 799.00, 'assets/images/family.jpg', NULL),
(7, 'Self-Shoot', 'Fam Two Package', 999.00, 'assets/images/famtwo.png', NULL),
(8, 'Self-Shoot', 'Fam Three Package', 1199.00, 'assets/images/famthree.png', NULL),
(9, 'Self-Shoot', 'Fam Four Package', 2199.00, 'assets/images/famfour.png', NULL),
(10, 'Party', 'Kids Party', 9000.00, 'assets/images/kidsparty.png', NULL),
(11, 'Party', 'Birthday Party', 9000.00, 'assets/images/birthday.png', NULL),
(12, 'Party', 'Debutant', 12000.00, 'assets/images/debut.png', NULL),
(13, 'Wedding', 'Civil Wedding', 5000.00, 'assets/images/civil.png', NULL),
(14, 'Wedding', 'Church Wedding', 7500.00, 'assets/images/church.png', NULL),
(15, 'Christening', 'Christening', 300.00, 'assets/images/christening_placeholder.png', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `package_free_items`
--

CREATE TABLE `package_free_items` (
  `free_item_id` int(11) NOT NULL,
  `package_id` int(11) NOT NULL,
  `free_item_text` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `package_free_items`
--

INSERT INTO `package_free_items` (`free_item_id`, `package_id`, `free_item_text`) VALUES
(1, 1, 'ALL soft copies'),
(2, 1, '1 4r size print'),
(3, 2, 'ALL Soft Copies'),
(4, 2, 'Two 4R Size Print'),
(5, 2, 'Number Balloon'),
(6, 3, 'ALL Soft Copies'),
(7, 3, 'Hard Copies'),
(8, 4, 'ALL Soft Copies'),
(9, 4, 'Two 4R Size Print'),
(10, 5, 'ALL Soft Copies'),
(11, 5, 'Four 4R Size Print'),
(12, 6, 'ALL Soft Copies'),
(13, 6, 'Two 4R Size Print'),
(14, 6, 'One A4 Size Print'),
(15, 7, 'ALL Soft Copies'),
(16, 7, 'Two 4R Size Print'),
(17, 7, 'One A4 Size Print'),
(18, 8, 'ALL Soft Copies'),
(19, 8, 'Four 4R Size Print'),
(20, 8, 'Two A4 Size Print'),
(21, 9, 'ALL Soft Copies'),
(22, 9, 'Four 4R Size Print'),
(23, 9, 'Two A4 Size Print');

-- --------------------------------------------------------

--
-- Table structure for table `package_inclusions`
--

CREATE TABLE `package_inclusions` (
  `inclusion_id` int(11) NOT NULL,
  `package_id` int(11) NOT NULL,
  `inclusion_text` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `package_inclusions`
--

INSERT INTO `package_inclusions` (`inclusion_id`, `package_id`, `inclusion_text`) VALUES
(1, 1, '20 mins shoot'),
(2, 1, 'Unlimited Shots'),
(3, 1, '1 Backdrop'),
(4, 1, '10 mins Photo Selection'),
(5, 2, 'Kids up to 7 years old'),
(6, 2, 'One Backdrop'),
(7, 2, '10 Mins Photo Selection'),
(8, 2, '2pc Single 4R or 2pc Collage 4R'),
(9, 3, 'Solo Package'),
(10, 3, '1 Backdrop'),
(11, 3, '1 A4 Size Print'),
(12, 3, '1 4R Size Print'),
(13, 3, '4 Wallet Size Print'),
(14, 4, '2 Persons'),
(15, 4, '20 Minutes'),
(16, 4, 'Unlimited shots'),
(17, 4, 'One Backdrop'),
(18, 4, '10 Mins Photo Selection'),
(19, 5, '3-4 Persons'),
(20, 5, '20 Minutes'),
(21, 5, 'Unlimited Slots'),
(22, 5, 'One Backdrop'),
(23, 5, '10 Mins Photo Selection'),
(24, 6, '3-4 Persons'),
(25, 6, '20 Minutes'),
(26, 6, 'Unlimited Slots'),
(27, 6, 'One Backdrop'),
(28, 6, '10 Mins Photo Selection'),
(29, 7, '5-6 Persons'),
(30, 7, '20 Minutes'),
(31, 7, 'Unlimited Slots'),
(32, 7, 'Two Backdrop'),
(33, 7, '10 Mins Photo Selection'),
(34, 8, '7-9 Persons'),
(35, 8, '20 Minutes'),
(36, 8, 'Unlimited Slots'),
(37, 8, 'Two Backdrop'),
(38, 8, '10 Mins Photo Selection'),
(39, 9, '10-15 Persons'),
(40, 9, '40 Minutes'),
(41, 9, 'Unlimited Slots'),
(42, 9, 'Two Backdrop'),
(43, 9, '10 Mins Photo Selection'),
(44, 10, '2-3 Hours Photo Coverage'),
(45, 10, 'Pre-Event Photoshoot'),
(46, 10, '200 - 300+ Soft Copies'),
(47, 10, 'All Copies Enhanced Sent'),
(48, 10, 'Sent Via Google Drive'),
(49, 10, 'Online Gallery Posted'),
(50, 11, '2-3 Hours Photo Coverage'),
(51, 11, 'Pre-Event Photoshoot'),
(52, 11, '200 - 300+ Soft Copies'),
(53, 11, 'All Copies Enhanced Sent'),
(54, 11, 'Sent Via Google Drive'),
(55, 11, 'Online Gallery Posted'),
(56, 12, 'Full Event Coverage'),
(57, 12, 'Pre-Event Photoshoot'),
(58, 12, '200 - 300+ Soft Copies'),
(59, 12, 'All Copies Enhanced Sent'),
(60, 12, 'Sent Via Google Drive'),
(61, 12, 'Online Gallery Posted'),
(62, 13, 'Full Event Coverage'),
(63, 13, 'Pre-Event Photoshoot'),
(64, 13, '200 - 300+ Soft Copies'),
(65, 13, 'All Copies Enhanced Sent'),
(66, 13, 'Sent Via Google Drive'),
(67, 13, 'Online Gallery Posted'),
(68, 14, 'Full Event Coverage'),
(69, 14, 'Pre-Event Photoshoot'),
(70, 14, '200 - 300+ Soft Copies'),
(71, 14, 'All Copies Enhanced Sent'),
(72, 14, 'Sent Via Google Drive'),
(73, 14, 'Online Gallery Posted'),
(74, 15, '2-3 Hours Photo Coverage'),
(75, 15, 'Pre-Event Photoshoot'),
(76, 15, '200 - 300+ Soft Copies'),
(77, 15, 'All Copies Enhanced Sent'),
(78, 15, 'Sent Via Google Drive'),
(79, 15, 'Online Gallery Posting');

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_codes`
--

CREATE TABLE `password_reset_codes` (
  `code_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `code` varchar(10) NOT NULL,
  `expires_at` datetime NOT NULL,
  `used` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `payment_id` int(11) NOT NULL,
  `booking_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_method` enum('GCash','Cash','Card') NOT NULL,
  `proof_image` varchar(255) DEFAULT NULL,
  `status` enum('pending','confirmed','failed') DEFAULT 'pending',
  `paid_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`payment_id`, `booking_id`, `amount`, `payment_method`, `proof_image`, `status`, `paid_at`) VALUES
(5, 5, 399.00, 'GCash', NULL, 'pending', '2025-07-26 02:21:48'),
(6, 7, 399.00, 'GCash', NULL, 'pending', '2025-07-26 03:25:20'),
(7, 1, 546.00, 'GCash', '/data/user/0/com.example.lenshine/cache/c148a0c5-a035-42f1-acfe-73d85b6743a0/33.jpg', 'pending', '2025-07-26 13:42:46'),
(8, 2, 696.00, 'GCash', NULL, 'pending', '2025-07-26 15:10:37'),
(9, 3, 794.00, 'GCash', '/data/user/0/com.example.lenshine/cache/73ffbee5-5839-4724-aefe-93fd7a93ef0a/1000001352.jpg', 'pending', '2025-07-26 15:14:07'),
(10, 4, 597.00, 'GCash', '/data/user/0/com.example.lenshine/cache/21acab53-5ea4-444f-a1f9-bfb9dec6e29e/33.jpg', 'pending', '2025-07-26 16:10:16');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES
(4, 'Julius', 'Tindugan', 'juliustindugan14@gmail.com', '9502508428', '$2b$10$AXcTpC3Nb30MEhn64pZMjewzWKziBDaUu7RUPe2KHpr7PmhlGmimO', '2025-07-13 00:11:32'),
(5, 'Julius', 'T', 'jct@g.co', '90673983743', '$2b$10$lua0Q0A3jBWb0vKXDVKbReW1bOMv3vU2YTcAKDmschTT9W7qCg2.a', '2025-07-15 21:11:46'),
(6, 'Julius', 'Castillo', '22-36455@g.batstate-u.edu.ph', '9502056783', '$2b$10$kXraLJpOB3PQ7EyYVQvMH.xVDn7FCLjFMPrF0/Rv81Ehe0TLrlT5O', '2025-07-15 23:27:10'),
(7, 'julius', 't', 'jct@g.com.ph', '9568326595', '$2b$10$ZzJcTOuGP4PUMTlKOpwS8usW22XrmDRkUFXbdtJ78GqO4qADhZP3y', '2025-07-16 03:31:28'),
(8, 'Julius', 'Castillo', 'juliusctindugan@gmail.com', '9502508428', '$2b$10$nlXFz92dUtEcXem8gLn1xeUi5ZwgPSdMN6w0MOhxyanGH6iuwgMm2', '2025-07-21 22:49:30'),
(9, 'Julius', 'Tindugan', 'juliustindugan11@gmail.com', '9076789876', '$2b$10$dFsZIr1l6yYY4RSbBPTnouSx3HW7BkSEbwyMIQHnTDKoimypKXJla', '2025-07-22 01:48:09'),
(10, 'julius', 'castillo', 'jcc@g.coo', '9873867933', '$2a$10$i2bXtoOPskuT9WYpBu/j.OMGE9s1ih5yPqpVKwpvtKb8qMEPaZeYm', '2025-07-25 18:46:43'),
(11, 'Julius', 'C', 'jc@g.co', '95023834783', '$2b$10$x2WLFmOhLT2RqcMhMTWtGughYPDn0FckRYxupbc.ob.L/8Xz0I0V6', '2025-07-26 05:50:37'),
(12, 'kristine', 'merylle', '22-33846@g.batstate-u.edu.ph', '9385315810', '$2b$10$VqIDHibN9IeNxJKCsBP1b.lMoc5nSCazKdgIfHwgcYomc3QXtl5B2', '2025-07-26 12:00:24'),
(13, 'jcti', 'jcc', 'jcc@g.cooo', '9532689564', '$2a$10$yU7GgiQNppogAuT4FSBHS./70uAtIqAAd3ikOFGfNALy6kumJX.VK', '2025-07-26 15:13:10'),
(15, 'Mark', 'Arguelles', 'mark@gmail.com', '9609847658', '$2a$10$1hjr4cajRL8enfMyXggpPOJr6tEAmXecmkToGrkA9ap9tnEK00KIi', '2025-07-26 16:06:23');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addons`
--
ALTER TABLE `addons`
  ADD PRIMARY KEY (`addon_id`);

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`booking_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `package_id` (`package_id`);

--
-- Indexes for table `booking_addons`
--
ALTER TABLE `booking_addons`
  ADD PRIMARY KEY (`booking_id`,`addon_id`),
  ADD KEY `addon_id` (`addon_id`);

--
-- Indexes for table `chat_messages`
--
ALTER TABLE `chat_messages`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `packages`
--
ALTER TABLE `packages`
  ADD PRIMARY KEY (`package_id`);

--
-- Indexes for table `package_free_items`
--
ALTER TABLE `package_free_items`
  ADD PRIMARY KEY (`free_item_id`),
  ADD KEY `package_id` (`package_id`);

--
-- Indexes for table `package_inclusions`
--
ALTER TABLE `package_inclusions`
  ADD PRIMARY KEY (`inclusion_id`),
  ADD KEY `package_id` (`package_id`);

--
-- Indexes for table `password_reset_codes`
--
ALTER TABLE `password_reset_codes`
  ADD PRIMARY KEY (`code_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `booking_id` (`booking_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `addons`
--
ALTER TABLE `addons`
  MODIFY `addon_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `booking_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `chat_messages`
--
ALTER TABLE `chat_messages`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `packages`
--
ALTER TABLE `packages`
  MODIFY `package_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `package_free_items`
--
ALTER TABLE `package_free_items`
  MODIFY `free_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `package_inclusions`
--
ALTER TABLE `package_inclusions`
  MODIFY `inclusion_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=80;

--
-- AUTO_INCREMENT for table `password_reset_codes`
--
ALTER TABLE `password_reset_codes`
  MODIFY `code_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`package_id`) REFERENCES `packages` (`package_id`);

--
-- Constraints for table `booking_addons`
--
ALTER TABLE `booking_addons`
  ADD CONSTRAINT `booking_addons_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `booking_addons_ibfk_2` FOREIGN KEY (`addon_id`) REFERENCES `addons` (`addon_id`);

--
-- Constraints for table `chat_messages`
--
ALTER TABLE `chat_messages`
  ADD CONSTRAINT `chat_messages_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `package_free_items`
--
ALTER TABLE `package_free_items`
  ADD CONSTRAINT `package_free_items_ibfk_1` FOREIGN KEY (`package_id`) REFERENCES `packages` (`package_id`) ON DELETE CASCADE;

--
-- Constraints for table `package_inclusions`
--
ALTER TABLE `package_inclusions`
  ADD CONSTRAINT `package_inclusions_ibfk_1` FOREIGN KEY (`package_id`) REFERENCES `packages` (`package_id`) ON DELETE CASCADE;

--
-- Constraints for table `password_reset_codes`
--
ALTER TABLE `password_reset_codes`
  ADD CONSTRAINT `password_reset_codes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
