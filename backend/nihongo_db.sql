-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 11, 2026 at 07:30 AM
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
-- Database: `nihongo_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `alembic_version`
--

CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `alembic_version`
--

INSERT INTO `alembic_version` (`version_num`) VALUES
('69e963bb7b7b');

-- --------------------------------------------------------

--
-- Table structure for table `audio_assets`
--

CREATE TABLE `audio_assets` (
  `file_path` varchar(512) NOT NULL,
  `file_url` varchar(512) NOT NULL,
  `duration_seconds` int(11) DEFAULT NULL,
  `transcript` text DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audio_assets`
--

INSERT INTO `audio_assets` (`file_path`, `file_url`, `duration_seconds`, `transcript`, `id`, `created_at`, `updated_at`) VALUES
('data\\uploads\\audio\\mock_audio_1_1.mp3', '/api/v1/content/audio/mock-1-1', 5, 'Transcript 1-1', '0111c833-9f18-453e-a2ea-5958f8f70572', '2026-07-11 03:03:59', '2026-07-11 03:03:59'),
('data\\uploads\\audio\\mock_audio_1_0.mp3', '/api/v1/content/audio/mock-1-0', 5, 'Transcript 1-0', '01ac9bca-44a6-469c-9a1b-c91100cc2b92', '2026-07-11 03:03:59', '2026-07-11 03:03:59'),
('data\\uploads\\audio\\mock_audio_16_1.mp3', '/api/v1/content/audio/mock-16-1', 5, 'Transcript 16-1', '0a432f94-3764-4ed5-9ed4-0ed47c935296', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('data\\uploads\\audio\\mock_audio_7_0.mp3', '/api/v1/content/audio/mock-7-0', 5, 'Transcript 7-0', '0e4b3fb2-e27a-4758-9143-e697d59451a6', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('data\\uploads\\audio\\mock_audio_10_1.mp3', '/api/v1/content/audio/mock-10-1', 5, 'Transcript 10-1', '121b80ca-d63e-43fb-af41-29b54ef6143f', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('data\\uploads\\audio\\mock_audio_12_1.mp3', '/api/v1/content/audio/mock-12-1', 5, 'Transcript 12-1', '17a3ac0f-7451-4d9c-9e5b-c3dc52d8c542', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('data\\uploads\\audio\\mock_audio_27_1.mp3', '/api/v1/content/audio/mock-27-1', 5, 'Transcript 27-1', '2125f063-7e57-4611-ae52-cc7c636c06d5', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('data\\uploads\\audio\\mock_audio_2_0.mp3', '/api/v1/content/audio/mock-2-0', 5, 'Transcript 2-0', '2451f6d0-2c37-4bcd-a909-6662c862f50b', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('data\\uploads\\audio\\mock_audio_19_1.mp3', '/api/v1/content/audio/mock-19-1', 5, 'Transcript 19-1', '2767b408-0df6-4491-a998-04b67b81880f', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('data/uploads/audio\\6d45a65b9178074170d4cb2422ee2acfaf66257031c8120bee9c14a2e778bff8.mp3', '/api/v1/content/audio/2ac9c3ac-1c9f-4bb9-83c2-389b983ac681', 0, 'This is a test transcript', '2ac9c3ac-1c9f-4bb9-83c2-389b983ac681', '2026-07-11 04:40:20', '2026-07-11 04:40:20'),
('data\\uploads\\audio\\mock_audio_1_1.mp3', '/api/v1/content/audio/mock-1-1', 5, 'Transcript 1-1', '2b5fb712-dbff-4b8c-b39d-11abdf458aa2', '2026-07-11 03:02:52', '2026-07-11 03:02:52'),
('data\\uploads\\audio\\mock_audio_18_1.mp3', '/api/v1/content/audio/mock-18-1', 5, 'Transcript 18-1', '2c1897f5-ba20-4bd4-b7b5-71f232cf60a6', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('data\\uploads\\audio\\mock_audio_10_0.mp3', '/api/v1/content/audio/mock-10-0', 5, 'Transcript 10-0', '30c29521-4ab9-45d0-be15-2b0d0cda8f5d', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('data\\uploads\\audio\\mock_audio_1_0.mp3', '/api/v1/content/audio/mock-1-0', 5, 'Transcript 1-0', '313bb95a-3747-4c42-b3e8-835928e106ea', '2026-07-11 03:02:52', '2026-07-11 03:02:52'),
('data/uploads/audio\\bf576d72318089610b88c05cea50175d8b980b3a839ec926e940f66fea98403f.mp3', '/api/v1/content/audio/36782149-9bc0-4fa3-9e38-aea17dd22b7c', 0, 'This is a test transcript', '36782149-9bc0-4fa3-9e38-aea17dd22b7c', '2026-07-10 15:26:44', '2026-07-10 15:26:44'),
('data\\uploads\\audio\\mock_audio_17_0.mp3', '/api/v1/content/audio/mock-17-0', 5, 'Transcript 17-0', '3d4cfa87-3fa5-4de2-bdb9-b9124a3730a2', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('data\\uploads\\audio\\mock_audio_4_1.mp3', '/api/v1/content/audio/mock-4-1', 5, 'Transcript 4-1', '3fc6ee23-df1c-4ea9-8a19-b34b2ec3f222', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('data\\uploads\\audio\\mock_audio_22_0.mp3', '/api/v1/content/audio/mock-22-0', 5, 'Transcript 22-0', '4a362727-75fb-49d6-8852-f5eea7995579', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('data\\uploads\\audio\\mock_audio_9_1.mp3', '/api/v1/content/audio/mock-9-1', 5, 'Transcript 9-1', '4dd4cd12-466f-48b2-9da6-a0cd6f0ba059', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('data\\uploads\\audio\\mock_audio_25_1.mp3', '/api/v1/content/audio/mock-25-1', 5, 'Transcript 25-1', '4e76f161-deeb-46e8-a502-24965feb8cc3', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('data\\uploads\\audio\\mock_audio_15_0.mp3', '/api/v1/content/audio/mock-15-0', 5, 'Transcript 15-0', '52515e5a-4a34-4fb2-89a8-994eed8d95ef', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('data\\uploads\\audio\\mock_audio_15_1.mp3', '/api/v1/content/audio/mock-15-1', 5, 'Transcript 15-1', '546198fc-8c1b-4125-b3ec-40b4ead45b8f', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('data/uploads/audio\\df4221a069c3635d64b4e3a90b3cc774150f7b7d60f4c97a84be2d3b2cff4a48.mp3', '/api/v1/content/audio/54651893-2b82-4400-a63a-3ebb0a907628', 0, NULL, '54651893-2b82-4400-a63a-3ebb0a907628', '2026-07-10 15:22:31', '2026-07-10 15:22:31'),
('data\\uploads\\audio\\mock_audio_24_0.mp3', '/api/v1/content/audio/mock-24-0', 5, 'Transcript 24-0', '58b1ba55-2a06-4e83-84b4-66f9cdca46a9', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('data\\uploads\\audio\\mock_audio_16_0.mp3', '/api/v1/content/audio/mock-16-0', 5, 'Transcript 16-0', '69b5f18d-f6bf-48c5-9425-b56568d57808', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('data\\uploads\\audio\\mock_audio_30_0.mp3', '/api/v1/content/audio/mock-30-0', 5, 'Transcript 30-0', '6b0c654b-8af8-4f63-bc15-4771099e00d5', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('data\\uploads\\audio\\mock_audio_23_1.mp3', '/api/v1/content/audio/mock-23-1', 5, 'Transcript 23-1', '6c7b1f8b-d311-4e0c-abe3-030aa46a830f', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('data\\uploads\\audio\\mock_audio_27_0.mp3', '/api/v1/content/audio/mock-27-0', 5, 'Transcript 27-0', '6d45a0ac-f442-496c-86bb-231825714dbc', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('data\\uploads\\audio\\mock_audio_13_0.mp3', '/api/v1/content/audio/mock-13-0', 5, 'Transcript 13-0', '74463b36-8680-4828-abb1-313340f72bc4', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('data\\uploads\\audio\\mock_audio_1_0.mp3', '/api/v1/content/audio/mock-1-0', 5, 'Transcript 1-0', '7907fa4f-7046-4ae0-b4e5-09d7c447bfa7', '2026-07-11 03:03:17', '2026-07-11 03:03:17'),
('data\\uploads\\audio\\mock_audio_5_1.mp3', '/api/v1/content/audio/mock-5-1', 5, 'Transcript 5-1', '79744a61-e2f7-409c-8286-99dd06dcbab1', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('data\\uploads\\audio\\mock_audio_28_0.mp3', '/api/v1/content/audio/mock-28-0', 5, 'Transcript 28-0', '7a5b83b9-292b-47a1-abd6-df9340193e89', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('data/uploads/audio\\d70467dc00fdcb6bf8752e9bc0506a6406b2fd1b1878a0333552647db19b57d0.mp3', '/api/v1/content/audio/81772798-68fe-48a8-bdc3-45254b088ed0', 0, 'This is a test transcript', '81772798-68fe-48a8-bdc3-45254b088ed0', '2026-07-10 15:26:56', '2026-07-10 15:26:56'),
('data\\uploads\\audio\\mock_audio_20_1.mp3', '/api/v1/content/audio/mock-20-1', 5, 'Transcript 20-1', '81f1cd1d-20fa-44d7-aa5c-6683e21d0b36', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('data\\uploads\\audio\\mock_audio_14_1.mp3', '/api/v1/content/audio/mock-14-1', 5, 'Transcript 14-1', '83bd8ed4-cb89-4b95-b604-0865e7696fb8', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('data\\uploads\\audio\\mock_audio_14_0.mp3', '/api/v1/content/audio/mock-14-0', 5, 'Transcript 14-0', '848cbd0a-7ff3-4d45-abc8-ca2564558ebb', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('data\\uploads\\audio\\mock_audio_4_0.mp3', '/api/v1/content/audio/mock-4-0', 5, 'Transcript 4-0', '870cbec5-4b09-46f8-aace-a0fa4892ff59', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('data\\uploads\\audio\\mock_audio_13_1.mp3', '/api/v1/content/audio/mock-13-1', 5, 'Transcript 13-1', '8921bedf-43c2-4f6d-b0b4-24ab7cddf068', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('data\\uploads\\audio\\mock_audio_7_1.mp3', '/api/v1/content/audio/mock-7-1', 5, 'Transcript 7-1', '917e4ab5-3275-45d4-843c-3cc6c64c46c7', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('data\\uploads\\audio\\mock_audio_9_0.mp3', '/api/v1/content/audio/mock-9-0', 5, 'Transcript 9-0', '923cab15-2756-4f92-b031-52a55996183c', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('data\\uploads\\audio\\mock_audio_19_0.mp3', '/api/v1/content/audio/mock-19-0', 5, 'Transcript 19-0', 'a38d3eb0-e35c-4ab3-beeb-2d50fee1a4c3', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('data\\uploads\\audio\\mock_audio_23_0.mp3', '/api/v1/content/audio/mock-23-0', 5, 'Transcript 23-0', 'a41c5f11-d9e3-4e36-a76a-f2c341b03007', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('data\\uploads\\audio\\mock_audio_2_1.mp3', '/api/v1/content/audio/mock-2-1', 5, 'Transcript 2-1', 'a44d0733-b906-4381-b958-2c3fbeab3a6c', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('data\\uploads\\audio\\mock_audio_11_1.mp3', '/api/v1/content/audio/mock-11-1', 5, 'Transcript 11-1', 'a842032f-e7e4-4594-8cba-cdf7992740e1', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('data\\uploads\\audio\\mock_audio_29_1.mp3', '/api/v1/content/audio/mock-29-1', 5, 'Transcript 29-1', 'abe0e559-a4ec-4316-b6d1-7e0f65a48c2b', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('data\\uploads\\audio\\mock_audio_11_0.mp3', '/api/v1/content/audio/mock-11-0', 5, 'Transcript 11-0', 'ad259c2b-84bd-4903-8d29-600e26c3b514', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('data\\uploads\\audio\\mock_audio_18_0.mp3', '/api/v1/content/audio/mock-18-0', 5, 'Transcript 18-0', 'aea999ac-e627-48b0-ac5a-9ac142cfe1fc', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('data\\uploads\\audio\\mock_audio_25_0.mp3', '/api/v1/content/audio/mock-25-0', 5, 'Transcript 25-0', 'b13c589a-ed14-49b8-82d6-c634c74deaca', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('data\\uploads\\audio\\mock_audio_22_1.mp3', '/api/v1/content/audio/mock-22-1', 5, 'Transcript 22-1', 'b5208d46-5fc8-47c4-a351-cdb0d3004b2c', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('data\\uploads\\audio\\mock_audio_3_0.mp3', '/api/v1/content/audio/mock-3-0', 5, 'Transcript 3-0', 'b5a7e92a-7c4a-4582-a446-e6098da27b9b', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('data\\uploads\\audio\\mock_audio_17_1.mp3', '/api/v1/content/audio/mock-17-1', 5, 'Transcript 17-1', 'b6dbb6dd-d309-452a-bb0b-0d75fdd27814', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('data\\uploads\\audio\\mock_audio_20_0.mp3', '/api/v1/content/audio/mock-20-0', 5, 'Transcript 20-0', 'bb5a91fa-fa78-4f1d-b06d-41cd49cde2de', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('data\\uploads\\audio\\mock_audio_30_1.mp3', '/api/v1/content/audio/mock-30-1', 5, 'Transcript 30-1', 'bdbbf28c-3dce-4efd-afce-b273e2b0c293', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('data\\uploads\\audio\\mock_audio_24_1.mp3', '/api/v1/content/audio/mock-24-1', 5, 'Transcript 24-1', 'be1b1fcf-57ca-46a2-9c79-3fb7da4499ca', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('data\\uploads\\audio\\mock_audio_3_1.mp3', '/api/v1/content/audio/mock-3-1', 5, 'Transcript 3-1', 'bedfcd95-6d31-4e70-8648-5e0d27b58a6b', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('data\\uploads\\audio\\mock_audio_12_0.mp3', '/api/v1/content/audio/mock-12-0', 5, 'Transcript 12-0', 'c5d6d365-7125-49ce-b649-e5ea72cef41e', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('data\\uploads\\audio\\mock_audio_26_0.mp3', '/api/v1/content/audio/mock-26-0', 5, 'Transcript 26-0', 'ce218880-9128-478c-8a74-88a7c1a44506', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('data\\uploads\\audio\\mock_audio_21_0.mp3', '/api/v1/content/audio/mock-21-0', 5, 'Transcript 21-0', 'ced95f5e-b5a1-4eab-8841-0e48e0483015', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('data\\uploads\\audio\\mock_audio_29_0.mp3', '/api/v1/content/audio/mock-29-0', 5, 'Transcript 29-0', 'd03d21f8-1f1c-4ebc-863a-abdff9299b11', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('data\\uploads\\audio\\mock_audio_6_1.mp3', '/api/v1/content/audio/mock-6-1', 5, 'Transcript 6-1', 'd4226b8b-9f60-4f30-b241-2fb9f0d565d6', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('data\\uploads\\audio\\mock_audio_8_0.mp3', '/api/v1/content/audio/mock-8-0', 5, 'Transcript 8-0', 'd90f0dfa-6cd3-4074-b284-1dd44c25c41c', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('data\\uploads\\audio\\mock_audio_26_1.mp3', '/api/v1/content/audio/mock-26-1', 5, 'Transcript 26-1', 'dfaf0df9-c967-4ce6-a4cf-41265455ea02', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('data\\uploads\\audio\\mock_audio_8_1.mp3', '/api/v1/content/audio/mock-8-1', 5, 'Transcript 8-1', 'e0e5732e-7327-49ce-866c-e3d3b051b8c9', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('data/uploads/audio\\d75e023ec2141910ecd8edefc4409ca9b6dbde42e6e3250213ad5b3883d2e987.mp3', '/api/v1/content/audio/e6154cf4-d27d-4c1a-bf8b-d4cc0b31f102', 0, 'This is a test transcript', 'e6154cf4-d27d-4c1a-bf8b-d4cc0b31f102', '2026-07-11 04:22:40', '2026-07-11 04:22:40'),
('data\\uploads\\audio\\mock_audio_5_0.mp3', '/api/v1/content/audio/mock-5-0', 5, 'Transcript 5-0', 'e715390f-3da3-4693-be97-09a2c2a333af', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('data\\uploads\\audio\\mock_audio_28_1.mp3', '/api/v1/content/audio/mock-28-1', 5, 'Transcript 28-1', 'e74f8e6f-e4ad-4ca5-986d-0f62c3e2bc0c', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('data\\uploads\\audio\\mock_audio_6_0.mp3', '/api/v1/content/audio/mock-6-0', 5, 'Transcript 6-0', 'f66e1f87-091d-4782-b6d4-40ffc39de1b0', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('data\\uploads\\audio\\mock_audio_21_1.mp3', '/api/v1/content/audio/mock-21-1', 5, 'Transcript 21-1', 'f7cae698-253a-4902-9799-5e04f512484a', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('data\\uploads\\audio\\mock_audio_1_1.mp3', '/api/v1/content/audio/mock-1-1', 5, 'Transcript 1-1', 'ff7404de-3e00-4580-a27c-0694fe810b22', '2026-07-11 03:03:17', '2026-07-11 03:03:17');

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `user_id` varchar(36) DEFAULT NULL,
  `action` varchar(255) NOT NULL,
  `entity_name` varchar(100) NOT NULL,
  `entity_id` varchar(36) NOT NULL,
  `details` text DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`user_id`, `action`, `entity_name`, `entity_id`, `details`, `created_at`, `id`, `updated_at`) VALUES
('8c059ab6-5a7d-4430-bcb2-3755623a3a0a', 'CREATE_AI_JOB', 'generation_jobs', '1c9d77ac-cad6-4691-9a39-ae1ad4178c91', 'Job Type: JobType.QUESTION_GENERATION', '2026-07-11 04:40:21', '050675f3-2732-4b36-af08-0d8be8dcacd4', '2026-07-11 04:40:21'),
('8c059ab6-5a7d-4430-bcb2-3755623a3a0a', 'CREATE_TTS_JOB', 'generation_jobs', 'b8c9674c-5776-4dc9-bc28-831eb8a468b7', 'Job Type: TTS_GENERATION', '2026-07-11 02:27:27', '25b21735-6890-4568-bdc8-360202b47746', '2026-07-11 02:27:27'),
('8c059ab6-5a7d-4430-bcb2-3755623a3a0a', 'CREATE_TTS_JOB', 'generation_jobs', '12e2574a-d600-4f59-9632-3f09e2819b81', 'Job Type: TTS_GENERATION', '2026-07-11 04:40:21', '25eec19f-31dd-4c2a-87c0-e698c9f9541c', '2026-07-11 04:40:21'),
('8c059ab6-5a7d-4430-bcb2-3755623a3a0a', 'CREATE_TTS_JOB', 'generation_jobs', '3d623cdb-fdd9-429a-bbb7-92360fc59d12', 'Job Type: TTS_GENERATION', '2026-07-11 02:28:44', '2f47bff6-6fef-434f-9b41-b63cf730f909', '2026-07-11 02:28:44'),
('8c059ab6-5a7d-4430-bcb2-3755623a3a0a', 'CREATE_AI_JOB', 'generation_jobs', '7c927e31-61e9-49f9-ae9e-531edceb94da', 'Job Type: JobType.QUESTION_GENERATION', '2026-07-11 02:25:43', '3335e20c-1bf1-4914-9872-9a30203f3dc0', '2026-07-11 02:25:43'),
('8c059ab6-5a7d-4430-bcb2-3755623a3a0a', 'CREATE_TTS_JOB', 'generation_jobs', '5aea3ab2-1a34-4a15-bd1a-64e2bae6c14e', 'Job Type: TTS_GENERATION', '2026-07-11 04:40:21', '4ad6431c-8cae-4e6a-b887-4eeee7e3044b', '2026-07-11 04:40:21'),
('8c059ab6-5a7d-4430-bcb2-3755623a3a0a', 'CREATE_TTS_JOB', 'generation_jobs', 'b9a308ad-ad82-442f-bd50-590fcda98cfe', 'Job Type: TTS_GENERATION', '2026-07-11 02:28:44', '569a8fa4-48dc-41cc-a3b0-8c6bc4a6813b', '2026-07-11 02:28:44'),
('8c059ab6-5a7d-4430-bcb2-3755623a3a0a', 'CREATE_AI_JOB', 'generation_jobs', '89605ca3-32fb-441b-b0fb-bdf117f6b7bc', 'Job Type: JobType.QUESTION_GENERATION', '2026-07-11 02:26:20', '581a4d71-13d0-4b47-8694-b86ee71498d0', '2026-07-11 02:26:20'),
('8c059ab6-5a7d-4430-bcb2-3755623a3a0a', 'CREATE_TTS_JOB', 'generation_jobs', '56a7e399-d48e-488a-8486-aa0cd06c26e5', 'Job Type: TTS_GENERATION', '2026-07-11 04:22:40', '5d347ce1-af91-465a-a101-76244d763933', '2026-07-11 04:22:40'),
('8c059ab6-5a7d-4430-bcb2-3755623a3a0a', 'CREATE_TTS_JOB', 'generation_jobs', '61d03ffb-a315-41e5-89b7-55aee02d2a00', 'Job Type: TTS_GENERATION', '2026-07-11 04:22:40', '633e5611-47f4-4ff0-947f-707adcc0d000', '2026-07-11 04:22:40'),
('8c059ab6-5a7d-4430-bcb2-3755623a3a0a', 'CREATE_AI_JOB', 'generation_jobs', 'a7de5980-d3c1-483e-825e-b7f74b72eeb6', 'Job Type: JobType.QUESTION_GENERATION', '2026-07-11 02:22:12', '69d8c50a-b18c-4698-8f1d-52e73f540222', '2026-07-11 02:22:12'),
('8c059ab6-5a7d-4430-bcb2-3755623a3a0a', 'CREATE_TTS_JOB', 'generation_jobs', '8d40eb8e-845c-4edc-9028-ea0651505554', 'Job Type: TTS_GENERATION', '2026-07-11 04:22:40', '81635f53-9c25-409d-977f-bbb0ac3e8666', '2026-07-11 04:22:40'),
('8c059ab6-5a7d-4430-bcb2-3755623a3a0a', 'CREATE_AI_JOB', 'generation_jobs', 'ea72aa38-8a84-4130-a603-0a7a6e4da35b', 'Job Type: JobType.QUESTION_GENERATION', '2026-07-11 02:28:44', 'a938fe56-349a-4069-af1e-97d6304af933', '2026-07-11 02:28:44'),
('8c059ab6-5a7d-4430-bcb2-3755623a3a0a', 'CREATE_TTS_JOB', 'generation_jobs', '0b43ec13-bb47-44e5-b915-2b8b051057e4', 'Job Type: TTS_GENERATION', '2026-07-11 02:28:44', 'eae4668d-46ee-403d-8ee1-67f0ef6e4fb6', '2026-07-11 02:28:44'),
('8c059ab6-5a7d-4430-bcb2-3755623a3a0a', 'CREATE_AI_JOB', 'generation_jobs', 'db58bffc-daee-4e3b-adf5-b0f170a333f2', 'Job Type: JobType.QUESTION_GENERATION', '2026-07-11 04:22:40', 'eddb0e87-d411-42b6-a2f4-52d834a73858', '2026-07-11 04:22:40'),
('8c059ab6-5a7d-4430-bcb2-3755623a3a0a', 'CREATE_TTS_JOB', 'generation_jobs', '4fe1253f-30a4-4387-8a7b-f1544a09752f', 'Job Type: TTS_GENERATION', '2026-07-11 04:40:21', 'f7b0ba50-1252-44d5-8729-e495c892dce0', '2026-07-11 04:40:21');

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `level_id` varchar(36) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `sequence` int(11) DEFAULT NULL,
  `is_published` tinyint(1) DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`level_id`, `title`, `description`, `sequence`, `is_published`, `id`, `created_at`, `updated_at`) VALUES
('b9dd728d-c0b8-4aff-8fc3-e7221d872dd7', 'Course', NULL, 0, 1, '009391fe-8c4f-4ba5-9df9-7b7313311330', '2026-07-10 15:37:13', '2026-07-10 15:37:13'),
('592a4200-76d2-430a-b46d-93f5aa6ac6ac', 'Course', NULL, 0, 1, '00b9eef8-82e1-4283-8279-62828045abc7', '2026-07-10 16:09:49', '2026-07-10 16:09:49'),
('87df419a-7875-4ddc-904e-bc83a88773fa', 'Course', NULL, 0, 1, '00be23aa-003d-4e73-b1d7-72ebf52710c6', '2026-07-10 16:09:32', '2026-07-10 16:09:32'),
('028863f4-d9ee-42d4-bbf7-f8dc2bd37e6a', 'Mock Course', NULL, 0, 0, '0126be1e-eabe-4924-9591-0448d8a79fc2', '2026-07-11 04:13:18', '2026-07-11 04:13:18'),
('174b27a4-9c71-4db0-b189-e63ea6fd10b8', 'Mock Course', NULL, 0, 0, '046975cf-3004-43ce-abf9-f92ed13e6ab8', '2026-07-11 04:14:10', '2026-07-11 04:14:10'),
('b13c52dd-5c57-4682-a131-e689bc39f9fb', 'Mock Course', NULL, 0, 0, '05557af5-4dd3-4b32-9056-2d36578a4e07', '2026-07-11 04:19:23', '2026-07-11 04:19:23'),
('47b4571b-72f8-431c-9f53-84e6520abb81', 'Course', NULL, 0, 1, '07d6d4ea-ca72-4165-beb3-eb5051bfb96d', '2026-07-10 16:15:48', '2026-07-10 16:15:48'),
('383f838e-c8e1-4aa9-b5a9-7a3f777781be', 'Course', NULL, 0, 1, '0eef7cd2-bbde-4ce6-b0b3-7537fe39e62a', '2026-07-10 15:34:14', '2026-07-10 15:34:14'),
('90410de0-d536-4ca8-aebb-1c0b21f40d21', 'Course', NULL, 0, 1, '0ef5e347-234c-433c-88f5-f3416c6486ac', '2026-07-10 16:04:54', '2026-07-10 16:04:54'),
('085b731d-e20d-4069-9329-66202b442f23', 'Mock Course', NULL, 0, 0, '10d5247f-8423-4422-8ad2-45d79b95bdcd', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('cb91002f-2d22-42be-a8a6-4b88e90d7496', 'Course', NULL, 0, 1, '11db9d1c-6a80-4c8e-8911-d33005b52047', '2026-07-10 15:55:00', '2026-07-10 15:55:00'),
('63e4c59d-120f-4021-b284-0dfd65c10e43', 'Course', NULL, 0, 1, '1342a040-8883-4094-b3df-65e9bbd197fb', '2026-07-10 16:21:02', '2026-07-10 16:21:02'),
('b9d70a62-39c7-48f8-abc6-2ec5b2ea62b7', 'Course', NULL, 0, 1, '18792bd7-0f7d-4986-829f-3f70b5a3fb05', '2026-07-10 15:54:01', '2026-07-10 15:54:01'),
('e9576d30-1b28-4a08-8481-139a2b6b2506', 'Mock Course', NULL, 0, 0, '1b78e046-68e1-4b4d-8ee7-d89f4d28269e', '2026-07-11 04:16:03', '2026-07-11 04:16:03'),
('aaeeb9f0-8571-4944-bcbe-12a21b9f482a', 'Mock Course', NULL, 0, 0, '1d65fe9f-4b4c-4960-acdd-36da95ea8eb5', '2026-07-11 04:15:52', '2026-07-11 04:15:52'),
('73fce9af-8df6-4607-a0d1-0ef8c16f6f34', 'Course', NULL, 0, 1, '1f5a50b0-851a-4fe0-9b93-9b7b90de7e1a', '2026-07-10 16:03:04', '2026-07-10 16:03:04'),
('9f255d3a-3b32-495f-aa06-61cf6c682c2d', 'Test Course', 'Desc', 0, 1, '1f82bff3-576a-41ee-b9c0-a3cff7decb1f', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('bf0b652c-9156-4ab8-a2b4-7ef9a61ba597', 'Course', NULL, 0, 1, '22ea5dec-6dd5-4d66-9d1e-ee661d50c5e6', '2026-07-10 16:16:06', '2026-07-10 16:16:06'),
('f18b926b-c01e-450d-a74e-52dcf599abf5', 'Course', NULL, 0, 1, '247c7c49-4419-4aae-8cb8-9609f901cfe3', '2026-07-10 16:15:48', '2026-07-10 16:15:48'),
('f90ea20e-66aa-4998-b804-32d53212514a', 'Mock Course', NULL, 0, 0, '27c6f600-4d1f-4200-b67e-2332a81b3551', '2026-07-11 04:15:52', '2026-07-11 04:15:52'),
('dae01a98-b09b-4b78-a282-87eb7f439ec4', 'Course', NULL, 0, 1, '28d026e0-7c69-44b9-a918-57b14c8b0b09', '2026-07-11 04:22:40', '2026-07-11 04:22:40'),
('abe4588f-ccb8-442f-97c6-e50535dcbc83', 'Course', NULL, 0, 1, '2afc7f43-9b05-4c57-a313-2d0af9de5ca5', '2026-07-10 16:06:38', '2026-07-10 16:06:38'),
('da57e369-0620-455d-b278-84cc7cf9f057', 'Course', NULL, 0, 1, '2be3c161-d7b9-4878-9e6e-2b0ded727af4', '2026-07-10 16:11:00', '2026-07-10 16:11:00'),
('75bd201e-5fc9-4fb8-acbd-434c94e3aac3', 'Mock Course', NULL, 0, 0, '2ebc06b8-1226-420e-8906-d5408f3b7934', '2026-07-11 04:17:24', '2026-07-11 04:17:24'),
('85bcf6e7-46e9-46a9-a15b-d4219ed143bc', 'Mock Course', NULL, 0, 0, '2f503ef7-36a9-483f-935e-acffa0e771b3', '2026-07-11 04:14:04', '2026-07-11 04:14:04'),
('0930e164-6465-4e87-95dc-fcf72b4a7a9a', 'Test Course', 'Desc', 0, 1, '2f6f6f4a-6e31-4ece-a4de-441faf809a90', '2026-07-11 03:33:03', '2026-07-11 03:33:03'),
('6bdd915d-22c8-4811-8297-39606b01626c', 'Course', NULL, 0, 1, '307233ee-6dd1-49ff-b629-3b8aabf9ba51', '2026-07-10 15:18:32', '2026-07-10 15:18:32'),
('5380e404-81cd-4ab2-8b2c-b4ca19228c5e', 'Course', NULL, 0, 1, '3154aa3d-ac33-43bf-bbbc-a0668a92bff1', '2026-07-10 16:14:03', '2026-07-10 16:14:03'),
('f4f59400-62cb-4108-af18-14d380f5e408', 'Course', NULL, 0, 1, '38cafe45-6744-4b21-853e-c610861ae23d', '2026-07-10 15:53:53', '2026-07-10 15:53:53'),
('453d4ba6-f27a-4c8a-a489-e91afb86b56e', 'Mock Course', NULL, 0, 0, '3b68a51c-10b0-4fd8-862c-4c24771a3718', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('bd8a19d1-9712-4e3c-b263-32a6ca600539', 'N5 Foundation', 'Basic foundation of N5', 1, 1, '3d54b92b-0fca-4652-815b-16fe3b3b0a6b', '2026-07-10 15:13:34', '2026-07-10 15:13:34'),
('42640ce5-b060-426a-862a-72e972a20f82', 'Course', NULL, 0, 1, '420cfe03-644a-4135-920f-dc713de64d5a', '2026-07-11 04:40:20', '2026-07-11 04:40:20'),
('f6574025-c15f-4696-be2b-3433faaa4ad0', 'Course', NULL, 0, 1, '4600ac84-85b3-46f6-88f8-bd5c9033b081', '2026-07-10 16:23:51', '2026-07-10 16:23:51'),
('adf27a43-8326-49bc-bdfb-d02979230305', 'Course', NULL, 0, 1, '4b9f09f3-deb6-4a9a-954f-9e09b7ae2fa1', '2026-07-11 04:40:21', '2026-07-11 04:40:21'),
('95c587ea-ff7d-46c4-86a9-4352dc1d54d6', 'Course', NULL, 0, 1, '5154ac18-9e23-41d0-a770-0c1338378b79', '2026-07-10 16:09:32', '2026-07-10 16:09:32'),
('4ebb51dd-43da-4541-99a7-f1453c88f4b3', 'Test Course', 'Desc', 0, 1, '521e5ddc-9039-4d6f-b87d-b307a3975f79', '2026-07-11 04:40:22', '2026-07-11 04:40:22'),
('db7f6bff-09f6-4a32-bbdd-bd034ebf7f39', 'Mock Course', NULL, 0, 0, '524fc5e2-905c-4a68-b4de-321ba1505b40', '2026-07-11 04:13:10', '2026-07-11 04:13:10'),
('665a172d-1a1f-4f26-aed6-578cfde1f45d', 'Test Course', 'Desc', 0, 1, '53e954d0-5d42-429d-a59a-2e631f1d997c', '2026-07-11 03:32:01', '2026-07-11 03:32:01'),
('0783751c-03cb-42f4-86e5-35821fc21212', 'Course', NULL, 0, 1, '591e74b4-8d36-4ddf-bae9-80bce83e4ecc', '2026-07-11 04:40:22', '2026-07-11 04:40:22'),
('00f7fae2-e1d5-47c7-8066-35829ac4fb98', 'Course', NULL, 0, 1, '5b2bc681-af23-40cd-8fdc-032fc18c114c', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('069a20ce-8935-42df-8823-72d308ec26c3', 'Course', NULL, 0, 1, '5bf1b00c-0854-4b99-8257-246178362504', '2026-07-10 16:23:51', '2026-07-10 16:23:51'),
('d39fd00a-478c-4422-bd73-c1768391b6b2', 'Course', NULL, 0, 1, '5e217c75-eede-4bc6-b9da-39058960c413', '2026-07-10 15:54:53', '2026-07-10 15:54:53'),
('c099ea8d-4e1e-4c25-91c0-82fcd7c3290c', 'Course', NULL, 0, 1, '654112a5-52c6-4be6-bf15-96a20a5fab80', '2026-07-10 16:21:03', '2026-07-10 16:21:03'),
('1aaec7d7-d384-42cd-8d37-88954519391f', 'Course', NULL, 0, 1, '696d8625-1b84-4d38-87a8-ef590c956191', '2026-07-10 16:02:47', '2026-07-10 16:02:47'),
('09bc81e6-9bec-490e-b09e-1f87494a5511', 'Course', NULL, 0, 1, '6d3b8200-edbb-4694-a9c4-4b236ea7a192', '2026-07-10 16:07:53', '2026-07-10 16:07:53'),
('40f5d42c-f7c4-4b2d-916c-7627a8640398', 'Mock Course', NULL, 0, 0, '6e14b3af-4c8b-4f18-b705-5e18c612e5d9', '2026-07-11 04:16:50', '2026-07-11 04:16:50'),
('94481ba8-b57a-45bb-b096-dc27863dd5cc', 'Course', NULL, 0, 1, '6eb698ce-0848-4752-97ae-f8cc62532b61', '2026-07-10 15:25:57', '2026-07-10 15:25:57'),
('23090b07-40d9-46be-8abd-157ef051eafe', 'Course', NULL, 0, 1, '730e573a-d0a5-4540-8031-f2e08b999647', '2026-07-10 16:04:53', '2026-07-10 16:04:53'),
('0cb66df1-2ae2-42cf-b37b-400f9cab8279', 'Course', NULL, 0, 1, '7872827c-c259-47ae-af28-b02a1028303b', '2026-07-10 16:06:22', '2026-07-10 16:06:22'),
('ffaf79c4-8a72-4a60-b134-f456b4786e9d', 'Course', NULL, 0, 1, '7bc714ab-d1f4-45f1-9c30-9d6e8a77a2f2', '2026-07-10 16:16:05', '2026-07-10 16:16:05'),
('03bf0661-a230-4d8f-9d30-9dc80d31fa26', 'Course', NULL, 0, 1, '83bd2404-ed61-4dd3-9ffc-a9365cab9a43', '2026-07-10 16:07:53', '2026-07-10 16:07:53'),
('11fdb47c-ea79-47e7-995f-dda8adb5df3a', 'Mock Course', NULL, 0, 0, '855fc796-fce8-482d-96bc-f4ff4243b514', '2026-07-11 04:14:55', '2026-07-11 04:14:55'),
('884e2273-f8a9-4a99-bbde-688f571716e3', 'Course', NULL, 0, 1, '864d17fa-1ed8-45ce-b1e9-ecf73cd95a11', '2026-07-10 16:04:37', '2026-07-10 16:04:37'),
('f13342d8-7b14-4e4a-91f3-8733ca842e7d', 'Course', NULL, 0, 1, '8779dd1a-f208-4007-95df-ef9cbef9f6f8', '2026-07-10 16:23:43', '2026-07-10 16:23:43'),
('ff4ffdfd-24c0-4247-b493-b8a7289ea6c0', 'Mock Course', NULL, 0, 0, '889982ea-b494-4986-a62e-d92ccfb5098e', '2026-07-11 04:14:11', '2026-07-11 04:14:11'),
('b4b071c8-63b3-4c2e-9d14-0e1821572e3a', 'Mock Course', NULL, 0, 0, '8d909254-382b-45ec-9ee8-7a3eabcfa2af', '2026-07-11 04:17:04', '2026-07-11 04:17:04'),
('213492d1-007e-47af-b4ea-1b243b9a87ca', 'Test Course', 'Desc', 0, 1, '917b0633-ce20-4d93-b5b1-c301ca61804c', '2026-07-11 03:32:51', '2026-07-11 03:32:51'),
('cdd128aa-fe87-4b2d-a348-ba17a75cc2a3', 'Course', NULL, 0, 1, '950ae37d-94f5-4213-9f16-2b1aa3f58b8e', '2026-07-10 15:26:56', '2026-07-10 15:26:56'),
('bd8a19d1-9712-4e3c-b263-32a6ca600539', 'N5 Masterclass', 'Comprehensive N5 Guide', 1, 1, '95326eba-631f-4bc1-8348-32d74335fc3b', '2026-07-11 03:02:52', '2026-07-11 03:02:52'),
('57b9e599-eb6e-4a82-a9fa-26bd86942c01', 'Course', NULL, 0, 1, '9ca9aedf-aaa0-4f14-a18d-2c724f40cd76', '2026-07-10 16:14:03', '2026-07-10 16:14:03'),
('8eba4334-b5f6-4bf3-8080-71277f7f400c', 'Course', NULL, 0, 1, '9dcd44c5-125d-40ee-bfe8-98651b91464e', '2026-07-10 16:20:00', '2026-07-10 16:20:00'),
('f22ccc5f-b343-40ee-b74c-cea6e7581110', 'Course', NULL, 0, 1, 'a5c4b13f-ff13-4c22-9084-1523e0bab183', '2026-07-10 16:06:23', '2026-07-10 16:06:23'),
('762a6143-ba98-4b49-8539-bd94e8e1d9fd', 'Course', NULL, 0, 1, 'a5e2a901-829d-463a-acb8-3426296a26b4', '2026-07-10 15:35:34', '2026-07-10 15:35:34'),
('98b2370c-0ca9-406c-8039-32edcb3a7f2a', 'Mock Course', NULL, 0, 0, 'a6fc3677-da21-41d5-ac4e-425d760409ac', '2026-07-11 04:14:04', '2026-07-11 04:14:04'),
('b0181098-acf3-4457-acc1-eda3cae65d0b', 'Mock Course', NULL, 0, 0, 'a6fed606-13dc-4a6a-9cd8-8ea3e4cb39c8', '2026-07-11 04:16:03', '2026-07-11 04:16:03'),
('bcff2196-6796-432a-a537-29862c59988b', 'Test Course', 'Desc', 0, 1, 'ab4f8bb5-7e63-4b75-9b05-df0f9bd4306b', '2026-07-11 03:32:12', '2026-07-11 03:32:12'),
('6410c191-4c63-4b1a-936c-7a3eb9e2b022', 'Course', NULL, 0, 1, 'b07c1a92-b143-495d-9d00-67068c1fe674', '2026-07-10 15:26:00', '2026-07-10 15:26:00'),
('e9c8557f-e9c5-4701-b458-3b4a504fba01', 'Course', NULL, 0, 1, 'b1cd3077-a4b3-429f-972b-33c89d7c8b16', '2026-07-10 15:38:04', '2026-07-10 15:38:04'),
('f75fad1c-6e26-423e-bce3-fd5c89a4fa7d', 'Course', NULL, 0, 1, 'b4bf4519-315a-4184-aad9-9a58fec6e78d', '2026-07-10 16:03:05', '2026-07-10 16:03:05'),
('f4e2c126-0453-4dc0-a518-2062ef5716ec', 'Course', NULL, 0, 1, 'bfa2ab29-0885-4d36-80f8-5dcf1ca24bd9', '2026-07-10 16:11:00', '2026-07-10 16:11:00'),
('9156e92d-09fa-49d9-99eb-827d2bf5737d', 'Mock Course', NULL, 0, 0, 'c135be25-943c-4f51-9396-322520918616', '2026-07-11 04:17:24', '2026-07-11 04:17:24'),
('ae5510f9-c018-4955-9402-16a6301e944a', 'Mock Course', NULL, 0, 0, 'c91875e3-e222-43f2-9f0a-1a927dd5a4fd', '2026-07-11 04:13:18', '2026-07-11 04:13:18'),
('e436b15e-8098-4701-9c01-d12b5c34d807', 'Mock Course', NULL, 0, 0, 'ce5a25bd-2276-4d40-852b-71493c1bae45', '2026-07-11 04:19:23', '2026-07-11 04:19:23'),
('f5590213-2244-4761-9d42-100e5f693432', 'Course', NULL, 0, 1, 'd51649cc-8746-4224-aa5c-f177ab08aef9', '2026-07-10 15:26:44', '2026-07-10 15:26:44'),
('b2992808-885b-4a7e-8517-de549b863225', 'Course', NULL, 0, 1, 'd8743062-34af-48df-984a-83432df08d63', '2026-07-11 04:40:21', '2026-07-11 04:40:21'),
('30c7f364-c3ae-4987-9785-8711d88cd953', 'Course', NULL, 0, 1, 'dc99ee52-ca17-4c15-b8a5-c6c3f89fb692', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('2d08b69f-6f34-49ec-a99a-208375f31068', 'Mock Course', NULL, 0, 0, 'e3a89ef4-1b83-4ada-9ae8-a9d82cc87f2d', '2026-07-11 04:16:50', '2026-07-11 04:16:50'),
('48322786-df8a-4aa7-a338-0535ae47517e', 'Course', NULL, 0, 1, 'e4acab09-d7a1-4067-b9a0-a457b2443bf7', '2026-07-10 16:09:49', '2026-07-10 16:09:49'),
('7eb6b233-853b-4186-8bb8-08148a8fad09', 'Mock Course', NULL, 0, 0, 'e564f30e-b9ae-4eed-866d-f023a129b459', '2026-07-11 04:13:10', '2026-07-11 04:13:10'),
('e34d19f4-1664-4f7e-a755-6fa56a320f44', 'Course', NULL, 0, 1, 'e663ff6c-fce2-4552-9f5c-e201e646a5af', '2026-07-11 04:22:40', '2026-07-11 04:22:40'),
('965638e7-0392-4b87-9e58-61200e43fbee', 'Course', NULL, 0, 1, 'e7ee0ad5-3857-4228-8d09-f75fb93f8d2a', '2026-07-10 16:04:36', '2026-07-10 16:04:36'),
('3b124b34-4dbc-4b64-a714-2917d00ec13d', 'Mock Course', NULL, 0, 0, 'e8a11e03-237f-470d-b2ff-5c5b942d2014', '2026-07-11 04:40:22', '2026-07-11 04:40:22'),
('c9deaa75-1a98-42dc-af15-dad6ec16df49', 'Course', NULL, 0, 1, 'e97548f5-7638-406f-bc73-79640a7f23be', '2026-07-10 16:02:48', '2026-07-10 16:02:48'),
('b6041550-4ec5-4f32-b795-5752c33deb82', 'Mock Course', NULL, 0, 0, 'ecd07d79-7e09-4a10-a553-7e0f71c79558', '2026-07-11 04:14:56', '2026-07-11 04:14:56'),
('a341d931-58dc-442b-8ea4-c822ab3caca0', 'Course', NULL, 0, 1, 'ef61a9a5-3392-4b38-bcd2-885ca055c169', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('f5c9075a-30d0-4d8c-89f2-70b1815190b9', 'Mock Course', NULL, 0, 0, 'ef6ed790-adb1-40ad-a85e-bd370d181f02', '2026-07-11 04:40:23', '2026-07-11 04:40:23'),
('4dcbddf9-360f-4074-aa3a-68c06d2a09aa', 'Course', NULL, 0, 1, 'f0266237-c72a-42d1-bed3-2e5e5bb845a0', '2026-07-10 16:20:00', '2026-07-10 16:20:00'),
('b2e1dcd6-6449-4179-b725-65b7b4ab48d3', 'Course', NULL, 0, 1, 'f1f52637-e709-4006-af50-485bb413c824', '2026-07-11 04:40:21', '2026-07-11 04:40:21'),
('b76ebcb8-8f66-49ad-afcc-604427e57f21', 'Course', NULL, 0, 1, 'f54e8d6a-455c-44b5-a508-e5ad0a50d7ad', '2026-07-10 16:06:37', '2026-07-10 16:06:37'),
('ded54a4b-644e-4f7d-bf5c-7840e70eaed3', 'Course', NULL, 0, 1, 'f56be25f-89e2-4cd5-92d9-80572ac777fd', '2026-07-10 15:36:45', '2026-07-10 15:36:45'),
('644d830f-00e3-4d98-a32a-e50f35b5ef9d', 'Course', NULL, 0, 1, 'fb56a41b-8d59-43bb-be91-38d61be43713', '2026-07-10 16:23:43', '2026-07-10 16:23:43'),
('7df7b11d-79a2-461b-b9c0-fd0ecc3a20ea', 'Course', NULL, 0, 1, 'fbe2bd78-fbd6-4344-a694-3689ee93f75b', '2026-07-10 15:38:11', '2026-07-10 15:38:11'),
('4a7be1bd-e24b-48d1-a405-61b645fe67c3', 'Mock Course', NULL, 0, 0, 'ff529c18-5b3a-432e-90f9-8286bf8b697e', '2026-07-11 04:17:05', '2026-07-11 04:17:05');

-- --------------------------------------------------------

--
-- Table structure for table `example_sentences`
--

CREATE TABLE `example_sentences` (
  `japanese` text NOT NULL,
  `romaji` text DEFAULT NULL,
  `indonesian` text NOT NULL,
  `audio_id` varchar(36) DEFAULT NULL,
  `vocabulary_id` varchar(36) DEFAULT NULL,
  `grammar_point_id` varchar(36) DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `example_sentences`
--

INSERT INTO `example_sentences` (`japanese`, `romaji`, `indonesian`, `audio_id`, `vocabulary_id`, `grammar_point_id`, `id`, `created_at`, `updated_at`) VALUES
('学校はどこですか。 (9)', 'Gakkou wa doko desu ka.', 'Where is the school? (9)', NULL, NULL, NULL, '01ce9703-5d05-4cdb-ae82-ab71e629145f', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('猫がいます。 (4)', 'Neko ga imasu.', 'There is a cat. (4)', NULL, NULL, NULL, '01ddb819-69fd-489e-ab5c-9aae8c46457b', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('あの車は高いです。 (3)', 'Ano kuruma wa takai desu.', 'That car is expensive. (3)', NULL, NULL, NULL, '029637da-afc6-4a6b-9284-7d0b7e949c3d', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('きのう、りんごを食べました。 (3)', 'Kinou, ringo o tabemashita.', 'I ate an apple yesterday. (3)', NULL, NULL, NULL, '041c1d0e-76be-4b58-a5fe-4cd8bfd36902', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('あの車は高いです。 (6)', 'Ano kuruma wa takai desu.', 'That car is expensive. (6)', NULL, NULL, NULL, '0475c542-4b98-4567-ba71-0f8eebb29fb4', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('日本語を勉強します。 (11)', 'Nihongo o benkyou shimasu.', 'I study Japanese. (11)', NULL, NULL, NULL, '085fdb1f-71d8-4c1a-841a-45a78e180923', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('学校はどこですか。 (14)', 'Gakkou wa doko desu ka.', 'Where is the school? (14)', NULL, NULL, NULL, '0a313335-9195-420d-a935-634b7dd9d831', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('あの車は高いです。 (11)', 'Ano kuruma wa takai desu.', 'That car is expensive. (11)', NULL, NULL, NULL, '0a67427a-e1e0-48d5-8dcd-76c5f91ad96c', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('今、何時ですか。 (2)', 'Ima, nanji desu ka.', 'What time is it now? (2)', NULL, NULL, NULL, '0bf346c5-b3c5-4fa6-99ee-9908535e87d4', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('猫がいます。 (14)', 'Neko ga imasu.', 'There is a cat. (14)', NULL, NULL, NULL, '1134b8dd-9296-403d-99fe-8eb45074f8e8', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('きのう、りんごを食べました。 (13)', 'Kinou, ringo o tabemashita.', 'I ate an apple yesterday. (13)', NULL, NULL, NULL, '12e60a37-6d69-48e4-80d6-ee2f28972f52', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('水を飲みます。 (6)', 'Mizu o nomimasu.', 'I drink water. (6)', NULL, NULL, NULL, '141ab00b-25b6-45e5-88d9-3b6cd92a5157', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('学校はどこですか。 (6)', 'Gakkou wa doko desu ka.', 'Where is the school? (6)', NULL, NULL, NULL, '144c6ceb-1671-491c-b3c3-f0a1de25773c', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('学校はどこですか。 (5)', 'Gakkou wa doko desu ka.', 'Where is the school? (5)', NULL, NULL, NULL, '1477e17e-694b-498d-b97d-0d6c9d0e146e', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('水を飲みます。 (4)', 'Mizu o nomimasu.', 'I drink water. (4)', NULL, NULL, NULL, '150eec21-5caf-46d6-9eff-9f10a5e6dcd8', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('あの車は高いです。 (14)', 'Ano kuruma wa takai desu.', 'That car is expensive. (14)', NULL, NULL, NULL, '168764be-03ea-409c-86da-c63726468fa9', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('私は学生です。 (9)', 'Watashi wa gakusei desu.', 'I am a student. (9)', NULL, NULL, NULL, '18845f64-48c5-4126-86f5-cae1edebff1d', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('猫がいます。 (11)', 'Neko ga imasu.', 'There is a cat. (11)', NULL, NULL, NULL, '1904b343-1a51-4401-9e52-2cd5f9df801d', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('これは私の本です。 (5)', 'Kore wa watashi no hon desu.', 'This is my book. (5)', NULL, NULL, NULL, '1a5cbb91-b409-4c2e-8b6f-7e98052288fe', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('私は学生です。 (12)', 'Watashi wa gakusei desu.', 'I am a student. (12)', NULL, NULL, NULL, '1ef1dc25-5880-4219-8412-6e0b85645a3d', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('明日、東京に行きます。', 'Ashita, Tokyo ni ikimasu.', 'I will go to Tokyo tomorrow.', NULL, NULL, NULL, '24830b9d-2037-4cfc-8913-5825733c860d', '2026-07-11 03:02:52', '2026-07-11 03:02:52'),
('きのう、りんごを食べました。 (14)', 'Kinou, ringo o tabemashita.', 'I ate an apple yesterday. (14)', NULL, NULL, NULL, '2695f366-9e6c-425c-9c2e-8687074b1e28', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('あの車は高いです。 (5)', 'Ano kuruma wa takai desu.', 'That car is expensive. (5)', NULL, NULL, NULL, '27b5c94b-5777-494c-8024-011094fa5e4b', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('これは私の本です。 (4)', 'Kore wa watashi no hon desu.', 'This is my book. (4)', NULL, NULL, NULL, '328a6afd-2e16-46ce-b169-455d4e93b59a', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('あの車は高いです。 (13)', 'Ano kuruma wa takai desu.', 'That car is expensive. (13)', NULL, NULL, NULL, '33940cec-dcac-4348-85cf-c5cd0ddb541e', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('学校はどこですか。 (2)', 'Gakkou wa doko desu ka.', 'Where is the school? (2)', NULL, NULL, NULL, '34a4a621-62e3-4ee8-a12d-7d47e0c42d22', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('私は学生です。 (13)', 'Watashi wa gakusei desu.', 'I am a student. (13)', NULL, NULL, NULL, '34c6abf0-2f9b-4a0e-b49d-11489b60d793', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('きのう、りんごを食べました。', 'Kinou, ringo o tabemashita.', 'I ate an apple yesterday.', NULL, NULL, NULL, '35e50cfc-4a2e-44b7-ae5d-8189181ed52b', '2026-07-11 03:02:52', '2026-07-11 03:02:52'),
('猫がいます。 (3)', 'Neko ga imasu.', 'There is a cat. (3)', NULL, NULL, NULL, '36761dba-6f10-427b-a127-e9ddc2614bef', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('これは私の本です。 (10)', 'Kore wa watashi no hon desu.', 'This is my book. (10)', NULL, NULL, NULL, '371463e4-e8ac-4673-a75f-48123757ed3b', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('明日、東京に行きます。 (10)', 'Ashita, Tokyo ni ikimasu.', 'I will go to Tokyo tomorrow. (10)', NULL, NULL, NULL, '3b511186-4fbc-4313-903b-28e6fd9b635f', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('今、何時ですか。 (15)', 'Ima, nanji desu ka.', 'What time is it now? (15)', NULL, NULL, NULL, '3c04c191-7044-4cea-a278-f41fe678f75e', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('日本語を勉強します。 (3)', 'Nihongo o benkyou shimasu.', 'I study Japanese. (3)', NULL, NULL, NULL, '3db89cbd-8f86-4a07-bb78-7edbedd97d49', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('私は学生です。 (2)', 'Watashi wa gakusei desu.', 'I am a student. (2)', NULL, NULL, NULL, '3e95b286-7d44-4980-84e9-9bd67148e858', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('日本語を勉強します。', 'Nihongo o benkyou shimasu.', 'I study Japanese.', NULL, NULL, NULL, '3eacddd1-53ca-402c-bdd6-e72feb9047ba', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('水を飲みます。 (9)', 'Mizu o nomimasu.', 'I drink water. (9)', NULL, NULL, NULL, '3ef63c9a-a5a5-4126-b920-eaaff66fe932', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('私は学生です。 (15)', 'Watashi wa gakusei desu.', 'I am a student. (15)', NULL, NULL, NULL, '3fe5c808-f923-4c6b-bedc-d017fe0fc99a', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('今、何時ですか。 (6)', 'Ima, nanji desu ka.', 'What time is it now? (6)', NULL, NULL, NULL, '41b9798d-4254-432b-bdcb-645ec65cec6f', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('私は学生です。 (5)', 'Watashi wa gakusei desu.', 'I am a student. (5)', NULL, NULL, NULL, '42459767-036e-4fb0-8bcd-f6a19bfb6bc3', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('今、何時ですか。 (10)', 'Ima, nanji desu ka.', 'What time is it now? (10)', NULL, NULL, NULL, '443f93fc-8d52-4f35-bc4d-6d6f879948a0', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('これは私の本です。 (7)', 'Kore wa watashi no hon desu.', 'This is my book. (7)', NULL, NULL, NULL, '468e0b09-7f5f-4e34-8688-516fbc1e3127', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('水を飲みます。', 'Mizu o nomimasu.', 'I drink water.', NULL, NULL, NULL, '48516346-c687-46c8-9cb6-6f7a400e0faf', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('今、何時ですか。', 'Ima, nanji desu ka.', 'What time is it now?', NULL, NULL, NULL, '48d086fa-a6b5-4951-92a6-97362bbfd256', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('私は学生です。 (4)', 'Watashi wa gakusei desu.', 'I am a student. (4)', NULL, NULL, NULL, '48e79c2e-2549-435e-a556-842cb3503abc', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('私は学生です。 (3)', 'Watashi wa gakusei desu.', 'I am a student. (3)', NULL, NULL, NULL, '4a463e6c-3122-4858-b51f-463e0ed2e5da', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('明日、東京に行きます。 (5)', 'Ashita, Tokyo ni ikimasu.', 'I will go to Tokyo tomorrow. (5)', NULL, NULL, NULL, '50104204-2121-42c9-ad75-f015bf381bcd', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('今、何時ですか。 (11)', 'Ima, nanji desu ka.', 'What time is it now? (11)', NULL, NULL, NULL, '533ee60a-d25c-4bdd-8ab9-2e57adb208c7', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('学校はどこですか。 (15)', 'Gakkou wa doko desu ka.', 'Where is the school? (15)', NULL, NULL, NULL, '53badb4f-bc41-4f81-85b8-2b056b7353a4', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('明日、東京に行きます。 (7)', 'Ashita, Tokyo ni ikimasu.', 'I will go to Tokyo tomorrow. (7)', NULL, NULL, NULL, '594de6ab-3758-48f9-8a4a-bd14ff4e6019', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('きのう、りんごを食べました。 (15)', 'Kinou, ringo o tabemashita.', 'I ate an apple yesterday. (15)', NULL, NULL, NULL, '59ac3b02-e7d6-4bc8-83b2-d382a749cf90', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('明日、東京に行きます。 (6)', 'Ashita, Tokyo ni ikimasu.', 'I will go to Tokyo tomorrow. (6)', NULL, NULL, NULL, '5a375693-2b43-45eb-9024-04475bb7c3e5', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('きのう、りんごを食べました。 (6)', 'Kinou, ringo o tabemashita.', 'I ate an apple yesterday. (6)', NULL, NULL, NULL, '5a4d3682-8174-44a0-ac0b-6a6eb8b66f92', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('水を飲みます。 (7)', 'Mizu o nomimasu.', 'I drink water. (7)', NULL, NULL, NULL, '5f8e3170-22ef-453e-a6e0-cd6c08424c49', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('今、何時ですか。 (13)', 'Ima, nanji desu ka.', 'What time is it now? (13)', NULL, NULL, NULL, '60c4e67f-4173-4bca-ad5b-7ddd9395dc86', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('猫がいます。 (5)', 'Neko ga imasu.', 'There is a cat. (5)', NULL, NULL, NULL, '65e05e80-b0da-4317-a20a-afb06eb933ff', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('水を飲みます。 (10)', 'Mizu o nomimasu.', 'I drink water. (10)', NULL, NULL, NULL, '6924324a-acbb-4790-b8c4-a4cd3a50f413', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('これは私の本です。 (8)', 'Kore wa watashi no hon desu.', 'This is my book. (8)', NULL, NULL, NULL, '69d51dab-43f9-461a-b24e-f4883f0fbd46', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('あの車は高いです。 (12)', 'Ano kuruma wa takai desu.', 'That car is expensive. (12)', NULL, NULL, NULL, '6a0b6a23-b6de-49c7-8f71-0004e1c5e302', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('日本語を勉強します。 (8)', 'Nihongo o benkyou shimasu.', 'I study Japanese. (8)', NULL, NULL, NULL, '6d467edc-3cf6-4fa3-ad3b-81d41f1ab0f9', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('明日、東京に行きます。 (12)', 'Ashita, Tokyo ni ikimasu.', 'I will go to Tokyo tomorrow. (12)', NULL, NULL, NULL, '6e8c1a92-b6dd-4157-8bd1-6878fff8eaa5', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('学校はどこですか。 (7)', 'Gakkou wa doko desu ka.', 'Where is the school? (7)', NULL, NULL, NULL, '73d59a00-fedc-4f3f-9066-ab73dc81cd5a', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('明日、東京に行きます。 (4)', 'Ashita, Tokyo ni ikimasu.', 'I will go to Tokyo tomorrow. (4)', NULL, NULL, NULL, '74ee6acb-a052-472a-8c55-c946fefc70bf', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('これは私の本です。 (15)', 'Kore wa watashi no hon desu.', 'This is my book. (15)', NULL, NULL, NULL, '76d09a8b-7ae9-4196-96ad-a96215cfc195', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('今、何時ですか。 (4)', 'Ima, nanji desu ka.', 'What time is it now? (4)', NULL, NULL, NULL, '78a30fe0-2d3d-4aa9-b858-bb13d0d1b536', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('水を飲みます。 (11)', 'Mizu o nomimasu.', 'I drink water. (11)', NULL, NULL, NULL, '79166e98-0bc1-4b68-8321-7b2b63701106', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('私は学生です。 (11)', 'Watashi wa gakusei desu.', 'I am a student. (11)', NULL, NULL, NULL, '7c7d8c7c-2bce-4885-8e36-810d19019a65', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('明日、東京に行きます。 (8)', 'Ashita, Tokyo ni ikimasu.', 'I will go to Tokyo tomorrow. (8)', NULL, NULL, NULL, '7cef13d2-0fbc-4f5a-b068-d4115d6422e8', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('きのう、りんごを食べました。 (7)', 'Kinou, ringo o tabemashita.', 'I ate an apple yesterday. (7)', NULL, NULL, NULL, '7e506f34-f5c5-402a-86a3-990f12a878e9', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('明日、東京に行きます。 (13)', 'Ashita, Tokyo ni ikimasu.', 'I will go to Tokyo tomorrow. (13)', NULL, NULL, NULL, '81a184f9-6b20-4ee4-bd6a-7baddb3fcf1c', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('猫がいます。 (2)', 'Neko ga imasu.', 'There is a cat. (2)', NULL, NULL, NULL, '85aff3c4-0167-4bac-a87a-f54998efd5b7', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('猫がいます。 (7)', 'Neko ga imasu.', 'There is a cat. (7)', NULL, NULL, NULL, '8785bd6c-15fa-4a4e-8ce1-9b3c984c9d1b', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('これは私の本です。', 'Kore wa watashi no hon desu.', 'This is my book.', NULL, NULL, NULL, '907ab574-27f4-47f1-a78f-09aff3f344fd', '2026-07-11 03:02:52', '2026-07-11 03:02:52'),
('学校はどこですか。 (13)', 'Gakkou wa doko desu ka.', 'Where is the school? (13)', NULL, NULL, NULL, '91e3fc01-5ff0-4142-aa52-a067572d17e2', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('日本語を勉強します。 (9)', 'Nihongo o benkyou shimasu.', 'I study Japanese. (9)', NULL, NULL, NULL, '924f09f0-a4cc-4110-9bb7-ac6596144ddc', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('日本語を勉強します。 (6)', 'Nihongo o benkyou shimasu.', 'I study Japanese. (6)', NULL, NULL, NULL, '9394188a-2e1f-498c-8100-8eafe8411041', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('日本語を勉強します。 (4)', 'Nihongo o benkyou shimasu.', 'I study Japanese. (4)', NULL, NULL, NULL, '97b1c3ab-c66a-42e2-b7f9-31154eab31fe', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('今、何時ですか。 (14)', 'Ima, nanji desu ka.', 'What time is it now? (14)', NULL, NULL, NULL, 'a11ddb1b-0304-4248-9765-cf5f11ce32f3', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('きのう、りんごを食べました。 (11)', 'Kinou, ringo o tabemashita.', 'I ate an apple yesterday. (11)', NULL, NULL, NULL, 'a465ff45-0702-420f-9e0d-2084a942f51a', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('日本語を勉強します。 (5)', 'Nihongo o benkyou shimasu.', 'I study Japanese. (5)', NULL, NULL, NULL, 'a48e0708-8859-4099-8432-ea8da385a36c', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('今、何時ですか。 (12)', 'Ima, nanji desu ka.', 'What time is it now? (12)', NULL, NULL, NULL, 'a5f9d890-78e7-4551-bb69-8d6b51f09dda', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('水を飲みます。 (8)', 'Mizu o nomimasu.', 'I drink water. (8)', NULL, NULL, NULL, 'a68a4c4c-99d7-47cc-8c3c-7b671cf00e72', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('今、何時ですか。 (5)', 'Ima, nanji desu ka.', 'What time is it now? (5)', NULL, NULL, NULL, 'a68ef77e-f4a9-4585-9b6d-e99e3072a891', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('私は学生です。 (14)', 'Watashi wa gakusei desu.', 'I am a student. (14)', NULL, NULL, NULL, 'a715d3d3-c776-4893-8bfb-51d7ee77d471', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('これは私の本です。 (14)', 'Kore wa watashi no hon desu.', 'This is my book. (14)', NULL, NULL, NULL, 'a71b6335-1da6-4a8b-9e79-d066ce198d9f', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('きのう、りんごを食べました。 (8)', 'Kinou, ringo o tabemashita.', 'I ate an apple yesterday. (8)', NULL, NULL, NULL, 'a8c2fae8-bdda-49e7-99cf-6b781ef7ffa8', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('日本語を勉強します。 (13)', 'Nihongo o benkyou shimasu.', 'I study Japanese. (13)', NULL, NULL, NULL, 'a99de3f2-b6b1-4eba-b226-b39981654a66', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('猫がいます。 (6)', 'Neko ga imasu.', 'There is a cat. (6)', NULL, NULL, NULL, 'aa0d4954-09c7-4780-b5f0-122c35b69cd4', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('これは私の本です。 (3)', 'Kore wa watashi no hon desu.', 'This is my book. (3)', NULL, NULL, NULL, 'aa865c2c-009e-4166-8fca-577a261e5fde', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('これは私の本です。 (6)', 'Kore wa watashi no hon desu.', 'This is my book. (6)', NULL, NULL, NULL, 'ac88bbbd-286a-4045-b80e-0a683aa21dfc', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('あの車は高いです。 (15)', 'Ano kuruma wa takai desu.', 'That car is expensive. (15)', NULL, NULL, NULL, 'ad0ef75f-833c-47b8-a256-35ea3e911b12', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('私は学生です。 (8)', 'Watashi wa gakusei desu.', 'I am a student. (8)', NULL, NULL, NULL, 'b2943cc2-afc1-4001-9e77-f961d56e919e', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('きのう、りんごを食べました。 (9)', 'Kinou, ringo o tabemashita.', 'I ate an apple yesterday. (9)', NULL, NULL, NULL, 'bedd4d65-b4ee-4063-8ae2-cc068cda008d', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('猫がいます。 (12)', 'Neko ga imasu.', 'There is a cat. (12)', NULL, NULL, NULL, 'bfefa69f-e8db-4679-b7d0-7ec80bfca514', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('学校はどこですか。', 'Gakkou wa doko desu ka.', 'Where is the school?', NULL, NULL, NULL, 'c14a6d93-d1c7-4b49-8f9f-db7fdb180c3c', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('猫がいます。', 'Neko ga imasu.', 'There is a cat.', NULL, NULL, NULL, 'c3e77ed7-e350-4399-8ab0-ccc7c02dd928', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('日本語を勉強します。 (7)', 'Nihongo o benkyou shimasu.', 'I study Japanese. (7)', NULL, NULL, NULL, 'c401f28c-ce6e-4179-8339-cab6ea96f808', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('水を飲みます。 (15)', 'Mizu o nomimasu.', 'I drink water. (15)', NULL, NULL, NULL, 'c43b68f5-5135-48e2-8170-411936e38701', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('水を飲みます。 (3)', 'Mizu o nomimasu.', 'I drink water. (3)', NULL, NULL, NULL, 'c5b2181e-0eac-4515-a120-3e89bd52199d', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('私は学生です。 (10)', 'Watashi wa gakusei desu.', 'I am a student. (10)', NULL, NULL, NULL, 'c7d90038-734d-4b7d-b24c-79762e9431f4', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('あの車は高いです。', 'Ano kuruma wa takai desu.', 'That car is expensive.', NULL, NULL, NULL, 'ca8202de-a4f9-489f-b021-b4f19d6fb3a9', '2026-07-11 03:02:52', '2026-07-11 03:02:52'),
('明日、東京に行きます。 (9)', 'Ashita, Tokyo ni ikimasu.', 'I will go to Tokyo tomorrow. (9)', NULL, NULL, NULL, 'cf40227f-8fcf-49ff-9b42-861c813d77c1', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('あの車は高いです。 (9)', 'Ano kuruma wa takai desu.', 'That car is expensive. (9)', NULL, NULL, NULL, 'cf4a7cd7-6714-4c40-944b-aaf1ac950932', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('きのう、りんごを食べました。 (5)', 'Kinou, ringo o tabemashita.', 'I ate an apple yesterday. (5)', NULL, NULL, NULL, 'd31e7b16-f0ea-4f00-b880-483b60cffc35', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('学校はどこですか。 (8)', 'Gakkou wa doko desu ka.', 'Where is the school? (8)', NULL, NULL, NULL, 'd4ee746a-8aac-4750-a748-72991af4757c', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('これは私の本です。 (11)', 'Kore wa watashi no hon desu.', 'This is my book. (11)', NULL, NULL, NULL, 'd530aee1-458a-4a3e-8dec-d4efbd113634', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('水を飲みます。 (5)', 'Mizu o nomimasu.', 'I drink water. (5)', NULL, NULL, NULL, 'd5e9617c-f90c-4866-b6d6-039c27ec378a', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('日本語を勉強します。 (15)', 'Nihongo o benkyou shimasu.', 'I study Japanese. (15)', NULL, NULL, NULL, 'd6844413-621b-4635-81a2-97cbf87da621', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('明日、東京に行きます。 (11)', 'Ashita, Tokyo ni ikimasu.', 'I will go to Tokyo tomorrow. (11)', NULL, NULL, NULL, 'd84c5363-0359-4df7-ac09-dca101d57d90', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('水を飲みます。 (12)', 'Mizu o nomimasu.', 'I drink water. (12)', NULL, NULL, NULL, 'd87c07fd-da59-4e9a-88b1-6a7842311b5f', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('猫がいます。 (15)', 'Neko ga imasu.', 'There is a cat. (15)', NULL, NULL, NULL, 'd8f30676-16b3-45bb-bf51-e274994d98d5', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('あの車は高いです。 (7)', 'Ano kuruma wa takai desu.', 'That car is expensive. (7)', NULL, NULL, NULL, 'dd375738-14c4-4ed6-b639-447830763b3a', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('これは私の本です。 (2)', 'Kore wa watashi no hon desu.', 'This is my book. (2)', NULL, NULL, NULL, 'dd524c39-d233-471c-a576-91a297c06631', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('これは私の本です。 (9)', 'Kore wa watashi no hon desu.', 'This is my book. (9)', NULL, NULL, NULL, 'dd9e31ef-f83a-4681-b8eb-82edc07eab04', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('今、何時ですか。 (9)', 'Ima, nanji desu ka.', 'What time is it now? (9)', NULL, NULL, NULL, 'ddf5f83b-79e1-48d8-8352-36751c1eca01', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('きのう、りんごを食べました。 (2)', 'Kinou, ringo o tabemashita.', 'I ate an apple yesterday. (2)', NULL, NULL, NULL, 'de1c7567-1f5e-4fe3-9f76-05b47b6d4be3', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('日本語を勉強します。 (10)', 'Nihongo o benkyou shimasu.', 'I study Japanese. (10)', NULL, NULL, NULL, 'de2c175d-8c7a-48a6-a2fa-b042a54134c5', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('猫がいます。 (13)', 'Neko ga imasu.', 'There is a cat. (13)', NULL, NULL, NULL, 'dffac2ef-0c30-4612-9ead-3c0b8fd20000', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('猫がいます。 (9)', 'Neko ga imasu.', 'There is a cat. (9)', NULL, NULL, NULL, 'e02b9a3f-57f6-4f8b-ac1a-df9ced39a216', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('学校はどこですか。 (3)', 'Gakkou wa doko desu ka.', 'Where is the school? (3)', NULL, NULL, NULL, 'e24076ca-bb3c-47bc-9123-34d0459a0f64', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('あの車は高いです。 (10)', 'Ano kuruma wa takai desu.', 'That car is expensive. (10)', NULL, NULL, NULL, 'e24cad93-9e22-4292-8047-b0421eb98db6', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('私は学生です。 (7)', 'Watashi wa gakusei desu.', 'I am a student. (7)', NULL, NULL, NULL, 'e2622b46-a721-4375-aeb3-1da9dafe2b21', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('明日、東京に行きます。 (15)', 'Ashita, Tokyo ni ikimasu.', 'I will go to Tokyo tomorrow. (15)', NULL, NULL, NULL, 'e2f5a98d-9f64-428b-9516-a9332e850626', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('水を飲みます。 (14)', 'Mizu o nomimasu.', 'I drink water. (14)', NULL, NULL, NULL, 'e32204fa-24ae-4d21-a3db-bd697bd287fc', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('私は学生です。 (6)', 'Watashi wa gakusei desu.', 'I am a student. (6)', NULL, NULL, NULL, 'e3c9edf3-3f81-4164-88fc-8ded835fc6f1', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('明日、東京に行きます。 (3)', 'Ashita, Tokyo ni ikimasu.', 'I will go to Tokyo tomorrow. (3)', NULL, NULL, NULL, 'e42ee4f2-c9cc-4070-8024-d9b02823a72f', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('学校はどこですか。 (4)', 'Gakkou wa doko desu ka.', 'Where is the school? (4)', NULL, NULL, NULL, 'e4f991e3-3470-4e17-90e5-9936f8280f35', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('猫がいます。 (10)', 'Neko ga imasu.', 'There is a cat. (10)', NULL, NULL, NULL, 'e66963d0-ceb6-46c6-ae2b-2c58fb061ca2', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('水を飲みます。 (2)', 'Mizu o nomimasu.', 'I drink water. (2)', NULL, NULL, NULL, 'e6ed5c82-2102-4432-a15b-abe453bc1bbe', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('学校はどこですか。 (10)', 'Gakkou wa doko desu ka.', 'Where is the school? (10)', NULL, NULL, NULL, 'e7c6bfee-bbe7-425f-9ed2-963ed8f57f59', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('明日、東京に行きます。 (14)', 'Ashita, Tokyo ni ikimasu.', 'I will go to Tokyo tomorrow. (14)', NULL, NULL, NULL, 'ebde1208-3ea2-408e-bdd8-1ad069b486b6', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('今、何時ですか。 (7)', 'Ima, nanji desu ka.', 'What time is it now? (7)', NULL, NULL, NULL, 'edcd7340-e46e-4dc2-804a-7c16145fbc70', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('あの車は高いです。 (8)', 'Ano kuruma wa takai desu.', 'That car is expensive. (8)', NULL, NULL, NULL, 'f09115f0-cebe-40eb-8ea2-d5aefa16d25c', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('これは私の本です。 (12)', 'Kore wa watashi no hon desu.', 'This is my book. (12)', NULL, NULL, NULL, 'f1deef2b-bda5-46cf-a2dc-9bd148976e2c', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('日本語を勉強します。 (12)', 'Nihongo o benkyou shimasu.', 'I study Japanese. (12)', NULL, NULL, NULL, 'f2951914-934e-4889-a7b4-b1f174c1b61e', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('今、何時ですか。 (3)', 'Ima, nanji desu ka.', 'What time is it now? (3)', NULL, NULL, NULL, 'f2f078db-eaa1-4235-9dac-f7c166582e9b', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('明日、東京に行きます。 (2)', 'Ashita, Tokyo ni ikimasu.', 'I will go to Tokyo tomorrow. (2)', NULL, NULL, NULL, 'f75ac570-c67d-42a0-a9b9-674d3cab17a4', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('きのう、りんごを食べました。 (10)', 'Kinou, ringo o tabemashita.', 'I ate an apple yesterday. (10)', NULL, NULL, NULL, 'f8051ac1-4151-4429-9562-2c804ca5af0c', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('水を飲みます。 (13)', 'Mizu o nomimasu.', 'I drink water. (13)', NULL, NULL, NULL, 'f8465ca9-c062-4b95-9c72-e7e021a41ec1', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('私は学生です。', 'Watashi wa gakusei desu.', 'I am a student.', NULL, NULL, NULL, 'f86ba3e2-6203-441c-b853-09c2246dbbbe', '2026-07-11 03:02:52', '2026-07-11 03:02:52'),
('あの車は高いです。 (4)', 'Ano kuruma wa takai desu.', 'That car is expensive. (4)', NULL, NULL, NULL, 'f9207d3e-4761-4745-b609-f5bc47f8c441', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('猫がいます。 (8)', 'Neko ga imasu.', 'There is a cat. (8)', NULL, NULL, NULL, 'f944174d-a3a5-4479-9df9-361abef4ac9a', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('学校はどこですか。 (12)', 'Gakkou wa doko desu ka.', 'Where is the school? (12)', NULL, NULL, NULL, 'fa3342fc-74ca-46f4-ab73-39431a5ab88a', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('きのう、りんごを食べました。 (4)', 'Kinou, ringo o tabemashita.', 'I ate an apple yesterday. (4)', NULL, NULL, NULL, 'fa596494-1e4b-4c28-b8c3-c5fa7151f650', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('日本語を勉強します。 (2)', 'Nihongo o benkyou shimasu.', 'I study Japanese. (2)', NULL, NULL, NULL, 'fa6d8314-b17c-457f-8148-a468b46b286f', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('きのう、りんごを食べました。 (12)', 'Kinou, ringo o tabemashita.', 'I ate an apple yesterday. (12)', NULL, NULL, NULL, 'fb5af349-1b9f-4c49-a658-898b1ff422e4', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('これは私の本です。 (13)', 'Kore wa watashi no hon desu.', 'This is my book. (13)', NULL, NULL, NULL, 'fb8f5f50-dbe8-4fce-9c89-9420ad03ae3e', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('日本語を勉強します。 (14)', 'Nihongo o benkyou shimasu.', 'I study Japanese. (14)', NULL, NULL, NULL, 'fcd53071-e46a-445d-925d-ba9b17ff5b2d', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('あの車は高いです。 (2)', 'Ano kuruma wa takai desu.', 'That car is expensive. (2)', NULL, NULL, NULL, 'fd379dbf-9381-4e80-9d51-d32cd8f88876', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('今、何時ですか。 (8)', 'Ima, nanji desu ka.', 'What time is it now? (8)', NULL, NULL, NULL, 'fd87aa1b-16ab-425a-a407-41c1a8aeadfd', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('学校はどこですか。 (11)', 'Gakkou wa doko desu ka.', 'Where is the school? (11)', NULL, NULL, NULL, 'ff6e9777-c48a-4cfc-8b5e-fefe52bfa9f4', '2026-07-11 03:04:03', '2026-07-11 03:04:03');

-- --------------------------------------------------------

--
-- Table structure for table `generation_jobs`
--

CREATE TABLE `generation_jobs` (
  `job_type` enum('QUESTION_GENERATION','TTS_GENERATION') NOT NULL,
  `status` enum('PENDING','PROCESSING','COMPLETED','FAILED','CANCELLED') NOT NULL,
  `prompt_json` text NOT NULL,
  `raw_response` text DEFAULT NULL,
  `error_message` text DEFAULT NULL,
  `tokens_used` int(11) DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `celery_task_id` varchar(255) DEFAULT NULL,
  `target_id` varchar(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `generation_jobs`
--

INSERT INTO `generation_jobs` (`job_type`, `status`, `prompt_json`, `raw_response`, `error_message`, `tokens_used`, `created_by`, `started_at`, `completed_at`, `id`, `created_at`, `updated_at`, `celery_task_id`, `target_id`) VALUES
('TTS_GENERATION', 'CANCELLED', 'キャンセル', NULL, NULL, 0, '8c059ab6-5a7d-4430-bcb2-3755623a3a0a', NULL, NULL, '0b43ec13-bb47-44e5-b915-2b8b051057e4', '2026-07-11 02:28:44', '2026-07-11 02:28:44', NULL, NULL),
('TTS_GENERATION', 'CANCELLED', 'キャンセル', NULL, NULL, 0, '8c059ab6-5a7d-4430-bcb2-3755623a3a0a', NULL, NULL, '12e2574a-d600-4f59-9632-3f09e2819b81', '2026-07-11 04:40:21', '2026-07-11 04:40:21', NULL, 'test-lesson-id'),
('QUESTION_GENERATION', 'PENDING', '{\"lesson_id\":\"test-lesson-id\",\"question_type\":\"MULTIPLE_CHOICE\",\"skill\":\"GRAMMAR\",\"count\":5,\"difficulty\":1,\"prompt_version\":\"v1\",\"additional_notes\":null}', NULL, NULL, 0, '8c059ab6-5a7d-4430-bcb2-3755623a3a0a', NULL, NULL, '1c9d77ac-cad6-4691-9a39-ae1ad4178c91', '2026-07-11 04:40:21', '2026-07-11 04:40:21', NULL, 'test-lesson-id'),
('TTS_GENERATION', 'PENDING', 'こんにちは', NULL, NULL, 0, '8c059ab6-5a7d-4430-bcb2-3755623a3a0a', NULL, NULL, '3d623cdb-fdd9-429a-bbb7-92360fc59d12', '2026-07-11 02:28:44', '2026-07-11 02:28:44', NULL, NULL),
('TTS_GENERATION', 'PENDING', 'テスト', NULL, NULL, 0, '8c059ab6-5a7d-4430-bcb2-3755623a3a0a', NULL, NULL, '4fe1253f-30a4-4387-8a7b-f1544a09752f', '2026-07-11 04:40:21', '2026-07-11 04:40:21', NULL, 'test-lesson-id'),
('TTS_GENERATION', 'PENDING', 'テスト', NULL, NULL, 0, '8c059ab6-5a7d-4430-bcb2-3755623a3a0a', NULL, NULL, '56a7e399-d48e-488a-8486-aa0cd06c26e5', '2026-07-11 04:22:40', '2026-07-11 04:22:40', NULL, 'test-lesson-id'),
('TTS_GENERATION', 'PENDING', 'こんにちは', NULL, NULL, 0, '8c059ab6-5a7d-4430-bcb2-3755623a3a0a', NULL, NULL, '5aea3ab2-1a34-4a15-bd1a-64e2bae6c14e', '2026-07-11 04:40:21', '2026-07-11 04:40:21', NULL, 'test-lesson-id'),
('TTS_GENERATION', 'PENDING', 'こんにちは', NULL, NULL, 0, '8c059ab6-5a7d-4430-bcb2-3755623a3a0a', NULL, NULL, '61d03ffb-a315-41e5-89b7-55aee02d2a00', '2026-07-11 04:22:40', '2026-07-11 04:22:40', NULL, 'test-lesson-id'),
('QUESTION_GENERATION', 'PENDING', '{\"lesson_id\":\"test-lesson-id\",\"question_type\":\"MULTIPLE_CHOICE\",\"skill\":\"GRAMMAR\",\"count\":5,\"difficulty\":1,\"prompt_version\":\"v1\",\"additional_notes\":null}', NULL, NULL, 0, '8c059ab6-5a7d-4430-bcb2-3755623a3a0a', NULL, NULL, '7c927e31-61e9-49f9-ae9e-531edceb94da', '2026-07-11 02:25:43', '2026-07-11 02:25:43', NULL, NULL),
('QUESTION_GENERATION', 'PENDING', '{\"lesson_id\":\"test-lesson-id\",\"question_type\":\"MULTIPLE_CHOICE\",\"skill\":\"GRAMMAR\",\"count\":5,\"difficulty\":1,\"prompt_version\":\"v1\",\"additional_notes\":null}', NULL, NULL, 0, '8c059ab6-5a7d-4430-bcb2-3755623a3a0a', NULL, NULL, '89605ca3-32fb-441b-b0fb-bdf117f6b7bc', '2026-07-11 02:26:20', '2026-07-11 02:26:20', NULL, NULL),
('TTS_GENERATION', 'CANCELLED', 'キャンセル', NULL, NULL, 0, '8c059ab6-5a7d-4430-bcb2-3755623a3a0a', NULL, NULL, '8d40eb8e-845c-4edc-9028-ea0651505554', '2026-07-11 04:22:40', '2026-07-11 04:22:40', NULL, 'test-lesson-id'),
('QUESTION_GENERATION', 'PENDING', '{\"lesson_id\":\"test-lesson-id\",\"question_type\":\"MULTIPLE_CHOICE\",\"skill\":\"GRAMMAR\",\"count\":5,\"difficulty\":1,\"prompt_version\":\"v1\",\"additional_notes\":null}', NULL, NULL, 0, '8c059ab6-5a7d-4430-bcb2-3755623a3a0a', NULL, NULL, 'a7de5980-d3c1-483e-825e-b7f74b72eeb6', '2026-07-11 02:22:12', '2026-07-11 02:22:12', NULL, NULL),
('TTS_GENERATION', 'PENDING', 'こんにちは', NULL, NULL, 0, '8c059ab6-5a7d-4430-bcb2-3755623a3a0a', NULL, NULL, 'b8c9674c-5776-4dc9-bc28-831eb8a468b7', '2026-07-11 02:27:27', '2026-07-11 02:27:27', NULL, NULL),
('TTS_GENERATION', 'PENDING', 'テスト', NULL, NULL, 0, '8c059ab6-5a7d-4430-bcb2-3755623a3a0a', NULL, NULL, 'b9a308ad-ad82-442f-bd50-590fcda98cfe', '2026-07-11 02:28:44', '2026-07-11 02:28:44', NULL, NULL),
('QUESTION_GENERATION', 'PENDING', '{\"lesson_id\":\"test-lesson-id\",\"question_type\":\"MULTIPLE_CHOICE\",\"skill\":\"GRAMMAR\",\"count\":5,\"difficulty\":1,\"prompt_version\":\"v1\",\"additional_notes\":null}', NULL, NULL, 0, '8c059ab6-5a7d-4430-bcb2-3755623a3a0a', NULL, NULL, 'db58bffc-daee-4e3b-adf5-b0f170a333f2', '2026-07-11 04:22:40', '2026-07-11 04:22:40', NULL, 'test-lesson-id'),
('QUESTION_GENERATION', 'PENDING', '{\"lesson_id\":\"test-lesson-id\",\"question_type\":\"MULTIPLE_CHOICE\",\"skill\":\"GRAMMAR\",\"count\":5,\"difficulty\":1,\"prompt_version\":\"v1\",\"additional_notes\":null}', NULL, NULL, 0, '8c059ab6-5a7d-4430-bcb2-3755623a3a0a', NULL, NULL, 'ea72aa38-8a84-4130-a603-0a7a6e4da35b', '2026-07-11 02:28:44', '2026-07-11 02:28:44', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `grammar_points`
--

CREATE TABLE `grammar_points` (
  `title` varchar(255) NOT NULL,
  `structure` text NOT NULL,
  `meaning` text NOT NULL,
  `explanation` text DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `grammar_points`
--

INSERT INTO `grammar_points` (`title`, `structure`, `meaning`, `explanation`, `id`, `created_at`, `updated_at`) VALUES
('Vました 3', 'Verb-ました', 'Did Verb (Polite)', 'Polite past affirmative.', '009086f2-1ec5-451c-b1ef-0581a818a770', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('Nに 3', 'N に', 'At/In/To N', 'Particle indicating time or destination.', '0122e1d0-82a8-48b6-b1a8-3e8cdfaeb021', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('Vました 2', 'Verb-ました', 'Did Verb (Polite)', 'Polite past affirmative.', '03f1e4a9-7ba7-462e-a91e-f6119474c048', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('NのN 3', 'N の N', 'N\'s N (Possessive)', 'Links two nouns.', '081d28f3-50fa-4de6-b7bd-dc96d2aa79b4', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('Nが', 'N が', 'Subject marker', 'Particle indicating subject.', '0fe4677e-2c80-4f6d-bf79-8481fc0d0044', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('NのN 2', 'N の N', 'N\'s N (Possessive)', 'Links two nouns.', '16681a78-573c-44bf-bc6e-a5ed2b4087ca', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('Vます 3', 'Verb-ます', 'Do Verb (Polite)', 'Polite non-past affirmative.', '1ae59eb4-d7ff-499f-9206-11a9e3dedac0', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('〜から〜まで', '〜から 〜まで', 'From ~ to ~', 'Indicates starting and ending points.', '246d0abf-624f-4a39-a07c-45eaf40ee690', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('NをV 3', 'N を Verb', 'Object marker', 'Particle indicating direct object.', '2e799ac9-1762-4416-bc98-594426dedab8', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('Nが 3', 'N が', 'Subject marker', 'Particle indicating subject.', '6600d329-7ac1-4161-8a88-c1b896f94798', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('Vたい 2', 'Verb-たい', 'Want to Verb', 'Indicates desire to perform an action.', '6dd7aba6-34fc-4c09-9456-e6abd0e154ae', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('Vました', 'Verb-ました', 'Did Verb (Polite)', 'Polite past affirmative.', '6de433ee-88ed-4bf4-97c2-bea64b8c86ba', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('Nが 2', 'N が', 'Subject marker', 'Particle indicating subject.', '7c8ab60f-6571-45fd-82cf-5cec60834e7b', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('〜から〜まで 3', '〜から 〜まで', 'From ~ to ~', 'Indicates starting and ending points.', '81b3badd-88e9-432b-a53a-d51d41d550de', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('〜から〜まで 2', '〜から 〜まで', 'From ~ to ~', 'Indicates starting and ending points.', '9551c5b3-ecb8-4a04-bb46-754fb9c747d7', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('NはNです', 'N は N です', 'N is N', 'Basic identification.', '9a6e0691-3ac0-40c2-a3f0-4032cee3e2e4', '2026-07-11 03:02:52', '2026-07-11 03:02:52'),
('NをV', 'N を Verb', 'Object marker', 'Particle indicating direct object.', '9da5a0f1-c362-4d50-9d78-534b7dee3678', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('Vます', 'Verb-ます', 'Do Verb (Polite)', 'Polite non-past affirmative.', 'b7fd71d2-1244-434c-aaaf-d08deea873b9', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('NをV 2', 'N を Verb', 'Object marker', 'Particle indicating direct object.', 'bad6a06d-1c6e-4213-b3ea-765168200bbb', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('Nに 2', 'N に', 'At/In/To N', 'Particle indicating time or destination.', 'bcd22a6e-069d-46de-9077-e0f5fa7fa89d', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('Vません 2', 'Verb-ません', 'Do not Verb (Polite)', 'Polite non-past negative.', 'c5ff326e-3010-46c2-a451-9a88b315771e', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('NのN', 'N の N', 'N\'s N (Possessive)', 'Links two nouns.', 'ce65eb0b-4ab8-4652-ac90-a23000a2154b', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('NはNです 3', 'N は N です', 'N is N', 'Basic identification.', 'd3ab6262-2628-49e3-943d-040084ef437a', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('Nに', 'N に', 'At/In/To N', 'Particle indicating time or destination.', 'daf1e110-340c-4c79-b58b-10e8eb72389f', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('NはNです 2', 'N は N です', 'N is N', 'Basic identification.', 'dbc8f5b6-7337-446f-912c-8429a13fdcbb', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('Vたい 3', 'Verb-たい', 'Want to Verb', 'Indicates desire to perform an action.', 'dfe9017c-d18a-4e88-929d-33cd290c7d42', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('Vます 2', 'Verb-ます', 'Do Verb (Polite)', 'Polite non-past affirmative.', 'e5db6461-22a6-424f-96ad-77ce1c81c88b', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('Vません 3', 'Verb-ません', 'Do not Verb (Polite)', 'Polite non-past negative.', 'e98a8c83-7033-4148-9b3b-aaae55ff9565', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('Vたい', 'Verb-たい', 'Want to Verb', 'Indicates desire to perform an action.', 'fe457b6d-b5df-4d90-9598-a13253285590', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('Vません', 'Verb-ません', 'Do not Verb (Polite)', 'Polite non-past negative.', 'fe91712a-5bdf-4ff7-8cdb-1fb29b58a4ee', '2026-07-11 03:04:00', '2026-07-11 03:04:00');

-- --------------------------------------------------------

--
-- Table structure for table `jlpt_simulations`
--

CREATE TABLE `jlpt_simulations` (
  `title` varchar(255) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `level` varchar(10) NOT NULL,
  `passing_score` int(11) NOT NULL,
  `is_published` tinyint(1) DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `jlpt_simulations`
--

INSERT INTO `jlpt_simulations` (`title`, `description`, `level`, `passing_score`, `is_published`, `id`, `created_at`, `updated_at`) VALUES
('N5 Mock', NULL, 'N5', 80, 1, '366dedc4-a1f2-47c7-b056-e5c4686adbec', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('N5 Mock', NULL, 'N5', 80, 1, '8c2675bb-a9dc-4df8-8e91-2ee06a0a0e18', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('N5 Mock', NULL, 'N5', 80, 1, 'a37d4eaa-9d50-4a8e-a312-28c98bda4d34', '2026-07-11 04:40:22', '2026-07-11 04:40:22'),
('N5 Mock', NULL, 'N5', 80, 1, 'a449e794-34b5-4ebd-97ae-6588fbf537cd', '2026-07-11 04:40:23', '2026-07-11 04:40:23');

-- --------------------------------------------------------

--
-- Table structure for table `jlpt_simulation_questions`
--

CREATE TABLE `jlpt_simulation_questions` (
  `section_id` varchar(36) NOT NULL,
  `question_id` varchar(36) NOT NULL,
  `order_number` int(11) NOT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `jlpt_simulation_questions`
--

INSERT INTO `jlpt_simulation_questions` (`section_id`, `question_id`, `order_number`, `id`, `created_at`, `updated_at`) VALUES
('cf4edffb-bb72-4433-9f2c-adb2f4cd4890', '36120889-4130-4d31-84ce-a1212482eecd', 1, '01987076-0b25-4012-bf8a-337e1016012f', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('cfae5523-1bfd-47d0-820a-23e9815c66cd', 'e60237b2-15b7-4066-89a8-fe022cd477e9', 1, '1b2f3060-12fa-4496-ab4b-701e04ee2ba9', '2026-07-11 04:40:23', '2026-07-11 04:40:23'),
('736bfb4e-c709-4c5d-851e-4a71d9caf3c7', 'f41f53af-c586-488f-9281-57a284312186', 1, '368ec434-3e4e-49c3-83e3-ecabfba6b4a4', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('ee4a97ad-55af-4f3c-ba6b-7a48012f9ecf', 'a2ada812-3aa7-405b-9650-108405f2f1a4', 1, '51dd292e-facb-43c6-9381-2799893f298d', '2026-07-11 04:40:23', '2026-07-11 04:40:23');

-- --------------------------------------------------------

--
-- Table structure for table `jlpt_simulation_sections`
--

CREATE TABLE `jlpt_simulation_sections` (
  `simulation_id` varchar(36) NOT NULL,
  `title` varchar(255) NOT NULL,
  `section_type` varchar(50) NOT NULL,
  `sequence` int(11) DEFAULT NULL,
  `duration_minutes` int(11) NOT NULL,
  `passing_score` int(11) NOT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `jlpt_simulation_sections`
--

INSERT INTO `jlpt_simulation_sections` (`simulation_id`, `title`, `section_type`, `sequence`, `duration_minutes`, `passing_score`, `id`, `created_at`, `updated_at`) VALUES
('366dedc4-a1f2-47c7-b056-e5c4686adbec', 'Vocab', 'VOCABULARY_KANJI', 1, 25, 19, '736bfb4e-c709-4c5d-851e-4a71d9caf3c7', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('8c2675bb-a9dc-4df8-8e91-2ee06a0a0e18', 'Vocab', 'VOCABULARY_KANJI', 1, 25, 19, 'cf4edffb-bb72-4433-9f2c-adb2f4cd4890', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('a449e794-34b5-4ebd-97ae-6588fbf537cd', 'Vocab', 'VOCABULARY_KANJI', 1, 25, 19, 'cfae5523-1bfd-47d0-820a-23e9815c66cd', '2026-07-11 04:40:23', '2026-07-11 04:40:23'),
('a37d4eaa-9d50-4a8e-a312-28c98bda4d34', 'Vocab', 'VOCABULARY_KANJI', 1, 25, 19, 'ee4a97ad-55af-4f3c-ba6b-7a48012f9ecf', '2026-07-11 04:40:23', '2026-07-11 04:40:23');

-- --------------------------------------------------------

--
-- Table structure for table `kanjis`
--

CREATE TABLE `kanjis` (
  `character` varchar(10) NOT NULL,
  `onyomi` varchar(100) DEFAULT NULL,
  `kunyomi` varchar(100) DEFAULT NULL,
  `meaning` varchar(255) NOT NULL,
  `stroke_count` int(11) DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `kanjis`
--

INSERT INTO `kanjis` (`character`, `onyomi`, `kunyomi`, `meaning`, `stroke_count`, `id`, `created_at`, `updated_at`) VALUES
('五', 'ゴ', 'いつ, いつ.つ', 'Five', 4, '0403843f-5416-47af-85f7-ba3d14d73f6b', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('人4', 'ジン, ニン', 'ひと', 'Person4', 2, '0489e89c-1a3a-4513-b6df-3d6374acc4e4', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('月4', 'ゲツ, ガツ', 'つき', 'Month, moon4', 4, '059140ee-01d2-46e7-bba9-9203bb38a84f', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('三2', 'サン, ゾウ', 'み, み.つ, みっ.つ', 'Three2', 3, '06140ad3-effd-46cd-ba7b-a124f882e816', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('五2', 'ゴ', 'いつ, いつ.つ', 'Five2', 4, '06894823-2e5b-403b-b95d-fa7525fa0081', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('火5', 'カ', 'ひ, -び, ほ-', 'Fire5', 4, '075f46ef-c707-4303-9b33-4007508cd107', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('四', 'シ', 'よ, よ.つ, よっ.つ, よん', 'Four', 5, '0b939ff3-7338-44f4-be90-a75bf81f2a6d', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('小4', 'ショウ', 'ちい.さい, こ-, お-, さ-', 'Little, small4', 3, '0fa30169-35c9-46e4-aa97-957fe1afcb96', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('一5', 'イチ, イツ', 'ひと-, ひと.つ', 'One5', 1, '1007fe21-4578-4ec1-9155-b5251a189edb', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('日2', 'ニチ, ジツ', 'ひ, -び, -か', 'Day, sun2', 4, '1081afcd-d098-40a5-af71-54ef466ad1b0', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('土2', 'ド, ト', 'つち', 'Earth, soil2', 3, '239540e3-681b-4ac5-a119-08f805a12aa3', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('土5', 'ド, ト', 'つち', 'Earth, soil5', 3, '25f8a60d-bc29-4a04-aaf4-cd9bc1e5e2b4', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('火3', 'カ', 'ひ, -び, ほ-', 'Fire3', 4, '26458b00-3cbe-4cfc-afee-02ffe78b4b30', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('月5', 'ゲツ, ガツ', 'つき', 'Month, moon5', 4, '269f7b80-0f36-4f5b-9664-dacf7c18b7a8', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('小', 'ショウ', 'ちい.さい, こ-, お-, さ-', 'Little, small', 3, '2d620b62-be27-4c3b-be53-b8f34fba9af9', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('土3', 'ド, ト', 'つち', 'Earth, soil3', 3, '2e7fe707-a734-408f-9c21-fd186f62f3ff', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('木5', 'ボク, モク', 'き, こ-', 'Tree, wood5', 4, '34009a6f-2807-44d5-918e-f06de6bd7eb4', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('四4', 'シ', 'よ, よ.つ, よっ.つ, よん', 'Four4', 5, '3d0160e3-a63e-42c5-bc87-fedb63ae9a13', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('日6', 'ニチ, ジツ', 'ひ, -び, -か', 'Day, sun6', 4, '3f4c269f-7c60-44e4-9f2e-3e117051b641', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('人6', 'ジン, ニン', 'ひと', 'Person6', 2, '41398445-adbd-479b-a74f-1565e1a027f4', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('二', 'ニ, ジ', 'ふた, ふた.つ, ふたた.び', 'Two', 2, '43b1e2bb-ef33-48a5-a9d8-1ccf856f6c64', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('水2', 'スイ', 'みず', 'Water2', 4, '454b0a2e-4b41-4b58-81a7-c110f90bf1bc', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('小5', 'ショウ', 'ちい.さい, こ-, お-, さ-', 'Little, small5', 3, '462bdffb-3bc3-45d0-9993-62f4639fb801', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('金2', 'キン, コン', 'かね, かな-', 'Gold, money2', 8, '4a07c6f4-0e55-4d50-a04a-355bcec550ac', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('火', 'カ', 'ひ, -び, ほ-', 'Fire', 4, '4f341103-c894-4806-ac7a-98b7f2b85978', '2026-07-11 03:02:52', '2026-07-11 03:02:52'),
('一', 'イチ, イツ', 'ひと-, ひと.つ', 'One', 1, '5218921b-79e8-492e-a5b7-e9c5e974e778', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('月2', 'ゲツ, ガツ', 'つき', 'Month, moon2', 4, '55f3d85e-d08e-401a-95fa-95137ee8810c', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('水', 'スイ', 'みず', 'Water', 4, '56edf6f9-7bf8-479b-8530-2fec783f02c1', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('水6', 'スイ', 'みず', 'Water6', 4, '5769c0fc-74d4-4294-9af6-70c35dbfe975', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('金3', 'キン, コン', 'かね, かな-', 'Gold, money3', 8, '588fe440-82a9-439a-9863-85d58c48f65b', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('土', 'ド, ト', 'つち', 'Earth, soil', 3, '5d143f79-bb9f-4de8-bcb1-2cddcd6b3355', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('小2', 'ショウ', 'ちい.さい, こ-, お-, さ-', 'Little, small2', 3, '5ea7cccf-d43f-4948-b706-87f22de762d0', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('三', 'サン, ゾウ', 'み, み.つ, みっ.つ', 'Three', 3, '5ee43eea-6afc-4e4f-b5f0-7402894f0185', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('一6', 'イチ, イツ', 'ひと-, ひと.つ', 'One6', 1, '5f40b2de-7de8-4088-9b5d-9734ce6030b1', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('一4', 'イチ, イツ', 'ひと-, ひと.つ', 'One4', 1, '61969586-af15-4936-9701-8c6cb877b7a8', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('小3', 'ショウ', 'ちい.さい, こ-, お-, さ-', 'Little, small3', 3, '69f9155d-01a5-4bc0-a5ad-1a678adb2bfb', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('日5', 'ニチ, ジツ', 'ひ, -び, -か', 'Day, sun5', 4, '6b4a3589-f7fd-4948-a3b1-a880908191a9', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('金4', 'キン, コン', 'かね, かな-', 'Gold, money4', 8, '6d431fab-47dc-4a39-8d5c-a13c8ac72fc2', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('五4', 'ゴ', 'いつ, いつ.つ', 'Five4', 4, '7450b4c4-85b6-43ca-8e59-15d7ab00b013', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('三3', 'サン, ゾウ', 'み, み.つ, みっ.つ', 'Three3', 3, '749b9d54-b14a-4982-80c3-42b473010c41', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('大2', 'ダイ, タイ', 'おお-, おお.きい, おお.いに', 'Large, big2', 3, '770a916c-02dd-44f5-9a0c-f03255e1932e', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('小6', 'ショウ', 'ちい.さい, こ-, お-, さ-', 'Little, small6', 3, '787165c5-e943-4cdf-969b-5838c9e19668', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('二3', 'ニ, ジ', 'ふた, ふた.つ, ふたた.び', 'Two3', 2, '7936172c-4a30-49e8-906c-e58cf7941445', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('金', 'キン, コン', 'かね, かな-', 'Gold, money', 8, '7a184f35-fdde-4974-8781-8eb65b3652e1', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('五5', 'ゴ', 'いつ, いつ.つ', 'Five5', 4, '7d3cd2f7-f39d-4446-8619-835d6eb1ce41', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('水4', 'スイ', 'みず', 'Water4', 4, '7e3dc270-9168-46d9-bda3-8d8aee47b4e5', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('日3', 'ニチ, ジツ', 'ひ, -び, -か', 'Day, sun3', 4, '80c4198b-f23c-4774-b2fc-61caa420fdcf', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('二4', 'ニ, ジ', 'ふた, ふた.つ, ふたた.び', 'Two4', 2, '81329835-58b3-4f33-a422-1ec6d8dd7fec', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('人2', 'ジン, ニン', 'ひと', 'Person2', 2, '87139d1e-f333-402a-beed-8e04074afc57', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('日', 'ニチ, ジツ', 'ひ, -び, -か', 'Day, sun', 4, '8a0c4957-9855-48be-92be-ce06f2683e01', '2026-07-10 15:13:34', '2026-07-10 15:13:34'),
('木', 'ボク, モク', 'き, こ-', 'Tree, wood', 4, '8d7b5abf-49f7-4784-bd19-131b9f287848', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('火4', 'カ', 'ひ, -び, ほ-', 'Fire4', 4, '8e87a5e5-f256-452f-a490-0a35106fa8e4', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('大3', 'ダイ, タイ', 'おお-, おお.きい, おお.いに', 'Large, big3', 3, '94642f2c-8b05-47b3-8895-070b538ba6ff', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('一2', 'イチ, イツ', 'ひと-, ひと.つ', 'One2', 1, '9a318459-0d88-4b5f-82c6-39567acdb2c5', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('木4', 'ボク, モク', 'き, こ-', 'Tree, wood4', 4, '9b8ef8a1-00ee-44d4-956c-55932fb758b2', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('木2', 'ボク, モク', 'き, こ-', 'Tree, wood2', 4, '9cd9189b-4df9-4fb2-a816-be0654259439', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('大4', 'ダイ, タイ', 'おお-, おお.きい, おお.いに', 'Large, big4', 3, 'a32e8c45-88dd-4b84-8148-fe1554fb85c6', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('二2', 'ニ, ジ', 'ふた, ふた.つ, ふたた.び', 'Two2', 2, 'a53f210a-074f-4ed8-9064-ad80d8d3f180', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('人', 'ジン, ニン', 'ひと', 'Person', 2, 'a5e2dd03-82af-487e-be6f-4cb60a9fcc1e', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('二6', 'ニ, ジ', 'ふた, ふた.つ, ふたた.び', 'Two6', 2, 'a8075010-7e7f-480a-860f-f10229e521cf', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('木3', 'ボク, モク', 'き, こ-', 'Tree, wood3', 4, 'a961a40a-185d-454a-bb7f-9c9b8d569fc3', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('木6', 'ボク, モク', 'き, こ-', 'Tree, wood6', 4, 'a9fb6c69-02e3-4269-927e-70575bd3cc5d', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('水5', 'スイ', 'みず', 'Water5', 4, 'ab223517-ab7b-4818-8a87-81ed0c66296f', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('四6', 'シ', 'よ, よ.つ, よっ.つ, よん', 'Four6', 5, 'ae398ba7-fe49-400e-9243-08a3c6d26c65', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('三4', 'サン, ゾウ', 'み, み.つ, みっ.つ', 'Three4', 3, 'b15676f8-4671-4225-a55a-6fd51f4fe8b2', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('土4', 'ド, ト', 'つち', 'Earth, soil4', 3, 'b52622a2-cd16-4436-9e9d-12b2d963382e', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('四3', 'シ', 'よ, よ.つ, よっ.つ, よん', 'Four3', 5, 'b6181a79-4ade-44db-a7dc-8b83df5bbb02', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('五6', 'ゴ', 'いつ, いつ.つ', 'Five6', 4, 'b7bac092-9626-4f42-b0df-47bdaa26545f', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('四2', 'シ', 'よ, よ.つ, よっ.つ, よん', 'Four2', 5, 'bb9e0ac0-c02f-4bdd-8905-09343dc67724', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('大6', 'ダイ, タイ', 'おお-, おお.きい, おお.いに', 'Large, big6', 3, 'bbf8c137-6380-4ec0-8525-1a5b121c9f54', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('三5', 'サン, ゾウ', 'み, み.つ, みっ.つ', 'Three5', 3, 'c603a10f-395e-4312-b216-a7027819df71', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('金5', 'キン, コン', 'かね, かな-', 'Gold, money5', 8, 'cab825ce-34ec-44b6-8f0f-90772a410e5a', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('四5', 'シ', 'よ, よ.つ, よっ.つ, よん', 'Four5', 5, 'cb70dee5-7c16-4d08-8829-d8cc35f2d0db', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('三6', 'サン, ゾウ', 'み, み.つ, みっ.つ', 'Three6', 3, 'd1acdfb8-5a6b-438a-939f-d98825fd7021', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('大5', 'ダイ, タイ', 'おお-, おお.きい, おお.いに', 'Large, big5', 3, 'd405a02f-6163-476c-b16e-f475de032941', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('土6', 'ド, ト', 'つち', 'Earth, soil6', 3, 'd56896da-bbe7-465d-8042-ac56d5d9628f', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('人5', 'ジン, ニン', 'ひと', 'Person5', 2, 'd7e84273-549a-43b3-b5a9-dcaa1e2ad367', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('月6', 'ゲツ, ガツ', 'つき', 'Month, moon6', 4, 'dc0d5213-8c54-4d5c-bedb-80fb77cfd2da', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('水3', 'スイ', 'みず', 'Water3', 4, 'dc99862c-d5c1-4c13-bf2f-a79da2319c3b', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('金6', 'キン, コン', 'かね, かな-', 'Gold, money6', 8, 'e937904e-6524-4988-b0c5-4238e2b316ec', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('人3', 'ジン, ニン', 'ひと', 'Person3', 2, 'e9aaf861-0c49-45ac-a69e-5b749e643d7c', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('火2', 'カ', 'ひ, -び, ほ-', 'Fire2', 4, 'eac015e1-d854-4358-b29f-edb51b69af69', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('大', 'ダイ, タイ', 'おお-, おお.きい, おお.いに', 'Large, big', 3, 'ee3338b1-b5d3-4c2a-9b84-c617218b174f', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('一3', 'イチ, イツ', 'ひと-, ひと.つ', 'One3', 1, 'eefafd02-d304-43d6-9bb8-255f15cdeacf', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('月3', 'ゲツ, ガツ', 'つき', 'Month, moon3', 4, 'f0078fef-8781-4a28-8f5b-a2323ba39812', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('月', 'ゲツ, ガツ', 'つき', 'Month, moon', 4, 'f01f43dc-b4fd-47d7-8987-cdf1fc82b5d1', '2026-07-10 15:13:34', '2026-07-10 15:13:34'),
('五3', 'ゴ', 'いつ, いつ.つ', 'Five3', 4, 'f42de83d-34cb-4061-b75e-b779a74b1538', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('火6', 'カ', 'ひ, -び, ほ-', 'Fire6', 4, 'f5b33235-140b-43ff-844e-4725973ecd7a', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('日4', 'ニチ, ジツ', 'ひ, -び, -か', 'Day, sun4', 4, 'f82bbb1d-2699-4691-8bfc-6a430535346a', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('二5', 'ニ, ジ', 'ふた, ふた.つ, ふたた.び', 'Two5', 2, 'f90efa36-f798-49b1-82a9-7461214eacd3', '2026-07-11 03:04:04', '2026-07-11 03:04:04');

-- --------------------------------------------------------

--
-- Table structure for table `learning_sessions`
--

CREATE TABLE `learning_sessions` (
  `user_id` varchar(36) NOT NULL,
  `lesson_id` varchar(36) DEFAULT NULL,
  `mode` enum('PRACTICE','EXAM') NOT NULL,
  `status` enum('ACTIVE','COMPLETED','CANCELLED') NOT NULL,
  `total_questions` int(11) DEFAULT NULL,
  `answered_questions` int(11) DEFAULT NULL,
  `correct_answers` int(11) DEFAULT NULL,
  `final_score` int(11) DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `learning_sessions`
--

INSERT INTO `learning_sessions` (`user_id`, `lesson_id`, `mode`, `status`, `total_questions`, `answered_questions`, `correct_answers`, `final_score`, `started_at`, `completed_at`, `id`, `created_at`, `updated_at`) VALUES
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'ed4bbc51-bfd6-40f7-af9e-a6c6dd6e6823', 'PRACTICE', 'COMPLETED', 1, 1, 0, 0, '2026-07-10 16:15:48', '2026-07-10 16:15:49', '02275d35-735d-4fa9-89b7-32e96eab16d7', '2026-07-10 16:15:48', '2026-07-10 16:15:49'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'c2572650-a575-4d45-91ba-eeef03530aea', 'PRACTICE', 'COMPLETED', 1, 1, 1, 100, '2026-07-10 16:23:43', '2026-07-10 16:23:43', '0a025ca3-c4f9-44ac-879c-2acfcdf03cb7', '2026-07-10 16:23:43', '2026-07-10 16:23:43'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '3c8870a6-081d-4154-88ab-b60d361d3c18', 'PRACTICE', 'COMPLETED', 1, 1, 1, 100, '2026-07-10 16:11:00', '2026-07-10 16:11:00', '0d76eee4-c2aa-458a-97f6-96b54a10a717', '2026-07-10 16:11:00', '2026-07-10 16:11:00'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '89f07a8c-bd62-422c-975e-09785e16834a', 'PRACTICE', 'ACTIVE', 1, 1, 0, 0, '2026-07-10 15:54:02', NULL, '0dc623f1-b71e-4c54-887b-415ba5dcd607', '2026-07-10 15:54:02', '2026-07-10 15:54:02'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'f8f97f68-a8e2-4b69-ad0c-17fcad7b0463', 'PRACTICE', 'COMPLETED', 1, 1, 0, 0, '2026-07-10 16:20:01', '2026-07-10 16:20:01', '12aa6a14-eced-4785-9ffd-b40bcf8c059e', '2026-07-10 16:20:01', '2026-07-10 16:20:01'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'b360716b-8e25-4946-aa90-5a902afdddbc', 'PRACTICE', 'ACTIVE', 1, 1, 0, 0, '2026-07-10 16:04:37', NULL, '1a054b63-53c6-48c4-aad4-fec413e9a61c', '2026-07-10 16:04:37', '2026-07-10 16:04:37'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '45d3cf24-9288-47f3-ba31-8afe95dcfe78', 'PRACTICE', 'COMPLETED', 1, 1, 0, 0, '2026-07-10 16:06:23', '2026-07-10 16:06:23', '1e18b4a8-b989-4845-9f50-3dc8f6151701', '2026-07-10 16:06:23', '2026-07-10 16:06:23'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'df3ef33d-9678-4373-befe-7c408f7e7c6d', 'PRACTICE', 'COMPLETED', 1, 1, 1, 100, '2026-07-10 16:09:49', '2026-07-10 16:09:49', '205b3037-bd34-4936-b8a1-f613d88317d3', '2026-07-10 16:09:49', '2026-07-10 16:09:49'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'ebdcd7d0-0fd0-4f52-b9e4-3fe9b34dfa09', 'PRACTICE', 'COMPLETED', 1, 1, 1, 100, '2026-07-10 16:15:48', '2026-07-10 16:15:48', '205da50b-460e-42dc-a8b3-cd42b740ce97', '2026-07-10 16:15:48', '2026-07-10 16:15:48'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'd3958367-bfd4-40a1-a5e9-6426dc39fff9', 'PRACTICE', 'ACTIVE', 1, 0, 0, 0, '2026-07-11 04:22:42', NULL, '32353c02-3945-4383-96ba-ed49dcdcff0b', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'fb6f81f4-0050-49ce-a147-9672b6e9ca3c', 'PRACTICE', 'COMPLETED', 1, 1, 0, 0, '2026-07-10 15:55:00', '2026-07-10 15:55:00', '37439872-ffab-4891-a8af-28e7e4fd67ea', '2026-07-10 15:55:00', '2026-07-10 15:55:00'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'e1db5222-af24-4be3-9837-1a4a8db18940', 'PRACTICE', 'COMPLETED', 1, 1, 0, 0, '2026-07-10 16:09:32', '2026-07-10 16:09:32', '39b25e9a-474e-4e41-8aa6-d89659d0ea6a', '2026-07-10 16:09:32', '2026-07-10 16:09:32'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '579fcbe8-22d9-4a4a-a643-76b4936f4909', 'PRACTICE', 'COMPLETED', 1, 1, 1, 100, '2026-07-10 16:16:05', '2026-07-10 16:16:05', '3f802aee-d739-4751-9d49-41858f91fd5f', '2026-07-10 16:16:05', '2026-07-10 16:16:05'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', NULL, 'PRACTICE', 'ACTIVE', 5, 0, 0, 0, '2026-07-11 04:22:41', NULL, '3fc557db-e767-423d-82b4-6f6a8142e58d', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'b2bfe62e-dd2b-4e21-878c-1a4c3eb354b3', 'PRACTICE', 'ACTIVE', 1, 1, 1, 0, '2026-07-10 16:04:36', NULL, '3fcefb44-fc83-4509-beb0-d1a80ad5adca', '2026-07-10 16:04:36', '2026-07-10 16:04:36'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '47f442d1-1589-41f3-9a36-fde592ad4522', 'PRACTICE', 'COMPLETED', 1, 1, 1, 100, '2026-07-10 16:06:22', '2026-07-10 16:06:23', '4ab24488-fc65-47c0-85eb-10b75b2a48cd', '2026-07-10 16:06:22', '2026-07-10 16:06:23'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '47dc78da-36d7-49a6-959d-f84c07a5ea53', 'PRACTICE', 'COMPLETED', 1, 1, 1, 100, '2026-07-11 04:22:41', '2026-07-11 04:22:41', '500fa73a-4ab8-450f-8011-071575d8eb43', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'd9aaff72-156b-4faa-88dc-ead305ecb063', 'PRACTICE', 'COMPLETED', 1, 1, 0, 0, '2026-07-11 04:22:41', '2026-07-11 04:22:41', '5b4ad3f2-13ce-45fa-aae4-eccd28c92563', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'a3232fac-0e05-4798-8cb0-2b676e03ab1d', 'PRACTICE', 'ACTIVE', 1, 1, 0, 0, '2026-07-10 16:04:54', NULL, '62874753-c11b-46cf-81a4-ce319ae877be', '2026-07-10 16:04:54', '2026-07-10 16:04:54'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '14c8ae06-5fdb-4748-aad0-26238692d933', 'PRACTICE', 'COMPLETED', 1, 1, 0, 0, '2026-07-10 16:14:03', '2026-07-10 16:14:03', '64ae4b19-9a56-46a6-b8cb-fd01c5261dcb', '2026-07-10 16:14:03', '2026-07-10 16:14:03'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '17978be0-dd11-4f7f-ac16-1af38e2eae7f', 'PRACTICE', 'COMPLETED', 1, 1, 0, 0, '2026-07-10 15:54:53', '2026-07-10 15:54:53', '6953f214-6dd2-4534-bea5-de91758539f1', '2026-07-10 15:54:53', '2026-07-10 15:54:53'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '6043f684-2388-4503-aa46-2c8a0cd78504', 'PRACTICE', 'COMPLETED', 1, 1, 1, 100, '2026-07-10 16:23:51', '2026-07-10 16:23:51', '6e24bf00-78fc-4b9f-8f3a-0ec952c1f881', '2026-07-10 16:23:51', '2026-07-10 16:23:51'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '52c7fecb-389c-4919-b10d-48e9df95a6bc', 'PRACTICE', 'COMPLETED', 1, 1, 0, 0, '2026-07-11 04:40:22', '2026-07-11 04:40:22', '7a9ec6dd-f272-405f-96c7-5e6969e274db', '2026-07-11 04:40:22', '2026-07-11 04:40:22'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '3d2bc98d-43ea-4001-9525-6fe9fa19708e', 'PRACTICE', 'COMPLETED', 1, 1, 0, 0, '2026-07-10 16:09:49', '2026-07-10 16:09:49', '7d20c6a3-d6df-4887-9fbc-e39712dc4b10', '2026-07-10 16:09:49', '2026-07-10 16:09:49'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'd079b702-fab2-4abd-9fef-00081207747b', 'PRACTICE', 'COMPLETED', 1, 1, 1, 100, '2026-07-10 16:14:03', '2026-07-10 16:14:03', '882a1724-6a92-45b0-863c-84f84d50676b', '2026-07-10 16:14:03', '2026-07-10 16:14:03'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '54a1097d-53b7-4333-88eb-a6b44730242a', 'PRACTICE', 'COMPLETED', 1, 1, 0, 0, '2026-07-10 16:07:53', '2026-07-10 16:07:53', '8f9b2e02-ca8e-4c54-aa4a-0d5073943fc3', '2026-07-10 16:07:53', '2026-07-10 16:07:53'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '5e7c6c2b-cbef-4fad-a100-aa1819c8711a', 'PRACTICE', 'COMPLETED', 1, 1, 1, 100, '2026-07-10 16:09:32', '2026-07-10 16:09:32', '93121dc6-5590-4dc3-8561-4516755077b1', '2026-07-10 16:09:32', '2026-07-10 16:09:32'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '27f16bc8-66e8-4cff-8fbb-57b01208d9bd', 'PRACTICE', 'COMPLETED', 1, 1, 1, 100, '2026-07-10 16:07:53', '2026-07-10 16:07:53', '9d9a8c52-e5f7-463e-bc51-6e19f6e82cd5', '2026-07-10 16:07:53', '2026-07-10 16:07:53'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', NULL, 'PRACTICE', 'ACTIVE', 6, 0, 0, 0, '2026-07-11 04:40:22', NULL, '9fd12678-0bcf-4397-b7e5-981bce5d72a4', '2026-07-11 04:40:22', '2026-07-11 04:40:22'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'c5ffb741-48b6-4636-a478-b038d4b245de', 'PRACTICE', 'COMPLETED', 1, 1, 1, 100, '2026-07-10 16:21:02', '2026-07-10 16:21:03', 'a33d7330-0642-431d-845a-7d80e4f72048', '2026-07-10 16:21:02', '2026-07-10 16:21:03'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '5ee85649-1578-49b3-9883-860604715370', 'PRACTICE', 'ACTIVE', 1, 0, 0, 0, '2026-07-11 04:40:22', NULL, 'a3640681-2c73-464c-a11e-735c0cac94c6', '2026-07-11 04:40:22', '2026-07-11 04:40:22'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '5a23eb31-9ce1-40ca-bbe1-8eae5a19b575', 'PRACTICE', 'COMPLETED', 1, 1, 0, 0, '2026-07-11 04:22:41', '2026-07-11 04:22:41', 'a8b45737-e47f-4385-8c79-cc8e8f87a427', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '1fbf7b41-4588-4334-8ef7-aa4921d2df65', 'PRACTICE', 'COMPLETED', 1, 1, 0, 0, '2026-07-10 16:06:38', '2026-07-10 16:06:38', 'ad81af49-d8de-49dc-a590-ba1a2062a7de', '2026-07-10 16:06:38', '2026-07-10 16:06:38'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '6367218c-d19e-429b-9a71-d7502b7ac080', 'PRACTICE', 'COMPLETED', 1, 1, 1, 100, '2026-07-10 16:20:00', '2026-07-10 16:20:00', 'add90505-f149-4455-ad22-029185bc068a', '2026-07-10 16:20:00', '2026-07-10 16:20:00'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', NULL, 'PRACTICE', 'ACTIVE', 4, 0, 0, 0, '2026-07-10 16:23:51', NULL, 'ae1bc8e9-018a-4abb-9dd9-849f683e48ea', '2026-07-10 16:23:51', '2026-07-10 16:23:51'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', NULL, 'PRACTICE', 'ACTIVE', 1, 0, 0, 0, '2026-07-10 16:20:01', NULL, 'b616c22a-69cb-4b14-a151-1482696d28a3', '2026-07-10 16:20:01', '2026-07-10 16:20:01'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '6b7802f7-2f34-49e7-bab8-cc60ea6e152b', 'PRACTICE', 'ACTIVE', 1, 1, 0, 0, '2026-07-10 15:53:53', NULL, 'b8c8c4eb-ed78-4910-82b2-6a5ac590b667', '2026-07-10 15:53:53', '2026-07-10 15:53:53'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '1f8386ae-57e5-4690-94b5-e69779a4c2cb', 'PRACTICE', 'ACTIVE', 1, 0, 0, 0, '2026-07-11 03:32:51', NULL, 'bcc452d7-f42a-46c1-81d8-924ab408a46e', '2026-07-11 03:32:51', '2026-07-11 03:32:51'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'ecc1233f-1417-4613-83fd-d2762b5cf0da', 'PRACTICE', 'COMPLETED', 1, 1, 0, 0, '2026-07-10 16:11:00', '2026-07-10 16:11:00', 'c79d3ab1-1a61-4ff1-8ec5-f21de9d534df', '2026-07-10 16:11:00', '2026-07-10 16:11:00'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'ac173bab-4c54-4d6d-b9dc-3ded3c8c25d6', 'PRACTICE', 'COMPLETED', 1, 1, 0, 0, '2026-07-10 16:21:03', '2026-07-10 16:21:03', 'cc36aed7-9e4d-45c2-ac63-be760d0ee659', '2026-07-10 16:21:03', '2026-07-10 16:21:03'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'a8e60cab-a07a-4ee3-a5a2-c628f614458e', 'PRACTICE', 'ACTIVE', 1, 0, 0, 0, '2026-07-11 03:33:03', NULL, 'd50e7ddc-977d-4e92-89e1-c00aff4c641b', '2026-07-11 03:33:03', '2026-07-11 03:33:03'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'c9f049ba-4a4f-4000-be39-b10cff1f7da2', 'PRACTICE', 'COMPLETED', 1, 1, 1, 100, '2026-07-11 04:40:21', '2026-07-11 04:40:21', 'dbb225d4-0d36-43c8-8792-f6795646ba51', '2026-07-11 04:40:21', '2026-07-11 04:40:21'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '23ce76f1-1a44-4b98-ada9-2223d08cf5a7', 'PRACTICE', 'COMPLETED', 1, 1, 1, 100, '2026-07-10 16:06:38', '2026-07-10 16:06:38', 'e4bc32b0-e773-4402-9e83-e7816efa4418', '2026-07-10 16:06:38', '2026-07-10 16:06:38'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '555373ba-5a3f-478e-83e0-beecc429f74e', 'PRACTICE', 'COMPLETED', 1, 1, 0, 0, '2026-07-10 16:16:06', '2026-07-10 16:16:06', 'e9633358-3637-458d-ae23-dd4e314ddf6c', '2026-07-10 16:16:06', '2026-07-10 16:16:06'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'fc34ca52-3c47-4896-826c-1122305a7942', 'PRACTICE', 'COMPLETED', 1, 1, 0, 0, '2026-07-10 16:23:43', '2026-07-10 16:23:44', 'edc2ce56-e177-42a3-aa76-6ea330b3668d', '2026-07-10 16:23:43', '2026-07-10 16:23:44'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'c06dc77a-ce37-4e9a-b01b-fbbc9696400d', 'PRACTICE', 'COMPLETED', 1, 1, 0, 0, '2026-07-10 16:23:51', '2026-07-10 16:23:51', 'ef98871c-70e9-4934-8b11-e7e561e266a1', '2026-07-10 16:23:51', '2026-07-10 16:23:51'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', NULL, 'PRACTICE', 'ACTIVE', 2, 0, 0, 0, '2026-07-10 16:21:03', NULL, 'f37f0562-326e-406d-b735-8c41e1c8cf52', '2026-07-10 16:21:03', '2026-07-10 16:21:03'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '238b63e5-65cf-4487-9062-742324853445', 'PRACTICE', 'ACTIVE', 1, 1, 1, 0, '2026-07-10 16:04:53', NULL, 'f76c08a6-25e7-4903-a6a9-55d89601d3f9', '2026-07-10 16:04:53', '2026-07-10 16:04:53'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', NULL, 'PRACTICE', 'ACTIVE', 3, 0, 0, 0, '2026-07-10 16:23:44', NULL, 'fc0e1fba-ed65-4cd8-8784-6fd591205f34', '2026-07-10 16:23:44', '2026-07-10 16:23:44'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'fcb039d9-9cd1-4f1a-898c-b48e0e002c70', 'PRACTICE', 'COMPLETED', 1, 1, 0, 0, '2026-07-11 04:40:21', '2026-07-11 04:40:21', 'ff7b7408-7842-4fc9-8ab2-8184cfef812e', '2026-07-11 04:40:21', '2026-07-11 04:40:21');

-- --------------------------------------------------------

--
-- Table structure for table `learning_session_questions`
--

CREATE TABLE `learning_session_questions` (
  `session_id` varchar(36) NOT NULL,
  `question_id` varchar(36) NOT NULL,
  `order_number` int(11) NOT NULL,
  `is_answered` tinyint(1) DEFAULT NULL,
  `user_answer_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`user_answer_json`)),
  `is_correct` tinyint(1) DEFAULT NULL,
  `score` int(11) DEFAULT NULL,
  `response_time_ms` int(11) DEFAULT NULL,
  `feedback_notes` text DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `question_revision_id` varchar(36) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `learning_session_questions`
--

INSERT INTO `learning_session_questions` (`session_id`, `question_id`, `order_number`, `is_answered`, `user_answer_json`, `is_correct`, `score`, `response_time_ms`, `feedback_notes`, `id`, `created_at`, `updated_at`, `question_revision_id`) VALUES
('205b3037-bd34-4936-b8a1-f613d88317d3', '3e924d1a-0431-4f4c-8911-814e6ab38ffb', 1, 1, '{\"selected_option_id\": \"opt2\"}', 1, 100, 0, 'Correct', '0121b1f9-d51c-4752-be4a-1dcc6237a56e', '2026-07-10 16:09:49', '2026-07-10 16:09:49', '85b4720e-37b2-4234-88ec-8c8713c3b45e'),
('ad81af49-d8de-49dc-a590-ba1a2062a7de', '395dd007-0f0d-4e4c-afb7-8618505c45cc', 1, 1, '{\"selected_option_id\": \"2\"}', 0, 0, 0, 'Incorrect', '044302d0-eca4-442e-beab-1b0b115af4dd', '2026-07-10 16:06:38', '2026-07-10 16:06:38', 'f2fe59b8-66d0-465e-9387-0532a6df15d4'),
('f37f0562-326e-406d-b735-8c41e1c8cf52', 'c2dbc501-6420-442a-93d8-a63302c89f0c', 2, 0, NULL, 0, 0, 0, NULL, '077c5279-167b-4d87-a819-2de392d2dc3b', '2026-07-10 16:21:03', '2026-07-10 16:21:03', '38bacbd9-e7d8-4447-9464-b2fa41e94e32'),
('bcc452d7-f42a-46c1-81d8-924ab408a46e', '76d3c72a-a5e2-4f06-8701-aae54d5cc47c', 1, 0, NULL, 0, 0, 0, NULL, '09e8eaf1-84b0-4219-9474-bf7f2af69ea1', '2026-07-11 03:32:51', '2026-07-11 03:32:51', 'a43d1cdf-58f2-4689-b78a-71c51550ae9a'),
('c79d3ab1-1a61-4ff1-8ec5-f21de9d534df', '35dc7a68-c00f-47bc-a444-aa37cddb3b62', 1, 1, '{\"selected_option_id\": \"2\"}', 0, 0, 0, 'Incorrect', '0bb6fd97-48c0-4045-a14e-d53bfc57856d', '2026-07-10 16:11:00', '2026-07-10 16:11:00', '3d4d64b0-9163-42bb-80ad-b186cceeb811'),
('3fc557db-e767-423d-82b4-6f6a8142e58d', '1f939f4b-5740-4cb7-b4c2-ee6d7541fef0', 4, 0, NULL, 0, 0, 0, NULL, '0bf69613-35b3-4787-aa99-b52b666371c1', '2026-07-11 04:22:41', '2026-07-11 04:22:41', '932128ea-1cbe-4d0d-9d75-d505bb56886a'),
('7a9ec6dd-f272-405f-96c7-5e6969e274db', '41cc3169-ed85-4a2c-8e81-404199c18f4b', 1, 1, '{\"selected_option_id\": \"2\"}', 0, 0, 0, 'Incorrect', '0eb996c4-63ca-4a5e-b5ff-6c9a38d1c4f3', '2026-07-11 04:40:22', '2026-07-11 04:40:22', '08a1cc47-4be3-43ad-b043-655106596648'),
('6e24bf00-78fc-4b9f-8f3a-0ec952c1f881', '9323f1bb-fbce-42f1-80ad-f7c66315a06b', 1, 1, '{\"selected_option_id\": \"opt2\"}', 1, 100, 0, 'Correct', '1325116e-b9e5-4db4-903c-6777dc50a454', '2026-07-10 16:23:51', '2026-07-10 16:23:51', '6a4ab4d8-fc05-4143-b95d-331cf6c8c067'),
('3fc557db-e767-423d-82b4-6f6a8142e58d', 'd539028b-0caf-4754-8c89-83da7b66d644', 3, 0, NULL, 0, 0, 0, NULL, '132f7da8-20f7-4104-b2d2-8222055a116b', '2026-07-11 04:22:41', '2026-07-11 04:22:41', '18397f9e-7184-4d68-b3ad-1085b36732d5'),
('a33d7330-0642-431d-845a-7d80e4f72048', 'daa3b019-1663-4197-a20d-f79dff24eab8', 1, 1, '{\"selected_option_id\": \"opt2\"}', 1, 100, 0, 'Correct', '174a0086-160e-4294-a5c7-08833d3f5355', '2026-07-10 16:21:02', '2026-07-10 16:21:03', 'd26d8fa1-6fef-458a-a47f-02447e39d5cc'),
('d50e7ddc-977d-4e92-89e1-c00aff4c641b', 'bad8e756-3a64-4939-a40d-d59303dc828c', 1, 0, NULL, 0, 0, 0, NULL, '17f6f872-dce7-4ed6-bca0-fee11fe04679', '2026-07-11 03:33:03', '2026-07-11 03:33:03', 'cebac797-1da5-4681-b52c-bc58e8288112'),
('ae1bc8e9-018a-4abb-9dd9-849f683e48ea', 'c2dbc501-6420-442a-93d8-a63302c89f0c', 2, 0, NULL, 0, 0, 0, NULL, '194acfca-1d23-4da4-91ef-4c04d29b1872', '2026-07-10 16:23:51', '2026-07-10 16:23:51', '38bacbd9-e7d8-4447-9464-b2fa41e94e32'),
('5b4ad3f2-13ce-45fa-aae4-eccd28c92563', 'd539028b-0caf-4754-8c89-83da7b66d644', 1, 1, '{\"selected_option_id\": \"2\"}', 0, 0, 0, 'Incorrect', '257ab259-423a-43b8-997a-06cc93e799cd', '2026-07-11 04:22:41', '2026-07-11 04:22:41', '18397f9e-7184-4d68-b3ad-1085b36732d5'),
('9fd12678-0bcf-4397-b7e5-981bce5d72a4', 'b8c1a10b-eceb-4fbf-b725-136d5a84896b', 6, 0, NULL, 0, 0, 0, NULL, '276f2ac9-36f6-45e4-b05a-8a258458f390', '2026-07-11 04:40:22', '2026-07-11 04:40:22', 'aa8b62fe-cbbb-4e0f-b69d-c098832cc013'),
('ae1bc8e9-018a-4abb-9dd9-849f683e48ea', 'b8c1a10b-eceb-4fbf-b725-136d5a84896b', 4, 0, NULL, 0, 0, 0, NULL, '2cef26c6-7841-4156-a2c7-bbffadf13fdf', '2026-07-10 16:23:51', '2026-07-10 16:23:51', 'aa8b62fe-cbbb-4e0f-b69d-c098832cc013'),
('9d9a8c52-e5f7-463e-bc51-6e19f6e82cd5', 'ac0fcdc1-7c67-4c8d-9b38-3c894f1f74b9', 1, 1, '{\"selected_option_id\": \"opt2\"}', 1, 100, 0, 'Correct', '3287ad3a-0d8b-4823-b988-c717dd549fa0', '2026-07-10 16:07:53', '2026-07-10 16:07:53', '4a6cb776-3573-4e9b-add9-4704f26b3321'),
('b8c8c4eb-ed78-4910-82b2-6a5ac590b667', 'b9ed4e0c-6784-4c2e-9beb-d80580576366', 1, 1, '{\"selected_option_id\": \"opt2\"}', 0, 0, 0, 'Incorrect', '3503f906-6210-419d-9e41-6c19a2b44ad9', '2026-07-10 15:53:53', '2026-07-10 15:53:53', '1be987d8-1944-46e4-a948-d838a4c75ee8'),
('12aa6a14-eced-4785-9ffd-b40bcf8c059e', '65cf5938-6f10-4710-a664-d5b47940e9da', 1, 1, '{\"selected_option_id\": \"2\"}', 0, 0, 0, 'Incorrect', '3c6fff41-dc16-4173-8064-70bc7db123aa', '2026-07-10 16:20:01', '2026-07-10 16:20:01', '3783a63a-84c6-4106-a4e0-8d1eabd56dcd'),
('3f802aee-d739-4751-9d49-41858f91fd5f', 'ee5aaa0f-92fb-4567-8806-ad0e27170f29', 1, 1, '{\"selected_option_id\": \"opt2\"}', 1, 100, 0, 'Correct', '3f6b4891-d521-4237-91b2-bbc1a88f96a4', '2026-07-10 16:16:05', '2026-07-10 16:16:05', 'cf985ae3-2306-482b-98fe-5c3b68864458'),
('9fd12678-0bcf-4397-b7e5-981bce5d72a4', '41cc3169-ed85-4a2c-8e81-404199c18f4b', 3, 0, NULL, 0, 0, 0, NULL, '46bdaca4-a432-4336-ae91-a64882677911', '2026-07-11 04:40:22', '2026-07-11 04:40:22', '08a1cc47-4be3-43ad-b043-655106596648'),
('9fd12678-0bcf-4397-b7e5-981bce5d72a4', 'd539028b-0caf-4754-8c89-83da7b66d644', 2, 0, NULL, 0, 0, 0, NULL, '4776fe76-e269-440f-b9a8-eef379296213', '2026-07-11 04:40:22', '2026-07-11 04:40:22', '18397f9e-7184-4d68-b3ad-1085b36732d5'),
('3fcefb44-fc83-4509-beb0-d1a80ad5adca', '10ed0932-e587-421b-9e05-54e2f9175b2a', 1, 1, '{\"selected_option_id\": \"opt2\"}', 1, 100, 0, 'Correct', '4c94a70e-6bba-4c89-8f6b-3d841c204440', '2026-07-10 16:04:36', '2026-07-10 16:04:36', '9905abb7-154c-483e-a2d7-773ee7f836fe'),
('fc0e1fba-ed65-4cd8-8784-6fd591205f34', '1f939f4b-5740-4cb7-b4c2-ee6d7541fef0', 1, 0, NULL, 0, 0, 0, NULL, '4dbfaa9e-0181-4c9c-a3d4-9c0b89f70dda', '2026-07-10 16:23:44', '2026-07-10 16:23:44', '932128ea-1cbe-4d0d-9d75-d505bb56886a'),
('7d20c6a3-d6df-4887-9fbc-e39712dc4b10', '119d69c5-7b53-43d2-9677-b560bdaec6e3', 1, 1, '{\"selected_option_id\": \"2\"}', 0, 0, 0, 'Incorrect', '5b34d6a5-974d-45a7-b25a-e9d8ac84f88e', '2026-07-10 16:09:49', '2026-07-10 16:09:49', '4f5901ac-8ed2-4e09-8cfa-cc2d21dea7ee'),
('3fc557db-e767-423d-82b4-6f6a8142e58d', 'c2dbc501-6420-442a-93d8-a63302c89f0c', 1, 0, NULL, 0, 0, 0, NULL, '5ee38711-a705-4792-aa25-feb8741196a5', '2026-07-11 04:22:41', '2026-07-11 04:22:41', '38bacbd9-e7d8-4447-9464-b2fa41e94e32'),
('f76c08a6-25e7-4903-a6a9-55d89601d3f9', '408b1543-20f0-4734-a6af-7fc0c7d3ad57', 1, 1, '{\"selected_option_id\": \"opt2\"}', 1, 100, 0, 'Correct', '60cfcef9-e4ed-4bca-9a14-7017d912e067', '2026-07-10 16:04:53', '2026-07-10 16:04:53', 'd9e51d7a-3e17-444b-8e4c-646ab43d59bb'),
('a3640681-2c73-464c-a11e-735c0cac94c6', 'f65eca1e-1bcd-4a20-af4f-600572ffc04a', 1, 0, NULL, 0, 0, 0, NULL, '6214bab8-7782-4e44-a8e9-cec2fd251203', '2026-07-11 04:40:22', '2026-07-11 04:40:22', '0803a459-cfc9-473b-b3c0-64ce2b326d87'),
('f37f0562-326e-406d-b735-8c41e1c8cf52', '65cf5938-6f10-4710-a664-d5b47940e9da', 1, 0, NULL, 0, 0, 0, NULL, '637f2b37-b07f-4578-b0a1-f2e21ea4d6c8', '2026-07-10 16:21:03', '2026-07-10 16:21:03', '3783a63a-84c6-4106-a4e0-8d1eabd56dcd'),
('a8b45737-e47f-4385-8c79-cc8e8f87a427', '607cfe2a-f5f7-46fb-a746-5c83a629f7e1', 1, 1, '{\"selected_option_id\": \"opt2\"}', 0, 0, 0, 'Incorrect', '6503a576-4857-4c76-8be6-afb521074866', '2026-07-11 04:22:41', '2026-07-11 04:22:41', 'ede959cf-33e2-478e-95dc-c870f97bccc4'),
('b616c22a-69cb-4b14-a151-1482696d28a3', '65cf5938-6f10-4710-a664-d5b47940e9da', 1, 0, NULL, 0, 0, 0, NULL, '66a8b43c-fdcd-41aa-a829-a3fecf336bc9', '2026-07-10 16:20:01', '2026-07-10 16:20:01', '3783a63a-84c6-4106-a4e0-8d1eabd56dcd'),
('8f9b2e02-ca8e-4c54-aa4a-0d5073943fc3', 'b7c72ad2-34d4-4f07-b7f9-5e84ccc64ecc', 1, 1, '{\"selected_option_id\": \"2\"}', 0, 0, 0, 'Incorrect', '6b047e88-48cd-4601-850b-b386004b8259', '2026-07-10 16:07:53', '2026-07-10 16:07:53', '1af7ebe2-276f-48ee-85ca-ba757ec4b534'),
('205da50b-460e-42dc-a8b3-cd42b740ce97', '035398f3-0cf4-43c7-85e9-db38f9a12295', 1, 1, '{\"selected_option_id\": \"opt2\"}', 1, 100, 0, 'Correct', '6e0aec26-385d-4b7f-b635-5da45fa6356b', '2026-07-10 16:15:48', '2026-07-10 16:15:48', '8a14d384-dd49-4473-ac3b-81c14ed2dc86'),
('64ae4b19-9a56-46a6-b8cb-fd01c5261dcb', '992a54c3-f35f-46ca-b495-c7707a9b2cc3', 1, 1, '{\"selected_option_id\": \"2\"}', 0, 0, 0, 'Incorrect', '73514fcb-974c-4ea0-a63d-76bf3859782c', '2026-07-10 16:14:03', '2026-07-10 16:14:03', '8acaa2ea-0a1b-4ca7-9bda-07a1aaed9fcb'),
('0dc623f1-b71e-4c54-887b-415ba5dcd607', 'ce58188c-2886-40bf-a1c5-964d5fbc0172', 1, 1, '{\"selected_option_id\": \"opt2\"}', 0, 0, 0, 'Incorrect', '76c4253f-ba8b-4528-aee3-7e15f08dd994', '2026-07-10 15:54:02', '2026-07-10 15:54:02', '19b300cc-4f51-4fdc-850b-248e2960b75f'),
('0d76eee4-c2aa-458a-97f6-96b54a10a717', '79a546c5-bd4a-464a-9f7d-17b6494979ea', 1, 1, '{\"selected_option_id\": \"opt2\"}', 1, 100, 0, 'Correct', '7c5b2281-7de3-4742-bee6-1b52043cd1ee', '2026-07-10 16:11:00', '2026-07-10 16:11:00', 'ad31ad50-bcda-49fd-99d6-cfa68b14f653'),
('62874753-c11b-46cf-81a4-ce319ae877be', 'd78d584c-0dd7-4a38-8c57-2d58acafcc64', 1, 1, '{\"selected_option_id\": \"2\"}', 0, 0, 0, 'Incorrect', '800378ac-7c5b-4c75-b557-34a679a7a05d', '2026-07-10 16:04:54', '2026-07-10 16:04:54', 'a318fd12-24ad-4837-8a09-f11003c5017c'),
('9fd12678-0bcf-4397-b7e5-981bce5d72a4', '1f939f4b-5740-4cb7-b4c2-ee6d7541fef0', 4, 0, NULL, 0, 0, 0, NULL, '8c884c1e-ba4d-4b7d-bee1-35e465a0648d', '2026-07-11 04:40:22', '2026-07-11 04:40:22', '932128ea-1cbe-4d0d-9d75-d505bb56886a'),
('9fd12678-0bcf-4397-b7e5-981bce5d72a4', 'c2dbc501-6420-442a-93d8-a63302c89f0c', 5, 0, NULL, 0, 0, 0, NULL, '8d680a1a-48a4-4e86-80d6-d13e54b38097', '2026-07-11 04:40:22', '2026-07-11 04:40:22', '38bacbd9-e7d8-4447-9464-b2fa41e94e32'),
('500fa73a-4ab8-450f-8011-071575d8eb43', '4247da87-9fa5-4ac3-8431-3a447406a1a1', 1, 1, '{\"selected_option_id\": \"opt2\"}', 1, 100, 0, 'Correct', '8f90860c-3cbe-4d73-adae-c4313a5c7ae1', '2026-07-11 04:22:41', '2026-07-11 04:22:41', 'b4ac8a73-e107-4bba-b247-a1245b9dd440'),
('1a054b63-53c6-48c4-aad4-fec413e9a61c', 'a7e9dff5-b3e5-420d-8879-344d953767b1', 1, 1, '{\"selected_option_id\": \"2\"}', 0, 0, 0, 'Incorrect', '93f1b872-6dc9-450c-a376-71f5e74794cd', '2026-07-10 16:04:37', '2026-07-10 16:04:37', '83a779d3-bf0e-4ce2-86b7-24b935558cd5'),
('e9633358-3637-458d-ae23-dd4e314ddf6c', '1f9d7e8d-4189-41ab-befe-22b7b3167e8d', 1, 1, '{\"selected_option_id\": \"2\"}', 0, 0, 0, 'Incorrect', '9c7bb32d-1cb4-4cf8-852b-92c61bfe2b25', '2026-07-10 16:16:06', '2026-07-10 16:16:06', '41ccaef1-a152-4017-b04c-ce39c2996a6c'),
('ef98871c-70e9-4934-8b11-e7e561e266a1', 'b8c1a10b-eceb-4fbf-b725-136d5a84896b', 1, 1, '{\"selected_option_id\": \"2\"}', 0, 0, 0, 'Incorrect', 'a097a1ff-8eca-4b7b-b570-34298fdcb8c1', '2026-07-10 16:23:51', '2026-07-10 16:23:51', 'aa8b62fe-cbbb-4e0f-b69d-c098832cc013'),
('39b25e9a-474e-4e41-8aa6-d89659d0ea6a', '11ac7036-d3f1-4ae6-8fef-76fed00df706', 1, 1, '{\"selected_option_id\": \"2\"}', 0, 0, 0, 'Incorrect', 'a18ec60e-0471-4c08-9696-641a8b5cd14f', '2026-07-10 16:09:32', '2026-07-10 16:09:32', 'ed707d20-cb82-43e0-8737-f630c230a035'),
('edc2ce56-e177-42a3-aa76-6ea330b3668d', '1f939f4b-5740-4cb7-b4c2-ee6d7541fef0', 1, 1, '{\"selected_option_id\": \"2\"}', 0, 0, 0, 'Incorrect', 'a2284dc2-fcf7-4ef5-9944-390964e7ee29', '2026-07-10 16:23:43', '2026-07-10 16:23:44', '932128ea-1cbe-4d0d-9d75-d505bb56886a'),
('add90505-f149-4455-ad22-029185bc068a', 'ae9b8443-fcbb-497b-8d2a-424499ef73f2', 1, 1, '{\"selected_option_id\": \"opt2\"}', 1, 100, 0, 'Correct', 'a2bdac36-805b-490d-8f41-746b59cec88a', '2026-07-10 16:20:00', '2026-07-10 16:20:00', '85b7eb9c-b60c-4a57-8ed5-8640b0ef99ea'),
('fc0e1fba-ed65-4cd8-8784-6fd591205f34', '65cf5938-6f10-4710-a664-d5b47940e9da', 3, 0, NULL, 0, 0, 0, NULL, 'aa62cf2c-1d65-4687-8419-5b941f1d12e6', '2026-07-10 16:23:44', '2026-07-10 16:23:44', '3783a63a-84c6-4106-a4e0-8d1eabd56dcd'),
('ff7b7408-7842-4fc9-8ab2-8184cfef812e', 'c85f81b8-5b36-458c-8326-eb2170e101e2', 1, 1, '{\"selected_option_id\": \"opt2\"}', 0, 0, 0, 'Incorrect', 'af09e775-9c74-4bb6-9f20-63591ea70359', '2026-07-11 04:40:21', '2026-07-11 04:40:21', '36056968-2af0-4d8f-8cf0-d468248f37c8'),
('3fc557db-e767-423d-82b4-6f6a8142e58d', 'b8c1a10b-eceb-4fbf-b725-136d5a84896b', 5, 0, NULL, 0, 0, 0, NULL, 'b78f4721-da8d-4c05-91c2-5f4ef14c4c36', '2026-07-11 04:22:41', '2026-07-11 04:22:41', 'aa8b62fe-cbbb-4e0f-b69d-c098832cc013'),
('0a025ca3-c4f9-44ac-879c-2acfcdf03cb7', '8cfe6fba-4dd3-4947-a5a1-25c96465fbe6', 1, 1, '{\"selected_option_id\": \"opt2\"}', 1, 100, 0, 'Correct', 'c01123a3-b9cd-4b45-b3ac-ca06175cc540', '2026-07-10 16:23:43', '2026-07-10 16:23:43', 'bf024c0e-e0b8-40fb-aeb5-0afb689dc2dc'),
('cc36aed7-9e4d-45c2-ac63-be760d0ee659', 'c2dbc501-6420-442a-93d8-a63302c89f0c', 1, 1, '{\"selected_option_id\": \"2\"}', 0, 0, 0, 'Incorrect', 'c3ac8acc-c602-4293-834e-7c5f01d1c12a', '2026-07-10 16:21:03', '2026-07-10 16:21:03', '38bacbd9-e7d8-4447-9464-b2fa41e94e32'),
('32353c02-3945-4383-96ba-ed49dcdcff0b', '6dd9bd3c-8f59-4ad3-b370-21a23c108c7e', 1, 0, NULL, 0, 0, 0, NULL, 'c55f96e3-4a60-4c8d-b7e0-c4343f1520bc', '2026-07-11 04:22:42', '2026-07-11 04:22:42', '1ef1744d-0091-4b86-8bc4-bc45e2b7f402'),
('02275d35-735d-4fa9-89b7-32e96eab16d7', '2fa28439-851b-4422-ab37-924c167695cb', 1, 1, '{\"selected_option_id\": \"2\"}', 0, 0, 0, 'Incorrect', 'c6ec254c-c972-4e37-8b8b-662f50779b67', '2026-07-10 16:15:48', '2026-07-10 16:15:48', 'dc2cba9b-8530-4c8c-b9ff-faa2290b3d19'),
('ae1bc8e9-018a-4abb-9dd9-849f683e48ea', '65cf5938-6f10-4710-a664-d5b47940e9da', 1, 0, NULL, 0, 0, 0, NULL, 'c85ebafa-4715-49af-a45e-a5ce43935db7', '2026-07-10 16:23:51', '2026-07-10 16:23:51', '3783a63a-84c6-4106-a4e0-8d1eabd56dcd'),
('4ab24488-fc65-47c0-85eb-10b75b2a48cd', '519b697f-e52a-48d2-878a-1f94544084ac', 1, 1, '{\"selected_option_id\": \"opt2\"}', 1, 100, 0, 'Correct', 'd3f3a370-ef54-4bce-873d-15c01d002408', '2026-07-10 16:06:22', '2026-07-10 16:06:23', '7073986c-b725-4777-be84-b88cb8904bc9'),
('1e18b4a8-b989-4845-9f50-3dc8f6151701', '2087477d-f6d5-4b57-9cd9-56891f041275', 1, 1, '{\"selected_option_id\": \"2\"}', 0, 0, 0, 'Incorrect', 'da390ad6-0ba1-4a31-a165-7972f5058978', '2026-07-10 16:06:23', '2026-07-10 16:06:23', '1aca22f5-7408-4b9f-b0c3-b9680e24aae9'),
('ae1bc8e9-018a-4abb-9dd9-849f683e48ea', '1f939f4b-5740-4cb7-b4c2-ee6d7541fef0', 3, 0, NULL, 0, 0, 0, NULL, 'e734716c-1b98-4e3c-a1f2-e1abdfe7236a', '2026-07-10 16:23:51', '2026-07-10 16:23:51', '932128ea-1cbe-4d0d-9d75-d505bb56886a'),
('9fd12678-0bcf-4397-b7e5-981bce5d72a4', '65cf5938-6f10-4710-a664-d5b47940e9da', 1, 0, NULL, 0, 0, 0, NULL, 'e87a8251-5da5-4ef0-ac5b-224adaa42af6', '2026-07-11 04:40:22', '2026-07-11 04:40:22', '3783a63a-84c6-4106-a4e0-8d1eabd56dcd'),
('dbb225d4-0d36-43c8-8792-f6795646ba51', 'c9aa4340-fb43-4776-a90f-0fb90976ecf1', 1, 1, '{\"selected_option_id\": \"opt2\"}', 1, 100, 0, 'Correct', 'e8db6e6d-75fe-496a-aee2-6bc54d3131fe', '2026-07-11 04:40:21', '2026-07-11 04:40:21', 'ff6fc3db-ab4c-4c5b-9dee-db6e061eede2'),
('fc0e1fba-ed65-4cd8-8784-6fd591205f34', 'c2dbc501-6420-442a-93d8-a63302c89f0c', 2, 0, NULL, 0, 0, 0, NULL, 'ebab6aaf-4f35-4b1c-87ad-c4a5a1691805', '2026-07-10 16:23:44', '2026-07-10 16:23:44', '38bacbd9-e7d8-4447-9464-b2fa41e94e32'),
('3fc557db-e767-423d-82b4-6f6a8142e58d', '65cf5938-6f10-4710-a664-d5b47940e9da', 2, 0, NULL, 0, 0, 0, NULL, 'ebc9a4ac-90d1-490b-afc3-7c7244d05ba3', '2026-07-11 04:22:41', '2026-07-11 04:22:41', '3783a63a-84c6-4106-a4e0-8d1eabd56dcd'),
('93121dc6-5590-4dc3-8561-4516755077b1', '382d5b2d-404d-4191-bb09-fa7a7bf5bc75', 1, 1, '{\"selected_option_id\": \"opt2\"}', 1, 100, 0, 'Correct', 'f775f372-8571-47ec-8c9b-7ff8a59eb565', '2026-07-10 16:09:32', '2026-07-10 16:09:32', '3aad657e-1b63-44a6-b5d7-1c503069fced'),
('6953f214-6dd2-4534-bea5-de91758539f1', '6a9d73b7-2e1e-447d-8794-0db2d583e3b4', 1, 1, '{\"selected_option_id\": \"opt2\"}', 0, 0, 0, 'Incorrect', 'f9627c3a-d5e3-4fcd-8db4-035e8af6bafb', '2026-07-10 15:54:53', '2026-07-10 15:54:53', 'dfe90224-1f93-4a57-99d9-65182eb1be17'),
('882a1724-6a92-45b0-863c-84f84d50676b', '54de490e-c725-419b-91c0-0082cbc0d8c9', 1, 1, '{\"selected_option_id\": \"opt2\"}', 1, 100, 0, 'Correct', 'faca462b-9bba-4f00-82cf-25e1dec97cfc', '2026-07-10 16:14:03', '2026-07-10 16:14:03', 'f72cd3ef-83e6-407e-8b3b-bb90086fd3bb'),
('37439872-ffab-4891-a8af-28e7e4fd67ea', '3a389d63-5c69-4506-ac15-e0c70c3c5724', 1, 1, '{\"selected_option_id\": \"opt2\"}', 0, 0, 0, 'Incorrect', 'fbb4d218-3a8b-4c11-a7a9-627840da6ffc', '2026-07-10 15:55:00', '2026-07-10 15:55:00', '20a23414-e6af-4a14-8879-7217ea766adf'),
('e4bc32b0-e773-4402-9e83-e7816efa4418', 'dad95425-09d2-4f2f-9dc9-a6d09f443585', 1, 1, '{\"selected_option_id\": \"opt2\"}', 1, 100, 0, 'Correct', 'fde4834e-d71a-4497-a40b-de69ce4594d7', '2026-07-10 16:06:38', '2026-07-10 16:06:38', 'a0b99a0c-5f4a-40c1-a7d6-793db2f43ad1');

-- --------------------------------------------------------

--
-- Table structure for table `lessons`
--

CREATE TABLE `lessons` (
  `unit_id` varchar(36) NOT NULL,
  `title` varchar(255) NOT NULL,
  `learning_objective` text DEFAULT NULL,
  `sequence` int(11) DEFAULT NULL,
  `is_published` tinyint(1) DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `lessons`
--

INSERT INTO `lessons` (`unit_id`, `title`, `learning_objective`, `sequence`, `is_published`, `id`, `created_at`, `updated_at`) VALUES
('20751fb1-c0ce-4758-8422-4e4a028e6238', 'Empty Lesson', NULL, 0, 0, '03e25d8d-5a02-4882-9260-3b0b51d26c0d', '2026-07-10 15:26:00', '2026-07-10 15:26:00'),
('ee46bd1f-e885-4492-9337-aef320740caf', 'Mock Lesson', NULL, 0, 0, '0460fc56-2a5d-4159-84dd-3064b48c1e29', '2026-07-11 04:40:23', '2026-07-11 04:40:23'),
('50b94769-e81e-4300-a880-7ec227b28543', 'Lesson 18', 'Objective for lesson 18', 3, 1, '07443ee1-78b4-404e-82de-c97a03809f12', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('c5a7a9c1-1233-47e0-9629-d910c6b818a0', 'Mock Lesson', NULL, 0, 0, '0ba7b706-6b5c-4dc3-b2f6-afe316d8de32', '2026-07-11 04:19:23', '2026-07-11 04:19:23'),
('ca8a1785-5367-4679-b7e8-2ab1a11d591b', 'Lesson 19', 'Objective for lesson 19', 1, 1, '0feee345-4eda-48eb-a5d8-b8bd6fd30915', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('ca8a1785-5367-4679-b7e8-2ab1a11d591b', 'Lesson 20', 'Objective for lesson 20', 2, 1, '12aa4576-6aa1-43d0-a1ae-9a6a0900480e', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('31ff3106-4f20-4ca5-aa01-d5775b08527e', 'Mock Lesson', NULL, 0, 0, '13f37db3-0c50-4f8b-8349-65fffb4086a6', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('b5dece2b-6a72-4661-9661-164dc44f8474', 'Lesson', NULL, 0, 1, '14c8ae06-5fdb-4748-aad0-26238692d933', '2026-07-10 16:14:03', '2026-07-10 16:14:03'),
('aa3668eb-6f12-4c03-a76a-681567cf5195', 'Lesson', NULL, 0, 1, '172a6134-5678-4b9c-bcea-06b9d69deaed', '2026-07-10 15:36:45', '2026-07-10 15:36:45'),
('4d296359-f130-485c-8bd9-57043c29ad5a', 'Lesson', NULL, 0, 1, '17978be0-dd11-4f7f-ac16-1af38e2eae7f', '2026-07-10 15:54:53', '2026-07-10 15:54:53'),
('e5b0563a-84f9-4674-aa09-7fec74868637', 'Lesson', NULL, 0, 1, '18699dbe-5942-4d5c-99b9-8123c2070709', '2026-07-10 15:34:14', '2026-07-10 15:34:14'),
('3336ca3f-c68d-4396-b0f1-f840721722f6', 'Test Lesson', NULL, 1, 1, '1f8386ae-57e5-4690-94b5-e69779a4c2cb', '2026-07-11 03:32:51', '2026-07-11 03:32:51'),
('e5f55cab-5eb9-43e5-b0b9-4d3ed19a304c', 'Lesson', NULL, 0, 1, '1f9a4447-5121-4868-96ef-3565c5056d01', '2026-07-10 15:37:13', '2026-07-10 15:37:13'),
('26f3af1f-91c5-402d-808b-38e1a0d1096f', 'Lesson', NULL, 0, 1, '1fbf7b41-4588-4334-8ef7-aa4921d2df65', '2026-07-10 16:06:38', '2026-07-10 16:06:38'),
('9943afd5-6718-46d3-91cc-95b5f79ea3a3', 'Lesson 30', 'Objective for lesson 30', 3, 1, '20e4f660-c70b-4602-ab8f-0ccd9aefb4c1', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('e1b8c312-01d4-4014-9440-31d09c72ec3a', 'Lesson', NULL, 0, 1, '238b63e5-65cf-4487-9062-742324853445', '2026-07-10 16:04:53', '2026-07-10 16:04:53'),
('b8a0204c-55b9-4656-8cdf-53811821f3ad', 'Mock Lesson', NULL, 0, 0, '23ba937b-fdc2-415f-be7f-c7f61a6d4ad1', '2026-07-11 04:16:50', '2026-07-11 04:16:50'),
('0fa45143-1717-4974-a911-95c1c9aaf6bb', 'Lesson', NULL, 0, 1, '23ce76f1-1a44-4b98-ada9-2223d08cf5a7', '2026-07-10 16:06:37', '2026-07-10 16:06:37'),
('df83c896-7d98-4a57-96f3-b62e3417a664', 'Lesson', NULL, 0, 1, '24375181-4084-45a4-9996-9b5e7415fd45', '2026-07-10 16:02:48', '2026-07-10 16:02:48'),
('3087c070-2e70-4c26-ba4e-f17dafb412d8', 'Lesson 3', 'Objective for lesson 3', 3, 1, '25082036-6d59-418e-9471-ef053cf3cf31', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('7e31be8c-0754-4a02-9d1c-0cb49c10ebe1', 'Lesson', NULL, 0, 1, '27f16bc8-66e8-4cff-8fbb-57b01208d9bd', '2026-07-10 16:07:53', '2026-07-10 16:07:53'),
('cf168d3a-7758-4cab-af32-1bd83e13c9dc', 'Lesson 27', 'Objective for lesson 27', 3, 1, '28800418-9d7b-4c94-8912-3944ff99f4e5', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('fdab6d15-235a-4ea8-a5de-3f4e354e3e06', 'Lesson 13', 'Objective for lesson 13', 1, 1, '28b761da-f6a3-4d80-8523-059b1ea49968', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('9c8f844b-dae8-485d-b9b2-c813e32dacb0', 'Mock Lesson', NULL, 0, 0, '29200da4-786f-4dfb-90dc-47b3d05f7137', '2026-07-11 04:13:18', '2026-07-11 04:13:18'),
('f5bd88f0-f590-4a1c-b10d-dd044d9303e3', 'Mock Lesson', NULL, 0, 0, '2b9069c8-66a0-43f2-9400-9c58cfa9e0e2', '2026-07-11 04:13:18', '2026-07-11 04:13:18'),
('34d04e06-807f-472d-b609-4b244d03f20f', 'Mock Lesson', NULL, 0, 0, '2c6abc91-90dd-483a-832e-11767853418d', '2026-07-11 04:15:52', '2026-07-11 04:15:52'),
('68f04a1f-f036-4d6f-af16-a4f51d392d94', 'Mock Lesson', NULL, 0, 0, '2d19c4e0-2896-4b4c-83f5-f34bb6963f6f', '2026-07-11 04:40:22', '2026-07-11 04:40:22'),
('867950ea-d9b1-4d4c-92a5-3c40a193a24e', 'Lesson 23', 'Objective for lesson 23', 2, 1, '311440a8-6fd6-492f-965c-966181e8d3b3', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('b5c0e1c0-9e20-4b46-af81-9ec28961cd92', 'Mock Lesson', NULL, 0, 0, '38443f4a-38b3-4721-b495-0b973cf50bf2', '2026-07-11 04:16:03', '2026-07-11 04:16:03'),
('8f91646e-ed94-42fa-9c7c-003263432a2f', 'Lesson', NULL, 0, 1, '39dc3396-dcbc-43aa-b0ae-ddf3c488975d', '2026-07-10 16:03:04', '2026-07-10 16:03:04'),
('d5be85af-cf1c-4891-847b-28c2034a5422', 'Mock Lesson', NULL, 0, 0, '3b6a911f-2923-45d1-8c8a-881d43e9f891', '2026-07-11 04:13:10', '2026-07-11 04:13:10'),
('4dc7b80a-74ca-4a84-8755-f3b0c9fa356d', 'Lesson', NULL, 0, 1, '3c8870a6-081d-4154-88ab-b60d361d3c18', '2026-07-10 16:11:00', '2026-07-10 16:11:00'),
('c9e09fb5-94b8-420c-aa3e-51e3810ca23d', 'Lesson', NULL, 0, 1, '3d2bc98d-43ea-4001-9525-6fe9fa19708e', '2026-07-10 16:09:49', '2026-07-10 16:09:49'),
('cf168d3a-7758-4cab-af32-1bd83e13c9dc', 'Lesson 26', 'Objective for lesson 26', 2, 1, '3eb78103-00ad-4e58-be6d-ea5ef58d99bc', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('516a23ee-c321-4636-9d1a-313518392045', 'Lesson', NULL, 0, 1, '45d3cf24-9288-47f3-ba31-8afe95dcfe78', '2026-07-10 16:06:23', '2026-07-10 16:06:23'),
('b807e3b3-421e-4900-a81c-b9d0d3a75a81', 'Lesson', NULL, 0, 1, '47dc78da-36d7-49a6-959d-f84c07a5ea53', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('c9023bc7-f050-4e05-b169-9cb03da5e17c', 'Lesson', NULL, 0, 1, '47f442d1-1589-41f3-9a36-fde592ad4522', '2026-07-10 16:06:22', '2026-07-10 16:06:22'),
('a5c5f337-8e85-4cb4-bd5b-7d8eaf5be5d0', 'Empty Lesson', NULL, 0, 0, '494430ab-9060-49d7-8295-39e05922c736', '2026-07-11 04:40:20', '2026-07-11 04:40:20'),
('44a8a474-34bc-4c9e-8487-f426d9d8c632', 'Mock Lesson', NULL, 0, 0, '51e7c25a-f4b7-47ce-b2ff-462a787cd243', '2026-07-11 04:17:04', '2026-07-11 04:17:04'),
('4e3defe1-61ef-4411-af28-df47a5232971', 'Lesson', NULL, 0, 1, '52c7fecb-389c-4919-b10d-48e9df95a6bc', '2026-07-11 04:40:21', '2026-07-11 04:40:21'),
('9943afd5-6718-46d3-91cc-95b5f79ea3a3', 'Lesson 28', 'Objective for lesson 28', 1, 1, '53b3d5fe-a25a-4670-9bce-cc0452d76ec7', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('8d93940b-85e4-4c3e-9055-cc1f6d4ecef4', 'Lesson', NULL, 0, 1, '54a1097d-53b7-4333-88eb-a6b44730242a', '2026-07-10 16:07:53', '2026-07-10 16:07:53'),
('1bc356ab-7fd2-4f14-886d-02ab33b29b38', 'Lesson', NULL, 0, 1, '555373ba-5a3f-478e-83e0-beecc429f74e', '2026-07-10 16:16:06', '2026-07-10 16:16:06'),
('c0c20471-8b6a-49c9-a158-34b05906ef7d', 'Lesson', NULL, 0, 1, '579fcbe8-22d9-4a4a-a643-76b4936f4909', '2026-07-10 16:16:05', '2026-07-10 16:16:05'),
('5ff56431-23d0-45ab-bf5b-10254a1c298b', 'Empty Lesson', NULL, 0, 0, '580a73fa-5de1-401a-aeb6-36664bab845f', '2026-07-10 15:26:56', '2026-07-10 15:26:56'),
('d0fbdd80-e430-4846-94f1-59f633e7b10b', 'Lesson 10', 'Objective for lesson 10', 1, 1, '59b863ad-9a4b-43b2-bd04-063b011e7510', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('6530bad5-67bf-478f-a69c-51c0b42dc2cd', 'Lesson', NULL, 0, 1, '5a23eb31-9ce1-40ca-bbe1-8eae5a19b575', '2026-07-11 04:22:40', '2026-07-11 04:22:40'),
('a23ccccc-dec9-453c-b5ca-075517d9b7f0', 'Mock Lesson', NULL, 0, 0, '5d238a85-ac9e-4fac-ae65-502529c203f9', '2026-07-11 04:15:52', '2026-07-11 04:15:52'),
('6356f049-8fb5-4201-8120-743ccb3e426f', 'Lesson', NULL, 0, 1, '5e7c6c2b-cbef-4fad-a100-aa1819c8711a', '2026-07-10 16:09:32', '2026-07-10 16:09:32'),
('4d465502-ab5b-4f46-83e8-8e9af888737b', 'Test Lesson', NULL, 1, 1, '5ee85649-1578-49b3-9883-860604715370', '2026-07-11 04:40:22', '2026-07-11 04:40:22'),
('935d6faa-8d62-4754-9fcb-0a055ea346d4', 'Mock Lesson', NULL, 0, 0, '5f458ee5-ccd7-47be-bbf8-a42c65366f65', '2026-07-11 04:17:05', '2026-07-11 04:17:05'),
('ef564515-46c6-49e9-877a-d9995e5f2fbe', 'Empty Lesson', NULL, 0, 0, '5fe3a2b2-0d38-4ee6-9924-5dfc4475b215', '2026-07-10 15:26:44', '2026-07-10 15:26:44'),
('3c53a977-9fa9-48e4-98eb-c06e18c60ba7', 'Lesson', NULL, 0, 1, '6043f684-2388-4503-aa46-2c8a0cd78504', '2026-07-10 16:23:51', '2026-07-10 16:23:51'),
('87b132c8-c218-44e1-b95f-f0fb92c28aad', 'Mock Lesson', NULL, 0, 0, '607efde2-407b-4cbe-ba82-62215000f916', '2026-07-11 04:14:11', '2026-07-11 04:14:11'),
('2d2c02d3-a7d8-41f4-9af3-b644e43f07fe', 'Lesson', NULL, 0, 1, '6367218c-d19e-429b-9a71-d7502b7ac080', '2026-07-10 16:20:00', '2026-07-10 16:20:00'),
('c0e6be80-7901-49f0-b8be-84127997d5a0', 'Mock Lesson', NULL, 0, 0, '6801c103-ae57-41fa-9561-975e53f8d0a3', '2026-07-11 04:14:55', '2026-07-11 04:14:55'),
('a858f159-90a5-4c78-9e23-a95057540b65', 'Lesson', NULL, 0, 1, '69647da2-98de-45bf-a875-49f054ec01a8', '2026-07-10 15:35:34', '2026-07-10 15:35:34'),
('1efb8f5b-2de4-4332-99e4-a518957a8118', 'Mock Lesson', NULL, 0, 0, '6b6f068a-7bca-4973-b803-4da3c3519ed7', '2026-07-11 04:14:04', '2026-07-11 04:14:04'),
('61049341-d439-4c13-ab2a-951d81b65c9f', 'Lesson', NULL, 0, 1, '6b7802f7-2f34-49e7-bab8-cc60ea6e152b', '2026-07-10 15:53:53', '2026-07-10 15:53:53'),
('cd3038c4-a47c-4364-883a-492d22ad94db', 'Lesson 5', 'Objective for lesson 5', 2, 1, '78589edc-8c29-43b3-b9b2-04d1b433a23e', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('3087c070-2e70-4c26-ba4e-f17dafb412d8', 'Lesson 2', 'Objective for lesson 2', 2, 1, '7add805b-c99a-4e33-aefb-150e23da2961', '2026-07-11 03:03:59', '2026-07-11 03:03:59'),
('cf5396b4-bc04-4ea1-83a3-da01f616899e', 'Empty Lesson', NULL, 0, 0, '7b6abade-db47-425a-93cd-4a4e00f86601', '2026-07-10 15:18:32', '2026-07-10 15:18:32'),
('9943afd5-6718-46d3-91cc-95b5f79ea3a3', 'Lesson 29', 'Objective for lesson 29', 2, 1, '7cea6f51-6269-481a-a61b-71a189816f59', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('a352e9d0-b6f3-4db5-abed-d3422cae7cfc', 'Mock Lesson', NULL, 0, 0, '7e6a25cb-d2be-4935-91be-bf9e8b4e083d', '2026-07-11 04:13:10', '2026-07-11 04:13:10'),
('fdab6d15-235a-4ea8-a5de-3f4e354e3e06', 'Lesson 14', 'Objective for lesson 14', 2, 1, '82cee997-09e3-460e-afed-05fc90d62c54', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('c6f63da1-35f6-4c36-9141-3b564f4c1c53', 'Lesson 7', 'Objective for lesson 7', 1, 1, '854c3593-4f38-44be-8336-62d66bee956b', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('eacd5f63-eabb-45ba-a507-020641e289c3', 'Mock Lesson', NULL, 0, 0, '859b9445-c65d-454d-98de-88a413493c57', '2026-07-11 04:14:04', '2026-07-11 04:14:04'),
('cd3038c4-a47c-4364-883a-492d22ad94db', 'Lesson 4', 'Objective for lesson 4', 1, 1, '87d161e1-ec62-4d74-8ca4-d576b3a4a21c', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('5a9dd402-e99f-4c58-b4ef-713bfa68e92a', 'Empty Lesson', NULL, 0, 0, '886317b7-287e-4f5e-914e-7f1544b95e95', '2026-07-11 04:22:40', '2026-07-11 04:22:40'),
('bd97e752-63be-47ea-8538-1e523e0842e1', 'Lesson', NULL, 0, 1, '89f07a8c-bd62-422c-975e-09785e16834a', '2026-07-10 15:54:01', '2026-07-10 15:54:01'),
('ae728f16-e94e-440e-b6d3-5fe9df3521a9', 'Mock Lesson', NULL, 0, 0, '8e00eafd-f89c-4303-a93c-0bf7ff315d52', '2026-07-11 04:14:56', '2026-07-11 04:14:56'),
('8afff953-b826-4b41-95b2-6887e1aed74b', 'Mock Lesson', NULL, 0, 0, '93122045-5ad8-4bff-8191-022f9749d5e7', '2026-07-11 04:16:50', '2026-07-11 04:16:50'),
('50b94769-e81e-4300-a880-7ec227b28543', 'Lesson 17', 'Objective for lesson 17', 2, 1, '93d8913f-9e51-4052-a201-5c317aa8f46a', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('b46ef0c0-81ca-48ef-948b-24a76aafe54d', 'Mock Lesson', NULL, 0, 0, '99a04bff-f4ab-4cc4-b8cb-acc77748f6b4', '2026-07-11 04:19:23', '2026-07-11 04:19:23'),
('56689189-0e73-48bd-8582-61dca3c1c51d', 'Lesson', NULL, 0, 1, '9e76f978-6dfa-4bf4-9ecc-10f5613fd906', '2026-07-10 15:38:04', '2026-07-10 15:38:04'),
('4b89938b-91cc-4c4b-a3e2-3baa00fbb8ad', 'Lesson', NULL, 0, 1, 'a3232fac-0e05-4798-8cb0-2b676e03ab1d', '2026-07-10 16:04:54', '2026-07-10 16:04:54'),
('b3c437eb-6ad6-40ee-8033-9e39b2a40af0', 'Lesson', NULL, 0, 1, 'a6ca7ff4-db73-4373-a975-9d648d1751e4', '2026-07-10 16:02:47', '2026-07-10 16:02:47'),
('3087c070-2e70-4c26-ba4e-f17dafb412d8', 'Lesson 1', 'Objective for lesson 1', 1, 1, 'a7b56a6f-98c5-4ee8-af1f-ecc71a18f38d', '2026-07-11 03:02:52', '2026-07-11 03:02:52'),
('c2ec2e0e-593f-4f66-b150-0da40b1426a1', 'Test Lesson', NULL, 1, 1, 'a8e60cab-a07a-4ee3-a5a2-c628f614458e', '2026-07-11 03:33:03', '2026-07-11 03:33:03'),
('9a60d488-cb0c-4c0f-be91-034de9d0fc80', 'Lesson', NULL, 0, 1, 'ac173bab-4c54-4d6d-b9dc-3ded3c8c25d6', '2026-07-10 16:21:03', '2026-07-10 16:21:03'),
('c6f63da1-35f6-4c36-9141-3b564f4c1c53', 'Lesson 8', 'Objective for lesson 8', 2, 1, 'ad2b3982-1bcc-47e8-96c1-dcf38e3242fc', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('dcbfc8a6-8937-48b7-97a6-e029a876210d', 'Mock Lesson', NULL, 0, 0, 'b083f3fd-fd38-4889-ba98-98ff1dc466d7', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('790fc260-021e-43d1-81e9-38a191d2fbdb', 'Lesson', NULL, 0, 1, 'b2bfe62e-dd2b-4e21-878c-1a4c3eb354b3', '2026-07-10 16:04:36', '2026-07-10 16:04:36'),
('867950ea-d9b1-4d4c-92a5-3c40a193a24e', 'Lesson 24', 'Objective for lesson 24', 3, 1, 'b2f7f273-823b-49be-a148-f7764f3d5b8c', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('d4d3b0c4-a76f-4b3a-9581-b645428316f9', 'Lesson', NULL, 0, 1, 'b360716b-8e25-4946-aa90-5a902afdddbc', '2026-07-10 16:04:37', '2026-07-10 16:04:37'),
('d0fbdd80-e430-4846-94f1-59f633e7b10b', 'Lesson 12', 'Objective for lesson 12', 3, 1, 'bf8862ab-3bfe-42bd-805b-613a5537fdce', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('6bb22b79-15bd-41fb-8c18-10980a4cb733', 'Mock Lesson', NULL, 0, 0, 'bfb15ae8-a948-4754-9f74-7039c966838b', '2026-07-11 04:17:24', '2026-07-11 04:17:24'),
('867950ea-d9b1-4d4c-92a5-3c40a193a24e', 'Lesson 22', 'Objective for lesson 22', 1, 1, 'c03c6d85-175d-481d-aea5-419e408b7e03', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('ce40919e-0230-4db7-aaf3-6546c0e147d4', 'Lesson', NULL, 0, 1, 'c06dc77a-ce37-4e9a-b01b-fbbc9696400d', '2026-07-10 16:23:51', '2026-07-10 16:23:51'),
('fdab6d15-235a-4ea8-a5de-3f4e354e3e06', 'Lesson 15', 'Objective for lesson 15', 3, 1, 'c140e128-4049-4967-8aee-7f53a1ca8672', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('576ce5d4-e937-4962-9a69-aeaf7a3e30df', 'Lesson', NULL, 0, 1, 'c2572650-a575-4d45-91ba-eeef03530aea', '2026-07-10 16:23:43', '2026-07-10 16:23:43'),
('9ae97a08-97d7-4485-aa2a-07d7e2475983', 'Test Lesson', NULL, 1, 1, 'c3d929dd-7b38-4424-a14a-c50f82679248', '2026-07-11 03:32:12', '2026-07-11 03:32:12'),
('b6e38f00-462c-47e1-9721-d8745a26cc17', 'Test Lesson', NULL, 1, 1, 'c40460b4-1d6e-49b4-a240-3490d8d57089', '2026-07-11 03:32:01', '2026-07-11 03:32:01'),
('cd3038c4-a47c-4364-883a-492d22ad94db', 'Lesson 6', 'Objective for lesson 6', 3, 1, 'c4e6b734-88e1-446e-8940-e228ea5d46e9', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('26f2ee7f-fa56-4ba9-aabd-8259c4bff2a2', 'Lesson', NULL, 0, 1, 'c5ffb741-48b6-4636-a478-b038d4b245de', '2026-07-10 16:21:02', '2026-07-10 16:21:02'),
('9d35cc7c-b183-405d-a876-a5aeb997717d', 'Lesson', NULL, 0, 1, 'c805c437-931e-4ae6-a8f5-ac8efd6f3ca3', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('c6f63da1-35f6-4c36-9141-3b564f4c1c53', 'Lesson 9', 'Objective for lesson 9', 3, 1, 'c9c85c2c-9745-44e5-8e7a-97b222ed5779', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('cf168d3a-7758-4cab-af32-1bd83e13c9dc', 'Lesson 25', 'Objective for lesson 25', 1, 1, 'c9cce62e-d2b1-4ea2-8428-45f96e76938f', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('b3d55079-ca7c-47af-9309-8691bb075add', 'Lesson', NULL, 0, 1, 'c9f049ba-4a4f-4000-be39-b10cff1f7da2', '2026-07-11 04:40:21', '2026-07-11 04:40:21'),
('73759cff-1168-4fc6-9818-fb2cba81efee', 'Mock Lesson', NULL, 0, 0, 'ce954d47-f1df-4bef-add2-35eda2f753e6', '2026-07-11 04:17:24', '2026-07-11 04:17:24'),
('31d2a28e-debb-493a-aba4-af0ea8f567d7', 'Mock Lesson', NULL, 0, 0, 'cf781417-6ed4-4896-9bb5-e8cd725b6b74', '2026-07-11 04:14:10', '2026-07-11 04:14:10'),
('e1e6dea6-331a-4c92-a024-daf163fbcd13', 'Lesson', NULL, 0, 1, 'd079b702-fab2-4abd-9fef-00081207747b', '2026-07-10 16:14:03', '2026-07-10 16:14:03'),
('40a77d3b-39c6-4540-9832-201fc16f9a05', 'Test Lesson', NULL, 1, 1, 'd3958367-bfd4-40a1-a5e9-6426dc39fff9', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('b5d9386a-a99d-4609-803b-93b25f3c2b01', 'Mock Lesson', NULL, 0, 0, 'd492a111-b029-4e4c-9eeb-61e4ee67d61b', '2026-07-11 04:16:03', '2026-07-11 04:16:03'),
('20dc8ec6-d4e1-4f39-bc2b-25a54ad1b24a', 'Lesson', NULL, 0, 1, 'd9aaff72-156b-4faa-88dc-ead305ecb063', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('0a8e6f1e-94b8-48c5-a0d3-989df92b8882', 'Self Introduction (Jikoshoukai)', 'Able to introduce oneself', 1, 1, 'da9fb269-f189-4d84-88b4-1bb2926e0705', '2026-07-10 15:13:34', '2026-07-10 15:13:34'),
('9c2216a8-1883-4baa-a0b6-18ea6b8803ca', 'Lesson', NULL, 0, 1, 'db9c11a5-a5c8-479c-9f69-47029724b479', '2026-07-11 04:40:22', '2026-07-11 04:40:22'),
('d0fbdd80-e430-4846-94f1-59f633e7b10b', 'Lesson 11', 'Objective for lesson 11', 2, 1, 'dd364720-5487-4148-940a-792c71cfe5e1', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('67bfd7ef-81db-4b55-bfe7-95d50b97d324', 'Lesson', NULL, 0, 1, 'df3ef33d-9678-4373-befe-7c408f7e7c6d', '2026-07-10 16:09:49', '2026-07-10 16:09:49'),
('34e2e4c1-c962-4a9c-bba2-dbc515cbe8f9', 'Lesson', NULL, 0, 1, 'e1db5222-af24-4be3-9837-1a4a8db18940', '2026-07-10 16:09:32', '2026-07-10 16:09:32'),
('e4890ac6-6415-4507-b7aa-2b1af0420f93', 'Lesson', NULL, 0, 1, 'e5eee978-b239-46f9-bbae-b2e08efd36cf', '2026-07-10 15:38:11', '2026-07-10 15:38:11'),
('014cf38b-7ff3-4502-9520-598f70364eb9', 'Lesson', NULL, 0, 1, 'ebdcd7d0-0fd0-4f52-b9e4-3fe9b34dfa09', '2026-07-10 16:15:48', '2026-07-10 16:15:48'),
('05e65954-db69-488b-9674-15a85c86fcfb', 'Lesson', NULL, 0, 1, 'ecc1233f-1417-4613-83fd-d2762b5cf0da', '2026-07-10 16:11:00', '2026-07-10 16:11:00'),
('74298325-3ad1-435c-935f-625e9058fc0b', 'Lesson', NULL, 0, 1, 'ed4bbc51-bfd6-40f7-af9e-a6c6dd6e6823', '2026-07-10 16:15:48', '2026-07-10 16:15:48'),
('b60a7e18-b841-4b5c-b16b-fb630789c8d0', 'Empty Lesson', NULL, 0, 0, 'ee9e62f0-904e-4d18-9ae6-98d1c517c53d', '2026-07-10 15:25:57', '2026-07-10 15:25:57'),
('ca8a1785-5367-4679-b7e8-2ab1a11d591b', 'Lesson 21', 'Objective for lesson 21', 3, 1, 'f215a15e-ac3d-4bf0-b7ff-cb6a989f3f83', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('50b94769-e81e-4300-a880-7ec227b28543', 'Lesson 16', 'Objective for lesson 16', 1, 1, 'f3de8168-b769-4588-8b80-f4790712e72b', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('e05f13a3-bd03-4268-92dc-d875d89ec930', 'Lesson', NULL, 0, 1, 'f8f97f68-a8e2-4b69-ad0c-17fcad7b0463', '2026-07-10 16:20:00', '2026-07-10 16:20:00'),
('d3ddada1-3f33-483e-80b3-e8686a98735a', 'Lesson', NULL, 0, 1, 'f9b18921-17a4-4da2-949a-9e66762d2380', '2026-07-10 16:03:05', '2026-07-10 16:03:05'),
('716b0957-38ce-4f5a-a73f-d562f71b483f', 'Lesson', NULL, 0, 1, 'fb6f81f4-0050-49ce-a147-9672b6e9ca3c', '2026-07-10 15:55:00', '2026-07-10 15:55:00'),
('eb05f7ab-f58a-4325-a2e8-ccc189063ad6', 'Lesson', NULL, 0, 1, 'fc34ca52-3c47-4896-826c-1122305a7942', '2026-07-10 16:23:43', '2026-07-10 16:23:43'),
('6337b9e3-5cab-4e01-963c-8feb0f10fc24', 'Lesson', NULL, 0, 1, 'fcb039d9-9cd1-4f1a-898c-b48e0e002c70', '2026-07-11 04:40:21', '2026-07-11 04:40:21');

-- --------------------------------------------------------

--
-- Table structure for table `lesson_grammar_points`
--

CREATE TABLE `lesson_grammar_points` (
  `lesson_id` varchar(36) NOT NULL,
  `grammar_point_id` varchar(36) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `lesson_grammar_points`
--

INSERT INTO `lesson_grammar_points` (`lesson_id`, `grammar_point_id`) VALUES
('07443ee1-78b4-404e-82de-c97a03809f12', '7c8ab60f-6571-45fd-82cf-5cec60834e7b'),
('0feee345-4eda-48eb-a5d8-b8bd6fd30915', '9551c5b3-ecb8-4a04-bb46-754fb9c747d7'),
('12aa4576-6aa1-43d0-a1ae-9a6a0900480e', '6dd7aba6-34fc-4c09-9456-e6abd0e154ae'),
('20e4f660-c70b-4602-ab8f-0ccd9aefb4c1', 'dfe9017c-d18a-4e88-929d-33cd290c7d42'),
('25082036-6d59-418e-9471-ef053cf3cf31', 'b7fd71d2-1244-434c-aaaf-d08deea873b9'),
('28800418-9d7b-4c94-8912-3944ff99f4e5', '2e799ac9-1762-4416-bc98-594426dedab8'),
('28b761da-f6a3-4d80-8523-059b1ea49968', 'e5db6461-22a6-424f-96ad-77ce1c81c88b'),
('311440a8-6fd6-492f-965c-966181e8d3b3', '1ae59eb4-d7ff-499f-9206-11a9e3dedac0'),
('3eb78103-00ad-4e58-be6d-ea5ef58d99bc', '0122e1d0-82a8-48b6-b1a8-3e8cdfaeb021'),
('53b3d5fe-a25a-4670-9bce-cc0452d76ec7', '6600d329-7ac1-4161-8a88-c1b896f94798'),
('59b863ad-9a4b-43b2-bd04-063b011e7510', 'fe457b6d-b5df-4d90-9598-a13253285590'),
('78589edc-8c29-43b3-b9b2-04d1b433a23e', '6de433ee-88ed-4bf4-97c2-bea64b8c86ba'),
('7add805b-c99a-4e33-aefb-150e23da2961', 'ce65eb0b-4ab8-4652-ac90-a23000a2154b'),
('7cea6f51-6269-481a-a61b-71a189816f59', '81b3badd-88e9-432b-a53a-d51d41d550de'),
('82cee997-09e3-460e-afed-05fc90d62c54', 'c5ff326e-3010-46c2-a451-9a88b315771e'),
('854c3593-4f38-44be-8336-62d66bee956b', '9da5a0f1-c362-4d50-9d78-534b7dee3678'),
('87d161e1-ec62-4d74-8ca4-d576b3a4a21c', 'fe91712a-5bdf-4ff7-8cdb-1fb29b58a4ee'),
('93d8913f-9e51-4052-a201-5c317aa8f46a', 'bad6a06d-1c6e-4213-b3ea-765168200bbb'),
('a7b56a6f-98c5-4ee8-af1f-ecc71a18f38d', '9a6e0691-3ac0-40c2-a3f0-4032cee3e2e4'),
('ad2b3982-1bcc-47e8-96c1-dcf38e3242fc', '0fe4677e-2c80-4f6d-bf79-8481fc0d0044'),
('b2f7f273-823b-49be-a148-f7764f3d5b8c', 'e98a8c83-7033-4148-9b3b-aaae55ff9565'),
('bf8862ab-3bfe-42bd-805b-613a5537fdce', '16681a78-573c-44bf-bc6e-a5ed2b4087ca'),
('c03c6d85-175d-481d-aea5-419e408b7e03', '081d28f3-50fa-4de6-b7bd-dc96d2aa79b4'),
('c140e128-4049-4967-8aee-7f53a1ca8672', '03f1e4a9-7ba7-462e-a91e-f6119474c048'),
('c4e6b734-88e1-446e-8940-e228ea5d46e9', 'daf1e110-340c-4c79-b58b-10e8eb72389f'),
('c9c85c2c-9745-44e5-8e7a-97b222ed5779', '246d0abf-624f-4a39-a07c-45eaf40ee690'),
('c9cce62e-d2b1-4ea2-8428-45f96e76938f', '009086f2-1ec5-451c-b1ef-0581a818a770'),
('dd364720-5487-4148-940a-792c71cfe5e1', 'dbc8f5b6-7337-446f-912c-8429a13fdcbb'),
('f215a15e-ac3d-4bf0-b7ff-cb6a989f3f83', 'd3ab6262-2628-49e3-943d-040084ef437a'),
('f3de8168-b769-4588-8b80-f4790712e72b', 'bcd22a6e-069d-46de-9077-e0f5fa7fa89d');

-- --------------------------------------------------------

--
-- Table structure for table `lesson_kanjis`
--

CREATE TABLE `lesson_kanjis` (
  `lesson_id` varchar(36) NOT NULL,
  `kanji_id` varchar(36) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `lesson_kanjis`
--

INSERT INTO `lesson_kanjis` (`lesson_id`, `kanji_id`) VALUES
('07443ee1-78b4-404e-82de-c97a03809f12', '0489e89c-1a3a-4513-b6df-3d6374acc4e4'),
('07443ee1-78b4-404e-82de-c97a03809f12', 'a32e8c45-88dd-4b84-8148-fe1554fb85c6'),
('07443ee1-78b4-404e-82de-c97a03809f12', 'b52622a2-cd16-4436-9e9d-12b2d963382e'),
('0feee345-4eda-48eb-a5d8-b8bd6fd30915', '0fa30169-35c9-46e4-aa97-957fe1afcb96'),
('0feee345-4eda-48eb-a5d8-b8bd6fd30915', '61969586-af15-4936-9701-8c6cb877b7a8'),
('0feee345-4eda-48eb-a5d8-b8bd6fd30915', '81329835-58b3-4f33-a422-1ec6d8dd7fec'),
('12aa4576-6aa1-43d0-a1ae-9a6a0900480e', '3d0160e3-a63e-42c5-bc87-fedb63ae9a13'),
('12aa4576-6aa1-43d0-a1ae-9a6a0900480e', '7450b4c4-85b6-43ca-8e59-15d7ab00b013'),
('12aa4576-6aa1-43d0-a1ae-9a6a0900480e', 'b15676f8-4671-4225-a55a-6fd51f4fe8b2'),
('20e4f660-c70b-4602-ab8f-0ccd9aefb4c1', 'ae398ba7-fe49-400e-9243-08a3c6d26c65'),
('20e4f660-c70b-4602-ab8f-0ccd9aefb4c1', 'b7bac092-9626-4f42-b0df-47bdaa26545f'),
('20e4f660-c70b-4602-ab8f-0ccd9aefb4c1', 'd1acdfb8-5a6b-438a-939f-d98825fd7021'),
('25082036-6d59-418e-9471-ef053cf3cf31', '5d143f79-bb9f-4de8-bcb1-2cddcd6b3355'),
('25082036-6d59-418e-9471-ef053cf3cf31', 'a5e2dd03-82af-487e-be6f-4cb60a9fcc1e'),
('25082036-6d59-418e-9471-ef053cf3cf31', 'ee3338b1-b5d3-4c2a-9b84-c617218b174f'),
('28800418-9d7b-4c94-8912-3944ff99f4e5', '5769c0fc-74d4-4294-9af6-70c35dbfe975'),
('28800418-9d7b-4c94-8912-3944ff99f4e5', 'a9fb6c69-02e3-4269-927e-70575bd3cc5d'),
('28800418-9d7b-4c94-8912-3944ff99f4e5', 'e937904e-6524-4988-b0c5-4238e2b316ec'),
('28b761da-f6a3-4d80-8523-059b1ea49968', '2e7fe707-a734-408f-9c21-fd186f62f3ff'),
('28b761da-f6a3-4d80-8523-059b1ea49968', '94642f2c-8b05-47b3-8895-070b538ba6ff'),
('28b761da-f6a3-4d80-8523-059b1ea49968', 'e9aaf861-0c49-45ac-a69e-5b749e643d7c'),
('311440a8-6fd6-492f-965c-966181e8d3b3', '25f8a60d-bc29-4a04-aaf4-cd9bc1e5e2b4'),
('311440a8-6fd6-492f-965c-966181e8d3b3', 'd405a02f-6163-476c-b16e-f475de032941'),
('311440a8-6fd6-492f-965c-966181e8d3b3', 'd7e84273-549a-43b3-b5a9-dcaa1e2ad367'),
('3eb78103-00ad-4e58-be6d-ea5ef58d99bc', '3f4c269f-7c60-44e4-9f2e-3e117051b641'),
('3eb78103-00ad-4e58-be6d-ea5ef58d99bc', 'dc0d5213-8c54-4d5c-bedb-80fb77cfd2da'),
('3eb78103-00ad-4e58-be6d-ea5ef58d99bc', 'f5b33235-140b-43ff-844e-4725973ecd7a'),
('53b3d5fe-a25a-4670-9bce-cc0452d76ec7', '41398445-adbd-479b-a74f-1565e1a027f4'),
('53b3d5fe-a25a-4670-9bce-cc0452d76ec7', 'bbf8c137-6380-4ec0-8525-1a5b121c9f54'),
('53b3d5fe-a25a-4670-9bce-cc0452d76ec7', 'd56896da-bbe7-465d-8042-ac56d5d9628f'),
('59b863ad-9a4b-43b2-bd04-063b011e7510', '06140ad3-effd-46cd-ba7b-a124f882e816'),
('59b863ad-9a4b-43b2-bd04-063b011e7510', '06894823-2e5b-403b-b95d-fa7525fa0081'),
('59b863ad-9a4b-43b2-bd04-063b011e7510', 'bb9e0ac0-c02f-4bdd-8905-09343dc67724'),
('78589edc-8c29-43b3-b9b2-04d1b433a23e', '0403843f-5416-47af-85f7-ba3d14d73f6b'),
('78589edc-8c29-43b3-b9b2-04d1b433a23e', '0b939ff3-7338-44f4-be90-a75bf81f2a6d'),
('78589edc-8c29-43b3-b9b2-04d1b433a23e', '5ee43eea-6afc-4e4f-b5f0-7402894f0185'),
('7add805b-c99a-4e33-aefb-150e23da2961', '56edf6f9-7bf8-479b-8530-2fec783f02c1'),
('7add805b-c99a-4e33-aefb-150e23da2961', '7a184f35-fdde-4974-8781-8eb65b3652e1'),
('7add805b-c99a-4e33-aefb-150e23da2961', '8d7b5abf-49f7-4784-bd19-131b9f287848'),
('7cea6f51-6269-481a-a61b-71a189816f59', '5f40b2de-7de8-4088-9b5d-9734ce6030b1'),
('7cea6f51-6269-481a-a61b-71a189816f59', '787165c5-e943-4cdf-969b-5838c9e19668'),
('7cea6f51-6269-481a-a61b-71a189816f59', 'a8075010-7e7f-480a-860f-f10229e521cf'),
('82cee997-09e3-460e-afed-05fc90d62c54', '69f9155d-01a5-4bc0-a5ad-1a678adb2bfb'),
('82cee997-09e3-460e-afed-05fc90d62c54', '7936172c-4a30-49e8-906c-e58cf7941445'),
('82cee997-09e3-460e-afed-05fc90d62c54', 'eefafd02-d304-43d6-9bb8-255f15cdeacf'),
('854c3593-4f38-44be-8336-62d66bee956b', '454b0a2e-4b41-4b58-81a7-c110f90bf1bc'),
('854c3593-4f38-44be-8336-62d66bee956b', '4a07c6f4-0e55-4d50-a04a-355bcec550ac'),
('854c3593-4f38-44be-8336-62d66bee956b', '9cd9189b-4df9-4fb2-a816-be0654259439'),
('87d161e1-ec62-4d74-8ca4-d576b3a4a21c', '2d620b62-be27-4c3b-be53-b8f34fba9af9'),
('87d161e1-ec62-4d74-8ca4-d576b3a4a21c', '43b1e2bb-ef33-48a5-a9d8-1ccf856f6c64'),
('87d161e1-ec62-4d74-8ca4-d576b3a4a21c', '5218921b-79e8-492e-a5b7-e9c5e974e778'),
('93d8913f-9e51-4052-a201-5c317aa8f46a', '6d431fab-47dc-4a39-8d5c-a13c8ac72fc2'),
('93d8913f-9e51-4052-a201-5c317aa8f46a', '7e3dc270-9168-46d9-bda3-8d8aee47b4e5'),
('93d8913f-9e51-4052-a201-5c317aa8f46a', '9b8ef8a1-00ee-44d4-956c-55932fb758b2'),
('a7b56a6f-98c5-4ee8-af1f-ecc71a18f38d', '4f341103-c894-4806-ac7a-98b7f2b85978'),
('a7b56a6f-98c5-4ee8-af1f-ecc71a18f38d', '8a0c4957-9855-48be-92be-ce06f2683e01'),
('a7b56a6f-98c5-4ee8-af1f-ecc71a18f38d', 'f01f43dc-b4fd-47d7-8987-cdf1fc82b5d1'),
('ad2b3982-1bcc-47e8-96c1-dcf38e3242fc', '239540e3-681b-4ac5-a119-08f805a12aa3'),
('ad2b3982-1bcc-47e8-96c1-dcf38e3242fc', '770a916c-02dd-44f5-9a0c-f03255e1932e'),
('ad2b3982-1bcc-47e8-96c1-dcf38e3242fc', '87139d1e-f333-402a-beed-8e04074afc57'),
('b2f7f273-823b-49be-a148-f7764f3d5b8c', '1007fe21-4578-4ec1-9155-b5251a189edb'),
('b2f7f273-823b-49be-a148-f7764f3d5b8c', '462bdffb-3bc3-45d0-9993-62f4639fb801'),
('b2f7f273-823b-49be-a148-f7764f3d5b8c', 'f90efa36-f798-49b1-82a9-7461214eacd3'),
('bf8862ab-3bfe-42bd-805b-613a5537fdce', '588fe440-82a9-439a-9863-85d58c48f65b'),
('bf8862ab-3bfe-42bd-805b-613a5537fdce', 'a961a40a-185d-454a-bb7f-9c9b8d569fc3'),
('bf8862ab-3bfe-42bd-805b-613a5537fdce', 'dc99862c-d5c1-4c13-bf2f-a79da2319c3b'),
('c03c6d85-175d-481d-aea5-419e408b7e03', '34009a6f-2807-44d5-918e-f06de6bd7eb4'),
('c03c6d85-175d-481d-aea5-419e408b7e03', 'ab223517-ab7b-4818-8a87-81ed0c66296f'),
('c03c6d85-175d-481d-aea5-419e408b7e03', 'cab825ce-34ec-44b6-8f0f-90772a410e5a'),
('c140e128-4049-4967-8aee-7f53a1ca8672', '749b9d54-b14a-4982-80c3-42b473010c41'),
('c140e128-4049-4967-8aee-7f53a1ca8672', 'b6181a79-4ade-44db-a7dc-8b83df5bbb02'),
('c140e128-4049-4967-8aee-7f53a1ca8672', 'f42de83d-34cb-4061-b75e-b779a74b1538'),
('c4e6b734-88e1-446e-8940-e228ea5d46e9', '1081afcd-d098-40a5-af71-54ef466ad1b0'),
('c4e6b734-88e1-446e-8940-e228ea5d46e9', '55f3d85e-d08e-401a-95fa-95137ee8810c'),
('c4e6b734-88e1-446e-8940-e228ea5d46e9', 'eac015e1-d854-4358-b29f-edb51b69af69'),
('c9c85c2c-9745-44e5-8e7a-97b222ed5779', '5ea7cccf-d43f-4948-b706-87f22de762d0'),
('c9c85c2c-9745-44e5-8e7a-97b222ed5779', '9a318459-0d88-4b5f-82c6-39567acdb2c5'),
('c9c85c2c-9745-44e5-8e7a-97b222ed5779', 'a53f210a-074f-4ed8-9064-ad80d8d3f180'),
('c9cce62e-d2b1-4ea2-8428-45f96e76938f', '7d3cd2f7-f39d-4446-8619-835d6eb1ce41'),
('c9cce62e-d2b1-4ea2-8428-45f96e76938f', 'c603a10f-395e-4312-b216-a7027819df71'),
('c9cce62e-d2b1-4ea2-8428-45f96e76938f', 'cb70dee5-7c16-4d08-8829-d8cc35f2d0db'),
('da9fb269-f189-4d84-88b4-1bb2926e0705', '8a0c4957-9855-48be-92be-ce06f2683e01'),
('da9fb269-f189-4d84-88b4-1bb2926e0705', 'f01f43dc-b4fd-47d7-8987-cdf1fc82b5d1'),
('dd364720-5487-4148-940a-792c71cfe5e1', '26458b00-3cbe-4cfc-afee-02ffe78b4b30'),
('dd364720-5487-4148-940a-792c71cfe5e1', '80c4198b-f23c-4774-b2fc-61caa420fdcf'),
('dd364720-5487-4148-940a-792c71cfe5e1', 'f0078fef-8781-4a28-8f5b-a2323ba39812'),
('f215a15e-ac3d-4bf0-b7ff-cb6a989f3f83', '075f46ef-c707-4303-9b33-4007508cd107'),
('f215a15e-ac3d-4bf0-b7ff-cb6a989f3f83', '269f7b80-0f36-4f5b-9664-dacf7c18b7a8'),
('f215a15e-ac3d-4bf0-b7ff-cb6a989f3f83', '6b4a3589-f7fd-4948-a3b1-a880908191a9'),
('f3de8168-b769-4588-8b80-f4790712e72b', '059140ee-01d2-46e7-bba9-9203bb38a84f'),
('f3de8168-b769-4588-8b80-f4790712e72b', '8e87a5e5-f256-452f-a490-0a35106fa8e4'),
('f3de8168-b769-4588-8b80-f4790712e72b', 'f82bbb1d-2699-4691-8bfc-6a430535346a');

-- --------------------------------------------------------

--
-- Table structure for table `lesson_sections`
--

CREATE TABLE `lesson_sections` (
  `lesson_id` varchar(36) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text DEFAULT NULL,
  `sequence` int(11) DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lesson_vocabularies`
--

CREATE TABLE `lesson_vocabularies` (
  `lesson_id` varchar(36) NOT NULL,
  `vocabulary_id` varchar(36) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `lesson_vocabularies`
--

INSERT INTO `lesson_vocabularies` (`lesson_id`, `vocabulary_id`) VALUES
('07443ee1-78b4-404e-82de-c97a03809f12', '01e9eaa5-1e60-4a3e-97f1-9ef75eeb4331'),
('07443ee1-78b4-404e-82de-c97a03809f12', '11f5df9c-5f45-4b32-abce-3c2b18448db8'),
('07443ee1-78b4-404e-82de-c97a03809f12', '411ea2e3-b820-489f-a815-8a335e98bdd1'),
('07443ee1-78b4-404e-82de-c97a03809f12', '57cde26f-ef37-4669-b53e-d852fdab8250'),
('07443ee1-78b4-404e-82de-c97a03809f12', '7d5a58c3-b04d-47b9-91ff-9c4917326b96'),
('07443ee1-78b4-404e-82de-c97a03809f12', '99a27dc2-fb9f-4534-82c2-07bc5bc035b0'),
('07443ee1-78b4-404e-82de-c97a03809f12', 'a133183a-ec2e-4575-af8a-d392c100a3a4'),
('07443ee1-78b4-404e-82de-c97a03809f12', 'c105b80f-5c3a-48e7-b924-53a2f6f81e09'),
('07443ee1-78b4-404e-82de-c97a03809f12', 'c9c0e1f2-41d1-4dec-aa17-9cfe9b81f16c'),
('07443ee1-78b4-404e-82de-c97a03809f12', 'd282e323-00c8-44db-a650-fb63a1ff57d3'),
('0feee345-4eda-48eb-a5d8-b8bd6fd30915', '0b5b2995-dbd4-495e-8986-06d46cf01b16'),
('0feee345-4eda-48eb-a5d8-b8bd6fd30915', '2bbbf13d-a1bd-43c9-88a4-6eea7c03ea55'),
('0feee345-4eda-48eb-a5d8-b8bd6fd30915', '2edce1ef-65a5-49d5-8613-0d4bce408518'),
('0feee345-4eda-48eb-a5d8-b8bd6fd30915', '37b92982-3f23-42ef-8718-e56c6e4baaf0'),
('0feee345-4eda-48eb-a5d8-b8bd6fd30915', '5d4250c6-db24-444f-8c87-ac5718cffff1'),
('0feee345-4eda-48eb-a5d8-b8bd6fd30915', '86492d13-02ab-45b3-8007-94af1e2ce8aa'),
('0feee345-4eda-48eb-a5d8-b8bd6fd30915', '93be667f-a662-4768-93e0-f06c4b4c0055'),
('0feee345-4eda-48eb-a5d8-b8bd6fd30915', 'cdac3b15-c2e5-4e23-a9c7-a3aa41e001bc'),
('0feee345-4eda-48eb-a5d8-b8bd6fd30915', 'd3293ff3-83ba-4594-b58f-99bbabbb4bbe'),
('0feee345-4eda-48eb-a5d8-b8bd6fd30915', 'f7411d66-6365-4959-b234-b85e509b39b5'),
('12aa4576-6aa1-43d0-a1ae-9a6a0900480e', '2e604afe-4793-40c5-bd1a-b06af2f07bd3'),
('12aa4576-6aa1-43d0-a1ae-9a6a0900480e', '312cc087-2944-40c3-ab8b-7c172bc8f1e6'),
('12aa4576-6aa1-43d0-a1ae-9a6a0900480e', '71284441-9872-45c1-9729-76f3f109f2f9'),
('12aa4576-6aa1-43d0-a1ae-9a6a0900480e', '826ff2d7-e981-4bed-973c-fa6fda6fefe3'),
('12aa4576-6aa1-43d0-a1ae-9a6a0900480e', '8cd03c9a-4004-4ea2-9dd8-ad39ca80a692'),
('12aa4576-6aa1-43d0-a1ae-9a6a0900480e', '92816106-4ce9-4506-968c-77c1b000d54b'),
('12aa4576-6aa1-43d0-a1ae-9a6a0900480e', '9502e5f8-c9ac-4f87-994d-96cf59a97761'),
('12aa4576-6aa1-43d0-a1ae-9a6a0900480e', 'a4250445-9995-4d5c-ae72-22b5ba8eae0c'),
('12aa4576-6aa1-43d0-a1ae-9a6a0900480e', 'bf823f98-394d-4eb7-ac55-0bdfc184488d'),
('12aa4576-6aa1-43d0-a1ae-9a6a0900480e', 'e2f98c4c-ab30-4936-a93c-4d9745551dbe'),
('20e4f660-c70b-4602-ab8f-0ccd9aefb4c1', '00b96962-b353-4eb7-ab2c-f1df755c0ec2'),
('20e4f660-c70b-4602-ab8f-0ccd9aefb4c1', '1eecfff8-cf78-4c14-9a90-e9afc25f7ebe'),
('20e4f660-c70b-4602-ab8f-0ccd9aefb4c1', '2b751270-6a1c-48b6-84bf-edba8e673a21'),
('20e4f660-c70b-4602-ab8f-0ccd9aefb4c1', '3eb8f3b1-d49b-4b97-85d2-87d176b554ef'),
('20e4f660-c70b-4602-ab8f-0ccd9aefb4c1', '50a9b80f-6568-452c-aaf0-9b06dfcaace4'),
('20e4f660-c70b-4602-ab8f-0ccd9aefb4c1', '85adde13-80cd-4a17-8715-89d82966ae05'),
('20e4f660-c70b-4602-ab8f-0ccd9aefb4c1', '8c22b79e-7e06-4a14-a26e-feea7c3428f6'),
('20e4f660-c70b-4602-ab8f-0ccd9aefb4c1', 'a424f64a-ad93-490e-ada5-7acab8a55aa8'),
('20e4f660-c70b-4602-ab8f-0ccd9aefb4c1', 'd45e5536-f72b-47cb-853d-46167dae1ddd'),
('20e4f660-c70b-4602-ab8f-0ccd9aefb4c1', 'f4f1ffa5-c3c0-4c03-b791-ac7ab1c10d5a'),
('25082036-6d59-418e-9471-ef053cf3cf31', '1aa46363-8f0f-4c15-8988-e4033b6b5e3e'),
('25082036-6d59-418e-9471-ef053cf3cf31', '5afc5219-789e-4e37-9ac4-dbb230db2c63'),
('25082036-6d59-418e-9471-ef053cf3cf31', '5b706b3a-9d3a-4b77-b2df-94dacc153caf'),
('25082036-6d59-418e-9471-ef053cf3cf31', '6a5f9c8b-c452-42a3-b135-7da3fdfa3061'),
('25082036-6d59-418e-9471-ef053cf3cf31', '7ab502a0-7884-4014-a938-4764cf9935d0'),
('25082036-6d59-418e-9471-ef053cf3cf31', 'bf689cf8-0985-4d1c-9f16-ac5f60173e29'),
('25082036-6d59-418e-9471-ef053cf3cf31', 'd532de17-f3b0-4d67-8991-8282b9571cd0'),
('25082036-6d59-418e-9471-ef053cf3cf31', 'f032d05a-eafa-4bea-9f95-6b3b623a9a18'),
('25082036-6d59-418e-9471-ef053cf3cf31', 'f9cb73bb-3ce6-4097-8a83-9c37c8d0b9a6'),
('25082036-6d59-418e-9471-ef053cf3cf31', 'fccb3cec-629c-4086-8822-046d5f4301c4'),
('28800418-9d7b-4c94-8912-3944ff99f4e5', '1b573d40-7b10-4f19-be07-6bb1ceb3d5e7'),
('28800418-9d7b-4c94-8912-3944ff99f4e5', '4007c34e-1a1f-41d4-a10f-867c10b3f941'),
('28800418-9d7b-4c94-8912-3944ff99f4e5', '44a5c8da-a16a-42e3-a927-84852a59cbc4'),
('28800418-9d7b-4c94-8912-3944ff99f4e5', '598b28cc-9e80-4437-a312-f56e6402cb4e'),
('28800418-9d7b-4c94-8912-3944ff99f4e5', '823b6319-d6a2-4884-a905-9ea123c26a3a'),
('28800418-9d7b-4c94-8912-3944ff99f4e5', '85217e7c-ea69-4938-82fd-4a88aa19d0c1'),
('28800418-9d7b-4c94-8912-3944ff99f4e5', 'b3e2adbb-edce-40dc-9bf2-e0b03dc37ba3'),
('28800418-9d7b-4c94-8912-3944ff99f4e5', 'c38ffb1e-ee4f-4855-8845-74b0cb53b85a'),
('28800418-9d7b-4c94-8912-3944ff99f4e5', 'ccfbd08a-b8fb-4286-b3e6-8406b8a306a2'),
('28800418-9d7b-4c94-8912-3944ff99f4e5', 'eb4449dc-e99e-443f-9d55-c541e0eaca8d'),
('28b761da-f6a3-4d80-8523-059b1ea49968', '19f9afc9-af9e-4fa9-a3da-1cad30e0a49e'),
('28b761da-f6a3-4d80-8523-059b1ea49968', '5cf7bb7a-4c02-41ad-84b1-11b883f31314'),
('28b761da-f6a3-4d80-8523-059b1ea49968', '8c301341-1530-4759-a38b-29aaddf9d159'),
('28b761da-f6a3-4d80-8523-059b1ea49968', '942f70b4-15e4-4c95-9390-7849a3ecd237'),
('28b761da-f6a3-4d80-8523-059b1ea49968', 'a3b04a30-fb5d-44be-9168-2da3914cb789'),
('28b761da-f6a3-4d80-8523-059b1ea49968', 'b0c85d01-d49f-4596-b86a-1f445e6a2ca5'),
('28b761da-f6a3-4d80-8523-059b1ea49968', 'ba2f476a-66e2-4aa0-bdab-b8121633b103'),
('28b761da-f6a3-4d80-8523-059b1ea49968', 'c5eea8aa-9068-419e-ba49-987e15bf7ea6'),
('28b761da-f6a3-4d80-8523-059b1ea49968', 'ce480380-2efb-4926-a957-34203444c14e'),
('28b761da-f6a3-4d80-8523-059b1ea49968', 'd30265c0-92d9-42ec-86f8-a831cdff4214'),
('311440a8-6fd6-492f-965c-966181e8d3b3', '163c37d0-c549-4a07-a0df-2e1feaa69f84'),
('311440a8-6fd6-492f-965c-966181e8d3b3', '268ed072-2392-4abd-b0f0-47867e4f14c9'),
('311440a8-6fd6-492f-965c-966181e8d3b3', '2d9bda27-e4a4-44d1-a900-78b771f6e025'),
('311440a8-6fd6-492f-965c-966181e8d3b3', '3597ba1b-2faf-4d45-b2d9-03e4ba3c869b'),
('311440a8-6fd6-492f-965c-966181e8d3b3', '5b883d5f-4eaa-4b04-85ab-3213184aa062'),
('311440a8-6fd6-492f-965c-966181e8d3b3', '8a9503ab-837f-4818-8fa3-025b2361ec70'),
('311440a8-6fd6-492f-965c-966181e8d3b3', '90f101c5-2bb1-472f-a20a-df1513623e76'),
('311440a8-6fd6-492f-965c-966181e8d3b3', '9971d699-d7ca-4121-be11-de0bdb656988'),
('311440a8-6fd6-492f-965c-966181e8d3b3', 'd9a6d3a6-b39b-4389-8405-b9eaba2e95fa'),
('311440a8-6fd6-492f-965c-966181e8d3b3', 'f43f466f-58c4-4d46-b19f-a0d94630abf5'),
('3eb78103-00ad-4e58-be6d-ea5ef58d99bc', '0cdd4aac-3be7-495f-a1cf-28369c685353'),
('3eb78103-00ad-4e58-be6d-ea5ef58d99bc', '0f553e30-4390-468f-b787-34d6cfdaeb3b'),
('3eb78103-00ad-4e58-be6d-ea5ef58d99bc', '1603fb84-8177-4867-8dfe-e17dc4da546d'),
('3eb78103-00ad-4e58-be6d-ea5ef58d99bc', '16938d48-7046-4171-83f2-7d978d8a95d0'),
('3eb78103-00ad-4e58-be6d-ea5ef58d99bc', '2006593a-78e8-47dc-82fc-c9b6ad0dd00e'),
('3eb78103-00ad-4e58-be6d-ea5ef58d99bc', '27495bde-074b-4187-8c68-5bef8d49aa4f'),
('3eb78103-00ad-4e58-be6d-ea5ef58d99bc', '2d8d47f9-6176-4adf-84a6-a0592bb2960e'),
('3eb78103-00ad-4e58-be6d-ea5ef58d99bc', '2df0f0b3-a5f1-498f-ab3e-d99c15698da0'),
('3eb78103-00ad-4e58-be6d-ea5ef58d99bc', '5d4a3979-e52f-4fc4-a291-579f19504c60'),
('3eb78103-00ad-4e58-be6d-ea5ef58d99bc', '6b3e6fa1-61db-4b33-b8d0-cfbb00066d87'),
('53b3d5fe-a25a-4670-9bce-cc0452d76ec7', '3998f3ae-7652-41fe-a2d2-f14c3127366c'),
('53b3d5fe-a25a-4670-9bce-cc0452d76ec7', '4777d44b-0210-4fd1-840b-f37c75b68ec9'),
('53b3d5fe-a25a-4670-9bce-cc0452d76ec7', '66836df7-fe9f-4131-a2df-858c69ada4a8'),
('53b3d5fe-a25a-4670-9bce-cc0452d76ec7', '716b7a2b-9c78-49c7-b985-ae6b89259ca9'),
('53b3d5fe-a25a-4670-9bce-cc0452d76ec7', '8d42fdd2-5e19-4757-95d8-1b03434f57e0'),
('53b3d5fe-a25a-4670-9bce-cc0452d76ec7', 'a3da0638-1280-4c91-a269-4b4ae66bbe79'),
('53b3d5fe-a25a-4670-9bce-cc0452d76ec7', 'ba16e4f2-eb71-4d21-ba20-876f5136ca80'),
('53b3d5fe-a25a-4670-9bce-cc0452d76ec7', 'ddd89c01-1920-4eff-9599-1cfffa9999d2'),
('53b3d5fe-a25a-4670-9bce-cc0452d76ec7', 'ecc542c4-7f4d-4d1c-aec4-d193d0a04ab5'),
('53b3d5fe-a25a-4670-9bce-cc0452d76ec7', 'f928612b-b24d-44a4-9b0e-38800653e067'),
('59b863ad-9a4b-43b2-bd04-063b011e7510', '0a263e92-632d-47c7-a720-8d14f79638db'),
('59b863ad-9a4b-43b2-bd04-063b011e7510', '1321a23e-bd50-4735-9871-3ba197037da0'),
('59b863ad-9a4b-43b2-bd04-063b011e7510', '4c296162-a70d-4ba1-b6b5-6e170ccda234'),
('59b863ad-9a4b-43b2-bd04-063b011e7510', '50bbf2fb-bf05-468b-90ce-d3a0bc060892'),
('59b863ad-9a4b-43b2-bd04-063b011e7510', '53204db5-8d45-44e6-893b-046a308c34d2'),
('59b863ad-9a4b-43b2-bd04-063b011e7510', '958fb0bf-4462-40d9-90f1-10fa5cdc6dbc'),
('59b863ad-9a4b-43b2-bd04-063b011e7510', '98951ab9-7d61-464f-92e9-8bde77b101f3'),
('59b863ad-9a4b-43b2-bd04-063b011e7510', 'a8e79607-72a2-4389-95fa-63127a29594c'),
('59b863ad-9a4b-43b2-bd04-063b011e7510', 'b2c56206-a856-4cfe-9434-289a58e77ae0'),
('59b863ad-9a4b-43b2-bd04-063b011e7510', 'e45ae948-2966-415f-9cbf-6d76b81edeb6'),
('78589edc-8c29-43b3-b9b2-04d1b433a23e', '0cf2bbad-fad2-4300-8097-d131fb3518e2'),
('78589edc-8c29-43b3-b9b2-04d1b433a23e', '135b00bb-c154-4005-8662-b21d008df3b5'),
('78589edc-8c29-43b3-b9b2-04d1b433a23e', '506615d9-7ff5-4734-8a1d-f9f92f2cec70'),
('78589edc-8c29-43b3-b9b2-04d1b433a23e', '8dfcb06a-4461-4990-9ca0-d191050de98e'),
('78589edc-8c29-43b3-b9b2-04d1b433a23e', 'b3fe0842-6f19-4393-87b3-2eea98ffb41f'),
('78589edc-8c29-43b3-b9b2-04d1b433a23e', 'bb34c9f4-9de1-42d0-96e5-46e4c504325b'),
('78589edc-8c29-43b3-b9b2-04d1b433a23e', 'c2a97e59-53aa-4663-89a8-6d1e8a0247ef'),
('78589edc-8c29-43b3-b9b2-04d1b433a23e', 'ddec9d8b-7066-4fc2-8f32-5d64429ba0cc'),
('78589edc-8c29-43b3-b9b2-04d1b433a23e', 'ee557749-ecfa-4146-aed3-40c800f9f5bb'),
('78589edc-8c29-43b3-b9b2-04d1b433a23e', 'f553912e-1edb-43aa-a283-9daa8c535cdb'),
('7add805b-c99a-4e33-aefb-150e23da2961', '045008df-2a04-488c-bafe-16fc45bbc224'),
('7add805b-c99a-4e33-aefb-150e23da2961', '3fd63afd-6bc0-4b14-9126-cbb409c484b9'),
('7add805b-c99a-4e33-aefb-150e23da2961', '5c917294-7261-4de9-914c-4b48d9c57d51'),
('7add805b-c99a-4e33-aefb-150e23da2961', '5caa0b2a-19ef-4d2d-8c13-e19ffc5907e8'),
('7add805b-c99a-4e33-aefb-150e23da2961', '65c24e6d-a532-448f-ac94-2fa7fe379afe'),
('7add805b-c99a-4e33-aefb-150e23da2961', 'ae494a5d-a77a-4b16-aaf0-03ab7811d0d3'),
('7add805b-c99a-4e33-aefb-150e23da2961', 'b34dfe0c-709d-46ad-8516-e7923d449365'),
('7add805b-c99a-4e33-aefb-150e23da2961', 'c754076e-d3ee-4947-b5df-575dd2d85279'),
('7add805b-c99a-4e33-aefb-150e23da2961', 'c77d1d2a-c316-4c5b-84f8-38b36d585c22'),
('7add805b-c99a-4e33-aefb-150e23da2961', 'd84d5a18-4d87-4f76-b5d6-5a7670c2955c'),
('7cea6f51-6269-481a-a61b-71a189816f59', '26da50b0-3f2a-4b93-b2bb-f627fd559e68'),
('7cea6f51-6269-481a-a61b-71a189816f59', '4d6ba03d-55d2-48bc-a5a6-027dc8ae99c0'),
('7cea6f51-6269-481a-a61b-71a189816f59', '54509a79-a51b-42fb-b13e-5eac9fee6f4b'),
('7cea6f51-6269-481a-a61b-71a189816f59', '7b443252-f09d-4306-9206-018b8377d7b3'),
('7cea6f51-6269-481a-a61b-71a189816f59', 'a6d07409-9b26-468b-aabf-ce89381bb26a'),
('7cea6f51-6269-481a-a61b-71a189816f59', 'b4a690d5-83d5-4659-9aae-4caa100968bb'),
('7cea6f51-6269-481a-a61b-71a189816f59', 'c5221fb2-7ea6-4d40-91b8-27adf3a4aa5b'),
('7cea6f51-6269-481a-a61b-71a189816f59', 'e3ea2923-7636-44c3-8450-7e9ad56f3db8'),
('7cea6f51-6269-481a-a61b-71a189816f59', 'fa70cc23-5358-4925-9b94-3c427c0ca553'),
('7cea6f51-6269-481a-a61b-71a189816f59', 'fcf67473-2ad6-4db2-a913-e3476ca85bda'),
('82cee997-09e3-460e-afed-05fc90d62c54', '1885917c-ac26-41bd-8a4a-89ddd0f93608'),
('82cee997-09e3-460e-afed-05fc90d62c54', '1d023e43-0557-4d88-9c16-21aca223bdc2'),
('82cee997-09e3-460e-afed-05fc90d62c54', '34ca1e5d-919c-40f1-98ee-4ce311370a64'),
('82cee997-09e3-460e-afed-05fc90d62c54', '7d3ed299-d949-4909-958e-3d978a3c75c7'),
('82cee997-09e3-460e-afed-05fc90d62c54', '93b54f4d-ad95-402b-8a6a-8caecf495de0'),
('82cee997-09e3-460e-afed-05fc90d62c54', 'a66b0055-c29e-48d0-85a5-a6c148483160'),
('82cee997-09e3-460e-afed-05fc90d62c54', 'b2b0781e-20fb-497c-b9e2-f84a58d071cd'),
('82cee997-09e3-460e-afed-05fc90d62c54', 'b5a3dd81-4da9-416d-b794-f52069ced7d3'),
('82cee997-09e3-460e-afed-05fc90d62c54', 'daa1d8c6-25a0-4ee8-ad3b-d7425f7f3751'),
('82cee997-09e3-460e-afed-05fc90d62c54', 'dfbdf83e-bf9d-4dbb-85ad-189c25fe16ba'),
('854c3593-4f38-44be-8336-62d66bee956b', '0da5ece0-1c61-4020-a152-a2e95dff5974'),
('854c3593-4f38-44be-8336-62d66bee956b', '1d735be6-31e6-4af4-b30c-79a98931c00d'),
('854c3593-4f38-44be-8336-62d66bee956b', '3d40902e-4d45-47b6-8308-ca148174a19f'),
('854c3593-4f38-44be-8336-62d66bee956b', '4557393a-92d5-4484-9719-b306c309f342'),
('854c3593-4f38-44be-8336-62d66bee956b', '4ba9de05-9bdf-47a1-a18a-5d355ab57a6b'),
('854c3593-4f38-44be-8336-62d66bee956b', '58e350ee-a0ba-4527-8cda-0b639bd24790'),
('854c3593-4f38-44be-8336-62d66bee956b', '72428d39-93a1-46eb-b06d-9ef530598f6d'),
('854c3593-4f38-44be-8336-62d66bee956b', '8197b0af-75e2-4b27-ba77-450c9451ad2b'),
('854c3593-4f38-44be-8336-62d66bee956b', 'b30fe8b9-1d63-4597-8081-052107357647'),
('854c3593-4f38-44be-8336-62d66bee956b', 'e7945332-75b2-4016-a5cf-96b3e4c3f8d2'),
('87d161e1-ec62-4d74-8ca4-d576b3a4a21c', '0f8b127d-5c94-49f9-8226-3c36200ea09a'),
('87d161e1-ec62-4d74-8ca4-d576b3a4a21c', '505d961d-9939-40d0-9a64-f7f8657a05b8'),
('87d161e1-ec62-4d74-8ca4-d576b3a4a21c', '7048534a-cf9f-4dd3-9e2e-9d8b2966cedc'),
('87d161e1-ec62-4d74-8ca4-d576b3a4a21c', '86f0df21-daee-4725-9bb7-0b09baff201e'),
('87d161e1-ec62-4d74-8ca4-d576b3a4a21c', '879d31d0-f7a8-4c7e-901e-aa3e40910459'),
('87d161e1-ec62-4d74-8ca4-d576b3a4a21c', '87faedb3-d330-44d3-b830-5559f123a6ca'),
('87d161e1-ec62-4d74-8ca4-d576b3a4a21c', '89dfc2c4-5e33-401c-a499-979d99388c40'),
('87d161e1-ec62-4d74-8ca4-d576b3a4a21c', 'add2ad43-96c3-4c46-9cfb-c11e405e0335'),
('87d161e1-ec62-4d74-8ca4-d576b3a4a21c', 'b1f92536-0a99-45ed-8891-30169466f8a5'),
('87d161e1-ec62-4d74-8ca4-d576b3a4a21c', 'c8944fb1-c5c0-4561-a626-0f71cfafe0c1'),
('93d8913f-9e51-4052-a201-5c317aa8f46a', '09e4ce23-1a50-458e-b3c4-d6050822c2be'),
('93d8913f-9e51-4052-a201-5c317aa8f46a', '105d7a5e-3054-41bb-adc2-dfd4e4238d81'),
('93d8913f-9e51-4052-a201-5c317aa8f46a', '39305728-eb14-447c-b3c0-db52f8a4cbe7'),
('93d8913f-9e51-4052-a201-5c317aa8f46a', '6319c7da-3a77-41fa-b6b9-d8d8f8bab509'),
('93d8913f-9e51-4052-a201-5c317aa8f46a', '70e23d8a-551c-40c7-a06f-bb428ec264ef'),
('93d8913f-9e51-4052-a201-5c317aa8f46a', '8397b4f9-eefd-47f0-8017-045b7a332acb'),
('93d8913f-9e51-4052-a201-5c317aa8f46a', '987f9e91-7a9a-4e48-9779-b7646447fda7'),
('93d8913f-9e51-4052-a201-5c317aa8f46a', 'aa09df50-3a78-460d-a720-9692ed5e016c'),
('93d8913f-9e51-4052-a201-5c317aa8f46a', 'd3331ec0-8c91-4907-b481-2c214b535612'),
('93d8913f-9e51-4052-a201-5c317aa8f46a', 'ed1fcd2a-32bb-455f-88f5-26ed1d3406ff'),
('a7b56a6f-98c5-4ee8-af1f-ecc71a18f38d', '0e1aa2be-331f-4d98-9b1b-84c436107936'),
('a7b56a6f-98c5-4ee8-af1f-ecc71a18f38d', '3a6a3060-2cf4-4614-bceb-3adb6085a9e8'),
('a7b56a6f-98c5-4ee8-af1f-ecc71a18f38d', '508eecf1-e9e3-49f0-93e2-92973bf368a6'),
('a7b56a6f-98c5-4ee8-af1f-ecc71a18f38d', '83d194f9-591a-4d20-ab72-0a9f284263c5'),
('a7b56a6f-98c5-4ee8-af1f-ecc71a18f38d', '9063c1a4-d8a6-4fe1-af04-7241cdea6cf5'),
('a7b56a6f-98c5-4ee8-af1f-ecc71a18f38d', '9c338a6e-6b17-4dad-b552-4d5efda55368'),
('a7b56a6f-98c5-4ee8-af1f-ecc71a18f38d', 'a6a78c06-9814-41ed-93f4-aa635b8a3d1a'),
('a7b56a6f-98c5-4ee8-af1f-ecc71a18f38d', 'bc6ea416-a441-4e35-813c-85fd7a2dac71'),
('a7b56a6f-98c5-4ee8-af1f-ecc71a18f38d', 'eba1b141-b7b6-4e4c-8239-37aa00a6413d'),
('a7b56a6f-98c5-4ee8-af1f-ecc71a18f38d', 'fb63c857-340d-463f-bf0a-6d4cdbdd09d9'),
('ad2b3982-1bcc-47e8-96c1-dcf38e3242fc', '2e38e229-29a1-4a73-822c-4321102089a2'),
('ad2b3982-1bcc-47e8-96c1-dcf38e3242fc', '41b6d1db-424c-4be2-a54b-33eed7d3a814'),
('ad2b3982-1bcc-47e8-96c1-dcf38e3242fc', '50263b11-bf93-4ee4-8d44-48934415554c'),
('ad2b3982-1bcc-47e8-96c1-dcf38e3242fc', '6ffc455b-666d-4a7d-b2b7-554fa0dd95ce'),
('ad2b3982-1bcc-47e8-96c1-dcf38e3242fc', '80d7e8e0-6dad-4f4c-9994-3ad35a16397f'),
('ad2b3982-1bcc-47e8-96c1-dcf38e3242fc', '90c13d14-4e15-4c3c-bab6-bae4c7097473'),
('ad2b3982-1bcc-47e8-96c1-dcf38e3242fc', '9f8d50a3-0b0c-4cd5-9b77-66f44c0d211f'),
('ad2b3982-1bcc-47e8-96c1-dcf38e3242fc', 'd675b3df-a69d-4653-b235-848da9f67aa3'),
('ad2b3982-1bcc-47e8-96c1-dcf38e3242fc', 'e1830bd4-ed45-4b44-86b5-aa763c63967b'),
('ad2b3982-1bcc-47e8-96c1-dcf38e3242fc', 'fb60f63b-3d26-48d9-8ca7-c5aa2379104b'),
('b2f7f273-823b-49be-a148-f7764f3d5b8c', '0739beac-8346-41ba-93fb-2eb819a6ad6a'),
('b2f7f273-823b-49be-a148-f7764f3d5b8c', '136dd3f9-7835-4e72-9ae2-23fc1bdd8ea5'),
('b2f7f273-823b-49be-a148-f7764f3d5b8c', '1da67aa7-1095-454d-ad39-6bbb07c05548'),
('b2f7f273-823b-49be-a148-f7764f3d5b8c', '24f832fd-f34d-4034-bbf9-6071601913de'),
('b2f7f273-823b-49be-a148-f7764f3d5b8c', '54c66b9b-d4b7-46a8-85fc-9e99764d8694'),
('b2f7f273-823b-49be-a148-f7764f3d5b8c', '64fe16d6-e551-465d-817d-34c46ee4b650'),
('b2f7f273-823b-49be-a148-f7764f3d5b8c', '7482bfff-cdfa-46a8-933a-a1898f8f1fa8'),
('b2f7f273-823b-49be-a148-f7764f3d5b8c', 'caabc81e-0347-4b22-a22b-6081bb72ef65'),
('b2f7f273-823b-49be-a148-f7764f3d5b8c', 'ebee1a14-8b30-4c1c-91b7-02fdc818a014'),
('b2f7f273-823b-49be-a148-f7764f3d5b8c', 'f3b4eebe-c27f-4320-86f4-26b3861e390c'),
('bf8862ab-3bfe-42bd-805b-613a5537fdce', '04130bc2-37bc-4a61-87e5-49906bacb371'),
('bf8862ab-3bfe-42bd-805b-613a5537fdce', '0f95f15a-7501-4cb4-bc80-802347d3247d'),
('bf8862ab-3bfe-42bd-805b-613a5537fdce', '145b763f-106e-449d-8022-87b70b519579'),
('bf8862ab-3bfe-42bd-805b-613a5537fdce', '14b3f351-4436-4819-bbae-4f63ece1a2ec'),
('bf8862ab-3bfe-42bd-805b-613a5537fdce', '479a3c74-f455-4dda-a59e-4414b9931054'),
('bf8862ab-3bfe-42bd-805b-613a5537fdce', '7e8000ac-a099-47e7-ba70-1a1135171395'),
('bf8862ab-3bfe-42bd-805b-613a5537fdce', '93cf8a1e-2b74-486f-8f3d-17eb920c8f0b'),
('bf8862ab-3bfe-42bd-805b-613a5537fdce', '9c3efb63-c5a7-4db0-8e5e-dff30f11af6e'),
('bf8862ab-3bfe-42bd-805b-613a5537fdce', 'a674e4b9-cc55-4d65-a9b8-4e9af4ee2ab9'),
('bf8862ab-3bfe-42bd-805b-613a5537fdce', 'ab121b59-c276-481a-a759-ad1d790d512e'),
('c03c6d85-175d-481d-aea5-419e408b7e03', '0f3473c4-5f39-4385-9d78-427ac0e6a89a'),
('c03c6d85-175d-481d-aea5-419e408b7e03', '0f841b1b-66a3-4c14-bd26-05920c178c3a'),
('c03c6d85-175d-481d-aea5-419e408b7e03', '387af58c-7f09-4242-9297-e8d3f24579c6'),
('c03c6d85-175d-481d-aea5-419e408b7e03', '5fd35b35-5443-445f-b148-38f9aa0ade9e'),
('c03c6d85-175d-481d-aea5-419e408b7e03', '76677b9f-69da-4685-923d-2d3807bd9dbd'),
('c03c6d85-175d-481d-aea5-419e408b7e03', '769ec639-2c58-4457-a81a-8b0f43daef38'),
('c03c6d85-175d-481d-aea5-419e408b7e03', 'ce715ef6-6d3c-4547-97f8-b66c14ec9cd0'),
('c03c6d85-175d-481d-aea5-419e408b7e03', 'd84fac9c-cf70-4fb3-afae-5e18cfe348fe'),
('c03c6d85-175d-481d-aea5-419e408b7e03', 'e4352461-cf52-4cc9-8b3f-baab4a1cb478'),
('c03c6d85-175d-481d-aea5-419e408b7e03', 'fdf4281b-b029-4c5d-ba16-5861a928411e'),
('c140e128-4049-4967-8aee-7f53a1ca8672', '17f362ce-cbaf-4d26-9eaf-19a8698030b9'),
('c140e128-4049-4967-8aee-7f53a1ca8672', '20942236-5377-44bf-af6a-c86413d41e6d'),
('c140e128-4049-4967-8aee-7f53a1ca8672', '492c697b-6c38-485c-a6c1-fa870324e425'),
('c140e128-4049-4967-8aee-7f53a1ca8672', '622c604b-ea21-457a-b2b1-b4f75d078f24'),
('c140e128-4049-4967-8aee-7f53a1ca8672', '7142784c-3dbf-4e5e-b999-6755ef2d6f2e'),
('c140e128-4049-4967-8aee-7f53a1ca8672', '7f722122-0e38-4ea4-8926-13f69afd599a'),
('c140e128-4049-4967-8aee-7f53a1ca8672', '7fdd59cf-53a9-4066-8440-f3cf2cad7a72'),
('c140e128-4049-4967-8aee-7f53a1ca8672', '8f9fdc81-f8d3-4f77-bdbe-f4c993e15e7a'),
('c140e128-4049-4967-8aee-7f53a1ca8672', '9abc4f40-9b97-4e71-9872-07a7956f8b48'),
('c140e128-4049-4967-8aee-7f53a1ca8672', 'eb1c7380-cae0-4830-8815-c7f0eb6539f7'),
('c4e6b734-88e1-446e-8940-e228ea5d46e9', '0bf96011-db26-4534-a360-411f9e8174ed'),
('c4e6b734-88e1-446e-8940-e228ea5d46e9', '3d771fe7-61f2-46ea-97fc-9c8076ed46ed'),
('c4e6b734-88e1-446e-8940-e228ea5d46e9', '3e05cd16-ff6f-459a-92b2-c48d9c169793'),
('c4e6b734-88e1-446e-8940-e228ea5d46e9', '6f13fc16-fbd3-41c8-aea4-5b2a56a060c7'),
('c4e6b734-88e1-446e-8940-e228ea5d46e9', '96f97c93-3de2-48f6-a0a9-827b85bff44c'),
('c4e6b734-88e1-446e-8940-e228ea5d46e9', 'bf8f6c08-1b0f-470c-b4c5-f8669a4a635c'),
('c4e6b734-88e1-446e-8940-e228ea5d46e9', 'c0ff85ab-2b80-4d51-a9ca-68dfbf8d0dc6'),
('c4e6b734-88e1-446e-8940-e228ea5d46e9', 'ca19a6bc-3259-4ec2-9497-b57f389c3e3a'),
('c4e6b734-88e1-446e-8940-e228ea5d46e9', 'f267c50f-7154-45d2-85fb-e7d4e62e9fe5'),
('c4e6b734-88e1-446e-8940-e228ea5d46e9', 'fe7b84ed-5b81-42fb-9ef9-b2ea254d5abc'),
('c9c85c2c-9745-44e5-8e7a-97b222ed5779', '2b9f2c20-6ac3-4c9f-998b-acbf10acf513'),
('c9c85c2c-9745-44e5-8e7a-97b222ed5779', '2dce2e2f-6099-4c08-9044-911be6a36b2e'),
('c9c85c2c-9745-44e5-8e7a-97b222ed5779', '34332d8c-c7ec-41c0-b4a5-9cc52e0110ad'),
('c9c85c2c-9745-44e5-8e7a-97b222ed5779', '3ea13ba3-22f3-4d2f-966c-ad04937002d6'),
('c9c85c2c-9745-44e5-8e7a-97b222ed5779', '45291676-7001-4df6-80fd-5d5e7780faa1'),
('c9c85c2c-9745-44e5-8e7a-97b222ed5779', '572183bc-0f12-449b-a9ca-7e0457adf7ff'),
('c9c85c2c-9745-44e5-8e7a-97b222ed5779', '726f6e6c-eaf9-41cd-b83f-51f070a7beda'),
('c9c85c2c-9745-44e5-8e7a-97b222ed5779', '82468973-7b37-42e8-9ece-3d391c923961'),
('c9c85c2c-9745-44e5-8e7a-97b222ed5779', '904a1a72-3839-4288-9b2c-955e7e87f8b8'),
('c9c85c2c-9745-44e5-8e7a-97b222ed5779', 'b3ae4036-f134-46e4-8ef4-615648428a8b'),
('c9cce62e-d2b1-4ea2-8428-45f96e76938f', '43f7b0cf-38eb-438a-9159-101b82000cd6'),
('c9cce62e-d2b1-4ea2-8428-45f96e76938f', '55cfd7be-7d01-4878-aa01-2fd8c8675317'),
('c9cce62e-d2b1-4ea2-8428-45f96e76938f', '839cb493-d7cf-4307-81f0-9fc4becf3128'),
('c9cce62e-d2b1-4ea2-8428-45f96e76938f', 'a6a878c0-1460-4f25-aa21-4f11e5f15e6d'),
('c9cce62e-d2b1-4ea2-8428-45f96e76938f', 'b2678898-b0ea-44ab-a58f-0cb978411a12'),
('c9cce62e-d2b1-4ea2-8428-45f96e76938f', 'c024f056-eadb-494c-8609-630cca539b84'),
('c9cce62e-d2b1-4ea2-8428-45f96e76938f', 'ca0f9c97-6574-4945-b1c1-25f77d028297'),
('c9cce62e-d2b1-4ea2-8428-45f96e76938f', 'dcf45d42-aa2d-4989-ae94-c6b9f5953633'),
('c9cce62e-d2b1-4ea2-8428-45f96e76938f', 'e09639ce-3d27-489e-bded-7880f25fe605'),
('c9cce62e-d2b1-4ea2-8428-45f96e76938f', 'e5de1b6d-4b0a-4138-853c-b641b42c0633'),
('da9fb269-f189-4d84-88b4-1bb2926e0705', '9c338a6e-6b17-4dad-b552-4d5efda55368'),
('da9fb269-f189-4d84-88b4-1bb2926e0705', 'bc6ea416-a441-4e35-813c-85fd7a2dac71'),
('da9fb269-f189-4d84-88b4-1bb2926e0705', 'eba1b141-b7b6-4e4c-8239-37aa00a6413d'),
('dd364720-5487-4148-940a-792c71cfe5e1', '04e5fa47-3fb1-49dc-a438-98ed2f70e6d0'),
('dd364720-5487-4148-940a-792c71cfe5e1', '062b6143-384b-431e-8300-96d30790fdd1'),
('dd364720-5487-4148-940a-792c71cfe5e1', '56ae7f75-cc58-417d-9c74-e9736f6203aa'),
('dd364720-5487-4148-940a-792c71cfe5e1', 'a45e05d4-6c6d-478d-88a3-1b3d1b18af3b'),
('dd364720-5487-4148-940a-792c71cfe5e1', 'b3e8500e-9eb7-44d6-9346-1b2a11143ac1'),
('dd364720-5487-4148-940a-792c71cfe5e1', 'bdf8d0b3-087b-4fb8-a2cb-b01b2babcb73'),
('dd364720-5487-4148-940a-792c71cfe5e1', 'be0d7f85-bd48-4b49-91c9-43881f5e9846'),
('dd364720-5487-4148-940a-792c71cfe5e1', 'dc73157b-d61f-4a4c-8a98-8d7858a9ca9c'),
('dd364720-5487-4148-940a-792c71cfe5e1', 'e292162f-5c54-4e4c-b593-7ca3f044d574'),
('dd364720-5487-4148-940a-792c71cfe5e1', 'e8310da3-b625-4132-87c7-fc6012841f95'),
('f215a15e-ac3d-4bf0-b7ff-cb6a989f3f83', '07068e97-a720-4faf-bb36-95baab358c22'),
('f215a15e-ac3d-4bf0-b7ff-cb6a989f3f83', '3bed7e35-207c-4ce8-ba84-01511bb04482'),
('f215a15e-ac3d-4bf0-b7ff-cb6a989f3f83', '5b27da4d-7309-4c5a-8cc9-3c14faf0420a'),
('f215a15e-ac3d-4bf0-b7ff-cb6a989f3f83', '6c5739c4-f9c6-475d-be47-504d2186c185'),
('f215a15e-ac3d-4bf0-b7ff-cb6a989f3f83', '89c40575-250c-4789-b7da-830e30f1fc2f'),
('f215a15e-ac3d-4bf0-b7ff-cb6a989f3f83', '8a199a5a-bb36-49d2-a5ca-2689f5bc1ad2'),
('f215a15e-ac3d-4bf0-b7ff-cb6a989f3f83', 'ac5a28ad-3ee3-49df-bb03-5f48d030550c'),
('f215a15e-ac3d-4bf0-b7ff-cb6a989f3f83', 'acb793f8-ffbf-4a06-a556-3755ca37e284'),
('f215a15e-ac3d-4bf0-b7ff-cb6a989f3f83', 'cdcd3638-c724-446d-b313-eb7daceab8cc'),
('f215a15e-ac3d-4bf0-b7ff-cb6a989f3f83', 'ea84f23b-a4ad-4ac3-9437-bc4ccc3db7a5'),
('f3de8168-b769-4588-8b80-f4790712e72b', '0421a928-28db-42a1-a3ea-d8dc6a6e1be6'),
('f3de8168-b769-4588-8b80-f4790712e72b', '124d772a-58a0-4c9d-9027-55c82b018900'),
('f3de8168-b769-4588-8b80-f4790712e72b', '3b0d4e86-8199-470d-b2e7-d45562ed7a3d'),
('f3de8168-b769-4588-8b80-f4790712e72b', '48c88db7-8594-485b-86f4-582a8b4607c7'),
('f3de8168-b769-4588-8b80-f4790712e72b', '6d2a9bd7-dbb7-4c50-aa5e-5ed9a77f2772'),
('f3de8168-b769-4588-8b80-f4790712e72b', '7c893639-7b2f-44f7-ace2-83d4a9a3de5f'),
('f3de8168-b769-4588-8b80-f4790712e72b', 'd20a11ad-2c26-4d34-998c-4e12b3e26b8e'),
('f3de8168-b769-4588-8b80-f4790712e72b', 'efed27ec-1edd-4d4d-b409-0e2733af8d4a'),
('f3de8168-b769-4588-8b80-f4790712e72b', 'f627b83d-0155-4db3-ac1e-fc737acda583'),
('f3de8168-b769-4588-8b80-f4790712e72b', 'fc690b2c-f8b0-447f-8e4a-f3f703180fab');

-- --------------------------------------------------------

--
-- Table structure for table `levels`
--

CREATE TABLE `levels` (
  `name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `sequence` int(11) DEFAULT NULL,
  `is_published` tinyint(1) DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `levels`
--

INSERT INTO `levels` (`name`, `description`, `sequence`, `is_published`, `id`, `created_at`, `updated_at`) VALUES
('Lvl dd59dae6', NULL, 0, 1, '00f7fae2-e1d5-47c7-8066-35829ac4fb98', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('N5 Mock Level b99a2c7f-edf7-4ae1-991c-06e8cdedf3b6', NULL, 0, 0, '028863f4-d9ee-42d4-bbf7-f8dc2bd37e6a', '2026-07-11 04:13:18', '2026-07-11 04:13:18'),
('Lvl 500962e4', NULL, 0, 1, '03bf0661-a230-4d8f-9d30-9dc80d31fa26', '2026-07-10 16:07:53', '2026-07-10 16:07:53'),
('Lvl 9429a98b', NULL, 0, 1, '069a20ce-8935-42df-8823-72d308ec26c3', '2026-07-10 16:23:50', '2026-07-10 16:23:50'),
('Lvl 64c31099', NULL, 0, 1, '0783751c-03cb-42f4-86e5-35821fc21212', '2026-07-11 04:40:22', '2026-07-11 04:40:22'),
('N5 Mock Level 93ed0dec-def3-4f1d-acfa-32976cd7cad4', NULL, 0, 0, '085b731d-e20d-4069-9329-66202b442f23', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('N5_deeb0696-42d1-4998-bf22-a8d777e63e52', NULL, 0, 1, '0930e164-6465-4e87-95dc-fcf72b4a7a9a', '2026-07-11 03:33:03', '2026-07-11 03:33:03'),
('Lvl 1cc31eed', NULL, 0, 1, '09bc81e6-9bec-490e-b09e-1f87494a5511', '2026-07-10 16:07:53', '2026-07-10 16:07:53'),
('Lvl b1de869d', NULL, 0, 1, '0cb66df1-2ae2-42cf-b37b-400f9cab8279', '2026-07-10 16:06:22', '2026-07-10 16:06:22'),
('N5 Mock Level d891dafc-022b-483b-803f-b6c2479cde45', NULL, 0, 0, '11fdb47c-ea79-47e7-995f-dda8adb5df3a', '2026-07-11 04:14:55', '2026-07-11 04:14:55'),
('N5 Mock Level 85612218-0ffe-4fde-8f07-ad00b7287792', NULL, 0, 0, '174b27a4-9c71-4db0-b189-e63ea6fd10b8', '2026-07-11 04:14:10', '2026-07-11 04:14:10'),
('Lvl 02f101df', NULL, 0, 1, '1aaec7d7-d384-42cd-8d37-88954519391f', '2026-07-10 16:02:47', '2026-07-10 16:02:47'),
('Pub Level 9b05d360', NULL, 1, 1, '2003c5f5-039e-454f-a472-b631c7e359f6', '2026-07-10 15:26:56', '2026-07-10 15:26:56'),
('N5_751e71e1-c465-4e20-9adb-c6ded967dd93', NULL, 0, 1, '213492d1-007e-47af-b4ea-1b243b9a87ca', '2026-07-11 03:32:51', '2026-07-11 03:32:51'),
('Lvl fafd9fad', NULL, 0, 1, '23090b07-40d9-46be-8abd-157ef051eafe', '2026-07-10 16:04:53', '2026-07-10 16:04:53'),
('Unpub Level 17b54d99', NULL, 2, 0, '23efe1a3-44f9-43d3-b871-0d108637c8c1', '2026-07-10 15:25:57', '2026-07-10 15:25:57'),
('N5 Mock Level 55880cbc-707c-42a5-8501-71458be17cad', NULL, 0, 0, '2d08b69f-6f34-49ec-a99a-208375f31068', '2026-07-11 04:16:50', '2026-07-11 04:16:50'),
('Lvl 30931442', NULL, 0, 1, '30c7f364-c3ae-4987-9785-8711d88cd953', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('Lvl 7a25ed3c', NULL, 0, 1, '383f838e-c8e1-4aa9-b5a9-7a3f777781be', '2026-07-10 15:34:14', '2026-07-10 15:34:14'),
('N5 Mock Level 667132f1-0a5f-4cf9-8e61-9dd8baa2c76d', NULL, 0, 0, '3b124b34-4dbc-4b64-a714-2917d00ec13d', '2026-07-11 04:40:22', '2026-07-11 04:40:22'),
('Unpub Level 45d3efd7', NULL, 2, 0, '3b155ebc-cd60-49d0-965a-cab0d0386f5f', '2026-07-10 15:26:56', '2026-07-10 15:26:56'),
('Test Level 10c8a22a', NULL, 10, 1, '3b7765db-a8ca-4d24-9066-dfb6e8646f6c', '2026-07-10 15:26:44', '2026-07-10 15:26:44'),
('N5 Mock Level e1927ca9-368e-4199-81cf-d898f1e490a8', NULL, 0, 0, '40f5d42c-f7c4-4b2d-916c-7627a8640398', '2026-07-11 04:16:50', '2026-07-11 04:16:50'),
('Level for Lesson 86b2abc5', NULL, 0, 1, '42640ce5-b060-426a-862a-72e972a20f82', '2026-07-11 04:40:20', '2026-07-11 04:40:20'),
('N5 Mock Level 87d06b64-2eee-4c96-b14a-1c7c9e63cd94', NULL, 0, 0, '453d4ba6-f27a-4c8a-a489-e91afb86b56e', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('Lvl b7a2c034', NULL, 0, 1, '47b4571b-72f8-431c-9f53-84e6520abb81', '2026-07-10 16:15:48', '2026-07-10 16:15:48'),
('Lvl 6842ccd6', NULL, 0, 1, '48322786-df8a-4aa7-a338-0535ae47517e', '2026-07-10 16:09:49', '2026-07-10 16:09:49'),
('Unpub Level ccfc514d', NULL, 2, 0, '49000224-b09d-45de-af11-83fcd435d2bb', '2026-07-10 15:26:44', '2026-07-10 15:26:44'),
('N5 Mock Level d85c8d41-5d9b-4675-92f4-41b8bc8f53ab', NULL, 0, 0, '4a7be1bd-e24b-48d1-a405-61b645fe67c3', '2026-07-11 04:17:05', '2026-07-11 04:17:05'),
('Lvl ff8bf2d9', NULL, 0, 1, '4dcbddf9-360f-4074-aa3a-68c06d2a09aa', '2026-07-10 16:20:00', '2026-07-10 16:20:00'),
('N5_c8fc684c-81ee-4fa0-bf56-0d36c2d683ea', NULL, 0, 1, '4ebb51dd-43da-4541-99a7-f1453c88f4b3', '2026-07-11 04:40:22', '2026-07-11 04:40:22'),
('Test Level 0fbc788e', NULL, 10, 1, '4fdcde08-d949-4432-90e2-7975aa604ea8', '2026-07-11 04:40:20', '2026-07-11 04:40:20'),
('Lvl 93612539', NULL, 0, 1, '5380e404-81cd-4ab2-8b2c-b4ca19228c5e', '2026-07-10 16:14:03', '2026-07-10 16:14:03'),
('Test Level ea30096e', NULL, 10, 1, '53ee6c7d-ef57-4f9a-9788-6018b5bdc4a6', '2026-07-11 04:22:40', '2026-07-11 04:22:40'),
('Lvl b1d7af69', NULL, 0, 1, '57b9e599-eb6e-4a82-a9fa-26bd86942c01', '2026-07-10 16:14:03', '2026-07-10 16:14:03'),
('Lvl 47260cb9', NULL, 0, 1, '592a4200-76d2-430a-b46d-93f5aa6ac6ac', '2026-07-10 16:09:49', '2026-07-10 16:09:49'),
('Unpub Level 11eea44d', NULL, 2, 0, '5e21d7d4-f417-4119-95e3-3f253a20bf3d', '2026-07-10 15:26:00', '2026-07-10 15:26:00'),
('Test Level d89073f7', NULL, 10, 1, '601e2ad5-b6de-4d95-8035-9b99a9a3ac38', '2026-07-10 15:26:00', '2026-07-10 15:26:00'),
('Lvl d9de2c84', NULL, 0, 1, '63e4c59d-120f-4021-b284-0dfd65c10e43', '2026-07-10 16:21:02', '2026-07-10 16:21:02'),
('Level for Lesson 2bbdfd7a', NULL, 0, 1, '6410c191-4c63-4b1a-936c-7a3eb9e2b022', '2026-07-10 15:26:00', '2026-07-10 15:26:00'),
('Lvl 2de7ca33', NULL, 0, 1, '644d830f-00e3-4d98-a32a-e50f35b5ef9d', '2026-07-10 16:23:43', '2026-07-10 16:23:43'),
('N5_1924a52e-f42a-48ec-b5b8-3331d6928404', NULL, 0, 1, '665a172d-1a1f-4f26-aed6-578cfde1f45d', '2026-07-11 03:32:01', '2026-07-11 03:32:01'),
('Pub Level', NULL, 1, 1, '693d0b5e-61db-44e0-b994-694251caf9d3', '2026-07-10 15:18:32', '2026-07-10 15:18:32'),
('Level for Lesson', NULL, 0, 1, '6bdd915d-22c8-4811-8297-39606b01626c', '2026-07-10 15:18:32', '2026-07-10 15:18:32'),
('Lvl 1bfa5492', NULL, 0, 1, '73fce9af-8df6-4607-a0d1-0ef8c16f6f34', '2026-07-10 16:03:04', '2026-07-10 16:03:04'),
('N5 Mock Level 4fefa2fd-2ea8-4f2f-b145-a9bc305489de', NULL, 0, 0, '75bd201e-5fc9-4fb8-acbd-434c94e3aac3', '2026-07-11 04:17:24', '2026-07-11 04:17:24'),
('Lvl 17c61839', NULL, 0, 1, '762a6143-ba98-4b49-8539-bd94e8e1d9fd', '2026-07-10 15:35:34', '2026-07-10 15:35:34'),
('Lvl 451b4acf', NULL, 0, 1, '7df7b11d-79a2-461b-b9c0-fd0ecc3a20ea', '2026-07-10 15:38:11', '2026-07-10 15:38:11'),
('N5 Mock Level d66270e7-9d00-40e1-aeb7-603977235d82', NULL, 0, 0, '7eb6b233-853b-4186-8bb8-08148a8fad09', '2026-07-11 04:13:10', '2026-07-11 04:13:10'),
('N5 Mock Level 2278e686-e76a-4a79-940a-1a1c93a59144', NULL, 0, 0, '85bcf6e7-46e9-46a9-a15b-d4219ed143bc', '2026-07-11 04:14:04', '2026-07-11 04:14:04'),
('Lvl 684d6b37', NULL, 0, 1, '87df419a-7875-4ddc-904e-bc83a88773fa', '2026-07-10 16:09:32', '2026-07-10 16:09:32'),
('Lvl c3139443', NULL, 0, 1, '884e2273-f8a9-4a99-bbde-688f571716e3', '2026-07-10 16:04:37', '2026-07-10 16:04:37'),
('Unpub Level 67e88332', NULL, 2, 0, '88d1d66b-6ee3-409e-83f2-12f5426443fc', '2026-07-11 04:40:20', '2026-07-11 04:40:20'),
('Lvl d3d3ea07', NULL, 0, 1, '8eba4334-b5f6-4bf3-8080-71277f7f400c', '2026-07-10 16:20:00', '2026-07-10 16:20:00'),
('Lvl 7efe1b47', NULL, 0, 1, '90410de0-d536-4ca8-aebb-1c0b21f40d21', '2026-07-10 16:04:54', '2026-07-10 16:04:54'),
('N5 Mock Level b70be024-5818-4e3c-80bd-b13765e16a93', NULL, 0, 0, '9156e92d-09fa-49d9-99eb-827d2bf5737d', '2026-07-11 04:17:24', '2026-07-11 04:17:24'),
('Test Level', NULL, 10, 1, '9293df60-58ea-44ed-b20e-faa3704e7b5e', '2026-07-10 15:22:30', '2026-07-10 15:22:30'),
('Level for Lesson a1460fa5', NULL, 0, 1, '94481ba8-b57a-45bb-b096-dc27863dd5cc', '2026-07-10 15:25:57', '2026-07-10 15:25:57'),
('Lvl ecaf8ab1', NULL, 0, 1, '95c587ea-ff7d-46c4-86a9-4352dc1d54d6', '2026-07-10 16:09:32', '2026-07-10 16:09:32'),
('Lvl 7d231ad9', NULL, 0, 1, '965638e7-0392-4b87-9e58-61200e43fbee', '2026-07-10 16:04:36', '2026-07-10 16:04:36'),
('N5 Mock Level fa0083d6-d8f6-4c60-8ce7-e84d91a09a1d', NULL, 0, 0, '98b2370c-0ca9-406c-8039-32edcb3a7f2a', '2026-07-11 04:14:04', '2026-07-11 04:14:04'),
('Unpub Level f935da49', NULL, 2, 0, '994768a2-c80b-486f-bc63-eccd230c7810', '2026-07-11 04:22:40', '2026-07-11 04:22:40'),
('N5_12dbb3f3-f31f-4ea8-82e0-7a002de1e380', NULL, 0, 1, '9f255d3a-3b32-495f-aa06-61cf6c682c2d', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('Lvl e9dee7fc', NULL, 0, 1, 'a341d931-58dc-442b-8ea4-c822ab3caca0', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('N5 Mock Level 237789d4-d884-43a0-9066-7280b0d2b308', NULL, 0, 0, 'aaeeb9f0-8571-4944-bcbe-12a21b9f482a', '2026-07-11 04:15:52', '2026-07-11 04:15:52'),
('Lvl 9b8fcbd2', NULL, 0, 1, 'abe4588f-ccb8-442f-97c6-e50535dcbc83', '2026-07-10 16:06:38', '2026-07-10 16:06:38'),
('Lvl 639d1718', NULL, 0, 1, 'adf27a43-8326-49bc-bdfb-d02979230305', '2026-07-11 04:40:21', '2026-07-11 04:40:21'),
('N5 Mock Level 87580ae9-8f61-4a52-8847-3212e2cef233', NULL, 0, 0, 'ae5510f9-c018-4955-9402-16a6301e944a', '2026-07-11 04:13:18', '2026-07-11 04:13:18'),
('N5 Mock Level 794b01b8-ccdb-43f9-9d08-0cad59ee0286', NULL, 0, 0, 'b0181098-acf3-4457-acc1-eda3cae65d0b', '2026-07-11 04:16:03', '2026-07-11 04:16:03'),
('N5 Mock Level 9880e849-6c16-4bd5-8583-6a6951cdfdc1', NULL, 0, 0, 'b13c52dd-5c57-4682-a131-e689bc39f9fb', '2026-07-11 04:19:23', '2026-07-11 04:19:23'),
('Lvl dc7195e6', NULL, 0, 1, 'b2992808-885b-4a7e-8517-de549b863225', '2026-07-11 04:40:21', '2026-07-11 04:40:21'),
('Lvl c8b954fe', NULL, 0, 1, 'b2e1dcd6-6449-4179-b725-65b7b4ab48d3', '2026-07-11 04:40:21', '2026-07-11 04:40:21'),
('Pub Level 2f34824c', NULL, 1, 1, 'b329782c-dc9f-4814-8464-72828132121b', '2026-07-11 04:40:20', '2026-07-11 04:40:20'),
('N5 Mock Level fcd86e6f-7c14-4ed5-9c3b-8e02b1654796', NULL, 0, 0, 'b4b071c8-63b3-4c2e-9d14-0e1821572e3a', '2026-07-11 04:17:04', '2026-07-11 04:17:04'),
('N5 Mock Level 296d77f5-4e8b-4ce2-85cb-8741cde6ce0d', NULL, 0, 0, 'b6041550-4ec5-4f32-b795-5752c33deb82', '2026-07-11 04:14:56', '2026-07-11 04:14:56'),
('Lvl 66856ca9', NULL, 0, 1, 'b76ebcb8-8f66-49ad-afcc-604427e57f21', '2026-07-10 16:06:37', '2026-07-10 16:06:37'),
('Lvl 59f28150', NULL, 0, 1, 'b9d70a62-39c7-48f8-abc6-2ec5b2ea62b7', '2026-07-10 15:54:01', '2026-07-10 15:54:01'),
('Lvl e373ed8c', NULL, 0, 1, 'b9dd728d-c0b8-4aff-8fc3-e7221d872dd7', '2026-07-10 15:37:13', '2026-07-10 15:37:13'),
('N5_86bdc4ce-b9ee-4181-bbfd-5ce31ddb8709', NULL, 0, 1, 'bcff2196-6796-432a-a537-29862c59988b', '2026-07-11 03:32:12', '2026-07-11 03:32:12'),
('JLPT N5', 'Beginner Japanese', 1, 1, 'bd8a19d1-9712-4e3c-b263-32a6ca600539', '2026-07-10 15:13:34', '2026-07-10 15:13:34'),
('Lvl a095253f', NULL, 0, 1, 'bf0b652c-9156-4ab8-a2b4-7ef9a61ba597', '2026-07-10 16:16:06', '2026-07-10 16:16:06'),
('Unpub Level', NULL, 2, 0, 'c040c98f-8a92-4088-a6ba-6f2268779324', '2026-07-10 15:18:32', '2026-07-10 15:18:32'),
('Lvl bc654055', NULL, 0, 1, 'c099ea8d-4e1e-4c25-91c0-82fcd7c3290c', '2026-07-10 16:21:03', '2026-07-10 16:21:03'),
('Pub Level 2b3b7338', NULL, 1, 1, 'c1c98cf7-164b-4ad6-b4e7-c3b2e593a359', '2026-07-10 15:26:00', '2026-07-10 15:26:00'),
('Test Level 20c6dc0e', NULL, 10, 1, 'c51c82ef-08ea-420e-a6ad-92e736cc5e9c', '2026-07-10 15:26:56', '2026-07-10 15:26:56'),
('Lvl e027fef0', NULL, 0, 1, 'c9deaa75-1a98-42dc-af15-dad6ec16df49', '2026-07-10 16:02:48', '2026-07-10 16:02:48'),
('Lvl c1a4e179', NULL, 0, 1, 'cb91002f-2d22-42be-a8a6-4b88e90d7496', '2026-07-10 15:55:00', '2026-07-10 15:55:00'),
('Level for Lesson 6e066130', NULL, 0, 1, 'cdd128aa-fe87-4b2d-a348-ba17a75cc2a3', '2026-07-10 15:26:56', '2026-07-10 15:26:56'),
('Lvl 2f1ca9e5', NULL, 0, 1, 'd39fd00a-478c-4422-bd73-c1768391b6b2', '2026-07-10 15:54:53', '2026-07-10 15:54:53'),
('Lvl eaacf227', NULL, 0, 1, 'da57e369-0620-455d-b278-84cc7cf9f057', '2026-07-10 16:11:00', '2026-07-10 16:11:00'),
('Level for Lesson daabf4c7', NULL, 0, 1, 'dae01a98-b09b-4b78-a282-87eb7f439ec4', '2026-07-11 04:22:40', '2026-07-11 04:22:40'),
('N5 Mock Level bef7deb9-0923-48f8-ba6e-ed9fb6aa11a0', NULL, 0, 0, 'db7f6bff-09f6-4a32-bbdd-bd034ebf7f39', '2026-07-11 04:13:10', '2026-07-11 04:13:10'),
('Test Level 87844e23', NULL, 10, 1, 'dc80e2f3-baf3-4724-bd6d-df1ea831fcea', '2026-07-10 15:25:57', '2026-07-10 15:25:57'),
('Lvl ec818396', NULL, 0, 1, 'ded54a4b-644e-4f7d-bf5c-7840e70eaed3', '2026-07-10 15:36:45', '2026-07-10 15:36:45'),
('Pub Level ca5b4904', NULL, 1, 1, 'df3377f1-4096-445f-ae7f-6b36833737ee', '2026-07-10 15:26:44', '2026-07-10 15:26:44'),
('Lvl c8e523f5', NULL, 0, 1, 'e34d19f4-1664-4f7e-a755-6fa56a320f44', '2026-07-11 04:22:40', '2026-07-11 04:22:40'),
('N5 Mock Level 3ede0c5f-6dee-4ef0-bd71-c6cf8353899e', NULL, 0, 0, 'e436b15e-8098-4701-9c01-d12b5c34d807', '2026-07-11 04:19:23', '2026-07-11 04:19:23'),
('N5 Mock Level ff390ae5-bab3-4341-8e30-54bb02a25a93', NULL, 0, 0, 'e9576d30-1b28-4a08-8481-139a2b6b2506', '2026-07-11 04:16:03', '2026-07-11 04:16:03'),
('Lvl 01cd1da6', NULL, 0, 1, 'e9c8557f-e9c5-4701-b458-3b4a504fba01', '2026-07-10 15:38:04', '2026-07-10 15:38:04'),
('Lvl 6df1cc81', NULL, 0, 1, 'f13342d8-7b14-4e4a-91f3-8733ca842e7d', '2026-07-10 16:23:43', '2026-07-10 16:23:43'),
('Lvl cf8ad149', NULL, 0, 1, 'f18b926b-c01e-450d-a74e-52dcf599abf5', '2026-07-10 16:15:48', '2026-07-10 16:15:48'),
('Lvl 677222e3', NULL, 0, 1, 'f22ccc5f-b343-40ee-b74c-cea6e7581110', '2026-07-10 16:06:23', '2026-07-10 16:06:23'),
('Pub Level 8c61dcb3', NULL, 1, 1, 'f255b2cd-aae9-40cd-9e13-1de0301192d9', '2026-07-10 15:25:57', '2026-07-10 15:25:57'),
('Lvl 283d77f7', NULL, 0, 1, 'f4e2c126-0453-4dc0-a518-2062ef5716ec', '2026-07-10 16:11:00', '2026-07-10 16:11:00'),
('Lvl 523584eb', NULL, 0, 1, 'f4f59400-62cb-4108-af18-14d380f5e408', '2026-07-10 15:53:53', '2026-07-10 15:53:53'),
('Level for Lesson d2cb1ba9', NULL, 0, 1, 'f5590213-2244-4761-9d42-100e5f693432', '2026-07-10 15:26:44', '2026-07-10 15:26:44'),
('N5 Mock Level 812349cc-9c77-488c-9c01-c7f2c6589ccd', NULL, 0, 0, 'f5c9075a-30d0-4d8c-89f2-70b1815190b9', '2026-07-11 04:40:23', '2026-07-11 04:40:23'),
('Lvl 10616b4a', NULL, 0, 1, 'f6574025-c15f-4696-be2b-3433faaa4ad0', '2026-07-10 16:23:51', '2026-07-10 16:23:51'),
('Pub Level cd9e8cf2', NULL, 1, 1, 'f72aec3e-90b4-435f-a4bc-6ae61bd4d6b2', '2026-07-11 04:22:40', '2026-07-11 04:22:40'),
('Lvl 45bef838', NULL, 0, 1, 'f75fad1c-6e26-423e-bce3-fd5c89a4fa7d', '2026-07-10 16:03:05', '2026-07-10 16:03:05'),
('N5 Mock Level f91c51f1-ab5b-47d0-b479-889b401e806a', NULL, 0, 0, 'f90ea20e-66aa-4998-b804-32d53212514a', '2026-07-11 04:15:52', '2026-07-11 04:15:52'),
('N5 Mock Level 48909f50-a1b0-450e-891a-70c8091df22d', NULL, 0, 0, 'ff4ffdfd-24c0-4247-b493-b8a7289ea6c0', '2026-07-11 04:14:11', '2026-07-11 04:14:11'),
('Lvl 666fd23b', NULL, 0, 1, 'ffaf79c4-8a72-4a60-b134-f456b4786e9d', '2026-07-10 16:16:05', '2026-07-10 16:16:05');

-- --------------------------------------------------------

--
-- Table structure for table `passwordresettokens`
--

CREATE TABLE `passwordresettokens` (
  `user_id` varchar(36) NOT NULL,
  `token_hash` varchar(255) NOT NULL,
  `expires_at` datetime NOT NULL,
  `is_used` tinyint(1) DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `questions`
--

CREATE TABLE `questions` (
  `lesson_id` varchar(36) NOT NULL,
  `reading_id` varchar(36) DEFAULT NULL,
  `audio_asset_id` varchar(36) DEFAULT NULL,
  `question_type` enum('MULTIPLE_CHOICE','TRUE_FALSE','MATCHING','ORDERING','CLOZE','LISTENING','READING') NOT NULL,
  `skill` enum('VOCABULARY','GRAMMAR','READING','LISTENING') NOT NULL,
  `difficulty` int(11) DEFAULT NULL,
  `prompt_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`prompt_json`)),
  `answer_key_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`answer_key_json`)),
  `explanation_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`explanation_json`)),
  `status` enum('DRAFT','AUTO_VALIDATED','IN_REVIEW','NEEDS_REVISION','APPROVED','PUBLISHED','REJECTED','ARCHIVED') NOT NULL,
  `is_ai_generated` tinyint(1) DEFAULT NULL,
  `version_number` int(11) DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `reviewed_by` varchar(36) DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `questions`
--

INSERT INTO `questions` (`lesson_id`, `reading_id`, `audio_asset_id`, `question_type`, `skill`, `difficulty`, `prompt_json`, `answer_key_json`, `explanation_json`, `status`, `is_ai_generated`, `version_number`, `created_by`, `reviewed_by`, `id`, `created_at`, `updated_at`) VALUES
('87d161e1-ec62-4d74-8ca4-d576b3a4a21c', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 4\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '020274e3-da33-42f7-b9ef-f1b33abdca2d', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('0feee345-4eda-48eb-a5d8-b8bd6fd30915', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 19\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '020f3425-1817-4c6a-9997-f31123d34963', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('3eb78103-00ad-4e58-be6d-ea5ef58d99bc', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 26\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '0305a8a8-2128-4ca0-8d34-55136c2ebae6', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('b2f7f273-823b-49be-a148-f7764f3d5b8c', NULL, '58b1ba55-2a06-4e83-84b4-66f9cdca46a9', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 24\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '0319cf5a-6fed-4b64-bec8-dceb5673803a', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('ebdcd7d0-0fd0-4f52-b9e4-3fe9b34dfa09', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '035398f3-0cf4-43c7-85e9-db38f9a12295', '2026-07-10 16:15:48', '2026-07-10 16:15:48'),
('ad2b3982-1bcc-47e8-96c1-dcf38e3242fc', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 8\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '03a8af71-28da-4981-909b-d85194076f95', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('7cea6f51-6269-481a-a61b-71a189816f59', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 29\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '03c03f98-06d6-49d5-ac84-166ba962f312', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('28800418-9d7b-4c94-8912-3944ff99f4e5', '59a22486-4951-4129-a8c9-d94aafbf413b', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 27\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '04059b69-29f9-4d12-ae29-5dfd79081c7f', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('c805c437-931e-4ae6-a8f5-ac8efd6f3ca3', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat in Japanese?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Neko\"}, {\"id\": \"opt2\", \"text\": \"Inu\"}]}', '{\"correct_option_id\": \"opt1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '0545bbb4-76c4-441a-add5-7450dc1687df', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('311440a8-6fd6-492f-965c-966181e8d3b3', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 23\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '05b4992e-86f1-4da8-aee6-503f23c24ee9', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('c3d929dd-7b38-4424-a14a-c50f82679248', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Test Q?\"}', '{\"correct\": \"A\"}', '{\"text\": \"Because A\"}', 'PUBLISHED', 0, 1, NULL, NULL, '075e2d0b-b8d1-493a-b08b-ef937c9dad1e', '2026-07-11 03:32:12', '2026-07-11 03:32:12'),
('a7b56a6f-98c5-4ee8-af1f-ecc71a18f38d', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 1\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '07b56dd6-9e43-4302-89ee-238423b4231b', '2026-07-11 03:03:59', '2026-07-11 03:03:59'),
('f215a15e-ac3d-4bf0-b7ff-cb6a989f3f83', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 21\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '0862a52e-0399-4c65-82ed-f379a48ee00f', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('3eb78103-00ad-4e58-be6d-ea5ef58d99bc', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 26\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '09be1ada-da25-4c21-b38b-7d00512aac1c', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('3b6a911f-2923-45d1-8c8a-881d43e9f891', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', NULL, NULL, 'PUBLISHED', 0, 1, NULL, NULL, '09cbf8f4-8c87-464d-bfbc-f1fe201c2bab', '2026-07-11 04:13:10', '2026-07-11 04:13:10'),
('7cea6f51-6269-481a-a61b-71a189816f59', NULL, 'd03d21f8-1f1c-4ebc-863a-abdff9299b11', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 29\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '0b880b66-5837-4271-81ec-f320f9e176c5', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('c140e128-4049-4967-8aee-7f53a1ca8672', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 15\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '0c83208b-d7aa-4969-b394-1fa0526dafbd', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('9e76f978-6dfa-4bf4-9ecc-10f5613fd906', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat in Japanese?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Neko\"}, {\"id\": \"opt2\", \"text\": \"Inu\"}]}', '{\"correct_option_id\": \"opt1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '0cd711be-8318-44d8-917a-112e34b56b34', '2026-07-10 15:38:04', '2026-07-10 15:38:04'),
('c9cce62e-d2b1-4ea2-8428-45f96e76938f', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 25\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '0d060b68-8683-469b-9863-a3d0866148be', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('a7b56a6f-98c5-4ee8-af1f-ecc71a18f38d', 'db82e44e-c3f5-4dd8-b6a4-d58aaaeef71a', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 1\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '0d158010-1dee-4072-9b8b-8ea1b8aa166e', '2026-07-11 03:03:59', '2026-07-11 03:03:59'),
('28800418-9d7b-4c94-8912-3944ff99f4e5', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 27\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '0d58e668-a73f-46d1-99a2-5f3906bd8ff9', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('6b6f068a-7bca-4973-b803-4da3c3519ed7', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', NULL, NULL, 'PUBLISHED', 0, 1, NULL, NULL, '0d97dabc-3fd1-4f4a-8198-a9de43395723', '2026-07-11 04:14:04', '2026-07-11 04:14:04'),
('7add805b-c99a-4e33-aefb-150e23da2961', '1f264fb1-7277-4512-8b64-4ace02e9f8ca', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 2\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '0f8ebb6d-9469-4e33-9b32-38434873a3ad', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('b2bfe62e-dd2b-4e21-878c-1a4c3eb354b3', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '10ed0932-e587-421b-9e05-54e2f9175b2a', '2026-07-10 16:04:36', '2026-07-10 16:04:36'),
('3d2bc98d-43ea-4001-9525-6fe9fa19708e', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '119d69c5-7b53-43d2-9677-b560bdaec6e3', '2026-07-10 16:09:49', '2026-07-10 16:09:49'),
('e1db5222-af24-4be3-9837-1a4a8db18940', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '11ac7036-d3f1-4ae6-8fef-76fed00df706', '2026-07-10 16:09:32', '2026-07-10 16:09:32'),
('78589edc-8c29-43b3-b9b2-04d1b433a23e', 'ec48baa2-4fe5-4b94-abcc-47c83d11813f', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 5\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '11e20b66-ac58-4dbd-9e6e-5d432f1197b4', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('c9cce62e-d2b1-4ea2-8428-45f96e76938f', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 25\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '12c8448e-a240-45e8-9c74-f2a56d527113', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('c9cce62e-d2b1-4ea2-8428-45f96e76938f', '1c96d35b-61de-4b1f-96b6-0cedfb1b0b59', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 25\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '1350f25d-1043-4a70-98de-83fb97f76d17', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('28800418-9d7b-4c94-8912-3944ff99f4e5', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 27\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '13646b04-50c7-424e-9c42-0e6d96ed9b59', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('12aa4576-6aa1-43d0-a1ae-9a6a0900480e', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 20\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '1375f61e-8c6f-432f-b728-71f6172ceff0', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('59b863ad-9a4b-43b2-bd04-063b011e7510', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 10\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '13d9d44e-27d4-48d2-9b7a-4bd9319da663', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('93d8913f-9e51-4052-a201-5c317aa8f46a', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 17\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '13daaabc-5526-43b6-a3f9-1dae6a7a26be', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('c4e6b734-88e1-446e-8940-e228ea5d46e9', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 6\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '1464e006-6f31-47f4-b408-278545b9dc38', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('53b3d5fe-a25a-4670-9bce-cc0452d76ec7', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 28\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '14aaaa9d-942e-40c3-9060-79a0cda187e2', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('82cee997-09e3-460e-afed-05fc90d62c54', 'e015fd61-e906-436e-ad42-6acd867195a9', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 14\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '151a3800-ecbe-4f89-931a-adc8b7db85ef', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('7add805b-c99a-4e33-aefb-150e23da2961', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 2\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '1621b1ea-b04f-4d1b-af8c-4f5107f29622', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('59b863ad-9a4b-43b2-bd04-063b011e7510', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 10\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '167b0f38-3993-47d2-ae63-6d554d347e15', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('dd364720-5487-4148-940a-792c71cfe5e1', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 11\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '18dbf025-cdab-46ae-9f77-31f19fff062b', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('78589edc-8c29-43b3-b9b2-04d1b433a23e', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 5\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '199b2d39-bc22-4d65-9470-51c02979602b', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('f215a15e-ac3d-4bf0-b7ff-cb6a989f3f83', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 21\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '1a1fce4d-dfe1-436a-ab3b-381783e17e77', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('c4e6b734-88e1-446e-8940-e228ea5d46e9', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 6\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '1ae14e80-7685-4b45-a2e2-6fef072da88d', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('87d161e1-ec62-4d74-8ca4-d576b3a4a21c', NULL, '870cbec5-4b09-46f8-aace-a0fa4892ff59', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 4\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '1b50688c-96df-4986-bc61-db2e392ec0cc', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('c9c85c2c-9745-44e5-8e7a-97b222ed5779', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 9\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '1baa61ed-41b4-4d73-889b-a9e37cd9f84e', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('93122045-5ad8-4bff-8191-022f9749d5e7', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', NULL, NULL, 'PUBLISHED', 0, 1, NULL, NULL, '1cac58fc-d75f-4adb-80da-18adaf75bd1a', '2026-07-11 04:16:50', '2026-07-11 04:16:50'),
('859b9445-c65d-454d-98de-88a413493c57', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', NULL, NULL, 'PUBLISHED', 0, 1, NULL, NULL, '1d1645b1-a9a0-44fa-ad92-338df6f05cdb', '2026-07-11 04:14:04', '2026-07-11 04:14:04'),
('0feee345-4eda-48eb-a5d8-b8bd6fd30915', '4eeffba1-94f3-486d-8730-22754234acc4', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 19\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '1d236158-edf3-4a5e-9832-4ea5478d307c', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('0feee345-4eda-48eb-a5d8-b8bd6fd30915', '4eeffba1-94f3-486d-8730-22754234acc4', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 19\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '1d84cc35-70f5-47bf-bde8-c8961185b8d6', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('87d161e1-ec62-4d74-8ca4-d576b3a4a21c', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 4\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '1d9944a1-62c0-4f82-9668-99bc1a5e77e2', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('fc34ca52-3c47-4896-826c-1122305a7942', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '1f939f4b-5740-4cb7-b4c2-ee6d7541fef0', '2026-07-10 16:23:43', '2026-07-10 16:23:43'),
('555373ba-5a3f-478e-83e0-beecc429f74e', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '1f9d7e8d-4189-41ab-befe-22b7b3167e8d', '2026-07-10 16:16:06', '2026-07-10 16:16:06'),
('3eb78103-00ad-4e58-be6d-ea5ef58d99bc', '211ac5b8-a528-4811-94e0-be6220b2ded5', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 26\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '200354b8-a96f-41eb-a315-6ae0706f7259', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('f3de8168-b769-4588-8b80-f4790712e72b', '820f0e5c-7248-4562-b09a-594b736d55a9', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 16\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '20472673-26c8-4508-b0fe-f8df813ba3c7', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('c140e128-4049-4967-8aee-7f53a1ca8672', '1cd90371-df3c-447a-a26a-79177185c732', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 15\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '2071540b-de90-4106-b832-14741fd47ce4', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('45d3cf24-9288-47f3-ba31-8afe95dcfe78', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '2087477d-f6d5-4b57-9cd9-56891f041275', '2026-07-10 16:06:23', '2026-07-10 16:06:23'),
('f215a15e-ac3d-4bf0-b7ff-cb6a989f3f83', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 21\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '20e972d5-c8b3-4ead-a44a-f2439fb6f83d', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('db9c11a5-a5c8-479c-9f69-47029724b479', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat in Japanese?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Neko\"}, {\"id\": \"opt2\", \"text\": \"Inu\"}]}', '{\"correct_option_id\": \"opt1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '213f3134-38ca-4d7a-ae7e-60cdb5a0c7e4', '2026-07-11 04:40:22', '2026-07-11 04:40:22'),
('f3de8168-b769-4588-8b80-f4790712e72b', NULL, '69b5f18d-f6bf-48c5-9425-b56568d57808', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 16\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '21be571a-cc65-481f-bdc4-acb507302b1f', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('c03c6d85-175d-481d-aea5-419e408b7e03', 'cb19536d-9f0e-4ec2-855f-c772fdbf5a13', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 22\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '2244a994-bb26-4c57-a952-8c09986d7cdc', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('28800418-9d7b-4c94-8912-3944ff99f4e5', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 27\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '22852a79-0cc4-4562-96c8-9f08cec4df66', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('3eb78103-00ad-4e58-be6d-ea5ef58d99bc', '211ac5b8-a528-4811-94e0-be6220b2ded5', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 26\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '22d24926-4efd-44f9-81cb-5fcecdf02681', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('ad2b3982-1bcc-47e8-96c1-dcf38e3242fc', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 8\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '24916e32-36ef-46d0-8611-bbb8e223b85b', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('bf8862ab-3bfe-42bd-805b-613a5537fdce', NULL, 'c5d6d365-7125-49ce-b649-e5ea72cef41e', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 12\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '27a03eb7-e052-42fb-a350-e89cf0b51da5', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('59b863ad-9a4b-43b2-bd04-063b011e7510', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 10\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '27fd40a9-5226-44e8-a8c4-f1652d26cfc2', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('3eb78103-00ad-4e58-be6d-ea5ef58d99bc', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 26\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '29525af1-c049-4a25-9705-881c02f9fb45', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('dd364720-5487-4148-940a-792c71cfe5e1', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 11\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '2999cfc3-d2c9-4a8e-9091-50dd374b906d', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('a6ca7ff4-db73-4373-a975-9d648d1751e4', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', 'DRAFT', 0, 1, '8c059ab6-5a7d-4430-bcb2-3755623a3a0a', NULL, '2a93d262-838b-4182-b67d-7cca72ce2b4d', '2026-07-10 16:02:48', '2026-07-10 16:02:48'),
('07443ee1-78b4-404e-82de-c97a03809f12', '1cddec41-8de8-4021-a14a-a9ddca9d198c', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 18\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '2b113c06-e7a3-4b3d-8c90-4844e2c589fe', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('c03c6d85-175d-481d-aea5-419e408b7e03', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 22\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '2b1e0b19-a59c-4602-b9f8-da492884b00e', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('b2f7f273-823b-49be-a148-f7764f3d5b8c', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 24\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '2b24a660-7cb2-49e5-9f16-26d831f03eee', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('dd364720-5487-4148-940a-792c71cfe5e1', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 11\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '2b6969cd-9c80-4b20-8fe8-54eade27f3c4', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('7add805b-c99a-4e33-aefb-150e23da2961', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 2\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '2c27b830-6768-453d-a479-7600fa9298db', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('20e4f660-c70b-4602-ab8f-0ccd9aefb4c1', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 30\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '2e649c9d-69f4-4f54-8d71-cea240242675', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('7add805b-c99a-4e33-aefb-150e23da2961', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 2\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '2ea47109-03b7-4d56-9558-c19038759e6a', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('87d161e1-ec62-4d74-8ca4-d576b3a4a21c', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 4\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '2f3b9e67-5628-4836-a86e-f482a2c23c48', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('ed4bbc51-bfd6-40f7-af9e-a6c6dd6e6823', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '2fa28439-851b-4422-ab37-924c167695cb', '2026-07-10 16:15:48', '2026-07-10 16:15:48'),
('a7b56a6f-98c5-4ee8-af1f-ecc71a18f38d', 'db82e44e-c3f5-4dd8-b6a4-d58aaaeef71a', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 1\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '2fe25df5-8b3f-492d-9000-75cbf8e7ddd6', '2026-07-11 03:03:59', '2026-07-11 03:03:59'),
('172a6134-5678-4b9c-bcea-06b9d69deaed', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat in Japanese?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Neko\"}, {\"id\": \"opt2\", \"text\": \"Inu\"}]}', '{\"correct_option_id\": \"opt1\"}', 'null', 'APPROVED', 0, 1, '8c059ab6-5a7d-4430-bcb2-3755623a3a0a', NULL, '305ff970-7dff-4a7d-a6fe-12c07c333da4', '2026-07-10 15:36:45', '2026-07-10 15:36:45'),
('c9cce62e-d2b1-4ea2-8428-45f96e76938f', NULL, 'b13c589a-ed14-49b8-82d6-c634c74deaca', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 25\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '3186beff-0022-456c-a35b-4456b3a23381', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('18699dbe-5942-4d5c-99b9-8123c2070709', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat in Japanese?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Neko\"}, {\"id\": \"opt2\", \"text\": \"Inu\"}]}', '{\"correct_option_id\": \"opt1\"}', 'null', 'DRAFT', 0, 1, '8c059ab6-5a7d-4430-bcb2-3755623a3a0a', NULL, '32475090-b7c7-44f8-b4b6-64419f385658', '2026-07-10 15:34:14', '2026-07-10 15:34:14'),
('82cee997-09e3-460e-afed-05fc90d62c54', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 14\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '325e8850-4d5b-4cf5-9977-fcce66a42c50', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('c4e6b734-88e1-446e-8940-e228ea5d46e9', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 6\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '328df067-dbac-43a3-86bf-cfc60e4c579b', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('20e4f660-c70b-4602-ab8f-0ccd9aefb4c1', NULL, '6b0c654b-8af8-4f63-bc15-4771099e00d5', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 30\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '3381bd9b-b49d-4a71-9c49-24ef3e5b576c', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('3eb78103-00ad-4e58-be6d-ea5ef58d99bc', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 26\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '34c08163-04d2-4faa-9341-5a1184060f52', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('ecc1233f-1417-4613-83fd-d2762b5cf0da', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '35dc7a68-c00f-47bc-a444-aa37cddb3b62', '2026-07-10 16:11:00', '2026-07-10 16:11:00'),
('b2f7f273-823b-49be-a148-f7764f3d5b8c', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 24\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '35e77347-8ce3-4cb3-b5f3-a56f5c9d0ae3', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('ad2b3982-1bcc-47e8-96c1-dcf38e3242fc', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 8\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '35ed31bf-7654-4fa5-bdae-3cc5acc84902', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('13f37db3-0c50-4f8b-8349-65fffb4086a6', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', NULL, NULL, 'PUBLISHED', 0, 1, NULL, NULL, '36120889-4130-4d31-84ce-a1212482eecd', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('5e7c6c2b-cbef-4fad-a100-aa1819c8711a', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '382d5b2d-404d-4191-bb09-fa7a7bf5bc75', '2026-07-10 16:09:32', '2026-07-10 16:09:32'),
('1fbf7b41-4588-4334-8ef7-aa4921d2df65', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '395dd007-0f0d-4e4c-afb7-8618505c45cc', '2026-07-10 16:06:38', '2026-07-10 16:06:38'),
('fb6f81f4-0050-49ce-a147-9672b6e9ca3c', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is dog in Japanese?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '3a389d63-5c69-4506-ac15-e0c70c3c5724', '2026-07-10 15:55:00', '2026-07-10 15:55:00'),
('ce954d47-f1df-4bef-add2-35eda2f753e6', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', NULL, NULL, 'PUBLISHED', 0, 1, NULL, NULL, '3aa219b5-a44b-42f2-961c-bbff31578ec9', '2026-07-11 04:17:24', '2026-07-11 04:17:24'),
('25082036-6d59-418e-9471-ef053cf3cf31', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 3\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '3c013049-9d2a-4932-a346-b97a60f7a0ca', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('c4e6b734-88e1-446e-8940-e228ea5d46e9', '2fd50e00-78db-490b-ae93-a3bfb75738e2', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 6\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '3dbf3334-ff94-42ab-ad3f-52afe1c4d2de', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('df3ef33d-9678-4373-befe-7c408f7e7c6d', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '3e924d1a-0431-4f4c-8911-814e6ab38ffb', '2026-07-10 16:09:49', '2026-07-10 16:09:49'),
('c140e128-4049-4967-8aee-7f53a1ca8672', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 15\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '3ee499e0-e5c1-4022-9795-5b7c8004395c', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('20e4f660-c70b-4602-ab8f-0ccd9aefb4c1', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 30\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '3eef42c4-7574-400b-bd1a-796c947c1c8b', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('b2f7f273-823b-49be-a148-f7764f3d5b8c', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 24\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '3f90aee7-9f0e-45d4-9de8-eafdf62a9bd4', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('854c3593-4f38-44be-8336-62d66bee956b', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 7\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '4045b378-aea2-4c42-8476-5255b93e4860', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('20e4f660-c70b-4602-ab8f-0ccd9aefb4c1', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 30\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '404a3d30-c16c-4da8-80d5-7d892ba0926e', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('238b63e5-65cf-4487-9062-742324853445', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '408b1543-20f0-4734-a6af-7fc0c7d3ad57', '2026-07-10 16:04:53', '2026-07-10 16:04:53'),
('12aa4576-6aa1-43d0-a1ae-9a6a0900480e', '7696211f-bf5e-427d-b64d-019df5926b54', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 20\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '409d2960-475c-45c7-97f9-45173c85209b', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('53b3d5fe-a25a-4670-9bce-cc0452d76ec7', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 28\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '41b41d3a-6c11-4532-9aea-4214ab46cb89', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('52c7fecb-389c-4919-b10d-48e9df95a6bc', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '41cc3169-ed85-4a2c-8e81-404199c18f4b', '2026-07-11 04:40:21', '2026-07-11 04:40:21'),
('47dc78da-36d7-49a6-959d-f84c07a5ea53', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '4247da87-9fa5-4ac3-8431-3a447406a1a1', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('c140e128-4049-4967-8aee-7f53a1ca8672', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 15\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '42f4fdd5-c16e-49ce-8dd4-7b28cdb8796d', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('82cee997-09e3-460e-afed-05fc90d62c54', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 14\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '4427349c-4c64-4744-ba1b-899af1eae661', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('f215a15e-ac3d-4bf0-b7ff-cb6a989f3f83', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 21\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '4473f7e3-e4b0-4965-b3b5-dea21b9daf9f', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('b2f7f273-823b-49be-a148-f7764f3d5b8c', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 24\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '4517961e-25be-4fb2-b439-adcf51050b0f', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('311440a8-6fd6-492f-965c-966181e8d3b3', '1aee8b0c-6b21-4a75-9519-6391bb4c8e2f', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 23\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '456f499e-45cc-40b3-9e18-a93278475e3e', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('7add805b-c99a-4e33-aefb-150e23da2961', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 2\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '45f328d3-1fde-494a-9ce7-56ad32e8d9a9', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('c9c85c2c-9745-44e5-8e7a-97b222ed5779', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 9\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '4923d730-df2d-485e-b2f9-a002063204a0', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('93d8913f-9e51-4052-a201-5c317aa8f46a', NULL, '3d4cfa87-3fa5-4de2-bdb9-b9124a3730a2', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 17\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '4986ae5c-230c-4b7d-9013-e16cb6d8d136', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('ad2b3982-1bcc-47e8-96c1-dcf38e3242fc', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 8\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '4a35aced-5e79-4766-ac5b-154119f45528', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('12aa4576-6aa1-43d0-a1ae-9a6a0900480e', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 20\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '4a9acbff-4fc5-4da2-a9a4-f25f0b965578', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('f9b18921-17a4-4da2-949a-9e66762d2380', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', 'DRAFT', 0, 1, '8c059ab6-5a7d-4430-bcb2-3755623a3a0a', NULL, '4ada2391-c698-44c9-994c-931805bb1320', '2026-07-10 16:03:05', '2026-07-10 16:03:05'),
('ad2b3982-1bcc-47e8-96c1-dcf38e3242fc', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 8\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '4c0fa33f-c933-4f73-8bfa-2242ce7ffe50', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('a7b56a6f-98c5-4ee8-af1f-ecc71a18f38d', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 1\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '4ca1639f-a323-4bc1-aaf1-3322ec101196', '2026-07-11 03:03:59', '2026-07-11 03:03:59'),
('12aa4576-6aa1-43d0-a1ae-9a6a0900480e', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 20\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '4d12ae27-f9e2-4c8e-b956-bea234ab98ba', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('3eb78103-00ad-4e58-be6d-ea5ef58d99bc', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 26\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '4df8f843-e4fb-42e7-980e-8f53e2fc2b32', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('28800418-9d7b-4c94-8912-3944ff99f4e5', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 27\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '4e9b445a-1b55-4e4c-8086-e4978b3c9c9d', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('854c3593-4f38-44be-8336-62d66bee956b', NULL, '0e4b3fb2-e27a-4758-9143-e697d59451a6', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 7\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '4f43107b-b102-458a-b904-20b2dc8d428a', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('28b761da-f6a3-4d80-8523-059b1ea49968', NULL, '74463b36-8680-4828-abb1-313340f72bc4', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 13\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '4fbc0e6d-b8b5-4fbd-af68-41a5b450f36d', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('b2f7f273-823b-49be-a148-f7764f3d5b8c', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 24\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '5049f502-89a0-4d7c-b9ed-98c58b5fb2d8', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('24375181-4084-45a4-9996-9b5e7415fd45', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', 'DRAFT', 0, 1, '8c059ab6-5a7d-4430-bcb2-3755623a3a0a', NULL, '50812321-27e2-45f6-876e-cab61be68150', '2026-07-10 16:02:48', '2026-07-10 16:02:48'),
('f215a15e-ac3d-4bf0-b7ff-cb6a989f3f83', '430f519e-3824-4be0-a85f-f3c0f126ec2a', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 21\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '50c1b733-2a23-4a50-a354-74b49714a356', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('12aa4576-6aa1-43d0-a1ae-9a6a0900480e', '7696211f-bf5e-427d-b64d-019df5926b54', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 20\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '516e54c1-9d8f-4328-8424-1c505932f70f', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('c140e128-4049-4967-8aee-7f53a1ca8672', '1cd90371-df3c-447a-a26a-79177185c732', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 15\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '5192a325-7e92-4cda-a0d8-074fa3ee808d', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('47f442d1-1589-41f3-9a36-fde592ad4522', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '519b697f-e52a-48d2-878a-1f94544084ac', '2026-07-10 16:06:22', '2026-07-10 16:06:22'),
('a7b56a6f-98c5-4ee8-af1f-ecc71a18f38d', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 1\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '52260ba8-3afe-46e9-ada7-a9b195fef07b', '2026-07-11 03:03:59', '2026-07-11 03:03:59'),
('53b3d5fe-a25a-4670-9bce-cc0452d76ec7', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 28\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '52857c47-c3d9-45f7-bc38-7a62ae8c204b', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('bf8862ab-3bfe-42bd-805b-613a5537fdce', '0624cf0f-7b65-4f7c-9191-f4add0b178be', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 12\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '52d8e36c-4ecd-4f0b-9891-681ac58ed0f0', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('a7b56a6f-98c5-4ee8-af1f-ecc71a18f38d', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 1\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '5345c7db-4e93-4c2b-8fe6-692db52faba6', '2026-07-11 03:03:59', '2026-07-11 03:03:59'),
('59b863ad-9a4b-43b2-bd04-063b011e7510', 'a60ee668-f6db-4d7b-9387-f56d64a49e31', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 10\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '540bc0ba-26da-45a1-820b-febe72a81136', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('d079b702-fab2-4abd-9fef-00081207747b', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '54de490e-c725-419b-91c0-0082cbc0d8c9', '2026-07-10 16:14:03', '2026-07-10 16:14:03'),
('28b761da-f6a3-4d80-8523-059b1ea49968', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 13\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '55b94c47-58c3-4322-a25a-ff8467cb734f', '2026-07-11 03:04:02', '2026-07-11 03:04:02');
INSERT INTO `questions` (`lesson_id`, `reading_id`, `audio_asset_id`, `question_type`, `skill`, `difficulty`, `prompt_json`, `answer_key_json`, `explanation_json`, `status`, `is_ai_generated`, `version_number`, `created_by`, `reviewed_by`, `id`, `created_at`, `updated_at`) VALUES
('28800418-9d7b-4c94-8912-3944ff99f4e5', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 27\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '56789ebf-b68c-47e3-bff7-47365710621f', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('12aa4576-6aa1-43d0-a1ae-9a6a0900480e', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 20\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '57da406b-af86-4fd8-9269-162e32662750', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('59b863ad-9a4b-43b2-bd04-063b011e7510', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 10\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '58d4f60b-0f46-41e2-a8ee-f27b1df585f2', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('c9cce62e-d2b1-4ea2-8428-45f96e76938f', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 25\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '58fe5042-1099-4760-90b3-4eeaf9fe7935', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('6801c103-ae57-41fa-9561-975e53f8d0a3', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', NULL, NULL, 'PUBLISHED', 0, 1, NULL, NULL, '5a351ed1-b088-4d64-9111-a1cd66bb422f', '2026-07-11 04:14:55', '2026-07-11 04:14:55'),
('bf8862ab-3bfe-42bd-805b-613a5537fdce', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 12\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '5ae45fbc-57ac-444a-ba63-3e5dc98c0cbc', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('25082036-6d59-418e-9471-ef053cf3cf31', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 3\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '5afec847-5344-4717-ae50-3e81b00f2b74', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('d492a111-b029-4e4c-9eeb-61e4ee67d61b', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', NULL, NULL, 'PUBLISHED', 0, 1, NULL, NULL, '5b97d071-9021-4e16-a5f2-a13cbcd2f086', '2026-07-11 04:16:03', '2026-07-11 04:16:03'),
('bf8862ab-3bfe-42bd-805b-613a5537fdce', '0624cf0f-7b65-4f7c-9191-f4add0b178be', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 12\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '5c11236d-63c9-404a-83e7-f4793743ed5a', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('93d8913f-9e51-4052-a201-5c317aa8f46a', '03ce8b04-c2e2-4b74-beae-966c615652c3', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 17\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '5d9e89f0-0dbe-4d82-81c9-b5a86cf70583', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('854c3593-4f38-44be-8336-62d66bee956b', '897f4834-70a5-4861-b6c8-aa5f1af1eeea', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 7\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '5df5cc42-9352-40b9-b695-8a06c668ed1e', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('28800418-9d7b-4c94-8912-3944ff99f4e5', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 27\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '5e2172a7-208e-4861-aa44-c0203d3feb9d', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('f3de8168-b769-4588-8b80-f4790712e72b', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 16\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '5f316ad9-bbb4-424e-960b-c77e416bc44f', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('93d8913f-9e51-4052-a201-5c317aa8f46a', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 17\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '5fb6d456-f608-4cbf-9a2c-0b8bb370ddbf', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('7cea6f51-6269-481a-a61b-71a189816f59', 'ed63563d-3add-40de-83fb-e80a376a7210', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 29\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '60578b98-695e-4c1f-ab96-047890957915', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('5a23eb31-9ce1-40ca-bbe1-8eae5a19b575', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is dog in Japanese?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '607cfe2a-f5f7-46fb-a746-5c83a629f7e1', '2026-07-11 04:22:40', '2026-07-11 04:22:40'),
('c9cce62e-d2b1-4ea2-8428-45f96e76938f', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 25\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '623a6f64-8a60-4a3e-993c-396690d3a851', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('dd364720-5487-4148-940a-792c71cfe5e1', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 11\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '62cf2747-2839-4f5b-b72e-2dadbd674dea', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('87d161e1-ec62-4d74-8ca4-d576b3a4a21c', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 4\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '6475a82d-0e61-4854-b0e3-3821780fac52', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('f8f97f68-a8e2-4b69-ad0c-17fcad7b0463', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '65cf5938-6f10-4710-a664-d5b47940e9da', '2026-07-10 16:20:00', '2026-07-10 16:20:01'),
('7cea6f51-6269-481a-a61b-71a189816f59', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 29\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '67547af4-5a1a-4c19-a55a-06a442964447', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('07443ee1-78b4-404e-82de-c97a03809f12', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 18\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '682bfdd3-7f08-4b19-b15c-c719262e560f', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('854c3593-4f38-44be-8336-62d66bee956b', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 7\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '692d4536-f2f1-415a-a781-1b3062caf2a5', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('bf8862ab-3bfe-42bd-805b-613a5537fdce', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 12\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '6a0289aa-92a6-4613-a29d-d4e1285fa151', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('a7b56a6f-98c5-4ee8-af1f-ecc71a18f38d', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 1\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '6a3b9bcd-b050-4e02-b119-db00f47b8490', '2026-07-11 03:03:59', '2026-07-11 03:03:59'),
('c4e6b734-88e1-446e-8940-e228ea5d46e9', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 6\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '6a471a6b-11c5-485b-8711-a65223d4e4d5', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('c03c6d85-175d-481d-aea5-419e408b7e03', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 22\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '6a545c66-709e-40fb-b948-553ff49cec3a', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('c03c6d85-175d-481d-aea5-419e408b7e03', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 22\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '6a99b660-f8bc-4e7e-9afa-86f1a0106e71', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('17978be0-dd11-4f7f-ac16-1af38e2eae7f', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is dog in Japanese?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '6a9d73b7-2e1e-447d-8794-0db2d583e3b4', '2026-07-10 15:54:53', '2026-07-10 15:54:53'),
('28b761da-f6a3-4d80-8523-059b1ea49968', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 13\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '6b5a0744-1b54-4c1b-b892-a71d75d11345', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('87d161e1-ec62-4d74-8ca4-d576b3a4a21c', '1327f311-4094-474d-824a-39d8b15b7315', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 4\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '6d46a929-0771-408f-9b2b-86221390cb1c', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('d3958367-bfd4-40a1-a5e9-6426dc39fff9', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Test Q?\"}', '{\"correct\": \"A\"}', '{\"text\": \"Because A\"}', 'PUBLISHED', 0, 1, NULL, NULL, '6dd9bd3c-8f59-4ad3-b370-21a23c108c7e', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('f215a15e-ac3d-4bf0-b7ff-cb6a989f3f83', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 21\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '6e182e7d-210b-482b-9339-1d2ece4acbba', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('93d8913f-9e51-4052-a201-5c317aa8f46a', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 17\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '6f17f17a-5605-4167-ac1a-ce36464a4b8b', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('12aa4576-6aa1-43d0-a1ae-9a6a0900480e', NULL, 'bb5a91fa-fa78-4f1d-b06d-41cd49cde2de', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 20\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '6f21dab9-b2ed-41fb-a99f-1b96a54dabf2', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('311440a8-6fd6-492f-965c-966181e8d3b3', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 23\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '6fe90e1b-f262-4d31-8ab0-d231973ee79b', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('a7b56a6f-98c5-4ee8-af1f-ecc71a18f38d', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 1\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '70a75ffc-3611-4368-bd5e-0ffd08c0fedd', '2026-07-11 03:03:59', '2026-07-11 03:03:59'),
('78589edc-8c29-43b3-b9b2-04d1b433a23e', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 5\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '7294103d-6d74-4baa-948c-f8b73eeedf8f', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('c9c85c2c-9745-44e5-8e7a-97b222ed5779', '68bf3139-c186-484b-aa84-3a5737cfcbe8', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 9\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '737441fb-b733-4a40-90b9-71294f669dd5', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('c9cce62e-d2b1-4ea2-8428-45f96e76938f', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 25\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '73c50c6b-a2b3-46db-a218-2c191b50f211', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('69647da2-98de-45bf-a875-49f054ec01a8', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat in Japanese?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Neko\"}, {\"id\": \"opt2\", \"text\": \"Inu\"}]}', '{\"correct_option_id\": \"opt1\"}', 'null', 'IN_REVIEW', 0, 1, '8c059ab6-5a7d-4430-bcb2-3755623a3a0a', NULL, '73d953b9-ee46-4971-a46d-1ada823dbf3b', '2026-07-10 15:35:34', '2026-07-10 15:35:34'),
('0feee345-4eda-48eb-a5d8-b8bd6fd30915', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 19\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '740248eb-a63a-42e4-8c5e-beb13a9ca1f2', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('b2f7f273-823b-49be-a148-f7764f3d5b8c', '61a22f0f-10cb-49bd-82d1-3374a64ab903', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 24\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '74cfa3b0-9616-4e96-a5ea-868ff9e6d64b', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('c9c85c2c-9745-44e5-8e7a-97b222ed5779', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 9\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '75160b51-2337-4c91-b4e7-e92a6532c4a9', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('59b863ad-9a4b-43b2-bd04-063b011e7510', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 10\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '76293399-bf69-4f15-bf7e-a730561f718d', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('93d8913f-9e51-4052-a201-5c317aa8f46a', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 17\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '7675733d-28c2-4214-a2be-2c961d4c5d55', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('c4e6b734-88e1-446e-8940-e228ea5d46e9', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 6\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '7698a2d2-8687-4aac-8733-1066dec8b6a6', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('1f8386ae-57e5-4690-94b5-e69779a4c2cb', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Test Q?\"}', '{\"correct\": \"A\"}', '{\"text\": \"Because A\"}', 'PUBLISHED', 0, 1, NULL, NULL, '76d3c72a-a5e2-4f06-8701-aae54d5cc47c', '2026-07-11 03:32:51', '2026-07-11 03:32:51'),
('25082036-6d59-418e-9471-ef053cf3cf31', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 3\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '772ab9ff-4ffd-4224-b75c-2ec406f770db', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('854c3593-4f38-44be-8336-62d66bee956b', '897f4834-70a5-4861-b6c8-aa5f1af1eeea', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 7\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '77f835e8-0e07-46dd-8948-a60ed17ecaef', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('f215a15e-ac3d-4bf0-b7ff-cb6a989f3f83', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 21\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '78a46ebe-8382-4fcc-8593-8dc404c63ff2', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('25082036-6d59-418e-9471-ef053cf3cf31', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 3\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '792f0c37-4a90-407c-b181-273a4d2904cf', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('bf8862ab-3bfe-42bd-805b-613a5537fdce', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 12\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '7968443c-3e13-4dae-a29e-e9e2a1875f28', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('3c8870a6-081d-4154-88ab-b60d361d3c18', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '79a546c5-bd4a-464a-9f7d-17b6494979ea', '2026-07-10 16:11:00', '2026-07-10 16:11:00'),
('07443ee1-78b4-404e-82de-c97a03809f12', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 18\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '7b212c41-6468-40b6-a6fa-9d6b43e787b9', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('dd364720-5487-4148-940a-792c71cfe5e1', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 11\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '7b29f0d8-0e22-4d9e-8a24-53455efdfcdc', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('82cee997-09e3-460e-afed-05fc90d62c54', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 14\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '7e55046a-4afd-4f89-bd4b-a92578d3c1f6', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('c9c85c2c-9745-44e5-8e7a-97b222ed5779', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 9\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '7e9eee50-0770-4b55-b36a-c7efec94b080', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('854c3593-4f38-44be-8336-62d66bee956b', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 7\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '7ec5d91f-cef6-4c1c-abba-a2ca27093b28', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('82cee997-09e3-460e-afed-05fc90d62c54', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 14\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '7ed1e575-8790-419c-850b-d8f2a5874a8d', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('53b3d5fe-a25a-4670-9bce-cc0452d76ec7', NULL, '7a5b83b9-292b-47a1-abd6-df9340193e89', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 28\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '7fd2049e-6f1b-4445-98a2-49301eb8b3d2', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('53b3d5fe-a25a-4670-9bce-cc0452d76ec7', '067fcca8-96ef-4a4b-99e8-ea2ce70aac42', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 28\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '8045f485-b2de-45aa-b0ee-5f23c4b1e2a3', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('bf8862ab-3bfe-42bd-805b-613a5537fdce', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 12\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '81162a71-3ead-445f-8cd5-dfcfe00ec664', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('53b3d5fe-a25a-4670-9bce-cc0452d76ec7', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 28\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '816b1b3f-941c-48ce-a902-96b04d07bf32', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('f3de8168-b769-4588-8b80-f4790712e72b', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 16\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '818e49c8-a309-4957-8917-832424ef056f', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('28800418-9d7b-4c94-8912-3944ff99f4e5', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 27\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '831ae911-ad41-44f5-8258-ea3e2e2367d7', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('f3de8168-b769-4588-8b80-f4790712e72b', '820f0e5c-7248-4562-b09a-594b736d55a9', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 16\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '832c41ab-765f-4241-a080-e5b42ea6bb6e', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('28b761da-f6a3-4d80-8523-059b1ea49968', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 13\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '8447c1c9-be08-4a50-ae46-7eab970dbf91', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('c03c6d85-175d-481d-aea5-419e408b7e03', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 22\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '85a852a5-70d6-4c05-949c-f1d9fc0245df', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('78589edc-8c29-43b3-b9b2-04d1b433a23e', 'ec48baa2-4fe5-4b94-abcc-47c83d11813f', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 5\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '86b227af-d426-4a5c-83f8-d3002f0195fc', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('20e4f660-c70b-4602-ab8f-0ccd9aefb4c1', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 30\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '88ebebda-0f52-4ef1-9573-91b93e1b0fe5', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('07443ee1-78b4-404e-82de-c97a03809f12', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 18\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '8972c48b-7865-465d-a722-fae8f749070e', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('28b761da-f6a3-4d80-8523-059b1ea49968', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 13\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '898d57f1-f831-438b-bbd5-7c0315a19c77', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('93d8913f-9e51-4052-a201-5c317aa8f46a', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 17\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '8b2fb63e-83d7-4a53-804c-68b4d703f6f4', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('25082036-6d59-418e-9471-ef053cf3cf31', '22ed8750-b928-4842-8846-30b2dd5cad77', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 3\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '8b6cbf97-67c8-41e7-8858-a96e41b10790', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('f3de8168-b769-4588-8b80-f4790712e72b', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 16\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '8ba154b8-de40-43e8-baee-68f045464880', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('c4e6b734-88e1-446e-8940-e228ea5d46e9', NULL, 'f66e1f87-091d-4782-b6d4-40ffc39de1b0', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 6\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '8ba32d74-262d-4a96-9ba4-9a509b04fbf4', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('07443ee1-78b4-404e-82de-c97a03809f12', '1cddec41-8de8-4021-a14a-a9ddca9d198c', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 18\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '8ba99ce2-eeaf-457b-b35e-15e4e14de35d', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('c2572650-a575-4d45-91ba-eeef03530aea', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '8cfe6fba-4dd3-4947-a5a1-25c96465fbe6', '2026-07-10 16:23:43', '2026-07-10 16:23:43'),
('07443ee1-78b4-404e-82de-c97a03809f12', NULL, 'aea999ac-e627-48b0-ac5a-9ac142cfe1fc', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 18\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '8e5186a4-98d7-411c-b43e-f749097451dc', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('854c3593-4f38-44be-8336-62d66bee956b', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 7\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '8f399ddf-c9aa-4ecf-b04d-e31a2eec7527', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('28b761da-f6a3-4d80-8523-059b1ea49968', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 13\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '8f9fbcf3-f316-4f0e-935b-43a7a459ba26', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('3eb78103-00ad-4e58-be6d-ea5ef58d99bc', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 26\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '91180726-64d8-41f7-ac91-d3426f12539a', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('59b863ad-9a4b-43b2-bd04-063b011e7510', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 10\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '91242696-dce2-4a01-8394-d2301611080f', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('7cea6f51-6269-481a-a61b-71a189816f59', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 29\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '916d529e-3028-45ea-8c65-072356a60e23', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('7cea6f51-6269-481a-a61b-71a189816f59', 'ed63563d-3add-40de-83fb-e80a376a7210', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 29\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '918e9c50-9f5b-469e-9a2d-e639f318c91b', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('dd364720-5487-4148-940a-792c71cfe5e1', NULL, 'ad259c2b-84bd-4903-8d29-600e26c3b514', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 11\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '92183141-e134-4edb-b7ee-3dd6c63ea9ca', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('6043f684-2388-4503-aa46-2c8a0cd78504', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '9323f1bb-fbce-42f1-80ad-f7c66315a06b', '2026-07-10 16:23:51', '2026-07-10 16:23:51'),
('25082036-6d59-418e-9471-ef053cf3cf31', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 3\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '958b9a8d-e69f-40ae-8ed4-1fcaab4c9bf3', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('23ba937b-fdc2-415f-be7f-c7f61a6d4ad1', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', NULL, NULL, 'PUBLISHED', 0, 1, NULL, NULL, '9714c8ca-15dd-488a-8273-9afeab488f39', '2026-07-11 04:16:50', '2026-07-11 04:16:50'),
('07443ee1-78b4-404e-82de-c97a03809f12', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 18\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '97232d96-8916-4ae4-a509-dc419a591228', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('311440a8-6fd6-492f-965c-966181e8d3b3', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 23\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '97f79f17-d1af-4cda-a177-a346c2e8cd45', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('14c8ae06-5fdb-4748-aad0-26238692d933', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, '992a54c3-f35f-46ca-b495-c7707a9b2cc3', '2026-07-10 16:14:03', '2026-07-10 16:14:03'),
('82cee997-09e3-460e-afed-05fc90d62c54', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 14\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '99a56d01-4463-4d35-a929-7c6f2a3657de', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('311440a8-6fd6-492f-965c-966181e8d3b3', '1aee8b0c-6b21-4a75-9519-6391bb4c8e2f', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 23\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '99cc655f-f986-443f-8856-5048539884dd', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('59b863ad-9a4b-43b2-bd04-063b011e7510', NULL, '30c29521-4ab9-45d0-be15-2b0d0cda8f5d', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 10\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '9b25262f-7abf-44bf-9a7d-495f9b210fb4', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('0feee345-4eda-48eb-a5d8-b8bd6fd30915', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 19\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '9c43b99b-f983-4662-91fc-7ed03c6cb22a', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('ad2b3982-1bcc-47e8-96c1-dcf38e3242fc', 'ce5aa5da-6eb8-415b-b98a-073883b6ca69', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 8\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '9ced7cba-1dea-4d8c-9a0f-897a6d9cdab8', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('82cee997-09e3-460e-afed-05fc90d62c54', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 14\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, '9e547f90-4f49-4c84-93a7-9c68f15c1e84', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('c9c85c2c-9745-44e5-8e7a-97b222ed5779', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 9\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'a1f3e9c1-02d0-42cf-8a39-d3cdbe174938', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('2d19c4e0-2896-4b4c-83f5-f34bb6963f6f', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', NULL, NULL, 'PUBLISHED', 0, 1, NULL, NULL, 'a2ada812-3aa7-405b-9650-108405f2f1a4', '2026-07-11 04:40:22', '2026-07-11 04:40:22'),
('bf8862ab-3bfe-42bd-805b-613a5537fdce', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 12\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'a2f08798-8ff1-4cb2-98a4-7a6734d3f30e', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('20e4f660-c70b-4602-ab8f-0ccd9aefb4c1', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 30\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'a3069941-11a9-4d3f-97fa-a9a2e8e1fcff', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('c4e6b734-88e1-446e-8940-e228ea5d46e9', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 6\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'a380b850-aa3c-4844-b9b5-0d4d3001a902', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('bf8862ab-3bfe-42bd-805b-613a5537fdce', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 12\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'a4d15af4-32ec-4d45-988f-1e94dcd6962c', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('39dc3396-dcbc-43aa-b0ae-ddf3c488975d', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', 'DRAFT', 0, 1, '8c059ab6-5a7d-4430-bcb2-3755623a3a0a', NULL, 'a5ca653f-204b-4a54-83a6-19f16f4e9c6e', '2026-07-10 16:03:05', '2026-07-10 16:03:05'),
('c4e6b734-88e1-446e-8940-e228ea5d46e9', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 6\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'a5f01d01-c6e7-4818-bf6b-17b4761cc058', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('f3de8168-b769-4588-8b80-f4790712e72b', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 16\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'a60ea369-6eb2-4ca1-bdbd-456f1c3343c6', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('bf8862ab-3bfe-42bd-805b-613a5537fdce', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 12\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'a630892d-ea21-497c-a254-7ae6232d5893', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('7cea6f51-6269-481a-a61b-71a189816f59', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 29\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'a68f23ba-e65c-40e6-918e-8fe6d4891dcb', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('29200da4-786f-4dfb-90dc-47b3d05f7137', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', NULL, NULL, 'PUBLISHED', 0, 1, NULL, NULL, 'a6ebab7a-79bf-41f1-b447-fa307b8d71be', '2026-07-11 04:13:18', '2026-07-11 04:13:18'),
('25082036-6d59-418e-9471-ef053cf3cf31', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 3\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'a774d656-2f68-4ab5-b359-a23ab2097847', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('b360716b-8e25-4946-aa90-5a902afdddbc', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, 'a7e9dff5-b3e5-420d-8879-344d953767b1', '2026-07-10 16:04:37', '2026-07-10 16:04:37'),
('28800418-9d7b-4c94-8912-3944ff99f4e5', '59a22486-4951-4129-a8c9-d94aafbf413b', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 27\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'aac318e2-bbe8-42ed-9853-a52253d3bc67', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('25082036-6d59-418e-9471-ef053cf3cf31', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 3\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'ab614285-76ff-4b9d-a080-d48578fcff82', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('27f16bc8-66e8-4cff-8fbb-57b01208d9bd', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, 'ac0fcdc1-7c67-4c8d-9b38-3c894f1f74b9', '2026-07-10 16:07:53', '2026-07-10 16:07:53'),
('99a04bff-f4ab-4cc4-b8cb-acc77748f6b4', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', NULL, NULL, 'PUBLISHED', 0, 1, NULL, NULL, 'ac2c593d-bbbd-4268-8304-5bbf99124ce4', '2026-07-11 04:19:23', '2026-07-11 04:19:23'),
('25082036-6d59-418e-9471-ef053cf3cf31', '22ed8750-b928-4842-8846-30b2dd5cad77', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 3\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'ac79bdaf-591e-484d-961d-59e056631bc4', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('c140e128-4049-4967-8aee-7f53a1ca8672', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 15\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'ac940b40-45a1-46aa-9fb0-b6835b558433', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('12aa4576-6aa1-43d0-a1ae-9a6a0900480e', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 20\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'acbbecb8-ad75-4ee0-9653-05b73a683379', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('6367218c-d19e-429b-9a71-d7502b7ac080', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, 'ae9b8443-fcbb-497b-8d2a-424499ef73f2', '2026-07-10 16:20:00', '2026-07-10 16:20:00'),
('20e4f660-c70b-4602-ab8f-0ccd9aefb4c1', '159ffb88-40c7-46dc-acfc-1a56785c4b96', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 30\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'af0fd5f9-d1f2-4401-9444-ea7bb76ab1ed', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('3eb78103-00ad-4e58-be6d-ea5ef58d99bc', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 26\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'af958719-bcf8-4f83-83a9-8448e98e7de4', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('311440a8-6fd6-492f-965c-966181e8d3b3', NULL, 'a41c5f11-d9e3-4e36-a76a-f2c341b03007', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 23\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'b031d980-0a78-44f6-aac1-47e164e49df9', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('b2f7f273-823b-49be-a148-f7764f3d5b8c', '61a22f0f-10cb-49bd-82d1-3374a64ab903', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 24\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'b0534fe3-7892-4c93-a765-96dd2e8c0da3', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('c40460b4-1d6e-49b4-a240-3490d8d57089', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Test Q?\"}', '{\"correct\": \"A\"}', '{\"text\": \"Because A\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'b11a06b3-79e5-4772-987a-4c50a64d9d95', '2026-07-11 03:32:01', '2026-07-11 03:32:01'),
('f3de8168-b769-4588-8b80-f4790712e72b', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 16\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'b1a9b318-dcc2-48cf-9a60-7acf81400107', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('3eb78103-00ad-4e58-be6d-ea5ef58d99bc', NULL, 'ce218880-9128-478c-8a74-88a7c1a44506', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 26\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'b2b2487f-61d9-48df-a0d6-9c7285609b4f', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('78589edc-8c29-43b3-b9b2-04d1b433a23e', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 5\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'b30ce6c5-e351-4f00-97d6-ce4e2d634d95', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('7e6a25cb-d2be-4935-91be-bf9e8b4e083d', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', NULL, NULL, 'PUBLISHED', 0, 1, NULL, NULL, 'b3ae5b86-de82-4e30-8a48-59b820024a63', '2026-07-11 04:13:10', '2026-07-11 04:13:10'),
('82cee997-09e3-460e-afed-05fc90d62c54', NULL, '848cbd0a-7ff3-4d45-abc8-ca2564558ebb', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 14\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'b42aae94-b10d-488f-87f7-805afaa8c38a', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('5f458ee5-ccd7-47be-bbf8-a42c65366f65', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', NULL, NULL, 'PUBLISHED', 0, 1, NULL, NULL, 'b4e53ed8-f242-4945-8ab9-b1abf8c93c58', '2026-07-11 04:17:05', '2026-07-11 04:17:05'),
('20e4f660-c70b-4602-ab8f-0ccd9aefb4c1', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 30\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'b5e6505c-43f5-48dc-a033-890ca8820724', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('78589edc-8c29-43b3-b9b2-04d1b433a23e', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 5\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'b629bd6c-737a-4dc3-842d-8e8f9d540cb6', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('7add805b-c99a-4e33-aefb-150e23da2961', NULL, '2451f6d0-2c37-4bcd-a909-6662c862f50b', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 2\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'b64d9776-c167-42ff-b276-7f4fbf572b6a', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('e5eee978-b239-46f9-bbae-b2e08efd36cf', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat in Japanese?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Neko\"}, {\"id\": \"opt2\", \"text\": \"Inu\"}]}', '{\"correct_option_id\": \"opt1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, 'b7987054-a494-4b66-afd8-0fe72019327a', '2026-07-10 15:38:11', '2026-07-10 15:38:11'),
('54a1097d-53b7-4333-88eb-a6b44730242a', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, 'b7c72ad2-34d4-4f07-b7f9-5e84ccc64ecc', '2026-07-10 16:07:53', '2026-07-10 16:07:53'),
('53b3d5fe-a25a-4670-9bce-cc0452d76ec7', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 28\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'b7f9da58-55d4-4cb5-aa91-feb986e4c29a', '2026-07-11 03:04:04', '2026-07-11 03:04:04');
INSERT INTO `questions` (`lesson_id`, `reading_id`, `audio_asset_id`, `question_type`, `skill`, `difficulty`, `prompt_json`, `answer_key_json`, `explanation_json`, `status`, `is_ai_generated`, `version_number`, `created_by`, `reviewed_by`, `id`, `created_at`, `updated_at`) VALUES
('c06dc77a-ce37-4e9a-b01b-fbbc9696400d', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, 'b8c1a10b-eceb-4fbf-b725-136d5a84896b', '2026-07-10 16:23:51', '2026-07-10 16:23:51'),
('6b7802f7-2f34-49e7-bab8-cc60ea6e152b', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is dog in Japanese?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, 'b9ed4e0c-6784-4c2e-9beb-d80580576366', '2026-07-10 15:53:53', '2026-07-10 15:53:53'),
('a8e60cab-a07a-4ee3-a5a2-c628f614458e', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Test Q?\"}', '{\"correct\": \"A\"}', '{\"text\": \"Because A\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'bad8e756-3a64-4939-a40d-d59303dc828c', '2026-07-11 03:33:03', '2026-07-11 03:33:03'),
('87d161e1-ec62-4d74-8ca4-d576b3a4a21c', '1327f311-4094-474d-824a-39d8b15b7315', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 4\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'bcf571c8-bc75-45e4-bf1b-497a7dbd4263', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('c9c85c2c-9745-44e5-8e7a-97b222ed5779', '68bf3139-c186-484b-aa84-3a5737cfcbe8', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 9\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'bdb986b5-48fb-40f5-8914-fe1ef452d40f', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('78589edc-8c29-43b3-b9b2-04d1b433a23e', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 5\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'bddc7570-2712-4078-abc2-58ad883ed954', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('c140e128-4049-4967-8aee-7f53a1ca8672', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 15\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'be361c9c-ce40-43f5-9c42-c15ec8737c34', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('53b3d5fe-a25a-4670-9bce-cc0452d76ec7', '067fcca8-96ef-4a4b-99e8-ea2ce70aac42', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 28\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'be86e6b8-5eab-416c-8fc2-c7f0c1ab8f13', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('bfb15ae8-a948-4754-9f74-7039c966838b', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', NULL, NULL, 'PUBLISHED', 0, 1, NULL, NULL, 'bebaf24c-6813-44e4-92a4-cb227597d7c0', '2026-07-11 04:17:24', '2026-07-11 04:17:24'),
('c9cce62e-d2b1-4ea2-8428-45f96e76938f', '1c96d35b-61de-4b1f-96b6-0cedfb1b0b59', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 25\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'bf610ec2-e85c-4328-a387-45c5db3adef8', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('87d161e1-ec62-4d74-8ca4-d576b3a4a21c', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 4\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'bf6cc16d-2bbb-4251-856a-b5ec70ca2b0b', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('f3de8168-b769-4588-8b80-f4790712e72b', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 16\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'bfc5b897-e45b-41a6-8a2f-fb31e4d440a7', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('78589edc-8c29-43b3-b9b2-04d1b433a23e', NULL, 'e715390f-3da3-4693-be97-09a2c2a333af', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 5\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'bfd532d7-7276-46b6-aae6-1986dcbe319a', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('07443ee1-78b4-404e-82de-c97a03809f12', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 18\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'c0012be5-a14a-465a-a473-cea6c9fed934', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('f215a15e-ac3d-4bf0-b7ff-cb6a989f3f83', NULL, 'ced95f5e-b5a1-4eab-8841-0e48e0483015', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 21\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'c0248df5-c821-4935-ba3c-f8528cdf3e82', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('c9cce62e-d2b1-4ea2-8428-45f96e76938f', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 25\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'c21a37e5-37ca-4a25-a0e1-e61a61cbbd2f', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('ac173bab-4c54-4d6d-b9dc-3ded3c8c25d6', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, 'c2dbc501-6420-442a-93d8-a63302c89f0c', '2026-07-10 16:21:03', '2026-07-10 16:21:03'),
('8e00eafd-f89c-4303-a93c-0bf7ff315d52', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', NULL, NULL, 'PUBLISHED', 0, 1, NULL, NULL, 'c309d966-e586-4f86-8ece-9538caf44461', '2026-07-11 04:14:56', '2026-07-11 04:14:56'),
('7cea6f51-6269-481a-a61b-71a189816f59', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 29\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'c4b6f296-7d69-4351-b10f-eaebd7ac46e9', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('93d8913f-9e51-4052-a201-5c317aa8f46a', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 17\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'c4e409c2-d6cf-406b-9f5d-dc9d7c3a3226', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('7add805b-c99a-4e33-aefb-150e23da2961', '1f264fb1-7277-4512-8b64-4ace02e9f8ca', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 2\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'c5f0c828-8d7c-4e19-8f76-44188045d0f5', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('53b3d5fe-a25a-4670-9bce-cc0452d76ec7', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 28\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'c687bc64-3964-4165-95e8-f867e899d68c', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('fcb039d9-9cd1-4f1a-898c-b48e0e002c70', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is dog in Japanese?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, 'c85f81b8-5b36-458c-8326-eb2170e101e2', '2026-07-11 04:40:21', '2026-07-11 04:40:21'),
('0feee345-4eda-48eb-a5d8-b8bd6fd30915', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 19\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'c98e4bf8-a67c-4ac7-aa86-da3de4790f5d', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('c9f049ba-4a4f-4000-be39-b10cff1f7da2', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, 'c9aa4340-fb43-4776-a90f-0fb90976ecf1', '2026-07-11 04:40:21', '2026-07-11 04:40:21'),
('7add805b-c99a-4e33-aefb-150e23da2961', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 2\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'ca29235f-30f9-4db9-a7c8-5adfcd38cda7', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('0feee345-4eda-48eb-a5d8-b8bd6fd30915', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 19\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'ca4593f0-80d6-4f3e-9ea9-25fd208c0050', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('82cee997-09e3-460e-afed-05fc90d62c54', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 14\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'cad9cba8-3396-4bea-b418-679f1dc31976', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('311440a8-6fd6-492f-965c-966181e8d3b3', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 23\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'cbf8c218-9b59-419d-996e-6dd36c689cac', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('a7b56a6f-98c5-4ee8-af1f-ecc71a18f38d', NULL, '01ac9bca-44a6-469c-9a1b-c91100cc2b92', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 1\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'cc03b0bd-5b43-429d-bd45-9b0044e2f6b5', '2026-07-11 03:03:59', '2026-07-11 03:03:59'),
('c140e128-4049-4967-8aee-7f53a1ca8672', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 15\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'cc19cf06-b106-4e71-a430-90aca4b6746c', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('b2f7f273-823b-49be-a148-f7764f3d5b8c', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 24\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'cc6e947b-c58d-4579-9c9e-feb80dec6d93', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('28b761da-f6a3-4d80-8523-059b1ea49968', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 13\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'cc77217b-d289-4afe-a216-4a57f0fecee2', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('ad2b3982-1bcc-47e8-96c1-dcf38e3242fc', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 8\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'cd18191a-77c3-4514-8490-b5baf485d520', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('28b761da-f6a3-4d80-8523-059b1ea49968', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 13\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'cdaf3abf-2aae-48df-9db2-9e4005e226f8', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('a7b56a6f-98c5-4ee8-af1f-ecc71a18f38d', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 1\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'cdd5b871-c250-49de-8765-3a83baea30ea', '2026-07-11 03:03:59', '2026-07-11 03:03:59'),
('89f07a8c-bd62-422c-975e-09785e16834a', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is dog in Japanese?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, 'ce58188c-2886-40bf-a1c5-964d5fbc0172', '2026-07-10 15:54:02', '2026-07-10 15:54:02'),
('ad2b3982-1bcc-47e8-96c1-dcf38e3242fc', 'ce5aa5da-6eb8-415b-b98a-073883b6ca69', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 8\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'ce8194c0-cfac-42ad-a5da-0641128ace9c', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('82cee997-09e3-460e-afed-05fc90d62c54', 'e015fd61-e906-436e-ad42-6acd867195a9', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 14\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'cf6e6465-84e1-4185-b66c-7b89a26a7e71', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('07443ee1-78b4-404e-82de-c97a03809f12', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 18\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'd091ff96-27a1-4d4a-b055-28cd7375195e', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('12aa4576-6aa1-43d0-a1ae-9a6a0900480e', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 20\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'd0a5220f-2b4d-409f-96ba-27db85caf243', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('7cea6f51-6269-481a-a61b-71a189816f59', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 29\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'd11da9d5-e5b3-44c9-bb02-a427dd5652b8', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('854c3593-4f38-44be-8336-62d66bee956b', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 7\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'd24aa12e-8f51-4b14-9f39-296596751749', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('311440a8-6fd6-492f-965c-966181e8d3b3', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 23\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'd3c82973-2a3d-4c20-8ea5-b9ef53de4a8a', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('d9aaff72-156b-4faa-88dc-ead305ecb063', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, 'd539028b-0caf-4754-8c89-83da7b66d644', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('87d161e1-ec62-4d74-8ca4-d576b3a4a21c', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 4\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'd569e832-41e9-4a10-9952-46595048bc24', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('1f9a4447-5121-4868-96ef-3565c5056d01', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat in Japanese?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Neko\"}, {\"id\": \"opt2\", \"text\": \"Inu\"}]}', '{\"correct_option_id\": \"opt1\"}', 'null', 'APPROVED', 0, 1, '8c059ab6-5a7d-4430-bcb2-3755623a3a0a', NULL, 'd64ae426-014e-49c3-aaaa-3d61480f78a1', '2026-07-10 15:37:13', '2026-07-10 15:37:13'),
('c03c6d85-175d-481d-aea5-419e408b7e03', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 22\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'd6a5813b-c169-4147-82d6-83b57503a72f', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('38443f4a-38b3-4721-b495-0b973cf50bf2', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', NULL, NULL, 'PUBLISHED', 0, 1, NULL, NULL, 'd76266f0-a101-45b1-b812-1ab7d6a53d97', '2026-07-11 04:16:03', '2026-07-11 04:16:03'),
('a3232fac-0e05-4798-8cb0-2b676e03ab1d', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, 'd78d584c-0dd7-4a38-8c57-2d58acafcc64', '2026-07-10 16:04:54', '2026-07-10 16:04:54'),
('20e4f660-c70b-4602-ab8f-0ccd9aefb4c1', '159ffb88-40c7-46dc-acfc-1a56785c4b96', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 30\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'd803f6cc-da2e-4896-9abc-71d64a84615e', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('7add805b-c99a-4e33-aefb-150e23da2961', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 2\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'd88d686d-f9e2-4216-9ae4-387c54b03057', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('854c3593-4f38-44be-8336-62d66bee956b', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 7\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'd8991617-fee7-4042-81ba-bfce7d0021b4', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('dd364720-5487-4148-940a-792c71cfe5e1', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 11\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'd8e07236-580e-4319-a461-545139e7aaee', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('7add805b-c99a-4e33-aefb-150e23da2961', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 2\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'da73a0fd-4ce0-4364-8710-84c11eed4414', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('ad2b3982-1bcc-47e8-96c1-dcf38e3242fc', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 8\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'daa1389c-0b3d-4e45-8aec-4c8cee5c123c', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('c5ffb741-48b6-4636-a478-b038d4b245de', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, 'daa3b019-1663-4197-a20d-f79dff24eab8', '2026-07-10 16:21:02', '2026-07-10 16:21:02'),
('23ce76f1-1a44-4b98-ada9-2223d08cf5a7', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, 'dad95425-09d2-4f2f-9dc9-a6d09f443585', '2026-07-10 16:06:37', '2026-07-10 16:06:38'),
('c03c6d85-175d-481d-aea5-419e408b7e03', NULL, '4a362727-75fb-49d6-8852-f5eea7995579', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 22\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'db0055ea-b711-4ce1-83fe-5d3e01075ce5', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('53b3d5fe-a25a-4670-9bce-cc0452d76ec7', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 28\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'dd338c6e-bf07-4ffa-a95c-1444f272fdd6', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('c4e6b734-88e1-446e-8940-e228ea5d46e9', '2fd50e00-78db-490b-ae93-a3bfb75738e2', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 6\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'e24e3d20-d0af-4960-8c07-cf37fdf9ed3e', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('ad2b3982-1bcc-47e8-96c1-dcf38e3242fc', NULL, 'd90f0dfa-6cd3-4074-b284-1dd44c25c41c', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 8\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'e2604284-508f-489a-bbfc-4a3771f4aad4', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('28800418-9d7b-4c94-8912-3944ff99f4e5', NULL, '6d45a0ac-f442-496c-86bb-231825714dbc', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 27\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'e2f5f6a1-1634-4fd4-9fd5-91a52e1227c3', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('854c3593-4f38-44be-8336-62d66bee956b', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 7\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'e3e9aaa2-c1d0-46e1-819b-0bc7b717f286', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('7cea6f51-6269-481a-a61b-71a189816f59', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 29\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'e41e9bd1-0de3-4792-9d87-3915dcb69838', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('5d238a85-ac9e-4fac-ae65-502529c203f9', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', NULL, NULL, 'PUBLISHED', 0, 1, NULL, NULL, 'e4d9b520-be5f-4925-976b-a2986c7ce549', '2026-07-11 04:15:52', '2026-07-11 04:15:52'),
('f215a15e-ac3d-4bf0-b7ff-cb6a989f3f83', '430f519e-3824-4be0-a85f-f3c0f126ec2a', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 21\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'e5a80cd6-13d1-4927-a166-574607a12f52', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('0460fc56-2a5d-4159-84dd-3064b48c1e29', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', NULL, NULL, 'PUBLISHED', 0, 1, NULL, NULL, 'e60237b2-15b7-4066-89a8-fe022cd477e9', '2026-07-11 04:40:23', '2026-07-11 04:40:23'),
('78589edc-8c29-43b3-b9b2-04d1b433a23e', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 5\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'e6a5b8bf-2f1d-4c25-880d-7310068f5c18', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('51e7c25a-f4b7-47ce-b2ff-462a787cd243', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', NULL, NULL, 'PUBLISHED', 0, 1, NULL, NULL, 'e6fd328d-9c89-43a3-9c54-d9cf511d7e9b', '2026-07-11 04:17:04', '2026-07-11 04:17:04'),
('c140e128-4049-4967-8aee-7f53a1ca8672', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 15\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'e8491f80-e4ce-4703-ae03-c42e4eaf05f1', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('c03c6d85-175d-481d-aea5-419e408b7e03', 'cb19536d-9f0e-4ec2-855f-c772fdbf5a13', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 22\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'e8dd1511-f216-42c3-b5f8-c91a0fd26e10', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('87d161e1-ec62-4d74-8ca4-d576b3a4a21c', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 4\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'e9d4c24e-19bc-405f-b2ef-47db821200cc', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('dd364720-5487-4148-940a-792c71cfe5e1', '1f05444e-66b4-4684-bce4-34e6afc5dfec', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 11\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'ea149241-e0c2-4f27-a450-113a1a2caa99', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('0feee345-4eda-48eb-a5d8-b8bd6fd30915', NULL, 'a38d3eb0-e35c-4ab3-beeb-2d50fee1a4c3', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 19\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'ea6d3dfb-c34d-496b-9421-eae1b5275e96', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('20e4f660-c70b-4602-ab8f-0ccd9aefb4c1', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 30\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'eacbeac8-c104-459c-9a40-49dbb743525a', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('311440a8-6fd6-492f-965c-966181e8d3b3', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 23\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'ec539097-faa1-480d-93f2-1308a88de364', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('c9c85c2c-9745-44e5-8e7a-97b222ed5779', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 9\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'ec54d0ca-a40e-4af2-a946-c3ce4e67abd3', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('c9cce62e-d2b1-4ea2-8428-45f96e76938f', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 25\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'ec9fad02-d59e-4174-b40b-be15f732eff9', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('311440a8-6fd6-492f-965c-966181e8d3b3', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 23\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'eccf3430-cab8-40d3-899a-ab44368e2389', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('07443ee1-78b4-404e-82de-c97a03809f12', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 6 for Lesson 18\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'eda03d8f-6b80-4b98-8926-1691aade0130', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('c03c6d85-175d-481d-aea5-419e408b7e03', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 22\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'edd67ebd-38c3-463e-a5b6-81834bb72053', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('579fcbe8-22d9-4a4a-a643-76b4936f4909', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', 'PUBLISHED', 0, 1, NULL, NULL, 'ee5aaa0f-92fb-4567-8806-ad0e27170f29', '2026-07-10 16:16:05', '2026-07-10 16:16:05'),
('c9c85c2c-9745-44e5-8e7a-97b222ed5779', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 9\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'ee8f7200-0f7d-44a3-a7d7-a937c87bb681', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('f3de8168-b769-4588-8b80-f4790712e72b', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 16\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'ef886f2b-b3be-49c2-a4ea-b6ae6a6ea28c', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('0feee345-4eda-48eb-a5d8-b8bd6fd30915', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 19\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'efe8f7eb-5b47-42c8-bbb7-2f2aeeff9a8f', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('93d8913f-9e51-4052-a201-5c317aa8f46a', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 17\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'f067ce33-36ef-4a25-b093-27182510b6d1', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('cf781417-6ed4-4896-9bb5-e8cd725b6b74', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', NULL, NULL, 'PUBLISHED', 0, 1, NULL, NULL, 'f0941efb-5e52-4f78-96ec-4d7b22d521f5', '2026-07-11 04:14:10', '2026-07-11 04:14:10'),
('0feee345-4eda-48eb-a5d8-b8bd6fd30915', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 0 for Lesson 19\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'f1479c93-b802-4d58-8d1b-2ba1864d603c', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('dd364720-5487-4148-940a-792c71cfe5e1', '1f05444e-66b4-4684-bce4-34e6afc5dfec', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 11\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'f2f7c81b-8c92-4c44-ba1f-6c02565cb0fd', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('0ba7b706-6b5c-4dc3-b2f6-afe316d8de32', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', NULL, NULL, 'PUBLISHED', 0, 1, NULL, NULL, 'f300514f-5daf-44df-a071-186ee84adc95', '2026-07-11 04:19:23', '2026-07-11 04:19:23'),
('c140e128-4049-4967-8aee-7f53a1ca8672', NULL, '52515e5a-4a34-4fb2-89a8-994eed8d95ef', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 15\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'f35745b8-f8d3-403e-8353-fe5c013a9a57', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('b083f3fd-fd38-4889-ba98-98ff1dc466d7', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', NULL, NULL, 'PUBLISHED', 0, 1, NULL, NULL, 'f41f53af-c586-488f-9281-57a284312186', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('59b863ad-9a4b-43b2-bd04-063b011e7510', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 10\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'f4227d35-d067-498c-9606-fc3c55585989', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('25082036-6d59-418e-9471-ef053cf3cf31', NULL, 'b5a7e92a-7c4a-4582-a446-e6098da27b9b', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 3\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'f604d568-831d-4b0c-ad9f-d712b9c47af6', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('5ee85649-1578-49b3-9883-860604715370', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Test Q?\"}', '{\"correct\": \"A\"}', '{\"text\": \"Because A\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'f65eca1e-1bcd-4a20-af4f-600572ffc04a', '2026-07-11 04:40:22', '2026-07-11 04:40:22'),
('59b863ad-9a4b-43b2-bd04-063b011e7510', 'a60ee668-f6db-4d7b-9387-f56d64a49e31', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 10\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'f6e59c43-1fdf-4447-bb8e-2fea9d5ac20c', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('c9c85c2c-9745-44e5-8e7a-97b222ed5779', NULL, '923cab15-2756-4f92-b031-52a55996183c', 'LISTENING', 'LISTENING', 1, '{\"text\": \"Question 9 for Lesson 9\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'f74dc554-77f9-4507-baaf-222cf03c2115', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('28b761da-f6a3-4d80-8523-059b1ea49968', '3890f436-d22b-4073-95e2-699b0e2fc17c', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 8 for Lesson 13\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'f782bb94-12bd-4042-8497-4f4573a87352', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('b2f7f273-823b-49be-a148-f7764f3d5b8c', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 24\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'f9ac6bb0-0714-4045-9ea2-879748e6a1d4', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('12aa4576-6aa1-43d0-a1ae-9a6a0900480e', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 3 for Lesson 20\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'fa2afef1-8121-4ec2-9070-e66ba96bbe9e', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('93d8913f-9e51-4052-a201-5c317aa8f46a', '03ce8b04-c2e2-4b74-beae-966c615652c3', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 17\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'fbcaaec4-b7d3-4648-a048-493052af7f9a', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('28b761da-f6a3-4d80-8523-059b1ea49968', '3890f436-d22b-4073-95e2-699b0e2fc17c', NULL, 'MULTIPLE_CHOICE', 'READING', 1, '{\"text\": \"Question 7 for Lesson 13\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'fbcf1987-ef05-41d3-af77-f520d0a7235a', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('607efde2-407b-4cbe-ba82-62215000f916', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', NULL, NULL, 'PUBLISHED', 0, 1, NULL, NULL, 'fbd69614-32da-4831-8358-67b40308652d', '2026-07-11 04:14:11', '2026-07-11 04:14:11'),
('c03c6d85-175d-481d-aea5-419e408b7e03', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 1 for Lesson 22\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'fbdd232f-bdcc-4d04-9ed3-034f80707cbb', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('dd364720-5487-4148-940a-792c71cfe5e1', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 5 for Lesson 11\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'fc89d234-0ce2-4726-8c15-930953e9759f', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('2c6abc91-90dd-483a-832e-11767853418d', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', NULL, NULL, 'PUBLISHED', 0, 1, NULL, NULL, 'fca1dc24-759c-457f-81cd-915cb79282e8', '2026-07-11 04:15:52', '2026-07-11 04:15:52'),
('f215a15e-ac3d-4bf0-b7ff-cb6a989f3f83', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '{\"text\": \"Question 2 for Lesson 21\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'fcffa245-e473-4ff2-a474-045956d477d2', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('78589edc-8c29-43b3-b9b2-04d1b433a23e', NULL, NULL, 'MULTIPLE_CHOICE', 'GRAMMAR', 1, '{\"text\": \"Question 4 for Lesson 5\", \"options\": [\"A\", \"B\", \"C\", \"D\"]}', '{\"correct_option\": \"A\"}', '{\"text\": \"Explanation here\"}', 'PUBLISHED', 0, 1, NULL, NULL, 'fd4c9a35-03ed-459f-9f34-d27bc7c42d57', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('2b9069c8-66a0-43f2-9400-9c58cfa9e0e2', NULL, NULL, 'MULTIPLE_CHOICE', 'VOCABULARY', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', NULL, NULL, 'PUBLISHED', 0, 1, NULL, NULL, 'ffb3f2e3-91d4-46e8-bbe3-4fb171b0fbbe', '2026-07-11 04:13:18', '2026-07-11 04:13:18');

-- --------------------------------------------------------

--
-- Table structure for table `question_reviews`
--

CREATE TABLE `question_reviews` (
  `question_id` varchar(36) NOT NULL,
  `reviewer_id` varchar(36) DEFAULT NULL,
  `status_given` enum('DRAFT','AUTO_VALIDATED','IN_REVIEW','NEEDS_REVISION','APPROVED','PUBLISHED','REJECTED','ARCHIVED') NOT NULL,
  `notes` text DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `question_revisions`
--

CREATE TABLE `question_revisions` (
  `question_id` varchar(36) NOT NULL,
  `version_number` int(11) NOT NULL,
  `prompt_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`prompt_json`)),
  `answer_key_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`answer_key_json`)),
  `explanation_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`explanation_json`)),
  `created_by` varchar(36) DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `question_revisions`
--

INSERT INTO `question_revisions` (`question_id`, `version_number`, `prompt_json`, `answer_key_json`, `explanation_json`, `created_by`, `id`, `created_at`, `updated_at`) VALUES
('bebaf24c-6813-44e4-92a4-cb227597d7c0', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', '\"{\\\"correct_answer\\\": \\\"A\\\"}\"', NULL, NULL, '00466d38-4cdf-498f-a739-f294b8a1b1db', '2026-07-11 04:17:24', '2026-07-11 04:17:24'),
('f65eca1e-1bcd-4a20-af4f-600572ffc04a', 1, '{\"text\": \"Test Q?\"}', '{\"correct\": \"A\"}', '{\"text\": \"Because A\"}', NULL, '0803a459-cfc9-473b-b3c0-64ce2b326d87', '2026-07-11 04:40:22', '2026-07-11 04:40:22'),
('41cc3169-ed85-4a2c-8e81-404199c18f4b', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', NULL, '08a1cc47-4be3-43ad-b043-655106596648', '2026-07-11 04:40:21', '2026-07-11 04:40:21'),
('0545bbb4-76c4-441a-add5-7450dc1687df', 1, '{\"text\": \"What is cat in Japanese?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Neko\"}, {\"id\": \"opt2\", \"text\": \"Inu\"}]}', '{\"correct_option_id\": \"opt1\"}', 'null', NULL, '16d22890-e3c1-462b-93a4-9687c867ce60', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('36120889-4130-4d31-84ce-a1212482eecd', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', '\"{\\\"correct_answer\\\": \\\"A\\\"}\"', NULL, NULL, '171198a8-3733-4fc4-b9da-20c400c005e3', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('d539028b-0caf-4754-8c89-83da7b66d644', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', NULL, '18397f9e-7184-4d68-b3ad-1085b36732d5', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('ce58188c-2886-40bf-a1c5-964d5fbc0172', 1, '{\"text\": \"What is dog in Japanese?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt1\"}', 'null', NULL, '19b300cc-4f51-4fdc-850b-248e2960b75f', '2026-07-10 15:54:02', '2026-07-10 15:54:02'),
('2087477d-f6d5-4b57-9cd9-56891f041275', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', NULL, '1aca22f5-7408-4b9f-b0c3-b9680e24aae9', '2026-07-10 16:06:23', '2026-07-10 16:06:23'),
('b7c72ad2-34d4-4f07-b7f9-5e84ccc64ecc', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', NULL, '1af7ebe2-276f-48ee-85ca-ba757ec4b534', '2026-07-10 16:07:53', '2026-07-10 16:07:53'),
('b9ed4e0c-6784-4c2e-9beb-d80580576366', 1, '{\"text\": \"What is dog in Japanese?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt1\"}', 'null', NULL, '1be987d8-1944-46e4-a948-d838a4c75ee8', '2026-07-10 15:53:53', '2026-07-10 15:53:53'),
('3aa219b5-a44b-42f2-961c-bbff31578ec9', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', '\"{\\\"correct_answer\\\": \\\"A\\\"}\"', NULL, NULL, '1c0fa447-a649-47c5-9296-77b6770502c1', '2026-07-11 04:17:24', '2026-07-11 04:17:24'),
('09cbf8f4-8c87-464d-bfbc-f1fe201c2bab', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', '\"{\\\"correct_answer\\\": \\\"A\\\"}\"', NULL, NULL, '1cc253fb-abf2-437f-8f1d-be40a896ca94', '2026-07-11 04:13:10', '2026-07-11 04:13:10'),
('6dd9bd3c-8f59-4ad3-b370-21a23c108c7e', 1, '{\"text\": \"Test Q?\"}', '{\"correct\": \"A\"}', '{\"text\": \"Because A\"}', NULL, '1ef1744d-0091-4b86-8bc4-bc45e2b7f402', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('3a389d63-5c69-4506-ac15-e0c70c3c5724', 1, '{\"text\": \"What is dog in Japanese?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt1\"}', 'null', NULL, '20a23414-e6af-4a14-8879-7217ea766adf', '2026-07-10 15:55:00', '2026-07-10 15:55:00'),
('5b97d071-9021-4e16-a5f2-a13cbcd2f086', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', '\"{\\\"correct_answer\\\": \\\"A\\\"}\"', NULL, NULL, '28827c9a-48d6-4ce8-9c36-e34093badc5a', '2026-07-11 04:16:03', '2026-07-11 04:16:03'),
('e60237b2-15b7-4066-89a8-fe022cd477e9', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', '\"{\\\"correct_answer\\\": \\\"A\\\"}\"', NULL, NULL, '2bfa6125-7110-45df-a2e8-24f66b286d8c', '2026-07-11 04:40:23', '2026-07-11 04:40:23'),
('f0941efb-5e52-4f78-96ec-4d7b22d521f5', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', '\"{\\\"correct_answer\\\": \\\"A\\\"}\"', NULL, NULL, '319fa6cc-0053-43dd-b070-345237e69910', '2026-07-11 04:14:10', '2026-07-11 04:14:10'),
('c85f81b8-5b36-458c-8326-eb2170e101e2', 1, '{\"text\": \"What is dog in Japanese?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt1\"}', 'null', NULL, '36056968-2af0-4d8f-8cf0-d468248f37c8', '2026-07-11 04:40:21', '2026-07-11 04:40:21'),
('65cf5938-6f10-4710-a664-d5b47940e9da', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', NULL, '3783a63a-84c6-4106-a4e0-8d1eabd56dcd', '2026-07-10 16:20:01', '2026-07-10 16:20:01'),
('c2dbc501-6420-442a-93d8-a63302c89f0c', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', NULL, '38bacbd9-e7d8-4447-9464-b2fa41e94e32', '2026-07-10 16:21:03', '2026-07-10 16:21:03'),
('382d5b2d-404d-4191-bb09-fa7a7bf5bc75', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', NULL, '3aad657e-1b63-44a6-b5d7-1c503069fced', '2026-07-10 16:09:32', '2026-07-10 16:09:32'),
('fbd69614-32da-4831-8358-67b40308652d', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', '\"{\\\"correct_answer\\\": \\\"A\\\"}\"', NULL, NULL, '3aaff675-552c-48cf-923a-1d889a61036e', '2026-07-11 04:14:11', '2026-07-11 04:14:11'),
('35dc7a68-c00f-47bc-a444-aa37cddb3b62', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', NULL, '3d4d64b0-9163-42bb-80ad-b186cceeb811', '2026-07-10 16:11:00', '2026-07-10 16:11:00'),
('1f9d7e8d-4189-41ab-befe-22b7b3167e8d', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', NULL, '41ccaef1-a152-4017-b04c-ce39c2996a6c', '2026-07-10 16:16:06', '2026-07-10 16:16:06'),
('b3ae5b86-de82-4e30-8a48-59b820024a63', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', '\"{\\\"correct_answer\\\": \\\"A\\\"}\"', NULL, NULL, '4243b499-5daa-4d47-9c71-607b3a0aa67a', '2026-07-11 04:13:10', '2026-07-11 04:13:10'),
('ac0fcdc1-7c67-4c8d-9b38-3c894f1f74b9', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', NULL, '4a6cb776-3573-4e9b-add9-4704f26b3321', '2026-07-10 16:07:53', '2026-07-10 16:07:53'),
('119d69c5-7b53-43d2-9677-b560bdaec6e3', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', NULL, '4f5901ac-8ed2-4e09-8cfa-cc2d21dea7ee', '2026-07-10 16:09:49', '2026-07-10 16:09:49'),
('e4d9b520-be5f-4925-976b-a2986c7ce549', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', '\"{\\\"correct_answer\\\": \\\"A\\\"}\"', NULL, NULL, '5081b86f-e371-435e-b5b4-b963a4857b94', '2026-07-11 04:15:52', '2026-07-11 04:15:52'),
('b7987054-a494-4b66-afd8-0fe72019327a', 1, '{\"text\": \"What is cat in Japanese?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Neko\"}, {\"id\": \"opt2\", \"text\": \"Inu\"}]}', '{\"correct_option_id\": \"opt1\"}', 'null', NULL, '5ecc61de-8603-414e-95e1-e4678e65748c', '2026-07-10 15:38:11', '2026-07-10 15:38:11'),
('a2ada812-3aa7-405b-9650-108405f2f1a4', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', '\"{\\\"correct_answer\\\": \\\"A\\\"}\"', NULL, NULL, '63134b83-ed9f-45a7-95c8-5b6f9ee2ca8f', '2026-07-11 04:40:22', '2026-07-11 04:40:22'),
('f300514f-5daf-44df-a071-186ee84adc95', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', '\"{\\\"correct_answer\\\": \\\"A\\\"}\"', NULL, NULL, '633cbdde-416c-438e-adab-a3cc1dce3e88', '2026-07-11 04:19:23', '2026-07-11 04:19:23'),
('b4e53ed8-f242-4945-8ab9-b1abf8c93c58', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', '\"{\\\"correct_answer\\\": \\\"A\\\"}\"', NULL, NULL, '68c02cc1-9497-4f90-826d-3bd74feca1de', '2026-07-11 04:17:05', '2026-07-11 04:17:05'),
('9323f1bb-fbce-42f1-80ad-f7c66315a06b', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', NULL, '6a4ab4d8-fc05-4143-b95d-331cf6c8c067', '2026-07-10 16:23:51', '2026-07-10 16:23:51'),
('d76266f0-a101-45b1-b812-1ab7d6a53d97', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', '\"{\\\"correct_answer\\\": \\\"A\\\"}\"', NULL, NULL, '6dcabe0d-4e4e-4504-99b0-44871178f974', '2026-07-11 04:16:03', '2026-07-11 04:16:03'),
('519b697f-e52a-48d2-878a-1f94544084ac', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', NULL, '7073986c-b725-4777-be84-b88cb8904bc9', '2026-07-10 16:06:22', '2026-07-10 16:06:22'),
('c309d966-e586-4f86-8ece-9538caf44461', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', '\"{\\\"correct_answer\\\": \\\"A\\\"}\"', NULL, NULL, '70f8b3e4-cc10-4bd5-befd-40c3932d762e', '2026-07-11 04:14:56', '2026-07-11 04:14:56'),
('a6ebab7a-79bf-41f1-b447-fa307b8d71be', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', '\"{\\\"correct_answer\\\": \\\"A\\\"}\"', NULL, NULL, '7c77a0cf-3f90-4ab4-bf87-73f393379018', '2026-07-11 04:13:18', '2026-07-11 04:13:18'),
('a7e9dff5-b3e5-420d-8879-344d953767b1', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', NULL, '83a779d3-bf0e-4ce2-86b7-24b935558cd5', '2026-07-10 16:04:37', '2026-07-10 16:04:37'),
('3e924d1a-0431-4f4c-8911-814e6ab38ffb', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', NULL, '85b4720e-37b2-4234-88ec-8c8713c3b45e', '2026-07-10 16:09:49', '2026-07-10 16:09:49'),
('ae9b8443-fcbb-497b-8d2a-424499ef73f2', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', NULL, '85b7eb9c-b60c-4a57-8ed5-8640b0ef99ea', '2026-07-10 16:20:00', '2026-07-10 16:20:00'),
('1d1645b1-a9a0-44fa-ad92-338df6f05cdb', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', '\"{\\\"correct_answer\\\": \\\"A\\\"}\"', NULL, NULL, '875c430e-6dbb-4bde-b842-c909ba4eb0c1', '2026-07-11 04:14:04', '2026-07-11 04:14:04'),
('035398f3-0cf4-43c7-85e9-db38f9a12295', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', NULL, '8a14d384-dd49-4473-ac3b-81c14ed2dc86', '2026-07-10 16:15:48', '2026-07-10 16:15:48'),
('992a54c3-f35f-46ca-b495-c7707a9b2cc3', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', NULL, '8acaa2ea-0a1b-4ca7-9bda-07a1aaed9fcb', '2026-07-10 16:14:03', '2026-07-10 16:14:03'),
('1f939f4b-5740-4cb7-b4c2-ee6d7541fef0', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', NULL, '932128ea-1cbe-4d0d-9d75-d505bb56886a', '2026-07-10 16:23:43', '2026-07-10 16:23:43'),
('10ed0932-e587-421b-9e05-54e2f9175b2a', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', NULL, '9905abb7-154c-483e-a2d7-773ee7f836fe', '2026-07-10 16:04:36', '2026-07-10 16:04:36'),
('f41f53af-c586-488f-9281-57a284312186', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', '\"{\\\"correct_answer\\\": \\\"A\\\"}\"', NULL, NULL, '9dc2cef0-0855-432a-8d21-89d46dcf2116', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('0d97dabc-3fd1-4f4a-8198-a9de43395723', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', '\"{\\\"correct_answer\\\": \\\"A\\\"}\"', NULL, NULL, '9f384b52-5c86-4e2f-a645-0f49417ea0d1', '2026-07-11 04:14:04', '2026-07-11 04:14:04'),
('dad95425-09d2-4f2f-9dc9-a6d09f443585', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', NULL, 'a0b99a0c-5f4a-40c1-a7d6-793db2f43ad1', '2026-07-10 16:06:38', '2026-07-10 16:06:38'),
('d78d584c-0dd7-4a38-8c57-2d58acafcc64', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', NULL, 'a318fd12-24ad-4837-8a09-f11003c5017c', '2026-07-10 16:04:54', '2026-07-10 16:04:54'),
('76d3c72a-a5e2-4f06-8701-aae54d5cc47c', 1, '{\"text\": \"Test Q?\"}', '{\"correct\": \"A\"}', '{\"text\": \"Because A\"}', NULL, 'a43d1cdf-58f2-4689-b78a-71c51550ae9a', '2026-07-11 03:32:51', '2026-07-11 03:32:51'),
('b8c1a10b-eceb-4fbf-b725-136d5a84896b', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', NULL, 'aa8b62fe-cbbb-4e0f-b69d-c098832cc013', '2026-07-10 16:23:51', '2026-07-10 16:23:51'),
('79a546c5-bd4a-464a-9f7d-17b6494979ea', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', NULL, 'ad31ad50-bcda-49fd-99d6-cfa68b14f653', '2026-07-10 16:11:00', '2026-07-10 16:11:00'),
('fca1dc24-759c-457f-81cd-915cb79282e8', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', '\"{\\\"correct_answer\\\": \\\"A\\\"}\"', NULL, NULL, 'b34740ef-80ca-44cf-8950-76ad75ae78e7', '2026-07-11 04:15:52', '2026-07-11 04:15:52'),
('4247da87-9fa5-4ac3-8431-3a447406a1a1', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', NULL, 'b4ac8a73-e107-4bba-b247-a1245b9dd440', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('e6fd328d-9c89-43a3-9c54-d9cf511d7e9b', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', '\"{\\\"correct_answer\\\": \\\"A\\\"}\"', NULL, NULL, 'ba43ac54-60c7-4a71-8268-edb78b86a575', '2026-07-11 04:17:04', '2026-07-11 04:17:04'),
('8cfe6fba-4dd3-4947-a5a1-25c96465fbe6', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', NULL, 'bf024c0e-e0b8-40fb-aeb5-0afb689dc2dc', '2026-07-10 16:23:43', '2026-07-10 16:23:43'),
('213f3134-38ca-4d7a-ae7e-60cdb5a0c7e4', 1, '{\"text\": \"What is cat in Japanese?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Neko\"}, {\"id\": \"opt2\", \"text\": \"Inu\"}]}', '{\"correct_option_id\": \"opt1\"}', 'null', NULL, 'ca6b35ce-4624-465b-8031-ecc6b8533a9d', '2026-07-11 04:40:22', '2026-07-11 04:40:22'),
('bad8e756-3a64-4939-a40d-d59303dc828c', 1, '{\"text\": \"Test Q?\"}', '{\"correct\": \"A\"}', '{\"text\": \"Because A\"}', NULL, 'cebac797-1da5-4681-b52c-bc58e8288112', '2026-07-11 03:33:03', '2026-07-11 03:33:03'),
('ee5aaa0f-92fb-4567-8806-ad0e27170f29', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', NULL, 'cf985ae3-2306-482b-98fe-5c3b68864458', '2026-07-10 16:16:05', '2026-07-10 16:16:05'),
('daa3b019-1663-4197-a20d-f79dff24eab8', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', NULL, 'd26d8fa1-6fef-458a-a47f-02447e39d5cc', '2026-07-10 16:21:02', '2026-07-10 16:21:02'),
('0cd711be-8318-44d8-917a-112e34b56b34', 1, '{\"text\": \"What is cat in Japanese?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Neko\"}, {\"id\": \"opt2\", \"text\": \"Inu\"}]}', '{\"correct_option_id\": \"opt1\"}', 'null', NULL, 'd83ee5b9-65f4-4c63-9695-e64f97f3a870', '2026-07-10 15:38:04', '2026-07-10 15:38:04'),
('408b1543-20f0-4734-a6af-7fc0c7d3ad57', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', NULL, 'd9e51d7a-3e17-444b-8e4c-646ab43d59bb', '2026-07-10 16:04:53', '2026-07-10 16:04:53'),
('2fa28439-851b-4422-ab37-924c167695cb', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', NULL, 'dc2cba9b-8530-4c8c-b9ff-faa2290b3d19', '2026-07-10 16:15:48', '2026-07-10 16:15:48'),
('ffb3f2e3-91d4-46e8-bbe3-4fb171b0fbbe', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', '\"{\\\"correct_answer\\\": \\\"A\\\"}\"', NULL, NULL, 'de696ccb-4fbc-4911-9047-855c4d73c75e', '2026-07-11 04:13:18', '2026-07-11 04:13:18'),
('6a9d73b7-2e1e-447d-8794-0db2d583e3b4', 1, '{\"text\": \"What is dog in Japanese?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt1\"}', 'null', NULL, 'dfe90224-1f93-4a57-99d9-65182eb1be17', '2026-07-10 15:54:53', '2026-07-10 15:54:53'),
('ac2c593d-bbbd-4268-8304-5bbf99124ce4', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', '\"{\\\"correct_answer\\\": \\\"A\\\"}\"', NULL, NULL, 'e3bcdaa0-57ab-4787-9b62-1991d679aac7', '2026-07-11 04:19:23', '2026-07-11 04:19:23'),
('5a351ed1-b088-4d64-9111-a1cd66bb422f', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', '\"{\\\"correct_answer\\\": \\\"A\\\"}\"', NULL, NULL, 'e4f5e55f-437c-4a17-aff4-1aef3b3af4a9', '2026-07-11 04:14:55', '2026-07-11 04:14:55'),
('11ac7036-d3f1-4ae6-8fef-76fed00df706', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', NULL, 'ed707d20-cb82-43e0-8737-f630c230a035', '2026-07-10 16:09:32', '2026-07-10 16:09:32'),
('607cfe2a-f5f7-46fb-a746-5c83a629f7e1', 1, '{\"text\": \"What is dog in Japanese?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt1\"}', 'null', NULL, 'ede959cf-33e2-478e-95dc-c870f97bccc4', '2026-07-11 04:22:40', '2026-07-11 04:22:40'),
('9714c8ca-15dd-488a-8273-9afeab488f39', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', '\"{\\\"correct_answer\\\": \\\"A\\\"}\"', NULL, NULL, 'f1fac076-1ce6-4599-9835-78edb6335d46', '2026-07-11 04:16:50', '2026-07-11 04:16:50'),
('395dd007-0f0d-4e4c-afb7-8618505c45cc', 1, '{\"text\": \"Particle?\", \"options\": [{\"id\": \"1\", \"text\": \"wa\"}, {\"id\": \"2\", \"text\": \"ga\"}]}', '{\"correct_option_id\": \"1\"}', 'null', NULL, 'f2fe59b8-66d0-465e-9387-0532a6df15d4', '2026-07-10 16:06:38', '2026-07-10 16:06:38'),
('1cac58fc-d75f-4adb-80da-18adaf75bd1a', 1, '\"{\\\"text\\\": \\\"Sim Question\\\"}\"', '\"{\\\"correct_answer\\\": \\\"A\\\"}\"', NULL, NULL, 'f5daad08-ffa5-4d5b-9099-5194013404a6', '2026-07-11 04:16:50', '2026-07-11 04:16:50'),
('54de490e-c725-419b-91c0-0082cbc0d8c9', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', NULL, 'f72cd3ef-83e6-407e-8b3b-bb90086fd3bb', '2026-07-10 16:14:03', '2026-07-10 16:14:03'),
('c9aa4340-fb43-4776-a90f-0fb90976ecf1', 1, '{\"text\": \"What is cat?\", \"options\": [{\"id\": \"opt1\", \"text\": \"Inu\"}, {\"id\": \"opt2\", \"text\": \"Neko\"}]}', '{\"correct_option_id\": \"opt2\"}', 'null', NULL, 'ff6fc3db-ab4c-4c5b-9dee-db6e061eede2', '2026-07-11 04:40:21', '2026-07-11 04:40:21');

-- --------------------------------------------------------

--
-- Table structure for table `readings`
--

CREATE TABLE `readings` (
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `translation` text DEFAULT NULL,
  `lesson_id` varchar(36) DEFAULT NULL,
  `audio_id` varchar(36) DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `readings`
--

INSERT INTO `readings` (`title`, `content`, `translation`, `lesson_id`, `audio_id`, `id`, `created_at`, `updated_at`) VALUES
('休日の予定 6', '明日は日曜日です。私は友達と映画を見に行きます。その後、レストランで昼ごはんを食べます。午後はデパートで買い物をします。とても楽しみです。', 'Tomorrow is Sunday. I will go see a movie with my friend. After that, we will eat lunch at a restaurant. In the afternoon, we will go shopping at a department store. I am looking forward to it.', '93d8913f-9e51-4052-a201-5c317aa8f46a', NULL, '03ce8b04-c2e2-4b74-beae-966c615652c3', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('日本語の勉強 4', '私は毎日日本語を勉強しています。漢字は難しいですが、面白いです。週末はアニメを見て日本語を聞きます。いつか日本に行きたいです。', 'I study Japanese every day. Kanji is difficult, but interesting. On weekends, I watch anime and listen to Japanese. I want to go to Japan someday.', 'bf8862ab-3bfe-42bd-805b-613a5537fdce', NULL, '0624cf0f-7b65-4f7c-9191-f4add0b178be', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('私の家族 10', '私の家族は4人です。父と母と姉と私です。父は会社員です。母は先生です。姉は大学生です。私は高校生です。私達は東京に住んでいます。', 'My family has 4 people. My father, mother, older sister, and me. My father is an office worker. My mother is a teacher. My older sister is a university student. I am a high school student. We live in Tokyo.', '53b3d5fe-a25a-4670-9bce-cc0452d76ec7', NULL, '067fcca8-96ef-4a4b-99e8-ea2ce70aac42', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('私の家族 2', '私の家族は4人です。父と母と姉と私です。父は会社員です。母は先生です。姉は大学生です。私は高校生です。私達は東京に住んでいます。', 'My family has 4 people. My father, mother, older sister, and me. My father is an office worker. My mother is a teacher. My older sister is a university student. I am a high school student. We live in Tokyo.', '87d161e1-ec62-4d74-8ca4-d576b3a4a21c', NULL, '1327f311-4094-474d-824a-39d8b15b7315', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('日本語の勉強 10', '私は毎日日本語を勉強しています。漢字は難しいですが、面白いです。週末はアニメを見て日本語を聞きます。いつか日本に行きたいです。', 'I study Japanese every day. Kanji is difficult, but interesting. On weekends, I watch anime and listen to Japanese. I want to go to Japan someday.', '20e4f660-c70b-4602-ab8f-0ccd9aefb4c1', NULL, '159ffb88-40c7-46dc-acfc-1a56785c4b96', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('休日の予定 8', '明日は日曜日です。私は友達と映画を見に行きます。その後、レストランで昼ごはんを食べます。午後はデパートで買い物をします。とても楽しみです。', 'Tomorrow is Sunday. I will go see a movie with my friend. After that, we will eat lunch at a restaurant. In the afternoon, we will go shopping at a department store. I am looking forward to it.', '311440a8-6fd6-492f-965c-966181e8d3b3', NULL, '1aee8b0c-6b21-4a75-9519-6391bb4c8e2f', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('私の家族 9', '私の家族は4人です。父と母と姉と私です。父は会社員です。母は先生です。姉は大学生です。私は高校生です。私達は東京に住んでいます。', 'My family has 4 people. My father, mother, older sister, and me. My father is an office worker. My mother is a teacher. My older sister is a university student. I am a high school student. We live in Tokyo.', 'c9cce62e-d2b1-4ea2-8428-45f96e76938f', NULL, '1c96d35b-61de-4b1f-96b6-0cedfb1b0b59', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('日本語の勉強 5', '私は毎日日本語を勉強しています。漢字は難しいですが、面白いです。週末はアニメを見て日本語を聞きます。いつか日本に行きたいです。', 'I study Japanese every day. Kanji is difficult, but interesting. On weekends, I watch anime and listen to Japanese. I want to go to Japan someday.', 'c140e128-4049-4967-8aee-7f53a1ca8672', NULL, '1cd90371-df3c-447a-a26a-79177185c732', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('日本語の勉強 6', '私は毎日日本語を勉強しています。漢字は難しいですが、面白いです。週末はアニメを見て日本語を聞きます。いつか日本に行きたいです。', 'I study Japanese every day. Kanji is difficult, but interesting. On weekends, I watch anime and listen to Japanese. I want to go to Japan someday.', '07443ee1-78b4-404e-82de-c97a03809f12', NULL, '1cddec41-8de8-4021-a14a-a9ddca9d198c', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('休日の予定 4', '明日は日曜日です。私は友達と映画を見に行きます。その後、レストランで昼ごはんを食べます。午後はデパートで買い物をします。とても楽しみです。', 'Tomorrow is Sunday. I will go see a movie with my friend. After that, we will eat lunch at a restaurant. In the afternoon, we will go shopping at a department store. I am looking forward to it.', 'dd364720-5487-4148-940a-792c71cfe5e1', NULL, '1f05444e-66b4-4684-bce4-34e6afc5dfec', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('休日の予定', '明日は日曜日です。私は友達と映画を見に行きます。その後、レストランで昼ごはんを食べます。午後はデパートで買い物をします。とても楽しみです。', 'Tomorrow is Sunday. I will go see a movie with my friend. After that, we will eat lunch at a restaurant. In the afternoon, we will go shopping at a department store. I am looking forward to it.', '7add805b-c99a-4e33-aefb-150e23da2961', NULL, '1f264fb1-7277-4512-8b64-4ace02e9f8ca', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('休日の予定 9', '明日は日曜日です。私は友達と映画を見に行きます。その後、レストランで昼ごはんを食べます。午後はデパートで買い物をします。とても楽しみです。', 'Tomorrow is Sunday. I will go see a movie with my friend. After that, we will eat lunch at a restaurant. In the afternoon, we will go shopping at a department store. I am looking forward to it.', '3eb78103-00ad-4e58-be6d-ea5ef58d99bc', NULL, '211ac5b8-a528-4811-94e0-be6220b2ded5', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('日本語の勉強', '私は毎日日本語を勉強しています。漢字は難しいですが、面白いです。週末はアニメを見て日本語を聞きます。いつか日本に行きたいです。', 'I study Japanese every day. Kanji is difficult, but interesting. On weekends, I watch anime and listen to Japanese. I want to go to Japan someday.', '25082036-6d59-418e-9471-ef053cf3cf31', NULL, '22ed8750-b928-4842-8846-30b2dd5cad77', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('日本語の勉強 2', '私は毎日日本語を勉強しています。漢字は難しいですが、面白いです。週末はアニメを見て日本語を聞きます。いつか日本に行きたいです。', 'I study Japanese every day. Kanji is difficult, but interesting. On weekends, I watch anime and listen to Japanese. I want to go to Japan someday.', 'c4e6b734-88e1-446e-8940-e228ea5d46e9', NULL, '2fd50e00-78db-490b-ae93-a3bfb75738e2', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('私の家族 5', '私の家族は4人です。父と母と姉と私です。父は会社員です。母は先生です。姉は大学生です。私は高校生です。私達は東京に住んでいます。', 'My family has 4 people. My father, mother, older sister, and me. My father is an office worker. My mother is a teacher. My older sister is a university student. I am a high school student. We live in Tokyo.', '28b761da-f6a3-4d80-8523-059b1ea49968', NULL, '3890f436-d22b-4073-95e2-699b0e2fc17c', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('日本語の勉強 7', '私は毎日日本語を勉強しています。漢字は難しいですが、面白いです。週末はアニメを見て日本語を聞きます。いつか日本に行きたいです。', 'I study Japanese every day. Kanji is difficult, but interesting. On weekends, I watch anime and listen to Japanese. I want to go to Japan someday.', 'f215a15e-ac3d-4bf0-b7ff-cb6a989f3f83', NULL, '430f519e-3824-4be0-a85f-f3c0f126ec2a', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('私の家族 7', '私の家族は4人です。父と母と姉と私です。父は会社員です。母は先生です。姉は大学生です。私は高校生です。私達は東京に住んでいます。', 'My family has 4 people. My father, mother, older sister, and me. My father is an office worker. My mother is a teacher. My older sister is a university student. I am a high school student. We live in Tokyo.', '0feee345-4eda-48eb-a5d8-b8bd6fd30915', NULL, '4eeffba1-94f3-486d-8730-22754234acc4', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('日本語の勉強 9', '私は毎日日本語を勉強しています。漢字は難しいですが、面白いです。週末はアニメを見て日本語を聞きます。いつか日本に行きたいです。', 'I study Japanese every day. Kanji is difficult, but interesting. On weekends, I watch anime and listen to Japanese. I want to go to Japan someday.', '28800418-9d7b-4c94-8912-3944ff99f4e5', NULL, '59a22486-4951-4129-a8c9-d94aafbf413b', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('日本語の勉強 8', '私は毎日日本語を勉強しています。漢字は難しいですが、面白いです。週末はアニメを見て日本語を聞きます。いつか日本に行きたいです。', 'I study Japanese every day. Kanji is difficult, but interesting. On weekends, I watch anime and listen to Japanese. I want to go to Japan someday.', 'b2f7f273-823b-49be-a148-f7764f3d5b8c', NULL, '61a22f0f-10cb-49bd-82d1-3374a64ab903', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('日本語の勉強 3', '私は毎日日本語を勉強しています。漢字は難しいですが、面白いです。週末はアニメを見て日本語を聞きます。いつか日本に行きたいです。', 'I study Japanese every day. Kanji is difficult, but interesting. On weekends, I watch anime and listen to Japanese. I want to go to Japan someday.', 'c9c85c2c-9745-44e5-8e7a-97b222ed5779', NULL, '68bf3139-c186-484b-aa84-3a5737cfcbe8', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('休日の予定 7', '明日は日曜日です。私は友達と映画を見に行きます。その後、レストランで昼ごはんを食べます。午後はデパートで買い物をします。とても楽しみです。', 'Tomorrow is Sunday. I will go see a movie with my friend. After that, we will eat lunch at a restaurant. In the afternoon, we will go shopping at a department store. I am looking forward to it.', '12aa4576-6aa1-43d0-a1ae-9a6a0900480e', NULL, '7696211f-bf5e-427d-b64d-019df5926b54', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('私の家族 6', '私の家族は4人です。父と母と姉と私です。父は会社員です。母は先生です。姉は大学生です。私は高校生です。私達は東京に住んでいます。', 'My family has 4 people. My father, mother, older sister, and me. My father is an office worker. My mother is a teacher. My older sister is a university student. I am a high school student. We live in Tokyo.', 'f3de8168-b769-4588-8b80-f4790712e72b', NULL, '820f0e5c-7248-4562-b09a-594b736d55a9', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('私の家族 3', '私の家族は4人です。父と母と姉と私です。父は会社員です。母は先生です。姉は大学生です。私は高校生です。私達は東京に住んでいます。', 'My family has 4 people. My father, mother, older sister, and me. My father is an office worker. My mother is a teacher. My older sister is a university student. I am a high school student. We live in Tokyo.', '854c3593-4f38-44be-8336-62d66bee956b', NULL, '897f4834-70a5-4861-b6c8-aa5f1af1eeea', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('私の家族 4', '私の家族は4人です。父と母と姉と私です。父は会社員です。母は先生です。姉は大学生です。私は高校生です。私達は東京に住んでいます。', 'My family has 4 people. My father, mother, older sister, and me. My father is an office worker. My mother is a teacher. My older sister is a university student. I am a high school student. We live in Tokyo.', '59b863ad-9a4b-43b2-bd04-063b011e7510', NULL, 'a60ee668-f6db-4d7b-9387-f56d64a49e31', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('私の家族 8', '私の家族は4人です。父と母と姉と私です。父は会社員です。母は先生です。姉は大学生です。私は高校生です。私達は東京に住んでいます。', 'My family has 4 people. My father, mother, older sister, and me. My father is an office worker. My mother is a teacher. My older sister is a university student. I am a high school student. We live in Tokyo.', 'c03c6d85-175d-481d-aea5-419e408b7e03', NULL, 'cb19536d-9f0e-4ec2-855f-c772fdbf5a13', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('休日の予定 3', '明日は日曜日です。私は友達と映画を見に行きます。その後、レストランで昼ごはんを食べます。午後はデパートで買い物をします。とても楽しみです。', 'Tomorrow is Sunday. I will go see a movie with my friend. After that, we will eat lunch at a restaurant. In the afternoon, we will go shopping at a department store. I am looking forward to it.', 'ad2b3982-1bcc-47e8-96c1-dcf38e3242fc', NULL, 'ce5aa5da-6eb8-415b-b98a-073883b6ca69', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('私の家族', '私の家族は4人です。父と母と姉と私です。父は会社員です。母は先生です。姉は大学生です。私は高校生です。私達は東京に住んでいます。', 'My family has 4 people. My father, mother, older sister, and me. My father is an office worker. My mother is a teacher. My older sister is a university student. I am a high school student. We live in Tokyo.', 'a7b56a6f-98c5-4ee8-af1f-ecc71a18f38d', NULL, 'db82e44e-c3f5-4dd8-b6a4-d58aaaeef71a', '2026-07-11 03:02:52', '2026-07-11 03:02:52'),
('休日の予定 5', '明日は日曜日です。私は友達と映画を見に行きます。その後、レストランで昼ごはんを食べます。午後はデパートで買い物をします。とても楽しみです。', 'Tomorrow is Sunday. I will go see a movie with my friend. After that, we will eat lunch at a restaurant. In the afternoon, we will go shopping at a department store. I am looking forward to it.', '82cee997-09e3-460e-afed-05fc90d62c54', NULL, 'e015fd61-e906-436e-ad42-6acd867195a9', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('休日の予定 2', '明日は日曜日です。私は友達と映画を見に行きます。その後、レストランで昼ごはんを食べます。午後はデパートで買い物をします。とても楽しみです。', 'Tomorrow is Sunday. I will go see a movie with my friend. After that, we will eat lunch at a restaurant. In the afternoon, we will go shopping at a department store. I am looking forward to it.', '78589edc-8c29-43b3-b9b2-04d1b433a23e', NULL, 'ec48baa2-4fe5-4b94-abcc-47c83d11813f', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('休日の予定 10', '明日は日曜日です。私は友達と映画を見に行きます。その後、レストランで昼ごはんを食べます。午後はデパートで買い物をします。とても楽しみです。', 'Tomorrow is Sunday. I will go see a movie with my friend. After that, we will eat lunch at a restaurant. In the afternoon, we will go shopping at a department store. I am looking forward to it.', '7cea6f51-6269-481a-a61b-71a189816f59', NULL, 'ed63563d-3add-40de-83fb-e80a376a7210', '2026-07-11 03:04:04', '2026-07-11 03:04:04');

-- --------------------------------------------------------

--
-- Table structure for table `refreshtokens`
--

CREATE TABLE `refreshtokens` (
  `user_id` varchar(36) NOT NULL,
  `token_hash` varchar(255) NOT NULL,
  `expires_at` datetime NOT NULL,
  `is_revoked` tinyint(1) DEFAULT NULL,
  `device_info` varchar(255) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `refreshtokens`
--

INSERT INTO `refreshtokens` (`user_id`, `token_hash`, `expires_at`, `is_revoked`, `device_info`, `ip_address`, `id`, `created_at`, `updated_at`) VALUES
('01d366f3-df31-4bfb-a895-dcd90e506bcc', '589d2eb2730937337404dc9791c95cc0183e37dbb4eba6e41da50e27e01cae14', '2026-07-17 15:05:27', 1, NULL, 'testclient', '075ae654-c7e8-4f6a-9cf7-6cd1f9df251c', '2026-07-10 15:05:27', '2026-07-10 15:05:27'),
('01d366f3-df31-4bfb-a895-dcd90e506bcc', '10ea6eb570493bf1a942f2c787e43599e514761c9e84e0838957366d5cf7ebea', '2026-07-18 04:40:20', 1, NULL, 'testclient', '19c3933b-b57c-4740-a65b-65739ce50b38', '2026-07-11 04:40:20', '2026-07-11 04:40:20'),
('01d366f3-df31-4bfb-a895-dcd90e506bcc', 'a9c4f8f710e91308eba675eaea98e4bd4b2c1301d7ec0b1e178c284b17c05bc3', '2026-07-17 15:03:27', 1, NULL, 'testclient', '1c650c55-1c84-4ed5-a977-f6c883bccadc', '2026-07-10 15:03:27', '2026-07-10 15:05:27'),
('01d366f3-df31-4bfb-a895-dcd90e506bcc', 'f408df6c09072aec3fb6a33963cbedebc6e7b3472641458c08c05b5867e4567a', '2026-07-18 04:40:20', 1, NULL, 'testclient', '2d109312-c448-4c7e-8e91-f904999cad5a', '2026-07-11 04:40:20', '2026-07-11 04:40:20'),
('27b8e458-a4db-4176-b2f2-30b3c4ea66e3', 'b77b9a16e5182f437d6df21f29b2e345e968c5464704ac2d6e8b44a2f219f4a2', '2026-07-17 15:05:27', 0, NULL, 'testclient', '3942e878-f6b0-42ed-b705-8cd59ec1abf4', '2026-07-10 15:05:27', '2026-07-10 15:05:27'),
('01d366f3-df31-4bfb-a895-dcd90e506bcc', '3430437d57be3164443ce25de59e9ef5e15a03d90b87f2778ea59b7babf949f3', '2026-07-17 15:05:27', 1, NULL, 'testclient', '3f3b2ca9-5298-4cdb-a13f-fd06db420ffb', '2026-07-10 15:05:27', '2026-07-10 15:05:27'),
('27b8e458-a4db-4176-b2f2-30b3c4ea66e3', '1165ac58c0d6c7f06c285e7cf0232e3d4410c8b19e4b83bb8712739d95753399', '2026-07-18 04:40:19', 0, NULL, 'testclient', '56c9ebfc-98a0-49fb-9299-7d574f9b0695', '2026-07-11 04:40:19', '2026-07-11 04:40:19'),
('27b8e458-a4db-4176-b2f2-30b3c4ea66e3', '189e71cd053bcc0659b80dd59a519bd29def6054b2d76b6eb20874445ccfe103', '2026-07-17 15:03:27', 0, NULL, 'testclient', '6f3bb571-d401-4008-a948-b3f18576aa9b', '2026-07-10 15:03:27', '2026-07-10 15:03:27'),
('27b8e458-a4db-4176-b2f2-30b3c4ea66e3', 'd51331baf872b9029202365463bd66556e781ce33220a9cca1ebe33fb6eb40a7', '2026-07-18 04:22:39', 0, NULL, 'testclient', '8ed0fcf5-541e-4746-9f95-a379458a96e3', '2026-07-11 04:22:39', '2026-07-11 04:22:39'),
('01d366f3-df31-4bfb-a895-dcd90e506bcc', '39b70d2ab5fb22a7373ef9201dece5588404de9bd1dbfcd600477696c198aeac', '2026-07-17 15:03:27', 1, NULL, 'testclient', '8f2e01f4-d2bb-42b1-888a-c89916a89b80', '2026-07-10 15:03:27', '2026-07-10 15:05:27'),
('01d366f3-df31-4bfb-a895-dcd90e506bcc', '040f3c6056a53e06e4ea10e1740854d149628bf8b9d89a613247abe4edb1a4e9', '2026-07-18 04:22:40', 1, NULL, 'testclient', '967b3769-65aa-421f-a237-20c1a12350e1', '2026-07-11 04:22:40', '2026-07-11 04:22:40'),
('01d366f3-df31-4bfb-a895-dcd90e506bcc', '18788b7c3b2c1504b9e7c86f3f780ac13387b50d3cef9e800523af79593c53ad', '2026-07-17 15:05:27', 1, NULL, 'testclient', 'bc35eaff-bc64-42de-8906-cc52f3f690f1', '2026-07-10 15:05:27', '2026-07-10 15:05:27'),
('01d366f3-df31-4bfb-a895-dcd90e506bcc', '0474a0784956f1351b7db4d3bb308cfb42d91a3ae28f6db379ef5b829569fa46', '2026-07-18 04:40:19', 1, NULL, 'testclient', 'c35eba15-3f9f-4919-94b0-b150781bcb74', '2026-07-11 04:40:19', '2026-07-11 04:40:20'),
('01d366f3-df31-4bfb-a895-dcd90e506bcc', '41100e289ce7f196e1536d19810cc5e9776046047aaf064be5f30410b8dc1876', '2026-07-18 04:22:40', 1, NULL, 'testclient', 'ce8873a6-fb3e-433e-acdf-7c2764e78586', '2026-07-11 04:22:40', '2026-07-11 04:22:40'),
('01d366f3-df31-4bfb-a895-dcd90e506bcc', 'fea8b3fba56a078e0d1c7b9c51446a010da36b18d2759b7cce099d502a7a5cc9', '2026-07-18 04:22:40', 1, NULL, 'testclient', 'e1f81687-822a-4b16-b7ea-73bf1196763f', '2026-07-11 04:22:40', '2026-07-11 04:22:40');

-- --------------------------------------------------------

--
-- Table structure for table `review_schedules`
--

CREATE TABLE `review_schedules` (
  `user_id` varchar(36) NOT NULL,
  `question_id` varchar(36) NOT NULL,
  `next_review_date` datetime NOT NULL,
  `interval_days` int(11) DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `review_schedules`
--

INSERT INTO `review_schedules` (`user_id`, `question_id`, `next_review_date`, `interval_days`, `id`, `created_at`, `updated_at`) VALUES
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '9323f1bb-fbce-42f1-80ad-f7c66315a06b', '2026-07-11 16:23:51', 1, '135b9715-83a9-4f1f-af56-0501797d62ba', '2026-07-10 16:23:51', '2026-07-10 16:23:51'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '519b697f-e52a-48d2-878a-1f94544084ac', '2026-07-11 16:06:23', 1, '169a2ab5-e96e-446a-9d86-8f81f50c2ef8', '2026-07-10 16:06:23', '2026-07-10 16:06:23'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '119d69c5-7b53-43d2-9677-b560bdaec6e3', '2026-07-11 16:09:49', 1, '229593cd-f96f-467f-b035-e0274884131b', '2026-07-10 16:09:49', '2026-07-10 16:09:49'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '1f9d7e8d-4189-41ab-befe-22b7b3167e8d', '2026-07-11 16:16:06', 1, '25d109ab-66b6-4a90-9cf2-b6a909628ac2', '2026-07-10 16:16:06', '2026-07-10 16:16:06'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '35dc7a68-c00f-47bc-a444-aa37cddb3b62', '2026-07-11 16:11:00', 1, '3b4c6261-3f32-4146-8489-5f356f01b2e0', '2026-07-10 16:11:00', '2026-07-10 16:11:00'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'c85f81b8-5b36-458c-8326-eb2170e101e2', '2026-07-12 04:40:21', 1, '4320817d-3778-43f1-9e60-48d8b4226d84', '2026-07-11 04:40:21', '2026-07-11 04:40:21'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '65cf5938-6f10-4710-a664-d5b47940e9da', '2026-07-08 16:20:01', 1, '43495fd6-5a05-4b26-aed4-c26db0acc9b1', '2026-07-10 16:20:01', '2026-07-10 16:20:01'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'ac0fcdc1-7c67-4c8d-9b38-3c894f1f74b9', '2026-07-11 16:07:53', 1, '4786ff6f-f034-43c1-92b4-f02356228bea', '2026-07-10 16:07:53', '2026-07-10 16:07:53'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '2087477d-f6d5-4b57-9cd9-56891f041275', '2026-07-11 16:06:23', 1, '49e8b9e2-7130-477c-8f39-9f776e56b491', '2026-07-10 16:06:23', '2026-07-10 16:06:23'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '4247da87-9fa5-4ac3-8431-3a447406a1a1', '2026-07-12 04:22:41', 1, '5308ca62-8691-4d6e-a178-923884533622', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'dad95425-09d2-4f2f-9dc9-a6d09f443585', '2026-07-11 16:06:38', 1, '5b163c0c-fc17-48b8-b617-78089b23eadc', '2026-07-10 16:06:38', '2026-07-10 16:06:38'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '41cc3169-ed85-4a2c-8e81-404199c18f4b', '2026-07-09 04:40:22', 1, '5ba01c20-2c67-4433-82b4-e7dc7e204d8c', '2026-07-11 04:40:22', '2026-07-11 04:40:22'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '11ac7036-d3f1-4ae6-8fef-76fed00df706', '2026-07-11 16:09:32', 1, '64bf144c-714a-4422-8acc-b754b916dbe4', '2026-07-10 16:09:32', '2026-07-10 16:09:32'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '382d5b2d-404d-4191-bb09-fa7a7bf5bc75', '2026-07-11 16:09:32', 1, '6def9bbb-f466-4261-8b87-73757120be52', '2026-07-10 16:09:32', '2026-07-10 16:09:32'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '54de490e-c725-419b-91c0-0082cbc0d8c9', '2026-07-11 16:14:03', 1, '728a7e6a-b3b1-4ec6-8bec-f4fbbeb45a68', '2026-07-10 16:14:03', '2026-07-10 16:14:03'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'ae9b8443-fcbb-497b-8d2a-424499ef73f2', '2026-07-11 16:20:00', 1, '74458c88-e2cb-4caf-93b5-babf79e30829', '2026-07-10 16:20:00', '2026-07-10 16:20:00'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'ee5aaa0f-92fb-4567-8806-ad0e27170f29', '2026-07-11 16:16:05', 1, '74f84816-836b-4766-a2b5-3dcffd492d53', '2026-07-10 16:16:05', '2026-07-10 16:16:05'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '79a546c5-bd4a-464a-9f7d-17b6494979ea', '2026-07-11 16:11:00', 1, '75228cec-4998-4a6e-aae6-f3fc2f65cc00', '2026-07-10 16:11:00', '2026-07-10 16:11:00'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'c9aa4340-fb43-4776-a90f-0fb90976ecf1', '2026-07-12 04:40:21', 1, '8408f21b-e59d-48cd-8860-2b381a0a11bb', '2026-07-11 04:40:21', '2026-07-11 04:40:21'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '607cfe2a-f5f7-46fb-a746-5c83a629f7e1', '2026-07-12 04:22:41', 1, '8fc2f2f1-6f21-4856-b536-4a257ce515c6', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '992a54c3-f35f-46ca-b495-c7707a9b2cc3', '2026-07-11 16:14:03', 1, '8fd9a781-57e7-4a90-8140-e6a0a6cc4186', '2026-07-10 16:14:03', '2026-07-10 16:14:03'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'b7c72ad2-34d4-4f07-b7f9-5e84ccc64ecc', '2026-07-11 16:07:53', 1, '935c17f1-9bc4-4e55-b9be-25b9cb44b18d', '2026-07-10 16:07:53', '2026-07-10 16:07:53'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'b8c1a10b-eceb-4fbf-b725-136d5a84896b', '2026-07-08 16:23:51', 1, 'a73a026c-6be8-4641-baf2-6c864d02a9bc', '2026-07-10 16:23:51', '2026-07-10 16:23:51'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '395dd007-0f0d-4e4c-afb7-8618505c45cc', '2026-07-11 16:06:38', 1, 'c17ba8d7-2625-4481-887b-f35e9e819ef3', '2026-07-10 16:06:38', '2026-07-10 16:06:38'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '8cfe6fba-4dd3-4947-a5a1-25c96465fbe6', '2026-07-11 16:23:43', 1, 'd58ae147-865e-4609-ac44-22e27a2ada08', '2026-07-10 16:23:43', '2026-07-10 16:23:43'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '3e924d1a-0431-4f4c-8911-814e6ab38ffb', '2026-07-11 16:09:49', 1, 'd9c4467e-7f6c-4e27-aad3-4ef3263be5e3', '2026-07-10 16:09:49', '2026-07-10 16:09:49'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'c2dbc501-6420-442a-93d8-a63302c89f0c', '2026-07-08 16:21:03', 1, 'df34f3f2-a9d2-43c5-a42a-ba4de593cd02', '2026-07-10 16:21:03', '2026-07-10 16:21:03'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'daa3b019-1663-4197-a20d-f79dff24eab8', '2026-07-11 16:21:03', 1, 'e5fcd1e6-31a5-4519-96d2-f936349211a3', '2026-07-10 16:21:03', '2026-07-10 16:21:03'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '1f939f4b-5740-4cb7-b4c2-ee6d7541fef0', '2026-07-08 16:23:44', 1, 'e86f7eb8-d2d0-4dd0-8423-1e0ef164849d', '2026-07-10 16:23:44', '2026-07-10 16:23:44'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '035398f3-0cf4-43c7-85e9-db38f9a12295', '2026-07-11 16:15:48', 1, 'f545cf8f-a852-4639-abee-e9bdcdf86902', '2026-07-10 16:15:48', '2026-07-10 16:15:48'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'd539028b-0caf-4754-8c89-83da7b66d644', '2026-07-09 04:22:41', 1, 'fc0cffdc-95d7-4120-8187-3b145d77461c', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '2fa28439-851b-4422-ab37-924c167695cb', '2026-07-11 16:15:49', 1, 'fc75f44f-df0c-41ad-83fb-a3f2f2f39113', '2026-07-10 16:15:49', '2026-07-10 16:15:49');

-- --------------------------------------------------------

--
-- Table structure for table `units`
--

CREATE TABLE `units` (
  `course_id` varchar(36) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `sequence` int(11) DEFAULT NULL,
  `is_published` tinyint(1) DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `units`
--

INSERT INTO `units` (`course_id`, `title`, `description`, `sequence`, `is_published`, `id`, `created_at`, `updated_at`) VALUES
('07d6d4ea-ca72-4165-beb3-eb5051bfb96d', 'Unit', NULL, 0, 1, '014cf38b-7ff3-4502-9520-598f70364eb9', '2026-07-10 16:15:48', '2026-07-10 16:15:48'),
('bfa2ab29-0885-4d36-80f8-5dcf1ca24bd9', 'Unit', NULL, 0, 1, '05e65954-db69-488b-9674-15a85c86fcfb', '2026-07-10 16:11:00', '2026-07-10 16:11:00'),
('3d54b92b-0fca-4652-815b-16fe3b3b0a6b', 'Greetings and Introductions', 'Learn how to greet people', 1, 1, '0a8e6f1e-94b8-48c5-a0d3-989df92b8882', '2026-07-10 15:13:34', '2026-07-10 15:13:34'),
('f54e8d6a-455c-44b5-a508-e5ad0a50d7ad', 'Unit', NULL, 0, 1, '0fa45143-1717-4974-a911-95c1c9aaf6bb', '2026-07-10 16:06:37', '2026-07-10 16:06:37'),
('22ea5dec-6dd5-4d66-9d1e-ee661d50c5e6', 'Unit', NULL, 0, 1, '1bc356ab-7fd2-4f14-886d-02ab33b29b38', '2026-07-10 16:16:06', '2026-07-10 16:16:06'),
('a6fc3677-da21-41d5-ac4e-425d760409ac', 'Mock Unit', NULL, 0, 0, '1efb8f5b-2de4-4332-99e4-a518957a8118', '2026-07-11 04:14:04', '2026-07-11 04:14:04'),
('b07c1a92-b143-495d-9d00-67068c1fe674', 'Unit', NULL, 0, 1, '20751fb1-c0ce-4758-8422-4e4a028e6238', '2026-07-10 15:26:00', '2026-07-10 15:26:00'),
('dc99ee52-ca17-4c15-b8a5-c6c3f89fb692', 'Unit', NULL, 0, 1, '20dc8ec6-d4e1-4f39-bc2b-25a54ad1b24a', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('1342a040-8883-4094-b3df-65e9bbd197fb', 'Unit', NULL, 0, 1, '26f2ee7f-fa56-4ba9-aabd-8259c4bff2a2', '2026-07-10 16:21:02', '2026-07-10 16:21:02'),
('2afc7f43-9b05-4c57-a313-2d0af9de5ca5', 'Unit', NULL, 0, 1, '26f3af1f-91c5-402d-808b-38e1a0d1096f', '2026-07-10 16:06:38', '2026-07-10 16:06:38'),
('f0266237-c72a-42d1-bed3-2e5e5bb845a0', 'Unit', NULL, 0, 1, '2d2c02d3-a7d8-41f4-9af3-b644e43f07fe', '2026-07-10 16:20:00', '2026-07-10 16:20:00'),
('95326eba-631f-4bc1-8348-32d74335fc3b', 'Unit 1: Foundation 1', 'N5 Unit 1', 1, 1, '3087c070-2e70-4c26-ba4e-f17dafb412d8', '2026-07-11 03:02:52', '2026-07-11 03:02:52'),
('046975cf-3004-43ce-abf9-f92ed13e6ab8', 'Mock Unit', NULL, 0, 0, '31d2a28e-debb-493a-aba4-af0ea8f567d7', '2026-07-11 04:14:10', '2026-07-11 04:14:10'),
('10d5247f-8423-4422-8ad2-45d79b95bdcd', 'Mock Unit', NULL, 0, 0, '31ff3106-4f20-4ca5-aa01-d5775b08527e', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('917b0633-ce20-4d93-b5b1-c301ca61804c', 'Test Unit', 'Desc', 1, 1, '3336ca3f-c68d-4396-b0f1-f840721722f6', '2026-07-11 03:32:51', '2026-07-11 03:32:51'),
('1d65fe9f-4b4c-4960-acdd-36da95ea8eb5', 'Mock Unit', NULL, 0, 0, '34d04e06-807f-472d-b609-4b244d03f20f', '2026-07-11 04:15:52', '2026-07-11 04:15:52'),
('00be23aa-003d-4e73-b1d7-72ebf52710c6', 'Unit', NULL, 0, 1, '34e2e4c1-c962-4a9c-bba2-dbc515cbe8f9', '2026-07-10 16:09:32', '2026-07-10 16:09:32'),
('5bf1b00c-0854-4b99-8257-246178362504', 'Unit', NULL, 0, 1, '3c53a977-9fa9-48e4-98eb-c06e18c60ba7', '2026-07-10 16:23:51', '2026-07-10 16:23:51'),
('1f82bff3-576a-41ee-b9c0-a3cff7decb1f', 'Test Unit', 'Desc', 1, 1, '40a77d3b-39c6-4540-9832-201fc16f9a05', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('8d909254-382b-45ec-9ee8-7a3eabcfa2af', 'Mock Unit', NULL, 0, 0, '44a8a474-34bc-4c9e-8487-f426d9d8c632', '2026-07-11 04:17:04', '2026-07-11 04:17:04'),
('0ef5e347-234c-433c-88f5-f3416c6486ac', 'Unit', NULL, 0, 1, '4b89938b-91cc-4c4b-a3e2-3baa00fbb8ad', '2026-07-10 16:04:54', '2026-07-10 16:04:54'),
('5e217c75-eede-4bc6-b9da-39058960c413', 'Unit', NULL, 0, 1, '4d296359-f130-485c-8bd9-57043c29ad5a', '2026-07-10 15:54:53', '2026-07-10 15:54:53'),
('521e5ddc-9039-4d6f-b87d-b307a3975f79', 'Test Unit', 'Desc', 1, 1, '4d465502-ab5b-4f46-83e8-8e9af888737b', '2026-07-11 04:40:22', '2026-07-11 04:40:22'),
('2be3c161-d7b9-4878-9e6e-2b0ded727af4', 'Unit', NULL, 0, 1, '4dc7b80a-74ca-4a84-8755-f3b0c9fa356d', '2026-07-10 16:11:00', '2026-07-10 16:11:00'),
('4b9f09f3-deb6-4a9a-954f-9e09b7ae2fa1', 'Unit', NULL, 0, 1, '4e3defe1-61ef-4411-af28-df47a5232971', '2026-07-11 04:40:21', '2026-07-11 04:40:21'),
('95326eba-631f-4bc1-8348-32d74335fc3b', 'Unit 6: Foundation 6', 'N5 Unit 6', 6, 1, '50b94769-e81e-4300-a880-7ec227b28543', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('a5c4b13f-ff13-4c22-9084-1523e0bab183', 'Unit', NULL, 0, 1, '516a23ee-c321-4636-9d1a-313518392045', '2026-07-10 16:06:23', '2026-07-10 16:06:23'),
('b1cd3077-a4b3-429f-972b-33c89d7c8b16', 'Unit', NULL, 0, 1, '56689189-0e73-48bd-8582-61dca3c1c51d', '2026-07-10 15:38:04', '2026-07-10 15:38:04'),
('8779dd1a-f208-4007-95df-ef9cbef9f6f8', 'Unit', NULL, 0, 1, '576ce5d4-e937-4962-9a69-aeaf7a3e30df', '2026-07-10 16:23:43', '2026-07-10 16:23:43'),
('28d026e0-7c69-44b9-a918-57b14c8b0b09', 'Unit', NULL, 0, 1, '5a9dd402-e99f-4c58-b4ef-713bfa68e92a', '2026-07-11 04:22:40', '2026-07-11 04:22:40'),
('950ae37d-94f5-4213-9f16-2b1aa3f58b8e', 'Unit', NULL, 0, 1, '5ff56431-23d0-45ab-bf5b-10254a1c298b', '2026-07-10 15:26:56', '2026-07-10 15:26:56'),
('38cafe45-6744-4b21-853e-c610861ae23d', 'Unit', NULL, 0, 1, '61049341-d439-4c13-ab2a-951d81b65c9f', '2026-07-10 15:53:53', '2026-07-10 15:53:53'),
('d8743062-34af-48df-984a-83432df08d63', 'Unit', NULL, 0, 1, '6337b9e3-5cab-4e01-963c-8feb0f10fc24', '2026-07-11 04:40:21', '2026-07-11 04:40:21'),
('5154ac18-9e23-41d0-a770-0c1338378b79', 'Unit', NULL, 0, 1, '6356f049-8fb5-4201-8120-743ccb3e426f', '2026-07-10 16:09:32', '2026-07-10 16:09:32'),
('e663ff6c-fce2-4552-9f5c-e201e646a5af', 'Unit', NULL, 0, 1, '6530bad5-67bf-478f-a69c-51c0b42dc2cd', '2026-07-11 04:22:40', '2026-07-11 04:22:40'),
('e4acab09-d7a1-4067-b9a0-a457b2443bf7', 'Unit', NULL, 0, 1, '67bfd7ef-81db-4b55-bfe7-95d50b97d324', '2026-07-10 16:09:49', '2026-07-10 16:09:49'),
('e8a11e03-237f-470d-b2ff-5c5b942d2014', 'Mock Unit', NULL, 0, 0, '68f04a1f-f036-4d6f-af16-a4f51d392d94', '2026-07-11 04:40:22', '2026-07-11 04:40:22'),
('c135be25-943c-4f51-9396-322520918616', 'Mock Unit', NULL, 0, 0, '6bb22b79-15bd-41fb-8c18-10980a4cb733', '2026-07-11 04:17:24', '2026-07-11 04:17:24'),
('11db9d1c-6a80-4c8e-8911-d33005b52047', 'Unit', NULL, 0, 1, '716b0957-38ce-4f5a-a73f-d562f71b483f', '2026-07-10 15:55:00', '2026-07-10 15:55:00'),
('2ebc06b8-1226-420e-8906-d5408f3b7934', 'Mock Unit', NULL, 0, 0, '73759cff-1168-4fc6-9818-fb2cba81efee', '2026-07-11 04:17:24', '2026-07-11 04:17:24'),
('247c7c49-4419-4aae-8cb8-9609f901cfe3', 'Unit', NULL, 0, 1, '74298325-3ad1-435c-935f-625e9058fc0b', '2026-07-10 16:15:48', '2026-07-10 16:15:48'),
('e7ee0ad5-3857-4228-8d09-f75fb93f8d2a', 'Unit', NULL, 0, 1, '790fc260-021e-43d1-81e9-38a191d2fbdb', '2026-07-10 16:04:36', '2026-07-10 16:04:36'),
('6d3b8200-edbb-4694-a9c4-4b236ea7a192', 'Unit', NULL, 0, 1, '7e31be8c-0754-4a02-9d1c-0cb49c10ebe1', '2026-07-10 16:07:53', '2026-07-10 16:07:53'),
('95326eba-631f-4bc1-8348-32d74335fc3b', 'Unit 8: Foundation 8', 'N5 Unit 8', 8, 1, '867950ea-d9b1-4d4c-92a5-3c40a193a24e', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('889982ea-b494-4986-a62e-d92ccfb5098e', 'Mock Unit', NULL, 0, 0, '87b132c8-c218-44e1-b95f-f0fb92c28aad', '2026-07-11 04:14:11', '2026-07-11 04:14:11'),
('e3a89ef4-1b83-4ada-9ae8-a9d82cc87f2d', 'Mock Unit', NULL, 0, 0, '8afff953-b826-4b41-95b2-6887e1aed74b', '2026-07-11 04:16:50', '2026-07-11 04:16:50'),
('83bd2404-ed61-4dd3-9ffc-a9365cab9a43', 'Unit', NULL, 0, 1, '8d93940b-85e4-4c3e-9055-cc1f6d4ecef4', '2026-07-10 16:07:53', '2026-07-10 16:07:53'),
('1f5a50b0-851a-4fe0-9b93-9b7b90de7e1a', 'Unit', NULL, 0, 1, '8f91646e-ed94-42fa-9c7c-003263432a2f', '2026-07-10 16:03:04', '2026-07-10 16:03:04'),
('ff529c18-5b3a-432e-90f9-8286bf8b697e', 'Mock Unit', NULL, 0, 0, '935d6faa-8d62-4754-9fcb-0a055ea346d4', '2026-07-11 04:17:05', '2026-07-11 04:17:05'),
('95326eba-631f-4bc1-8348-32d74335fc3b', 'Unit 10: Foundation 10', 'N5 Unit 10', 10, 1, '9943afd5-6718-46d3-91cc-95b5f79ea3a3', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('654112a5-52c6-4be6-bf15-96a20a5fab80', 'Unit', NULL, 0, 1, '9a60d488-cb0c-4c0f-be91-034de9d0fc80', '2026-07-10 16:21:03', '2026-07-10 16:21:03'),
('ab4f8bb5-7e63-4b75-9b05-df0f9bd4306b', 'Test Unit', 'Desc', 1, 1, '9ae97a08-97d7-4485-aa2a-07d7e2475983', '2026-07-11 03:32:12', '2026-07-11 03:32:12'),
('591e74b4-8d36-4ddf-bae9-80bce83e4ecc', 'Unit', NULL, 0, 1, '9c2216a8-1883-4baa-a0b6-18ea6b8803ca', '2026-07-11 04:40:22', '2026-07-11 04:40:22'),
('0126be1e-eabe-4924-9591-0448d8a79fc2', 'Mock Unit', NULL, 0, 0, '9c8f844b-dae8-485d-b9b2-c813e32dacb0', '2026-07-11 04:13:18', '2026-07-11 04:13:18'),
('ef61a9a5-3392-4b38-bcd2-885ca055c169', 'Unit', NULL, 0, 1, '9d35cc7c-b183-405d-a876-a5aeb997717d', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('27c6f600-4d1f-4200-b67e-2332a81b3551', 'Mock Unit', NULL, 0, 0, 'a23ccccc-dec9-453c-b5ca-075517d9b7f0', '2026-07-11 04:15:52', '2026-07-11 04:15:52'),
('e564f30e-b9ae-4eed-866d-f023a129b459', 'Mock Unit', NULL, 0, 0, 'a352e9d0-b6f3-4db5-abed-d3422cae7cfc', '2026-07-11 04:13:10', '2026-07-11 04:13:10'),
('420cfe03-644a-4135-920f-dc713de64d5a', 'Unit', NULL, 0, 1, 'a5c5f337-8e85-4cb4-bd5b-7d8eaf5be5d0', '2026-07-11 04:40:20', '2026-07-11 04:40:20'),
('a5e2a901-829d-463a-acb8-3426296a26b4', 'Unit', NULL, 0, 1, 'a858f159-90a5-4c78-9e23-a95057540b65', '2026-07-10 15:35:34', '2026-07-10 15:35:34'),
('f56be25f-89e2-4cd5-92d9-80572ac777fd', 'Unit', NULL, 0, 1, 'aa3668eb-6f12-4c03-a76a-681567cf5195', '2026-07-10 15:36:45', '2026-07-10 15:36:45'),
('ecd07d79-7e09-4a10-a553-7e0f71c79558', 'Mock Unit', NULL, 0, 0, 'ae728f16-e94e-440e-b6d3-5fe9df3521a9', '2026-07-11 04:14:56', '2026-07-11 04:14:56'),
('696d8625-1b84-4d38-87a8-ef590c956191', 'Unit', NULL, 0, 1, 'b3c437eb-6ad6-40ee-8033-9e39b2a40af0', '2026-07-10 16:02:47', '2026-07-10 16:02:47'),
('f1f52637-e709-4006-af50-485bb413c824', 'Unit', NULL, 0, 1, 'b3d55079-ca7c-47af-9309-8691bb075add', '2026-07-11 04:40:21', '2026-07-11 04:40:21'),
('05557af5-4dd3-4b32-9056-2d36578a4e07', 'Mock Unit', NULL, 0, 0, 'b46ef0c0-81ca-48ef-948b-24a76aafe54d', '2026-07-11 04:19:23', '2026-07-11 04:19:23'),
('a6fed606-13dc-4a6a-9cd8-8ea3e4cb39c8', 'Mock Unit', NULL, 0, 0, 'b5c0e1c0-9e20-4b46-af81-9ec28961cd92', '2026-07-11 04:16:03', '2026-07-11 04:16:03'),
('1b78e046-68e1-4b4d-8ee7-d89f4d28269e', 'Mock Unit', NULL, 0, 0, 'b5d9386a-a99d-4609-803b-93b25f3c2b01', '2026-07-11 04:16:03', '2026-07-11 04:16:03'),
('3154aa3d-ac33-43bf-bbbc-a0668a92bff1', 'Unit', NULL, 0, 1, 'b5dece2b-6a72-4661-9661-164dc44f8474', '2026-07-10 16:14:03', '2026-07-10 16:14:03'),
('6eb698ce-0848-4752-97ae-f8cc62532b61', 'Unit', NULL, 0, 1, 'b60a7e18-b841-4b5c-b16b-fb630789c8d0', '2026-07-10 15:25:57', '2026-07-10 15:25:57'),
('53e954d0-5d42-429d-a59a-2e631f1d997c', 'Test Unit', 'Desc', 1, 1, 'b6e38f00-462c-47e1-9721-d8745a26cc17', '2026-07-11 03:32:01', '2026-07-11 03:32:01'),
('5b2bc681-af23-40cd-8fdc-032fc18c114c', 'Unit', NULL, 0, 1, 'b807e3b3-421e-4900-a81c-b9d0d3a75a81', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('6e14b3af-4c8b-4f18-b705-5e18c612e5d9', 'Mock Unit', NULL, 0, 0, 'b8a0204c-55b9-4656-8cdf-53811821f3ad', '2026-07-11 04:16:50', '2026-07-11 04:16:50'),
('18792bd7-0f7d-4986-829f-3f70b5a3fb05', 'Unit', NULL, 0, 1, 'bd97e752-63be-47ea-8538-1e523e0842e1', '2026-07-10 15:54:01', '2026-07-10 15:54:01'),
('7bc714ab-d1f4-45f1-9c30-9d6e8a77a2f2', 'Unit', NULL, 0, 1, 'c0c20471-8b6a-49c9-a158-34b05906ef7d', '2026-07-10 16:16:05', '2026-07-10 16:16:05'),
('855fc796-fce8-482d-96bc-f4ff4243b514', 'Mock Unit', NULL, 0, 0, 'c0e6be80-7901-49f0-b8be-84127997d5a0', '2026-07-11 04:14:55', '2026-07-11 04:14:55'),
('2f6f6f4a-6e31-4ece-a4de-441faf809a90', 'Test Unit', 'Desc', 1, 1, 'c2ec2e0e-593f-4f66-b150-0da40b1426a1', '2026-07-11 03:33:03', '2026-07-11 03:33:03'),
('ce5a25bd-2276-4d40-852b-71493c1bae45', 'Mock Unit', NULL, 0, 0, 'c5a7a9c1-1233-47e0-9629-d910c6b818a0', '2026-07-11 04:19:23', '2026-07-11 04:19:23'),
('95326eba-631f-4bc1-8348-32d74335fc3b', 'Unit 3: Foundation 3', 'N5 Unit 3', 3, 1, 'c6f63da1-35f6-4c36-9141-3b564f4c1c53', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('7872827c-c259-47ae-af28-b02a1028303b', 'Unit', NULL, 0, 1, 'c9023bc7-f050-4e05-b169-9cb03da5e17c', '2026-07-10 16:06:22', '2026-07-10 16:06:22'),
('00b9eef8-82e1-4283-8279-62828045abc7', 'Unit', NULL, 0, 1, 'c9e09fb5-94b8-420c-aa3e-51e3810ca23d', '2026-07-10 16:09:49', '2026-07-10 16:09:49'),
('95326eba-631f-4bc1-8348-32d74335fc3b', 'Unit 7: Foundation 7', 'N5 Unit 7', 7, 1, 'ca8a1785-5367-4679-b7e8-2ab1a11d591b', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('95326eba-631f-4bc1-8348-32d74335fc3b', 'Unit 2: Foundation 2', 'N5 Unit 2', 2, 1, 'cd3038c4-a47c-4364-883a-492d22ad94db', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('4600ac84-85b3-46f6-88f8-bd5c9033b081', 'Unit', NULL, 0, 1, 'ce40919e-0230-4db7-aaf3-6546c0e147d4', '2026-07-10 16:23:51', '2026-07-10 16:23:51'),
('95326eba-631f-4bc1-8348-32d74335fc3b', 'Unit 9: Foundation 9', 'N5 Unit 9', 9, 1, 'cf168d3a-7758-4cab-af32-1bd83e13c9dc', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('307233ee-6dd1-49ff-b629-3b8aabf9ba51', 'Unit', NULL, 0, 1, 'cf5396b4-bc04-4ea1-83a3-da01f616899e', '2026-07-10 15:18:32', '2026-07-10 15:18:32'),
('95326eba-631f-4bc1-8348-32d74335fc3b', 'Unit 4: Foundation 4', 'N5 Unit 4', 4, 1, 'd0fbdd80-e430-4846-94f1-59f633e7b10b', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('b4bf4519-315a-4184-aad9-9a58fec6e78d', 'Unit', NULL, 0, 1, 'd3ddada1-3f33-483e-80b3-e8686a98735a', '2026-07-10 16:03:05', '2026-07-10 16:03:05'),
('864d17fa-1ed8-45ce-b1e9-ecf73cd95a11', 'Unit', NULL, 0, 1, 'd4d3b0c4-a76f-4b3a-9581-b645428316f9', '2026-07-10 16:04:37', '2026-07-10 16:04:37'),
('524fc5e2-905c-4a68-b4de-321ba1505b40', 'Mock Unit', NULL, 0, 0, 'd5be85af-cf1c-4891-847b-28c2034a5422', '2026-07-11 04:13:10', '2026-07-11 04:13:10'),
('3b68a51c-10b0-4fd8-862c-4c24771a3718', 'Mock Unit', NULL, 0, 0, 'dcbfc8a6-8937-48b7-97a6-e029a876210d', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('e97548f5-7638-406f-bc73-79640a7f23be', 'Unit', NULL, 0, 1, 'df83c896-7d98-4a57-96f3-b62e3417a664', '2026-07-10 16:02:48', '2026-07-10 16:02:48'),
('9dcd44c5-125d-40ee-bfe8-98651b91464e', 'Unit', NULL, 0, 1, 'e05f13a3-bd03-4268-92dc-d875d89ec930', '2026-07-10 16:20:00', '2026-07-10 16:20:00'),
('730e573a-d0a5-4540-8031-f2e08b999647', 'Unit', NULL, 0, 1, 'e1b8c312-01d4-4014-9440-31d09c72ec3a', '2026-07-10 16:04:53', '2026-07-10 16:04:53'),
('9ca9aedf-aaa0-4f14-a18d-2c724f40cd76', 'Unit', NULL, 0, 1, 'e1e6dea6-331a-4c92-a024-daf163fbcd13', '2026-07-10 16:14:03', '2026-07-10 16:14:03'),
('fbe2bd78-fbd6-4344-a694-3689ee93f75b', 'Unit', NULL, 0, 1, 'e4890ac6-6415-4507-b7aa-2b1af0420f93', '2026-07-10 15:38:11', '2026-07-10 15:38:11'),
('0eef7cd2-bbde-4ce6-b0b3-7537fe39e62a', 'Unit', NULL, 0, 1, 'e5b0563a-84f9-4674-aa09-7fec74868637', '2026-07-10 15:34:14', '2026-07-10 15:34:14'),
('009391fe-8c4f-4ba5-9df9-7b7313311330', 'Unit', NULL, 0, 1, 'e5f55cab-5eb9-43e5-b0b9-4d3ed19a304c', '2026-07-10 15:37:13', '2026-07-10 15:37:13'),
('2f503ef7-36a9-483f-935e-acffa0e771b3', 'Mock Unit', NULL, 0, 0, 'eacd5f63-eabb-45ba-a507-020641e289c3', '2026-07-11 04:14:04', '2026-07-11 04:14:04'),
('fb56a41b-8d59-43bb-be91-38d61be43713', 'Unit', NULL, 0, 1, 'eb05f7ab-f58a-4325-a2e8-ccc189063ad6', '2026-07-10 16:23:43', '2026-07-10 16:23:43'),
('ef6ed790-adb1-40ad-a85e-bd370d181f02', 'Mock Unit', NULL, 0, 0, 'ee46bd1f-e885-4492-9337-aef320740caf', '2026-07-11 04:40:23', '2026-07-11 04:40:23'),
('d51649cc-8746-4224-aa5c-f177ab08aef9', 'Unit', NULL, 0, 1, 'ef564515-46c6-49e9-877a-d9995e5f2fbe', '2026-07-10 15:26:44', '2026-07-10 15:26:44'),
('c91875e3-e222-43f2-9f0a-1a927dd5a4fd', 'Mock Unit', NULL, 0, 0, 'f5bd88f0-f590-4a1c-b10d-dd044d9303e3', '2026-07-11 04:13:18', '2026-07-11 04:13:18'),
('95326eba-631f-4bc1-8348-32d74335fc3b', 'Unit 5: Foundation 5', 'N5 Unit 5', 5, 1, 'fdab6d15-235a-4ea8-a5de-3f4e354e3e06', '2026-07-11 03:04:02', '2026-07-11 03:04:02');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `photo_url` varchar(512) DEFAULT NULL,
  `timezone` varchar(50) DEFAULT NULL,
  `target_level` varchar(10) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `role` enum('LEARNER','CONTENT_EDITOR','REVIEWER','ADMINISTRATOR') NOT NULL,
  `current_streak` int(11) DEFAULT NULL,
  `longest_streak` int(11) DEFAULT NULL,
  `last_activity_date` date DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`email`, `password_hash`, `name`, `photo_url`, `timezone`, `target_level`, `is_active`, `role`, `current_streak`, `longest_streak`, `last_activity_date`, `id`, `created_at`, `updated_at`) VALUES
('testauth@example.com', '$2b$12$p441kxMaSh3NDfK1.mv/QOXlv2wdVlRqsdkcV6I4IkHXkKRSjRpJu', 'Test User', NULL, 'UTC', 'N5', 1, 'LEARNER', 0, 0, NULL, '01d366f3-df31-4bfb-a895-dcd90e506bcc', '2026-07-10 15:03:27', '2026-07-10 15:03:27'),
('hacker_99e0eb5b-4abb-457a-aeb9-4587b2f63cfc@example.com', '$2b$12$sG5dQCljk77cMOD2Y1jb2Obp2MkmFHEpass4hes.CQplerlYL4zIy', 'Hacker', NULL, 'UTC', 'N5', 1, 'LEARNER', 0, 0, NULL, '1ba48f44-f4a3-4a6e-96c6-add5b6f86210', '2026-07-11 03:30:09', '2026-07-11 03:30:09'),
('learner_test_fixture@example.com', 'fakehash', 'Learner User', NULL, 'UTC', 'N5', 1, 'LEARNER', 2, 2, '2026-07-11', '1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '2026-07-10 15:18:32', '2026-07-11 04:22:41'),
('hacker_f4185ab4-ea99-4c01-a9dc-b5525c9d619a@example.com', '$2b$12$NE.JmjgMSbQMVIpOQ3p0AeH6R7VJCsFZjg9kbMxHsOYGrRT/.Drs.', 'Hacker', NULL, 'UTC', 'N5', 1, 'LEARNER', 0, 0, NULL, '273b91fc-2dd4-4779-b71a-f13885c2fa34', '2026-07-11 03:29:08', '2026-07-11 03:29:08'),
('learner_admin_test@example.com', '$2b$12$fjXxVZMcro3zLQgBh6OQ2O/jWCEaMDK8GrtniueNWeZSNnjbH5bSi', 'Learner', NULL, 'UTC', 'N5', 1, 'LEARNER', 0, 0, NULL, '27b8e458-a4db-4176-b2f2-30b3c4ea66e3', '2026-07-10 15:03:26', '2026-07-10 15:03:26'),
('hacker_52ec1c21-b595-412d-835f-a11698cd0daa@example.com', '$2b$12$IS.B.uOUkUmTekUwTN5CjOM8yLMYtUfPht/VzHRJbsLoDLxX1/RLy', 'Hacker', NULL, 'UTC', 'N5', 1, 'LEARNER', 0, 0, NULL, '4ca4585d-9b61-4823-afad-f91899664d6f', '2026-07-11 03:27:26', '2026-07-11 03:27:26'),
('hacker_123a4469-a856-40a6-90f3-a8fc1db94a0f@example.com', '$2b$12$JqyjK.CSpE7ZsPbuskdDyeJSgkpPS7azsmbbZitkUWMQBZsQUKDYS', 'Hacker', NULL, 'UTC', 'N5', 1, 'LEARNER', 0, 0, NULL, '5093473a-2934-48cd-b8ed-7911a951f814', '2026-07-11 03:33:03', '2026-07-11 03:33:03'),
('hacker_31d9b5e3-9949-47f2-b350-d01d5254de0c@example.com', '$2b$12$b2HBC2IKHIc2ifN/4S4RV.RZLeB0kxw.femXtxOLcYGXIKfOLthM2', 'Hacker', NULL, 'UTC', 'N5', 1, 'LEARNER', 0, 0, NULL, '50cccfcc-a631-4e39-8c9f-fd9f5ccdf961', '2026-07-11 03:28:54', '2026-07-11 03:28:54'),
('hacker_7b2cb9ce-1dcb-406a-996c-0a12e2eb5ec3@example.com', '$2b$12$gbCQC5CMe.WmKGzNv.2cnuA811XCDl.ZmiPdOVPxrveaGZSRqXJde', 'Hacker', NULL, 'UTC', 'N5', 1, 'LEARNER', 0, 0, NULL, '5792adab-c6fd-4531-a4ee-fe2e0b88d74e', '2026-07-11 03:32:12', '2026-07-11 03:32:12'),
('hacker_4b58c070-86e6-4def-8c66-5b65d4c9481a@example.com', '$2b$12$QGLeGpDXD3wkKYBQvyXGKeTDlnal4fxM5KY2e5ez2yxvUUXZaZ0NK', 'Hacker', NULL, 'UTC', 'N5', 1, 'LEARNER', 0, 0, NULL, '81daa9a3-af7d-4906-9e94-29ccfe5ccccf', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('hacker_eacf5e45-4a48-471d-b1e0-1597d8daf81e@example.com', '$2b$12$jRRe06pXl83nPyv9Y8P.bu00huL.QoyopKRfFeuaTMwfrqvgF9Oau', 'Hacker', NULL, 'UTC', 'N5', 1, 'LEARNER', 0, 0, NULL, '897dc5f1-a013-428f-96a0-03d12a655ff5', '2026-07-11 03:25:10', '2026-07-11 03:25:10'),
('admin_test_fixture@example.com', 'fakehash', 'Admin User', NULL, 'UTC', 'N5', 1, 'ADMINISTRATOR', 0, 0, NULL, '8c059ab6-5a7d-4430-bcb2-3755623a3a0a', '2026-07-10 15:18:31', '2026-07-10 15:18:31'),
('hacker_ea667772-2cfe-4250-bc37-b150be2be9a6@example.com', '$2b$12$XLeeSyK3GnCmLNhvsF6DberfGRCpcp8oCkBuXTqodPP1.KR5Qk0pq', 'Hacker', NULL, 'UTC', 'N5', 1, 'LEARNER', 0, 0, NULL, '9b791e36-7942-4345-af05-a5407be2fcb3', '2026-07-11 03:32:01', '2026-07-11 03:32:01'),
('hacker_b9d6f177-e4fe-49b5-9d6c-76d34bc257ab@example.com', '$2b$12$VeqzdcEq9apZ/BXo9IJVWOeFfmGvqxug70RfyD2.HK6BTzfgUna5i', 'Hacker', NULL, 'UTC', 'N5', 1, 'LEARNER', 0, 0, NULL, 'bc181a5e-a064-4630-bdd8-338931eb55d4', '2026-07-11 04:40:22', '2026-07-11 04:40:22'),
('hacker_0d5fd966-e2dc-463a-b521-9e56b8e7ada7@example.com', '$2b$12$U8Y5Std6zxsWvdoxQoy9VuNymz8OfWkG7xmuGOSNPNO6C0Ug/fhTC', 'Hacker', NULL, 'UTC', 'N5', 1, 'LEARNER', 0, 0, NULL, 'cd4c9bf4-14da-4e03-9106-d353b282ecd4', '2026-07-11 03:27:42', '2026-07-11 03:27:42'),
('hacker@example.com', '$2b$12$6r0vZ1xbbHESQBrXAnWqneJkdjZahCuAiCfrrPFedtk6uKgcDKg3S', 'Hacker', NULL, 'UTC', 'N5', 1, 'LEARNER', 0, 0, NULL, 'eef516a2-9d24-409c-a138-22b75276eb62', '2026-07-11 03:22:51', '2026-07-11 03:22:51'),
('hacker_56cde7ee-c41e-4b0e-9712-f5bed8d626d2@example.com', '$2b$12$KI35H1HhL3LTTOtXhJ.SdOWxINcEvBDUIebGOweRE9nxegYV1311y', 'Hacker', NULL, 'UTC', 'N5', 1, 'LEARNER', 0, 0, NULL, 'f767de29-9519-4f6e-a23d-15e5e9686ad2', '2026-07-11 03:32:51', '2026-07-11 03:32:51');

-- --------------------------------------------------------

--
-- Table structure for table `user_lesson_progress`
--

CREATE TABLE `user_lesson_progress` (
  `user_id` varchar(36) NOT NULL,
  `lesson_id` varchar(36) NOT NULL,
  `status` enum('NOT_STARTED','IN_PROGRESS','COMPLETED') NOT NULL,
  `attempts_count` int(11) DEFAULT NULL,
  `best_score` int(11) DEFAULT NULL,
  `last_score` int(11) DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_lesson_progress`
--

INSERT INTO `user_lesson_progress` (`user_id`, `lesson_id`, `status`, `attempts_count`, `best_score`, `last_score`, `id`, `created_at`, `updated_at`) VALUES
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '52c7fecb-389c-4919-b10d-48e9df95a6bc', 'IN_PROGRESS', 1, 0, 0, '08665332-2cb1-46e7-8587-171769493241', '2026-07-11 04:40:22', '2026-07-11 04:40:22'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '14c8ae06-5fdb-4748-aad0-26238692d933', 'IN_PROGRESS', 1, 0, 0, '08ba063b-a0d0-4112-87b4-64df9d9a2d13', '2026-07-10 16:14:03', '2026-07-10 16:14:03'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '54a1097d-53b7-4333-88eb-a6b44730242a', 'IN_PROGRESS', 1, 0, 0, '11c931ba-15a3-4090-98ff-491d0ff8c2cf', '2026-07-10 16:07:53', '2026-07-10 16:07:53'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '45d3cf24-9288-47f3-ba31-8afe95dcfe78', 'IN_PROGRESS', 1, 0, 0, '13ac696b-3031-4fee-b6fc-b38795a81ccf', '2026-07-10 16:06:23', '2026-07-10 16:06:23'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'f8f97f68-a8e2-4b69-ad0c-17fcad7b0463', 'IN_PROGRESS', 1, 0, 0, '2841cd75-e17a-4154-9443-d67374ebc6fc', '2026-07-10 16:20:01', '2026-07-10 16:20:01'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '47dc78da-36d7-49a6-959d-f84c07a5ea53', 'COMPLETED', 1, 100, 100, '32739292-0baf-4c23-a313-62d5c8403a68', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'c06dc77a-ce37-4e9a-b01b-fbbc9696400d', 'IN_PROGRESS', 1, 0, 0, '35bfc180-116a-46be-8845-659876cf09b1', '2026-07-10 16:23:51', '2026-07-10 16:23:51'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '3d2bc98d-43ea-4001-9525-6fe9fa19708e', 'IN_PROGRESS', 1, 0, 0, '45539b06-0cb1-4284-87b8-98dd30f31ba0', '2026-07-10 16:09:49', '2026-07-10 16:09:49'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '6367218c-d19e-429b-9a71-d7502b7ac080', 'COMPLETED', 1, 100, 100, '467a6637-b49f-4421-a5c0-92af87133384', '2026-07-10 16:20:00', '2026-07-10 16:20:00'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '6043f684-2388-4503-aa46-2c8a0cd78504', 'COMPLETED', 1, 100, 100, '4fea571b-a36c-45cb-9373-1958030b0a7e', '2026-07-10 16:23:51', '2026-07-10 16:23:51'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '47f442d1-1589-41f3-9a36-fde592ad4522', 'COMPLETED', 1, 100, 100, '5410ff60-0526-4d40-9856-c9d366d9fd99', '2026-07-10 16:06:23', '2026-07-10 16:06:23'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '5e7c6c2b-cbef-4fad-a100-aa1819c8711a', 'COMPLETED', 1, 100, 100, '595da180-b90c-4e3e-a58d-43373e9e302c', '2026-07-10 16:09:32', '2026-07-10 16:09:32'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'd079b702-fab2-4abd-9fef-00081207747b', 'COMPLETED', 1, 100, 100, '66a7ddfa-c650-4e47-a2ed-8cdd6c106180', '2026-07-10 16:14:03', '2026-07-10 16:14:03'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '3c8870a6-081d-4154-88ab-b60d361d3c18', 'COMPLETED', 1, 100, 100, '67b13006-bcd6-4592-ab5f-19aa007271d2', '2026-07-10 16:11:00', '2026-07-10 16:11:00'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'ebdcd7d0-0fd0-4f52-b9e4-3fe9b34dfa09', 'COMPLETED', 1, 100, 100, '68d3f071-50ce-4c32-96e7-9b60ecbf5347', '2026-07-10 16:15:48', '2026-07-10 16:15:48'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'c2572650-a575-4d45-91ba-eeef03530aea', 'COMPLETED', 1, 100, 100, '71032735-f28e-4906-a4bc-246d6ea40096', '2026-07-10 16:23:43', '2026-07-10 16:23:43'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '579fcbe8-22d9-4a4a-a643-76b4936f4909', 'COMPLETED', 1, 100, 100, '81b463f1-4f77-498a-a97a-00529e0da4e8', '2026-07-10 16:16:05', '2026-07-10 16:16:05'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'c9f049ba-4a4f-4000-be39-b10cff1f7da2', 'COMPLETED', 1, 100, 100, '8563533d-2b50-4fc7-88b2-e9487cc738cc', '2026-07-11 04:40:21', '2026-07-11 04:40:21'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'd9aaff72-156b-4faa-88dc-ead305ecb063', 'IN_PROGRESS', 1, 0, 0, '8707f1fb-57f1-44d9-92e9-31a053658c2f', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'ecc1233f-1417-4613-83fd-d2762b5cf0da', 'IN_PROGRESS', 1, 0, 0, '89f4818a-3853-4b9d-a36b-cb239763b806', '2026-07-10 16:11:00', '2026-07-10 16:11:00'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'c5ffb741-48b6-4636-a478-b038d4b245de', 'COMPLETED', 1, 100, 100, '9d1abf8e-e96c-49fe-8923-00cacff7ca42', '2026-07-10 16:21:03', '2026-07-10 16:21:03'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'fcb039d9-9cd1-4f1a-898c-b48e0e002c70', 'IN_PROGRESS', 1, 0, 0, 'a55f33b1-d023-473f-8d9f-2aea7299d8fa', '2026-07-11 04:40:21', '2026-07-11 04:40:21'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'fc34ca52-3c47-4896-826c-1122305a7942', 'IN_PROGRESS', 1, 0, 0, 'a5a94489-3b96-4815-955d-c68c603ddc46', '2026-07-10 16:23:44', '2026-07-10 16:23:44'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '555373ba-5a3f-478e-83e0-beecc429f74e', 'IN_PROGRESS', 1, 0, 0, 'aa12628a-681a-41e0-982c-40ad9ed166d8', '2026-07-10 16:16:06', '2026-07-10 16:16:06'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '5a23eb31-9ce1-40ca-bbe1-8eae5a19b575', 'IN_PROGRESS', 1, 0, 0, 'b563d49d-1c73-4660-81de-de15a6a9a949', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '27f16bc8-66e8-4cff-8fbb-57b01208d9bd', 'COMPLETED', 1, 100, 100, 'cca8f8aa-4e4d-406e-96fe-1ce9642bf616', '2026-07-10 16:07:53', '2026-07-10 16:07:53'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'ac173bab-4c54-4d6d-b9dc-3ded3c8c25d6', 'IN_PROGRESS', 1, 0, 0, 'd1d4db79-84dd-4c7f-bd62-f6c453508f64', '2026-07-10 16:21:03', '2026-07-10 16:21:03'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '1fbf7b41-4588-4334-8ef7-aa4921d2df65', 'IN_PROGRESS', 1, 0, 0, 'e05737c4-57f7-440a-b470-0f41cea740e7', '2026-07-10 16:06:38', '2026-07-10 16:06:38'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'e1db5222-af24-4be3-9837-1a4a8db18940', 'IN_PROGRESS', 1, 0, 0, 'ee8262df-9b0f-4888-8221-91e5cabc87d4', '2026-07-10 16:09:32', '2026-07-10 16:09:32'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'ed4bbc51-bfd6-40f7-af9e-a6c6dd6e6823', 'IN_PROGRESS', 1, 0, 0, 'f3023943-c3e1-4d91-a983-708f24dec828', '2026-07-10 16:15:49', '2026-07-10 16:15:49'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '23ce76f1-1a44-4b98-ada9-2223d08cf5a7', 'COMPLETED', 1, 100, 100, 'f909b799-2947-4444-af9b-7e96960b6895', '2026-07-10 16:06:38', '2026-07-10 16:06:38'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'df3ef33d-9678-4373-befe-7c408f7e7c6d', 'COMPLETED', 1, 100, 100, 'fc55c9d0-f05e-47b0-aa16-b1bf5fec5765', '2026-07-10 16:09:49', '2026-07-10 16:09:49');

-- --------------------------------------------------------

--
-- Table structure for table `user_masteries`
--

CREATE TABLE `user_masteries` (
  `user_id` varchar(36) NOT NULL,
  `skill` enum('VOCABULARY','GRAMMAR','READING','LISTENING') NOT NULL,
  `mastery_level` int(11) DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_masteries`
--

INSERT INTO `user_masteries` (`user_id`, `skill`, `mastery_level`, `id`, `created_at`, `updated_at`) VALUES
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'VOCABULARY', 13, 'c9d72ea9-4f87-4b0b-9e76-34f51d1cad19', '2026-07-10 16:06:23', '2026-07-11 04:40:21'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'GRAMMAR', 0, 'd1b3ae65-d593-4c68-bd31-cac09a937218', '2026-07-10 16:06:23', '2026-07-10 16:06:23');

-- --------------------------------------------------------

--
-- Table structure for table `user_mistakes`
--

CREATE TABLE `user_mistakes` (
  `user_id` varchar(36) NOT NULL,
  `question_id` varchar(36) NOT NULL,
  `mistake_count` int(11) DEFAULT NULL,
  `is_resolved` tinyint(1) DEFAULT NULL,
  `last_failed_at` datetime DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_mistakes`
--

INSERT INTO `user_mistakes` (`user_id`, `question_id`, `mistake_count`, `is_resolved`, `last_failed_at`, `id`, `created_at`, `updated_at`) VALUES
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'd539028b-0caf-4754-8c89-83da7b66d644', 1, 0, '2026-07-11 04:22:41', '1ec26b0a-1706-4ea0-997d-8bf35cc5e67e', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'b7c72ad2-34d4-4f07-b7f9-5e84ccc64ecc', 1, 0, '2026-07-10 16:07:53', '3061804b-ff7a-4678-8e12-be5a718c77a3', '2026-07-10 16:07:53', '2026-07-10 16:07:53'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '119d69c5-7b53-43d2-9677-b560bdaec6e3', 1, 0, '2026-07-10 16:09:49', '3adf4d89-09e0-43d7-861d-aede4aff07d8', '2026-07-10 16:09:49', '2026-07-10 16:09:49'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '395dd007-0f0d-4e4c-afb7-8618505c45cc', 1, 0, '2026-07-10 16:06:38', '4130b360-4309-4cd3-a7e5-bbeaae82a8aa', '2026-07-10 16:06:38', '2026-07-10 16:06:38'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '1f939f4b-5740-4cb7-b4c2-ee6d7541fef0', 1, 0, '2026-07-10 16:23:44', '46b47e64-7fc8-4729-8b67-e3c73351a046', '2026-07-10 16:23:44', '2026-07-10 16:23:44'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '1f9d7e8d-4189-41ab-befe-22b7b3167e8d', 1, 0, '2026-07-10 16:16:06', '476dec9d-7bbd-4a21-9d43-32175db74ea6', '2026-07-10 16:16:06', '2026-07-10 16:16:06'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'c2dbc501-6420-442a-93d8-a63302c89f0c', 1, 0, '2026-07-10 16:21:03', '494d0f17-3c35-4d98-b2a8-c84dd4f0b176', '2026-07-10 16:21:03', '2026-07-10 16:21:03'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '2fa28439-851b-4422-ab37-924c167695cb', 1, 0, '2026-07-10 16:15:49', '49702462-e194-49f2-a6ac-e1c8fdb5d9dc', '2026-07-10 16:15:49', '2026-07-10 16:15:49'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'b8c1a10b-eceb-4fbf-b725-136d5a84896b', 1, 0, '2026-07-10 16:23:51', '5434d150-04f2-408a-968f-13d956a012b1', '2026-07-10 16:23:51', '2026-07-10 16:23:51'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '2087477d-f6d5-4b57-9cd9-56891f041275', 1, 0, '2026-07-10 16:06:23', '6ccbc76f-d80a-419f-9570-efe605da3935', '2026-07-10 16:06:23', '2026-07-10 16:06:23'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '41cc3169-ed85-4a2c-8e81-404199c18f4b', 1, 0, '2026-07-11 04:40:22', '986ed063-e9a7-46d2-920b-078275541398', '2026-07-11 04:40:22', '2026-07-11 04:40:22'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'c85f81b8-5b36-458c-8326-eb2170e101e2', 1, 0, '2026-07-11 04:40:21', 'a70eb0c0-6b97-472d-b94e-85496a29e92e', '2026-07-11 04:40:21', '2026-07-11 04:40:21'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '65cf5938-6f10-4710-a664-d5b47940e9da', 1, 0, '2026-07-10 16:20:01', 'b619580c-cc3a-4e13-a18a-9061487fb440', '2026-07-10 16:20:01', '2026-07-10 16:20:01'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '11ac7036-d3f1-4ae6-8fef-76fed00df706', 1, 0, '2026-07-10 16:09:32', 'b878cd59-485e-4c6b-b821-1835689ab342', '2026-07-10 16:09:32', '2026-07-10 16:09:32'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '992a54c3-f35f-46ca-b495-c7707a9b2cc3', 1, 0, '2026-07-10 16:14:03', 'f586e686-7d2c-44f2-bd51-ab2b9ffd8e93', '2026-07-10 16:14:03', '2026-07-10 16:14:03'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '607cfe2a-f5f7-46fb-a746-5c83a629f7e1', 1, 0, '2026-07-11 04:22:41', 'f80a2784-7aec-4c15-a487-41a98026d820', '2026-07-11 04:22:41', '2026-07-11 04:22:41'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '35dc7a68-c00f-47bc-a444-aa37cddb3b62', 1, 0, '2026-07-10 16:11:00', 'fe7a2e90-3aa6-4925-850b-026c71f607c5', '2026-07-10 16:11:00', '2026-07-10 16:11:00');

-- --------------------------------------------------------

--
-- Table structure for table `user_simulation_attempts`
--

CREATE TABLE `user_simulation_attempts` (
  `user_id` varchar(36) NOT NULL,
  `simulation_id` varchar(36) NOT NULL,
  `status` varchar(50) NOT NULL,
  `started_at` datetime NOT NULL,
  `completed_at` datetime DEFAULT NULL,
  `total_score` int(11) DEFAULT NULL,
  `is_passed` tinyint(1) DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_simulation_attempts`
--

INSERT INTO `user_simulation_attempts` (`user_id`, `simulation_id`, `status`, `started_at`, `completed_at`, `total_score`, `is_passed`, `id`, `created_at`, `updated_at`) VALUES
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'a37d4eaa-9d50-4a8e-a312-28c98bda4d34', 'COMPLETED', '2026-07-11 04:40:23', '2026-07-11 04:40:23', 2, 0, '5b8320fe-1dce-4e19-8875-6e2d0922585d', '2026-07-11 04:40:23', '2026-07-11 04:40:23'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '366dedc4-a1f2-47c7-b056-e5c4686adbec', 'IN_PROGRESS', '2026-07-11 04:22:42', NULL, 0, 0, 'b2a58a06-b0f7-4d62-8a92-d9ac847aaaa5', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 'a449e794-34b5-4ebd-97ae-6588fbf537cd', 'IN_PROGRESS', '2026-07-11 04:40:23', NULL, 0, 0, 'bb7bb8a7-72fd-4ebe-83b2-d91125021be9', '2026-07-11 04:40:23', '2026-07-11 04:40:23'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', '8c2675bb-a9dc-4df8-8e91-2ee06a0a0e18', 'COMPLETED', '2026-07-11 04:22:42', '2026-07-11 04:22:42', 2, 0, 'c0ae7152-dcfb-4483-88ae-16a4ab3b5dbd', '2026-07-11 04:22:42', '2026-07-11 04:22:42');

-- --------------------------------------------------------

--
-- Table structure for table `user_simulation_attempt_questions`
--

CREATE TABLE `user_simulation_attempt_questions` (
  `attempt_id` varchar(36) NOT NULL,
  `attempt_section_id` varchar(36) NOT NULL,
  `question_id` varchar(36) NOT NULL,
  `question_revision_id` varchar(36) NOT NULL,
  `order_number` int(11) NOT NULL,
  `is_answered` tinyint(1) DEFAULT NULL,
  `is_correct` tinyint(1) DEFAULT NULL,
  `score` int(11) DEFAULT NULL,
  `answer_data_json` varchar(2000) DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_simulation_attempt_questions`
--

INSERT INTO `user_simulation_attempt_questions` (`attempt_id`, `attempt_section_id`, `question_id`, `question_revision_id`, `order_number`, `is_answered`, `is_correct`, `score`, `answer_data_json`, `id`, `created_at`, `updated_at`) VALUES
('c0ae7152-dcfb-4483-88ae-16a4ab3b5dbd', '71d9ed4c-8fa3-44e7-b57a-22c4e358bcbd', '36120889-4130-4d31-84ce-a1212482eecd', '171198a8-3733-4fc4-b9da-20c400c005e3', 1, 1, 1, 2, '{\"choice\": \"A\"}', '120f31a3-4907-4073-bb32-f18edbce95dd', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('5b8320fe-1dce-4e19-8875-6e2d0922585d', 'd6095f72-a9f8-494b-9aa8-5ce89792dc3e', 'a2ada812-3aa7-405b-9650-108405f2f1a4', '63134b83-ed9f-45a7-95c8-5b6f9ee2ca8f', 1, 1, 1, 2, '{\"choice\": \"A\"}', '39bf2515-6c76-45c4-9472-ba79128c5f86', '2026-07-11 04:40:23', '2026-07-11 04:40:23'),
('bb7bb8a7-72fd-4ebe-83b2-d91125021be9', 'c4adc522-9818-4b82-add4-c44f37a82075', 'e60237b2-15b7-4066-89a8-fe022cd477e9', '2bfa6125-7110-45df-a2e8-24f66b286d8c', 1, 0, 0, 0, NULL, '61930b8e-5699-4e8a-9bdd-3ef02845d99e', '2026-07-11 04:40:23', '2026-07-11 04:40:23'),
('b2a58a06-b0f7-4d62-8a92-d9ac847aaaa5', '58e32f18-4625-4df0-afcc-a90fcdeb429a', 'f41f53af-c586-488f-9281-57a284312186', '9dc2cef0-0855-432a-8d21-89d46dcf2116', 1, 0, 0, 0, NULL, 'e22ee396-b8c1-41bb-9e1a-8a5979d84def', '2026-07-11 04:22:42', '2026-07-11 04:22:42');

-- --------------------------------------------------------

--
-- Table structure for table `user_simulation_attempt_sections`
--

CREATE TABLE `user_simulation_attempt_sections` (
  `attempt_id` varchar(36) NOT NULL,
  `section_id` varchar(36) NOT NULL,
  `status` varchar(50) NOT NULL,
  `started_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `score` int(11) DEFAULT NULL,
  `is_passed` tinyint(1) DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_simulation_attempt_sections`
--

INSERT INTO `user_simulation_attempt_sections` (`attempt_id`, `section_id`, `status`, `started_at`, `completed_at`, `score`, `is_passed`, `id`, `created_at`, `updated_at`) VALUES
('b2a58a06-b0f7-4d62-8a92-d9ac847aaaa5', '736bfb4e-c709-4c5d-851e-4a71d9caf3c7', 'EXPIRED', '2026-07-11 03:52:42', '2026-07-11 04:22:42', 0, 0, '58e32f18-4625-4df0-afcc-a90fcdeb429a', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('c0ae7152-dcfb-4483-88ae-16a4ab3b5dbd', 'cf4edffb-bb72-4433-9f2c-adb2f4cd4890', 'COMPLETED', '2026-07-11 04:22:42', '2026-07-11 04:22:42', 2, 0, '71d9ed4c-8fa3-44e7-b57a-22c4e358bcbd', '2026-07-11 04:22:42', '2026-07-11 04:22:42'),
('bb7bb8a7-72fd-4ebe-83b2-d91125021be9', 'cfae5523-1bfd-47d0-820a-23e9815c66cd', 'EXPIRED', '2026-07-11 04:10:23', '2026-07-11 04:40:23', 0, 0, 'c4adc522-9818-4b82-add4-c44f37a82075', '2026-07-11 04:40:23', '2026-07-11 04:40:23'),
('5b8320fe-1dce-4e19-8875-6e2d0922585d', 'ee4a97ad-55af-4f3c-ba6b-7a48012f9ecf', 'COMPLETED', '2026-07-11 04:40:23', '2026-07-11 04:40:23', 2, 0, 'd6095f72-a9f8-494b-9aa8-5ce89792dc3e', '2026-07-11 04:40:23', '2026-07-11 04:40:23');

-- --------------------------------------------------------

--
-- Table structure for table `vocabularies`
--

CREATE TABLE `vocabularies` (
  `word` varchar(100) NOT NULL,
  `kana` varchar(100) NOT NULL,
  `romaji` varchar(100) DEFAULT NULL,
  `meaning` varchar(255) NOT NULL,
  `audio_id` varchar(36) DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `vocabularies`
--

INSERT INTO `vocabularies` (`word`, `kana`, `romaji`, `meaning`, `audio_id`, `id`, `created_at`, `updated_at`) VALUES
('高い 10', 'たかい', 'takai', 'High, expensive 10', NULL, '00b96962-b353-4eb7-ab2c-f1df755c0ec2', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('犬 6', 'いぬ', 'inu', 'Dog 6', NULL, '01e9eaa5-1e60-4a3e-97f1-9ef75eeb4331', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('古い 4', 'ふるい', 'furui', 'Old 4', NULL, '04130bc2-37bc-4a61-87e5-49906bacb371', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('飲む 6', 'のむ', 'nomu', 'To drink 6', NULL, '0421a928-28db-42a1-a3ea-d8dc6a6e1be6', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('買う', 'かう', 'kau', 'To buy', NULL, '045008df-2a04-488c-bafe-16fc45bbc224', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('聞く 4', 'きく', 'kiku', 'To listen, hear 4', NULL, '04e5fa47-3fb1-49dc-a438-98ed2f70e6d0', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('大きい 4', 'おおきい', 'ookii', 'Big 4', NULL, '062b6143-384b-431e-8300-96d30790fdd1', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('安い 7', 'やすい', 'yasui', 'Cheap 7', NULL, '07068e97-a720-4faf-bb36-95baab358c22', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('安い 8', 'やすい', 'yasui', 'Cheap 8', NULL, '0739beac-8346-41ba-93fb-2eb819a6ad6a', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('読む 6', 'よむ', 'yomu', 'To read 6', NULL, '09e4ce23-1a50-458e-b3c4-d6050822c2be', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('今日 4', 'きょう', 'kyou', 'Today 4', NULL, '0a263e92-632d-47c7-a720-8d14f79638db', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('学生 7', 'がくせい', 'gakusei', 'Student 7', NULL, '0b5b2995-dbd4-495e-8986-06d46cf01b16', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('高い 2', 'たかい', 'takai', 'High, expensive 2', NULL, '0bf96011-db26-4534-a360-411f9e8174ed', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('小さい 9', 'ちいさい', 'chiisai', 'Small 9', NULL, '0cdd4aac-3be7-495f-a1cf-28369c685353', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('話す 2', 'はなす', 'hanasu', 'To speak 2', NULL, '0cf2bbad-fad2-4300-8097-d131fb3518e2', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('学生 3', 'がくせい', 'gakusei', 'Student 3', NULL, '0da5ece0-1c61-4020-a152-a2e95dff5974', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('明日', 'あした', 'ashita', 'Tomorrow', NULL, '0e1aa2be-331f-4d98-9b1b-84c436107936', '2026-07-11 03:02:52', '2026-07-11 03:02:52'),
('食べる 8', 'たべる', 'taberu', 'To eat 8', NULL, '0f3473c4-5f39-4385-9d78-427ac0e6a89a', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('行く 9', 'いく', 'iku', 'To go 9', NULL, '0f553e30-4390-468f-b787-34d6cfdaeb3b', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('私 8', 'わたし', 'watashi', 'I, myself 8', NULL, '0f841b1b-66a3-4c14-bd26-05920c178c3a', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('学校 2', 'がっこう', 'gakkou', 'School 2', NULL, '0f8b127d-5c94-49f9-8226-3c36200ea09a', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('安い 4', 'やすい', 'yasui', 'Cheap 4', NULL, '0f95f15a-7501-4cb4-bc80-802347d3247d', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('行く 6', 'いく', 'iku', 'To go 6', NULL, '105d7a5e-3054-41bb-adc2-dfd4e4238d81', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('電車 6', 'でんしゃ', 'densha', 'Train 6', NULL, '11f5df9c-5f45-4b32-abce-3c2b18448db8', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('私 6', 'わたし', 'watashi', 'I, myself 6', NULL, '124d772a-58a0-4c9d-9027-55c82b018900', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('先生 4', 'せんせい', 'sensei', 'Teacher 4', NULL, '1321a23e-bd50-4735-9871-3ba197037da0', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('大きい 2', 'おおきい', 'ookii', 'Big 2', NULL, '135b00bb-c154-4005-8662-b21d008df3b5', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('電車 8', 'でんしゃ', 'densha', 'Train 8', NULL, '136dd3f9-7835-4e72-9ae2-23fc1bdd8ea5', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('猫f6da', 'ねこ', 'neko', 'Cat', NULL, '138d77b5-c496-487b-ac73-3b6bd6a6f0a4', '2026-07-10 15:25:57', '2026-07-10 15:25:57'),
('電車 4', 'でんしゃ', 'densha', 'Train 4', NULL, '145b763f-106e-449d-8022-87b70b519579', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('新しい 4', 'あたらしい', 'atarashii', 'New 4', NULL, '14b3f351-4436-4819-bbae-4f63ece1a2ec', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('聞く 9', 'きく', 'kiku', 'To listen, hear 9', NULL, '1603fb84-8177-4867-8dfe-e17dc4da546d', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('読む 8', 'よむ', 'yomu', 'To read 8', NULL, '163c37d0-c549-4a07-a0df-2e1feaa69f84', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('大きい 9', 'おおきい', 'ookii', 'Big 9', NULL, '16938d48-7046-4171-83f2-7d978d8a95d0', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('犬 5', 'いぬ', 'inu', 'Dog 5', NULL, '17f362ce-cbaf-4d26-9eaf-19a8698030b9', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('読む 5', 'よむ', 'yomu', 'To read 5', NULL, '1885917c-ac26-41bd-8a4a-89ddd0f93608', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('先生 5', 'せんせい', 'sensei', 'Teacher 5', NULL, '19f9afc9-af9e-4fa9-a3da-1cad30e0a49e', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('本', 'ほん', 'hon', 'Book', NULL, '1aa46363-8f0f-4c15-8988-e4033b6b5e3e', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('安い 9', 'やすい', 'yasui', 'Cheap 9', NULL, '1b573d40-7b10-4f19-be07-6bb1ceb3d5e7', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('話す 5', 'はなす', 'hanasu', 'To speak 5', NULL, '1d023e43-0557-4d88-9c16-21aca223bdc2', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('会社 3', 'かいしゃ', 'kaisha', 'Company 3', NULL, '1d735be6-31e6-4af4-b30c-79a98931c00d', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('本 8', 'ほん', 'hon', 'Book 8', NULL, '1da67aa7-1095-454d-ad39-6bbb07c05548', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('安い 10', 'やすい', 'yasui', 'Cheap 10', NULL, '1eecfff8-cf78-4c14-9a90-e9afc25f7ebe', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('書く 9', 'かく', 'kaku', 'To write 9', NULL, '2006593a-78e8-47dc-82fc-c9b6ad0dd00e', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('新しい 5', 'あたらしい', 'atarashii', 'New 5', NULL, '20942236-5377-44bf-af6a-c86413d41e6d', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('水 8', 'みず', 'mizu', 'Water 8', NULL, '24f832fd-f34d-4034-bbf9-6071601913de', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('話す 8', 'はなす', 'hanasu', 'To speak 8', NULL, '268ed072-2392-4abd-b0f0-47867e4f14c9', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('大きい 10', 'おおきい', 'ookii', 'Big 10', NULL, '26da50b0-3f2a-4b93-b2bb-f627fd559e68', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('読む 9', 'よむ', 'yomu', 'To read 9', NULL, '27495bde-074b-4187-8c68-5bef8d49aa4f', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('犬 10', 'いぬ', 'inu', 'Dog 10', NULL, '2b751270-6a1c-48b6-84bf-edba8e673a21', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('高い 3', 'たかい', 'takai', 'High, expensive 3', NULL, '2b9f2c20-6ac3-4c9f-998b-acbf10acf513', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('明日 7', 'あした', 'ashita', 'Tomorrow 7', NULL, '2bbbf13d-a1bd-43c9-88a4-6eea7c03ea55', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('見る 9', 'みる', 'miru', 'To see 9', NULL, '2d8d47f9-6176-4adf-84a6-a0592bb2960e', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('買う 8', 'かう', 'kau', 'To buy 8', NULL, '2d9bda27-e4a4-44d1-a900-78b771f6e025', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('車 3', 'くるま', 'kuruma', 'Car 3', NULL, '2dce2e2f-6099-4c08-9044-911be6a36b2e', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('話す 9', 'はなす', 'hanasu', 'To speak 9', NULL, '2df0f0b3-a5f1-498f-ab3e-d99c15698da0', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('話す 3', 'はなす', 'hanasu', 'To speak 3', NULL, '2e38e229-29a1-4a73-822c-4321102089a2', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('猫79e7', 'ねこ', 'neko', 'Cat', NULL, '2e47b7df-4d56-437a-aa70-0d6dd9cdb859', '2026-07-10 15:26:44', '2026-07-10 15:26:44'),
('行く 7', 'いく', 'iku', 'To go 7', NULL, '2e604afe-4793-40c5-bd1a-b06af2f07bd3', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('私 7', 'わたし', 'watashi', 'I, myself 7', NULL, '2edce1ef-65a5-49d5-8613-0d4bce408518', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('小さい 7', 'ちいさい', 'chiisai', 'Small 7', NULL, '312cc087-2944-40c3-ab8b-7c172bc8f1e6', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('新しい 3', 'あたらしい', 'atarashii', 'New 3', NULL, '34332d8c-c7ec-41c0-b4a5-9cc52e0110ad', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('行く 5', 'いく', 'iku', 'To go 5', NULL, '34ca1e5d-919c-40f1-98ee-4ce311370a64', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('行く 8', 'いく', 'iku', 'To go 8', NULL, '3597ba1b-2faf-4d45-b2d9-03e4ba3c869b', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('食べる 7', 'たべる', 'taberu', 'To eat 7', NULL, '37b92982-3f23-42ef-8718-e56c6e4baaf0', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('明日 8', 'あした', 'ashita', 'Tomorrow 8', NULL, '387af58c-7f09-4242-9297-e8d3f24579c6', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('来る 6', 'くる', 'kuru', 'To come 6', NULL, '39305728-eb14-447c-b3c0-db52f8a4cbe7', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('先生 10', 'せんせい', 'sensei', 'Teacher 10', NULL, '3998f3ae-7652-41fe-a2d2-f14c3127366c', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('猫5ea3', 'ねこ', 'neko', 'Cat', NULL, '3a02163c-0521-44ae-ba0c-7f04b7f307a4', '2026-07-11 04:40:20', '2026-07-11 04:40:20'),
('昨日', 'きのう', 'kinou', 'Yesterday', NULL, '3a6a3060-2cf4-4614-bceb-3adb6085a9e8', '2026-07-11 03:02:52', '2026-07-11 03:02:52'),
('会社 6', 'かいしゃ', 'kaisha', 'Company 6', NULL, '3b0d4e86-8199-470d-b2e7-d45562ed7a3d', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('本 7', 'ほん', 'hon', 'Book 7', NULL, '3bed7e35-207c-4ce8-ba84-01511bb04482', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('明日 3', 'あした', 'ashita', 'Tomorrow 3', NULL, '3d40902e-4d45-47b6-8308-ca148174a19f', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('犬 2', 'いぬ', 'inu', 'Dog 2', NULL, '3d771fe7-61f2-46ea-97fc-9c8076ed46ed', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('本 2', 'ほん', 'hon', 'Book 2', NULL, '3e05cd16-ff6f-459a-92b2-c48d9c169793', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('電車 3', 'でんしゃ', 'densha', 'Train 3', NULL, '3ea13ba3-22f3-4d2f-966c-ad04937002d6', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('車 10', 'くるま', 'kuruma', 'Car 10', NULL, '3eb8f3b1-d49b-4b97-85d2-87d176b554ef', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('行く', 'いく', 'iku', 'To go', NULL, '3fd63afd-6bc0-4b14-9126-cbb409c484b9', '2026-07-11 03:03:59', '2026-07-11 03:03:59'),
('猫 9', 'ねこ', 'neko', 'Cat 9', NULL, '4007c34e-1a1f-41d4-a10f-867c10b3f941', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('安い 6', 'やすい', 'yasui', 'Cheap 6', NULL, '411ea2e3-b820-489f-a815-8a335e98bdd1', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('見る 3', 'みる', 'miru', 'To see 3', NULL, '41b6d1db-424c-4be2-a54b-33eed7d3a814', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('会社 9', 'かいしゃ', 'kaisha', 'Company 9', NULL, '43f7b0cf-38eb-438a-9159-101b82000cd6', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('犬 9', 'いぬ', 'inu', 'Dog 9', NULL, '44a5c8da-a16a-42e3-a927-84852a59cbc4', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('安い 3', 'やすい', 'yasui', 'Cheap 3', NULL, '45291676-7001-4df6-80fd-5d5e7780faa1', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('今日 3', 'きょう', 'kyou', 'Today 3', NULL, '4557393a-92d5-4484-9719-b306c309f342', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('飲む 10', 'のむ', 'nomu', 'To drink 10', NULL, '4777d44b-0210-4fd1-840b-f37c75b68ec9', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('犬 4', 'いぬ', 'inu', 'Dog 4', NULL, '479a3c74-f455-4dda-a59e-4414b9931054', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('明日 6', 'あした', 'ashita', 'Tomorrow 6', NULL, '48c88db7-8594-485b-86f4-582a8b4607c7', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('車 5', 'くるま', 'kuruma', 'Car 5', NULL, '492c697b-6c38-485c-a6c1-fa870324e425', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('昨日 3', 'きのう', 'kinou', 'Yesterday 3', NULL, '4ba9de05-9bdf-47a1-a18a-5d355ab57a6b', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('昨日 4', 'きのう', 'kinou', 'Yesterday 4', NULL, '4c296162-a70d-4ba1-b6b5-6e170ccda234', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('聞く 10', 'きく', 'kiku', 'To listen, hear 10', NULL, '4d6ba03d-55d2-48bc-a5a6-027dc8ae99c0', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('大きい 3', 'おおきい', 'ookii', 'Big 3', NULL, '50263b11-bf93-4ee4-8d44-48934415554c', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('今日 2', 'きょう', 'kyou', 'Today 2', NULL, '505d961d-9939-40d0-9a64-f7f8657a05b8', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('来る 2', 'くる', 'kuru', 'To come 2', NULL, '506615d9-7ff5-4734-8a1d-f9f92f2cec70', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('会社', 'かいしゃ', 'kaisha', 'Company', NULL, '508eecf1-e9e3-49f0-93e2-92973bf368a6', '2026-07-11 03:02:52', '2026-07-11 03:02:52'),
('電車 10', 'でんしゃ', 'densha', 'Train 10', NULL, '50a9b80f-6568-452c-aaf0-9b06dfcaace4', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('学生 4', 'がくせい', 'gakusei', 'Student 4', NULL, '50bbf2fb-bf05-468b-90ce-d3a0bc060892', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('食べる 4', 'たべる', 'taberu', 'To eat 4', NULL, '53204db5-8d45-44e6-893b-046a308c34d2', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('来る 10', 'くる', 'kuru', 'To come 10', NULL, '54509a79-a51b-42fb-b13e-5eac9fee6f4b', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('犬 8', 'いぬ', 'inu', 'Dog 8', NULL, '54c66b9b-d4b7-46a8-85fc-9e99764d8694', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('先生 9', 'せんせい', 'sensei', 'Teacher 9', NULL, '55cfd7be-7d01-4878-aa01-2fd8c8675317', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('来る 4', 'くる', 'kuru', 'To come 4', NULL, '56ae7f75-cc58-417d-9c74-e9736f6203aa', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('水 3', 'みず', 'mizu', 'Water 3', NULL, '572183bc-0f12-449b-a9ca-7e0457adf7ff', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('猫 6', 'ねこ', 'neko', 'Cat 6', NULL, '57cde26f-ef37-4669-b53e-d852fdab8250', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('私 3', 'わたし', 'watashi', 'I, myself 3', NULL, '58e350ee-a0ba-4527-8cda-0b639bd24790', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('本 9', 'ほん', 'hon', 'Book 9', NULL, '598b28cc-9e80-4437-a312-f56e6402cb4e', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('犬', 'いぬ', 'inu', 'Dog', NULL, '5afc5219-789e-4e37-9ac4-dbb230db2c63', '2026-07-10 15:22:31', '2026-07-10 15:22:31'),
('高い 7', 'たかい', 'takai', 'High, expensive 7', NULL, '5b27da4d-7309-4c5a-8cc9-3c14faf0420a', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('猫', 'ねこ', 'neko', 'Cat', NULL, '5b706b3a-9d3a-4b77-b2df-94dacc153caf', '2026-07-10 15:23:44', '2026-07-10 15:23:44'),
('書く 8', 'かく', 'kaku', 'To write 8', NULL, '5b883d5f-4eaa-4b04-85ab-3213184aa062', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('話す', 'はなす', 'hanasu', 'To speak', NULL, '5c917294-7261-4de9-914c-4b48d9c57d51', '2026-07-11 03:03:59', '2026-07-11 03:03:59'),
('来る', 'くる', 'kuru', 'To come', NULL, '5caa0b2a-19ef-4d2d-8c13-e19ffc5907e8', '2026-07-11 03:03:59', '2026-07-11 03:03:59'),
('学校 5', 'がっこう', 'gakkou', 'School 5', NULL, '5cf7bb7a-4c02-41ad-84b1-11b883f31314', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('学校 7', 'がっこう', 'gakkou', 'School 7', NULL, '5d4250c6-db24-444f-8c87-ac5718cffff1', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('来る 9', 'くる', 'kuru', 'To come 9', NULL, '5d4a3979-e52f-4fc4-a291-579f19504c60', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('先生 8', 'せんせい', 'sensei', 'Teacher 8', NULL, '5fd35b35-5443-445f-b148-38f9aa0ade9e', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('水 5', 'みず', 'mizu', 'Water 5', NULL, '622c604b-ea21-457a-b2b1-b4f75d078f24', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('見る 6', 'みる', 'miru', 'To see 6', NULL, '6319c7da-3a77-41fa-b6b9-d8d8f8bab509', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('古い 8', 'ふるい', 'furui', 'Old 8', NULL, '64fe16d6-e551-465d-817d-34c46ee4b650', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('聞く', 'きく', 'kiku', 'To listen, hear', NULL, '65c24e6d-a532-448f-ac94-2fa7fe379afe', '2026-07-11 03:03:59', '2026-07-11 03:03:59'),
('学校 10', 'がっこう', 'gakkou', 'School 10', NULL, '66836df7-fe9f-4131-a2df-858c69ada4a8', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('高い', 'たかい', 'takai', 'High, expensive', NULL, '6a5f9c8b-c452-42a3-b135-7da3fdfa3061', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('買う 9', 'かう', 'kau', 'To buy 9', NULL, '6b3e6fa1-61db-4b33-b8d0-cfbb00066d87', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('古い 7', 'ふるい', 'furui', 'Old 7', NULL, '6c5739c4-f9c6-475d-be47-504d2186c185', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('食べる 6', 'たべる', 'taberu', 'To eat 6', NULL, '6d2a9bd7-dbb7-4c50-aa5e-5ed9a77f2772', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('安い 2', 'やすい', 'yasui', 'Cheap 2', NULL, '6f13fc16-fbd3-41c8-aea4-5b2a56a060c7', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('聞く 3', 'きく', 'kiku', 'To listen, hear 3', NULL, '6ffc455b-666d-4a7d-b2b7-554fa0dd95ce', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('昨日 2', 'きのう', 'kinou', 'Yesterday 2', NULL, '7048534a-cf9f-4dd3-9e2e-9d8b2966cedc', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('話す 6', 'はなす', 'hanasu', 'To speak 6', NULL, '70e23d8a-551c-40c7-a06f-bb428ec264ef', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('大きい 7', 'おおきい', 'ookii', 'Big 7', NULL, '71284441-9872-45c1-9729-76f3f109f2f9', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('電車 5', 'でんしゃ', 'densha', 'Train 5', NULL, '7142784c-3dbf-4e5e-b999-6755ef2d6f2e', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('明日 10', 'あした', 'ashita', 'Tomorrow 10', NULL, '716b7a2b-9c78-49c7-b985-ae6b89259ca9', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('学校 3', 'がっこう', 'gakkou', 'School 3', NULL, '72428d39-93a1-46eb-b06d-9ef530598f6d', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('犬 3', 'いぬ', 'inu', 'Dog 3', NULL, '726f6e6c-eaf9-41cd-b83f-51f070a7beda', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('猫 8', 'ねこ', 'neko', 'Cat 8', NULL, '7482bfff-cdfa-46a8-933a-a1898f8f1fa8', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('学校 8', 'がっこう', 'gakkou', 'School 8', NULL, '76677b9f-69da-4685-923d-2d3807bd9dbd', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('今日 8', 'きょう', 'kyou', 'Today 8', NULL, '769ec639-2c58-4457-a81a-8b0f43daef38', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('新しい', 'あたらしい', 'atarashii', 'New', NULL, '7ab502a0-7884-4014-a938-4764cf9935d0', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('見る 10', 'みる', 'miru', 'To see 10', NULL, '7b443252-f09d-4306-9206-018b8377d7b3', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('今日 6', 'きょう', 'kyou', 'Today 6', NULL, '7c893639-7b2f-44f7-ace2-83d4a9a3de5f', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('聞く 5', 'きく', 'kiku', 'To listen, hear 5', NULL, '7d3ed299-d949-4909-958e-3d978a3c75c7', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('水 6', 'みず', 'mizu', 'Water 6', NULL, '7d5a58c3-b04d-47b9-91ff-9c4917326b96', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('高い 4', 'たかい', 'takai', 'High, expensive 4', NULL, '7e8000ac-a099-47e7-ba70-1a1135171395', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('猫f45f', 'ねこ', 'neko', 'Cat', NULL, '7f1c4cf4-4966-400d-84e0-b9415dc0e6b4', '2026-07-10 15:26:56', '2026-07-10 15:26:56'),
('本 5', 'ほん', 'hon', 'Book 5', NULL, '7f722122-0e38-4ea4-8926-13f69afd599a', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('猫 5', 'ねこ', 'neko', 'Cat 5', NULL, '7fdd59cf-53a9-4066-8440-f3cf2cad7a72', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('読む 3', 'よむ', 'yomu', 'To read 3', NULL, '80d7e8e0-6dad-4f4c-9994-3ad35a16397f', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('先生 3', 'せんせい', 'sensei', 'Teacher 3', NULL, '8197b0af-75e2-4b27-ba77-450c9451ad2b', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('高い 9', 'たかい', 'takai', 'High, expensive 9', NULL, '823b6319-d6a2-4884-a905-9ea123c26a3a', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('古い 3', 'ふるい', 'furui', 'Old 3', NULL, '82468973-7b37-42e8-9ece-3d391c923961', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('書く 7', 'かく', 'kaku', 'To write 7', NULL, '826ff2d7-e981-4bed-973c-fa6fda6fefe3', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('猫8a28', 'ねこ', 'neko', 'Cat', NULL, '82fe6110-de61-4000-8f7a-49636aaac353', '2026-07-10 15:26:01', '2026-07-10 15:26:01'),
('書く 6', 'かく', 'kaku', 'To write 6', NULL, '8397b4f9-eefd-47f0-8017-045b7a332acb', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('学校 9', 'がっこう', 'gakkou', 'School 9', NULL, '839cb493-d7cf-4307-81f0-9fc4becf3128', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('飲む', 'のむ', 'nomu', 'To drink', NULL, '83d194f9-591a-4d20-ab72-0a9f284263c5', '2026-07-11 03:02:52', '2026-07-11 03:02:52'),
('電車 9', 'でんしゃ', 'densha', 'Train 9', NULL, '85217e7c-ea69-4938-82fd-4a88aa19d0c1', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('本 10', 'ほん', 'hon', 'Book 10', NULL, '85adde13-80cd-4a17-8715-89d82966ae05', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('先生 7', 'せんせい', 'sensei', 'Teacher 7', NULL, '86492d13-02ab-45b3-8007-94af1e2ce8aa', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('先生 2', 'せんせい', 'sensei', 'Teacher 2', NULL, '86f0df21-daee-4725-9bb7-0b09baff201e', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('学生 2', 'がくせい', 'gakusei', 'Student 2', NULL, '879d31d0-f7a8-4c7e-901e-aa3e40910459', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('私 2', 'わたし', 'watashi', 'I, myself 2', NULL, '87faedb3-d330-44d3-b830-5559f123a6ca', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('犬 7', 'いぬ', 'inu', 'Dog 7', NULL, '89c40575-250c-4789-b7da-830e30f1fc2f', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('会社 2', 'かいしゃ', 'kaisha', 'Company 2', NULL, '89dfc2c4-5e33-401c-a499-979d99388c40', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('猫 7', 'ねこ', 'neko', 'Cat 7', NULL, '8a199a5a-bb36-49d2-a5ca-2689f5bc1ad2', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('大きい 8', 'おおきい', 'ookii', 'Big 8', NULL, '8a9503ab-837f-4818-8fa3-025b2361ec70', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('水 10', 'みず', 'mizu', 'Water 10', NULL, '8c22b79e-7e06-4a14-a26e-feea7c3428f6', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('昨日 5', 'きのう', 'kinou', 'Yesterday 5', NULL, '8c301341-1530-4759-a38b-29aaddf9d159', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('読む 7', 'よむ', 'yomu', 'To read 7', NULL, '8cd03c9a-4004-4ea2-9dd8-ad39ca80a692', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('会社 10', 'かいしゃ', 'kaisha', 'Company 10', NULL, '8d42fdd2-5e19-4757-95d8-1b03434f57e0', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('読む 2', 'よむ', 'yomu', 'To read 2', NULL, '8dfcb06a-4461-4990-9ca0-d191050de98e', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('古い 5', 'ふるい', 'furui', 'Old 5', NULL, '8f9fdc81-f8d3-4f77-bdbe-f4c993e15e7a', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('本 3', 'ほん', 'hon', 'Book 3', NULL, '904a1a72-3839-4288-9b2c-955e7e87f8b8', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('学校', 'がっこう', 'gakkou', 'School', NULL, '9063c1a4-d8a6-4fe1-af04-7241cdea6cf5', '2026-07-11 03:02:52', '2026-07-11 03:02:52'),
('来る 3', 'くる', 'kuru', 'To come 3', NULL, '90c13d14-4e15-4c3c-bab6-bae4c7097473', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('来る 8', 'くる', 'kuru', 'To come 8', NULL, '90f101c5-2bb1-472f-a20a-df1513623e76', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('話す 7', 'はなす', 'hanasu', 'To speak 7', NULL, '92816106-4ce9-4506-968c-77c1b000d54b', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('買う 5', 'かう', 'kau', 'To buy 5', NULL, '93b54f4d-ad95-402b-8a6a-8caecf495de0', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('飲む 7', 'のむ', 'nomu', 'To drink 7', NULL, '93be667f-a662-4768-93e0-f06c4b4c0055', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('本 4', 'ほん', 'hon', 'Book 4', NULL, '93cf8a1e-2b74-486f-8f3d-17eb920c8f0b', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('会社 5', 'かいしゃ', 'kaisha', 'Company 5', NULL, '942f70b4-15e4-4c95-9390-7849a3ecd237', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('見る 7', 'みる', 'miru', 'To see 7', NULL, '9502e5f8-c9ac-4f87-994d-96cf59a97761', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('飲む 4', 'のむ', 'nomu', 'To drink 4', NULL, '958fb0bf-4462-40d9-90f1-10fa5cdc6dbc', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('古い 2', 'ふるい', 'furui', 'Old 2', NULL, '96f97c93-3de2-48f6-a0a9-827b85bff44c', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('小さい 6', 'ちいさい', 'chiisai', 'Small 6', NULL, '987f9e91-7a9a-4e48-9779-b7646447fda7', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('学校 4', 'がっこう', 'gakkou', 'School 4', NULL, '98951ab9-7d61-464f-92e9-8bde77b101f3', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('見る 8', 'みる', 'miru', 'To see 8', NULL, '9971d699-d7ca-4121-be11-de0bdb656988', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('古い 6', 'ふるい', 'furui', 'Old 6', NULL, '99a27dc2-fb9f-4534-82c2-07bc5bc035b0', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('安い 5', 'やすい', 'yasui', 'Cheap 5', NULL, '9abc4f40-9b97-4e71-9872-07a7956f8b48', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('私', 'わたし', 'watashi', 'I, myself', NULL, '9c338a6e-6b17-4dad-b552-4d5efda55368', '2026-07-10 15:13:34', '2026-07-10 15:13:34'),
('猫 4', 'ねこ', 'neko', 'Cat 4', NULL, '9c3efb63-c5a7-4db0-8e5e-dff30f11af6e', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('小さい 3', 'ちいさい', 'chiisai', 'Small 3', NULL, '9f8d50a3-0b0c-4cd5-9b77-66f44c0d211f', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('車 6', 'くるま', 'kuruma', 'Car 6', NULL, 'a133183a-ec2e-4575-af8a-d392c100a3a4', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('今日 5', 'きょう', 'kyou', 'Today 5', NULL, 'a3b04a30-fb5d-44be-9168-2da3914cb789', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('今日 10', 'きょう', 'kyou', 'Today 10', NULL, 'a3da0638-1280-4c91-a269-4b4ae66bbe79', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('猫 10', 'ねこ', 'neko', 'Cat 10', NULL, 'a424f64a-ad93-490e-ada5-7acab8a55aa8', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('聞く 7', 'きく', 'kiku', 'To listen, hear 7', NULL, 'a4250445-9995-4d5c-ae72-22b5ba8eae0c', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('書く 4', 'かく', 'kaku', 'To write 4', NULL, 'a45e05d4-6c6d-478d-88a3-1b3d1b18af3b', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('来る 5', 'くる', 'kuru', 'To come 5', NULL, 'a66b0055-c29e-48d0-85a5-a6c148483160', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('車 4', 'くるま', 'kuruma', 'Car 4', NULL, 'a674e4b9-cc55-4d65-a9b8-4e9af4ee2ab9', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('今日', 'きょう', 'kyou', 'Today', NULL, 'a6a78c06-9814-41ed-93f4-aa635b8a3d1a', '2026-07-11 03:02:52', '2026-07-11 03:02:52'),
('私 9', 'わたし', 'watashi', 'I, myself 9', NULL, 'a6a878c0-1460-4f25-aa21-4f11e5f15e6d', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('行く 10', 'いく', 'iku', 'To go 10', NULL, 'a6d07409-9b26-468b-aabf-ce89381bb26a', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('会社 4', 'かいしゃ', 'kaisha', 'Company 4', NULL, 'a8e79607-72a2-4389-95fa-63127a29594c', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('聞く 6', 'きく', 'kiku', 'To listen, hear 6', NULL, 'aa09df50-3a78-460d-a720-9692ed5e016c', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('水 4', 'みず', 'mizu', 'Water 4', NULL, 'ab121b59-c276-481a-a759-ad1d790d512e', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('水 7', 'みず', 'mizu', 'Water 7', NULL, 'ac5a28ad-3ee3-49df-bb03-5f48d030550c', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('車 7', 'くるま', 'kuruma', 'Car 7', NULL, 'acb793f8-ffbf-4a06-a556-3755ca37e284', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('飲む 2', 'のむ', 'nomu', 'To drink 2', NULL, 'add2ad43-96c3-4c46-9cfb-c11e405e0335', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('書く', 'かく', 'kaku', 'To write', NULL, 'ae494a5d-a77a-4b16-aaf0-03ab7811d0d3', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('私 5', 'わたし', 'watashi', 'I, myself 5', NULL, 'b0c85d01-d49f-4596-b86a-1f445e6a2ca5', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('明日 2', 'あした', 'ashita', 'Tomorrow 2', NULL, 'b1f92536-0a99-45ed-8891-30169466f8a5', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('猫84cb', 'ねこ', 'neko', 'Cat', NULL, 'b2665975-d12d-4709-800b-de525cc11280', '2026-07-11 04:22:40', '2026-07-11 04:22:40'),
('食べる 9', 'たべる', 'taberu', 'To eat 9', NULL, 'b2678898-b0ea-44ab-a58f-0cb978411a12', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('見る 5', 'みる', 'miru', 'To see 5', NULL, 'b2b0781e-20fb-497c-b9e2-f84a58d071cd', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('私 4', 'わたし', 'watashi', 'I, myself 4', NULL, 'b2c56206-a856-4cfe-9434-289a58e77ae0', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('飲む 3', 'のむ', 'nomu', 'To drink 3', NULL, 'b30fe8b9-1d63-4597-8081-052107357647', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('小さい', 'ちいさい', 'chiisai', 'Small', NULL, 'b34dfe0c-709d-46ad-8516-e7923d449365', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('猫 3', 'ねこ', 'neko', 'Cat 3', NULL, 'b3ae4036-f134-46e4-8ef4-615648428a8b', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('古い 9', 'ふるい', 'furui', 'Old 9', NULL, 'b3e2adbb-edce-40dc-9bf2-e0b03dc37ba3', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('行く 4', 'いく', 'iku', 'To go 4', NULL, 'b3e8500e-9eb7-44d6-9346-1b2a11143ac1', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('小さい 2', 'ちいさい', 'chiisai', 'Small 2', NULL, 'b3fe0842-6f19-4393-87b3-2eea98ffb41f', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('話す 10', 'はなす', 'hanasu', 'To speak 10', NULL, 'b4a690d5-83d5-4659-9aae-4caa100968bb', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('大きい 5', 'おおきい', 'ookii', 'Big 5', NULL, 'b5a3dd81-4da9-416d-b794-f52069ced7d3', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('学生 10', 'がくせい', 'gakusei', 'Student 10', NULL, 'ba16e4f2-eb71-4d21-ba20-876f5136ca80', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('飲む 5', 'のむ', 'nomu', 'To drink 5', NULL, 'ba2f476a-66e2-4aa0-bdab-b8121633b103', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('買う 2', 'かう', 'kau', 'To buy 2', NULL, 'bb34c9f4-9de1-42d0-96e5-46e4c504325b', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('先生', 'せんせい', 'sensei', 'Teacher', NULL, 'bc6ea416-a441-4e35-813c-85fd7a2dac71', '2026-07-10 15:13:34', '2026-07-10 15:13:34'),
('買う 4', 'かう', 'kau', 'To buy 4', NULL, 'bdf8d0b3-087b-4fb8-a2cb-b01b2babcb73', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('読む 4', 'よむ', 'yomu', 'To read 4', NULL, 'be0d7f85-bd48-4b49-91c9-43881f5e9846', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('車', 'くるま', 'kuruma', 'Car', NULL, 'bf689cf8-0985-4d1c-9f16-ac5f60173e29', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('来る 7', 'くる', 'kuru', 'To come 7', NULL, 'bf823f98-394d-4eb7-ac55-0bdfc184488d', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('水 2', 'みず', 'mizu', 'Water 2', NULL, 'bf8f6c08-1b0f-470c-b4c5-f8669a4a635c', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('飲む 9', 'のむ', 'nomu', 'To drink 9', NULL, 'c024f056-eadb-494c-8609-630cca539b84', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('新しい 2', 'あたらしい', 'atarashii', 'New 2', NULL, 'c0ff85ab-2b80-4d51-a9ca-68dfbf8d0dc6', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('新しい 6', 'あたらしい', 'atarashii', 'New 6', NULL, 'c105b80f-5c3a-48e7-b924-53a2f6f81e09', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('見る 2', 'みる', 'miru', 'To see 2', NULL, 'c2a97e59-53aa-4663-89a8-6d1e8a0247ef', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('水 9', 'みず', 'mizu', 'Water 9', NULL, 'c38ffb1e-ee4f-4855-8845-74b0cb53b85a', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('読む 10', 'よむ', 'yomu', 'To read 10', NULL, 'c5221fb2-7ea6-4d40-91b8-27adf3a4aa5b', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('学生 5', 'がくせい', 'gakusei', 'Student 5', NULL, 'c5eea8aa-9068-419e-ba49-987e15bf7ea6', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('猫', 'ねこ', 'neko', 'Cat', NULL, 'c63dcf3b-536f-4d41-b0c3-f5f0e39b0af2', '2026-07-10 15:22:31', '2026-07-10 15:22:31'),
('読む', 'よむ', 'yomu', 'To read', NULL, 'c754076e-d3ee-4947-b5df-575dd2d85279', '2026-07-11 03:03:59', '2026-07-11 03:03:59'),
('見る', 'みる', 'miru', 'To see', NULL, 'c77d1d2a-c316-4c5b-84f8-38b36d585c22', '2026-07-11 03:03:59', '2026-07-11 03:03:59'),
('食べる 2', 'たべる', 'taberu', 'To eat 2', NULL, 'c8944fb1-c5c0-4561-a626-0f71cfafe0c1', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('本 6', 'ほん', 'hon', 'Book 6', NULL, 'c9c0e1f2-41d1-4dec-aa17-9cfe9b81f16c', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('今日 9', 'きょう', 'kyou', 'Today 9', NULL, 'ca0f9c97-6574-4945-b1c1-25f77d028297', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('車 2', 'くるま', 'kuruma', 'Car 2', NULL, 'ca19a6bc-3259-4ec2-9497-b57f389c3e3a', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('新しい 8', 'あたらしい', 'atarashii', 'New 8', NULL, 'caabc81e-0347-4b22-a22b-6081bb72ef65', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('新しい 9', 'あたらしい', 'atarashii', 'New 9', NULL, 'ccfbd08a-b8fb-4286-b3e6-8406b8a306a2', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('今日 7', 'きょう', 'kyou', 'Today 7', NULL, 'cdac3b15-c2e5-4e23-a9c7-a3aa41e001bc', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('新しい 7', 'あたらしい', 'atarashii', 'New 7', NULL, 'cdcd3638-c724-446d-b313-eb7daceab8cc', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('明日 5', 'あした', 'ashita', 'Tomorrow 5', NULL, 'ce480380-2efb-4926-a957-34203444c14e', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('会社 8', 'かいしゃ', 'kaisha', 'Company 8', NULL, 'ce715ef6-6d3c-4547-97f8-b66c14ec9cd0', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('学校 6', 'がっこう', 'gakkou', 'School 6', NULL, 'd20a11ad-2c26-4d34-998c-4e12b3e26b8e', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('高い 6', 'たかい', 'takai', 'High, expensive 6', NULL, 'd282e323-00c8-44db-a650-fb63a1ff57d3', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('食べる 5', 'たべる', 'taberu', 'To eat 5', NULL, 'd30265c0-92d9-42ec-86f8-a831cdff4214', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('会社 7', 'かいしゃ', 'kaisha', 'Company 7', NULL, 'd3293ff3-83ba-4594-b58f-99bbabbb4bbe', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('買う 6', 'かう', 'kau', 'To buy 6', NULL, 'd3331ec0-8c91-4907-b481-2c214b535612', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('新しい 10', 'あたらしい', 'atarashii', 'New 10', NULL, 'd45e5536-f72b-47cb-853d-46167dae1ddd', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('電車', 'でんしゃ', 'densha', 'Train', NULL, 'd532de17-f3b0-4d67-8991-8282b9571cd0', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('買う 3', 'かう', 'kau', 'To buy 3', NULL, 'd675b3df-a69d-4653-b235-848da9f67aa3', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('大きい', 'おおきい', 'ookii', 'Big', NULL, 'd84d5a18-4d87-4f76-b5d6-5a7670c2955c', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('学生 8', 'がくせい', 'gakusei', 'Student 8', NULL, 'd84fac9c-cf70-4fb3-afae-5e18cfe348fe', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('小さい 8', 'ちいさい', 'chiisai', 'Small 8', NULL, 'd9a6d3a6-b39b-4389-8405-b9eaba2e95fa', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('小さい 5', 'ちいさい', 'chiisai', 'Small 5', NULL, 'daa1d8c6-25a0-4ee8-ad3b-d7425f7f3751', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('見る 4', 'みる', 'miru', 'To see 4', NULL, 'dc73157b-d61f-4a4c-8a98-8d7858a9ca9c', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('明日 9', 'あした', 'ashita', 'Tomorrow 9', NULL, 'dcf45d42-aa2d-4989-ae94-c6b9f5953633', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('私 10', 'わたし', 'watashi', 'I, myself 10', NULL, 'ddd89c01-1920-4eff-9599-1cfffa9999d2', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('行く 2', 'いく', 'iku', 'To go 2', NULL, 'ddec9d8b-7066-4fc2-8f32-5d64429ba0cc', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('書く 5', 'かく', 'kaku', 'To write 5', NULL, 'dfbdf83e-bf9d-4dbb-85ad-189c25fe16ba', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('昨日 9', 'きのう', 'kinou', 'Yesterday 9', NULL, 'e09639ce-3d27-489e-bded-7880f25fe605', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('鳥', 'とり', 'tori', 'Bird', NULL, 'e0f08761-e5a3-4047-ac99-0f6134ad503f', '2026-07-10 15:22:31', '2026-07-10 15:22:31'),
('書く 3', 'かく', 'kaku', 'To write 3', NULL, 'e1830bd4-ed45-4b44-86b5-aa763c63967b', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('話す 4', 'はなす', 'hanasu', 'To speak 4', NULL, 'e292162f-5c54-4e4c-b593-7ca3f044d574', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('買う 7', 'かう', 'kau', 'To buy 7', NULL, 'e2f98c4c-ab30-4936-a93c-4d9745551dbe', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('小さい 10', 'ちいさい', 'chiisai', 'Small 10', NULL, 'e3ea2923-7636-44c3-8450-7e9ad56f3db8', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('飲む 8', 'のむ', 'nomu', 'To drink 8', NULL, 'e4352461-cf52-4cc9-8b3f-baab4a1cb478', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('明日 4', 'あした', 'ashita', 'Tomorrow 4', NULL, 'e45ae948-2966-415f-9cbf-6d76b81edeb6', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('学生 9', 'がくせい', 'gakusei', 'Student 9', NULL, 'e5de1b6d-4b0a-4138-853c-b641b42c0633', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('食べる 3', 'たべる', 'taberu', 'To eat 3', NULL, 'e7945332-75b2-4016-a5cf-96b3e4c3f8d2', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('小さい 4', 'ちいさい', 'chiisai', 'Small 4', NULL, 'e8310da3-b625-4132-87c7-fc6012841f95', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('電車 7', 'でんしゃ', 'densha', 'Train 7', NULL, 'ea84f23b-a4ad-4ac3-9437-bc4ccc3db7a5', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('高い 5', 'たかい', 'takai', 'High, expensive 5', NULL, 'eb1c7380-cae0-4830-8815-c7f0eb6539f7', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('車 9', 'くるま', 'kuruma', 'Car 9', NULL, 'eb4449dc-e99e-443f-9d55-c541e0eaca8d', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('学生', 'がくせい', 'gakusei', 'Student', NULL, 'eba1b141-b7b6-4e4c-8239-37aa00a6413d', '2026-07-10 15:13:34', '2026-07-10 15:13:34'),
('車 8', 'くるま', 'kuruma', 'Car 8', NULL, 'ebee1a14-8b30-4c1c-91b7-02fdc818a014', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('昨日 10', 'きのう', 'kinou', 'Yesterday 10', NULL, 'ecc542c4-7f4d-4d1c-aec4-d193d0a04ab5', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('大きい 6', 'おおきい', 'ookii', 'Big 6', NULL, 'ed1fcd2a-32bb-455f-88f5-26ed1d3406ff', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('書く 2', 'かく', 'kaku', 'To write 2', NULL, 'ee557749-ecfa-4146-aed3-40c800f9f5bb', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('先生 6', 'せんせい', 'sensei', 'Teacher 6', NULL, 'efed27ec-1edd-4d4d-b409-0e2733af8d4a', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('古い', 'ふるい', 'furui', 'Old', NULL, 'f032d05a-eafa-4bea-9f95-6b3b623a9a18', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('猫 2', 'ねこ', 'neko', 'Cat 2', NULL, 'f267c50f-7154-45d2-85fb-e7d4e62e9fe5', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('高い 8', 'たかい', 'takai', 'High, expensive 8', NULL, 'f3b4eebe-c27f-4320-86f4-26b3861e390c', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('聞く 8', 'きく', 'kiku', 'To listen, hear 8', NULL, 'f43f466f-58c4-4d46-b19f-a0d94630abf5', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('古い 10', 'ふるい', 'furui', 'Old 10', NULL, 'f4f1ffa5-c3c0-4c03-b791-ac7ab1c10d5a', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('聞く 2', 'きく', 'kiku', 'To listen, hear 2', NULL, 'f553912e-1edb-43aa-a283-9daa8c535cdb', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('昨日 6', 'きのう', 'kinou', 'Yesterday 6', NULL, 'f627b83d-0155-4db3-ac1e-fc737acda583', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('昨日 7', 'きのう', 'kinou', 'Yesterday 7', NULL, 'f7411d66-6365-4959-b234-b85e509b39b5', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('食べる 10', 'たべる', 'taberu', 'To eat 10', NULL, 'f928612b-b24d-44a4-9b0e-38800653e067', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('安い', 'やすい', 'yasui', 'Cheap', NULL, 'f9cb73bb-3ce6-4097-8a83-9c37c8d0b9a6', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('買う 10', 'かう', 'kau', 'To buy 10', NULL, 'fa70cc23-5358-4925-9b94-3c427c0ca553', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('行く 3', 'いく', 'iku', 'To go 3', NULL, 'fb60f63b-3d26-48d9-8ca7-c5aa2379104b', '2026-07-11 03:04:01', '2026-07-11 03:04:01'),
('食べる', 'たべる', 'taberu', 'To eat', NULL, 'fb63c857-340d-463f-bf0a-6d4cdbdd09d9', '2026-07-11 03:02:52', '2026-07-11 03:02:52'),
('学生 6', 'がくせい', 'gakusei', 'Student 6', NULL, 'fc690b2c-f8b0-447f-8e4a-f3f703180fab', '2026-07-11 03:04:02', '2026-07-11 03:04:02'),
('水', 'みず', 'mizu', 'Water', NULL, 'fccb3cec-629c-4086-8822-046d5f4301c4', '2026-07-11 03:04:00', '2026-07-11 03:04:00'),
('書く 10', 'かく', 'kaku', 'To write 10', NULL, 'fcf67473-2ad6-4db2-a913-e3476ca85bda', '2026-07-11 03:04:04', '2026-07-11 03:04:04'),
('昨日 8', 'きのう', 'kinou', 'Yesterday 8', NULL, 'fdf4281b-b029-4c5d-ba16-5861a928411e', '2026-07-11 03:04:03', '2026-07-11 03:04:03'),
('電車 2', 'でんしゃ', 'densha', 'Train 2', NULL, 'fe7b84ed-5b81-42fb-9ef9-b2ea254d5abc', '2026-07-11 03:04:00', '2026-07-11 03:04:00');

-- --------------------------------------------------------

--
-- Table structure for table `xp_transactions`
--

CREATE TABLE `xp_transactions` (
  `user_id` varchar(36) NOT NULL,
  `amount` int(11) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `session_id` varchar(36) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `xp_transactions`
--

INSERT INTO `xp_transactions` (`user_id`, `amount`, `reason`, `session_id`, `created_at`, `id`, `updated_at`) VALUES
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 60, 'Completed Learning Session', '0a025ca3-c4f9-44ac-879c-2acfcdf03cb7', '2026-07-10 16:23:43', '00aea992-b48f-47d0-9408-744b9014fbe3', '2026-07-10 16:23:43'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 60, 'Completed Learning Session', '9d9a8c52-e5f7-463e-bc51-6e19f6e82cd5', '2026-07-10 16:07:53', '0893b437-0653-4071-9895-ada29716f773', '2026-07-10 16:07:53'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 60, 'Completed Learning Session', '205da50b-460e-42dc-a8b3-cd42b740ce97', '2026-07-10 16:15:48', '14fcee9d-1835-4a47-aa3b-6e76bca7d17e', '2026-07-10 16:15:48'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 60, 'Completed Learning Session', '500fa73a-4ab8-450f-8011-071575d8eb43', '2026-07-11 04:22:41', '25241269-6b15-451f-b3a1-9e90b74ffc01', '2026-07-11 04:22:41'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 60, 'Completed Learning Session', '3f802aee-d739-4751-9d49-41858f91fd5f', '2026-07-10 16:16:05', '267ee7c0-eb1f-4ffd-9c4d-66553070ebb7', '2026-07-10 16:16:05'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 60, 'Completed Learning Session', '93121dc6-5590-4dc3-8561-4516755077b1', '2026-07-10 16:09:32', '2c5e4f28-bf90-4058-9e23-d4b7eeb98439', '2026-07-10 16:09:32'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 60, 'Completed Learning Session', '4ab24488-fc65-47c0-85eb-10b75b2a48cd', '2026-07-10 16:06:23', '2e09e656-93d6-48e8-a015-75468483b476', '2026-07-10 16:06:23'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 60, 'Completed Learning Session', 'dbb225d4-0d36-43c8-8792-f6795646ba51', '2026-07-11 04:40:21', '3283a650-b26e-40af-b076-85d20a2aaf29', '2026-07-11 04:40:21'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 60, 'Completed Learning Session', '6e24bf00-78fc-4b9f-8f3a-0ec952c1f881', '2026-07-10 16:23:51', '3bc7eb50-0d65-4e39-9ddd-42455bf7bdec', '2026-07-10 16:23:51'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 60, 'Completed Learning Session', 'add90505-f149-4455-ad22-029185bc068a', '2026-07-10 16:20:00', '68a2eeb5-75bf-4ced-9c66-2ca9cb4f06e2', '2026-07-10 16:20:00'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 60, 'Completed Learning Session', '882a1724-6a92-45b0-863c-84f84d50676b', '2026-07-10 16:14:03', '9fcb44dc-27b1-44fe-8eae-4ca29ad4d974', '2026-07-10 16:14:03'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 60, 'Completed Learning Session', 'e4bc32b0-e773-4402-9e83-e7816efa4418', '2026-07-10 16:06:38', 'c10c35db-57d2-456d-87a4-11d9c97471d3', '2026-07-10 16:06:38'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 60, 'Completed Learning Session', '0d76eee4-c2aa-458a-97f6-96b54a10a717', '2026-07-10 16:11:00', 'd0142c14-21aa-4d67-89ef-02d691e96a5f', '2026-07-10 16:11:00'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 60, 'Completed Learning Session', '205b3037-bd34-4936-b8a1-f613d88317d3', '2026-07-10 16:09:49', 'dcaa7ee6-38ba-429f-a49b-5d1caa811431', '2026-07-10 16:09:49'),
('1f1ed139-7bd3-40d6-ab37-3851a4ab5a5c', 60, 'Completed Learning Session', 'a33d7330-0642-431d-845a-7d80e4f72048', '2026-07-10 16:21:03', 'e60138e3-c73f-43c1-9eb0-ccd5b99c5250', '2026-07-10 16:21:03');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `alembic_version`
--
ALTER TABLE `alembic_version`
  ADD PRIMARY KEY (`version_num`);

--
-- Indexes for table `audio_assets`
--
ALTER TABLE `audio_assets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ix_audio_assets_id` (`id`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `ix_audit_logs_id` (`id`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `level_id` (`level_id`),
  ADD KEY `ix_courses_id` (`id`);

--
-- Indexes for table `example_sentences`
--
ALTER TABLE `example_sentences`
  ADD PRIMARY KEY (`id`),
  ADD KEY `audio_id` (`audio_id`),
  ADD KEY `grammar_point_id` (`grammar_point_id`),
  ADD KEY `vocabulary_id` (`vocabulary_id`),
  ADD KEY `ix_example_sentences_id` (`id`);

--
-- Indexes for table `generation_jobs`
--
ALTER TABLE `generation_jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `ix_generation_jobs_id` (`id`),
  ADD KEY `ix_generation_jobs_celery_task_id` (`celery_task_id`);

--
-- Indexes for table `grammar_points`
--
ALTER TABLE `grammar_points`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ix_grammar_points_id` (`id`);

--
-- Indexes for table `jlpt_simulations`
--
ALTER TABLE `jlpt_simulations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ix_jlpt_simulations_id` (`id`);

--
-- Indexes for table `jlpt_simulation_questions`
--
ALTER TABLE `jlpt_simulation_questions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `question_id` (`question_id`),
  ADD KEY `section_id` (`section_id`),
  ADD KEY `ix_jlpt_simulation_questions_id` (`id`);

--
-- Indexes for table `jlpt_simulation_sections`
--
ALTER TABLE `jlpt_simulation_sections`
  ADD PRIMARY KEY (`id`),
  ADD KEY `simulation_id` (`simulation_id`),
  ADD KEY `ix_jlpt_simulation_sections_id` (`id`);

--
-- Indexes for table `kanjis`
--
ALTER TABLE `kanjis`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ix_kanjis_id` (`id`);

--
-- Indexes for table `learning_sessions`
--
ALTER TABLE `learning_sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lesson_id` (`lesson_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `ix_learning_sessions_id` (`id`);

--
-- Indexes for table `learning_session_questions`
--
ALTER TABLE `learning_session_questions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `question_id` (`question_id`),
  ADD KEY `session_id` (`session_id`),
  ADD KEY `ix_learning_session_questions_id` (`id`),
  ADD KEY `question_revision_id` (`question_revision_id`);

--
-- Indexes for table `lessons`
--
ALTER TABLE `lessons`
  ADD PRIMARY KEY (`id`),
  ADD KEY `unit_id` (`unit_id`),
  ADD KEY `ix_lessons_id` (`id`);

--
-- Indexes for table `lesson_grammar_points`
--
ALTER TABLE `lesson_grammar_points`
  ADD PRIMARY KEY (`lesson_id`,`grammar_point_id`),
  ADD KEY `grammar_point_id` (`grammar_point_id`);

--
-- Indexes for table `lesson_kanjis`
--
ALTER TABLE `lesson_kanjis`
  ADD PRIMARY KEY (`lesson_id`,`kanji_id`),
  ADD KEY `kanji_id` (`kanji_id`);

--
-- Indexes for table `lesson_sections`
--
ALTER TABLE `lesson_sections`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lesson_id` (`lesson_id`),
  ADD KEY `ix_lesson_sections_id` (`id`);

--
-- Indexes for table `lesson_vocabularies`
--
ALTER TABLE `lesson_vocabularies`
  ADD PRIMARY KEY (`lesson_id`,`vocabulary_id`),
  ADD KEY `vocabulary_id` (`vocabulary_id`);

--
-- Indexes for table `levels`
--
ALTER TABLE `levels`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ix_levels_name` (`name`),
  ADD KEY `ix_levels_id` (`id`);

--
-- Indexes for table `passwordresettokens`
--
ALTER TABLE `passwordresettokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ix_passwordresettokens_token_hash` (`token_hash`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `ix_passwordresettokens_id` (`id`);

--
-- Indexes for table `questions`
--
ALTER TABLE `questions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `audio_asset_id` (`audio_asset_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `lesson_id` (`lesson_id`),
  ADD KEY `reading_id` (`reading_id`),
  ADD KEY `reviewed_by` (`reviewed_by`),
  ADD KEY `ix_questions_id` (`id`);

--
-- Indexes for table `question_reviews`
--
ALTER TABLE `question_reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `question_id` (`question_id`),
  ADD KEY `reviewer_id` (`reviewer_id`),
  ADD KEY `ix_question_reviews_id` (`id`);

--
-- Indexes for table `question_revisions`
--
ALTER TABLE `question_revisions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `question_id` (`question_id`),
  ADD KEY `ix_question_revisions_id` (`id`);

--
-- Indexes for table `readings`
--
ALTER TABLE `readings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `audio_id` (`audio_id`),
  ADD KEY `lesson_id` (`lesson_id`),
  ADD KEY `ix_readings_id` (`id`);

--
-- Indexes for table `refreshtokens`
--
ALTER TABLE `refreshtokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ix_refreshtokens_token_hash` (`token_hash`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `ix_refreshtokens_id` (`id`);

--
-- Indexes for table `review_schedules`
--
ALTER TABLE `review_schedules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `question_id` (`question_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `ix_review_schedules_id` (`id`);

--
-- Indexes for table `units`
--
ALTER TABLE `units`
  ADD PRIMARY KEY (`id`),
  ADD KEY `course_id` (`course_id`),
  ADD KEY `ix_units_id` (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ix_users_email` (`email`),
  ADD KEY `ix_users_id` (`id`);

--
-- Indexes for table `user_lesson_progress`
--
ALTER TABLE `user_lesson_progress`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lesson_id` (`lesson_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `ix_user_lesson_progress_id` (`id`);

--
-- Indexes for table `user_masteries`
--
ALTER TABLE `user_masteries`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `ix_user_masteries_id` (`id`);

--
-- Indexes for table `user_mistakes`
--
ALTER TABLE `user_mistakes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `question_id` (`question_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `ix_user_mistakes_id` (`id`);

--
-- Indexes for table `user_simulation_attempts`
--
ALTER TABLE `user_simulation_attempts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `simulation_id` (`simulation_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `ix_user_simulation_attempts_id` (`id`);

--
-- Indexes for table `user_simulation_attempt_questions`
--
ALTER TABLE `user_simulation_attempt_questions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `attempt_id` (`attempt_id`),
  ADD KEY `attempt_section_id` (`attempt_section_id`),
  ADD KEY `question_id` (`question_id`),
  ADD KEY `question_revision_id` (`question_revision_id`),
  ADD KEY `ix_user_simulation_attempt_questions_id` (`id`);

--
-- Indexes for table `user_simulation_attempt_sections`
--
ALTER TABLE `user_simulation_attempt_sections`
  ADD PRIMARY KEY (`id`),
  ADD KEY `attempt_id` (`attempt_id`),
  ADD KEY `section_id` (`section_id`),
  ADD KEY `ix_user_simulation_attempt_sections_id` (`id`);

--
-- Indexes for table `vocabularies`
--
ALTER TABLE `vocabularies`
  ADD PRIMARY KEY (`id`),
  ADD KEY `audio_id` (`audio_id`),
  ADD KEY `ix_vocabularies_id` (`id`);

--
-- Indexes for table `xp_transactions`
--
ALTER TABLE `xp_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `session_id` (`session_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `ix_xp_transactions_id` (`id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `courses`
--
ALTER TABLE `courses`
  ADD CONSTRAINT `courses_ibfk_1` FOREIGN KEY (`level_id`) REFERENCES `levels` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `example_sentences`
--
ALTER TABLE `example_sentences`
  ADD CONSTRAINT `example_sentences_ibfk_1` FOREIGN KEY (`audio_id`) REFERENCES `audio_assets` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `example_sentences_ibfk_2` FOREIGN KEY (`grammar_point_id`) REFERENCES `grammar_points` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `example_sentences_ibfk_3` FOREIGN KEY (`vocabulary_id`) REFERENCES `vocabularies` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `generation_jobs`
--
ALTER TABLE `generation_jobs`
  ADD CONSTRAINT `generation_jobs_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `jlpt_simulation_questions`
--
ALTER TABLE `jlpt_simulation_questions`
  ADD CONSTRAINT `jlpt_simulation_questions_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `jlpt_simulation_questions_ibfk_2` FOREIGN KEY (`section_id`) REFERENCES `jlpt_simulation_sections` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `jlpt_simulation_sections`
--
ALTER TABLE `jlpt_simulation_sections`
  ADD CONSTRAINT `jlpt_simulation_sections_ibfk_1` FOREIGN KEY (`simulation_id`) REFERENCES `jlpt_simulations` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `learning_sessions`
--
ALTER TABLE `learning_sessions`
  ADD CONSTRAINT `learning_sessions_ibfk_1` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `learning_sessions_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `learning_session_questions`
--
ALTER TABLE `learning_session_questions`
  ADD CONSTRAINT `learning_session_questions_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `learning_session_questions_ibfk_2` FOREIGN KEY (`session_id`) REFERENCES `learning_sessions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `learning_session_questions_ibfk_3` FOREIGN KEY (`question_revision_id`) REFERENCES `question_revisions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `lessons`
--
ALTER TABLE `lessons`
  ADD CONSTRAINT `lessons_ibfk_1` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `lesson_grammar_points`
--
ALTER TABLE `lesson_grammar_points`
  ADD CONSTRAINT `lesson_grammar_points_ibfk_1` FOREIGN KEY (`grammar_point_id`) REFERENCES `grammar_points` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `lesson_grammar_points_ibfk_2` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `lesson_kanjis`
--
ALTER TABLE `lesson_kanjis`
  ADD CONSTRAINT `lesson_kanjis_ibfk_1` FOREIGN KEY (`kanji_id`) REFERENCES `kanjis` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `lesson_kanjis_ibfk_2` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `lesson_sections`
--
ALTER TABLE `lesson_sections`
  ADD CONSTRAINT `lesson_sections_ibfk_1` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `lesson_vocabularies`
--
ALTER TABLE `lesson_vocabularies`
  ADD CONSTRAINT `lesson_vocabularies_ibfk_1` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `lesson_vocabularies_ibfk_2` FOREIGN KEY (`vocabulary_id`) REFERENCES `vocabularies` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `passwordresettokens`
--
ALTER TABLE `passwordresettokens`
  ADD CONSTRAINT `passwordresettokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `questions`
--
ALTER TABLE `questions`
  ADD CONSTRAINT `questions_ibfk_1` FOREIGN KEY (`audio_asset_id`) REFERENCES `audio_assets` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `questions_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `questions_ibfk_3` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `questions_ibfk_4` FOREIGN KEY (`reading_id`) REFERENCES `readings` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `questions_ibfk_5` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `question_reviews`
--
ALTER TABLE `question_reviews`
  ADD CONSTRAINT `question_reviews_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `question_reviews_ibfk_2` FOREIGN KEY (`reviewer_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `question_revisions`
--
ALTER TABLE `question_revisions`
  ADD CONSTRAINT `question_revisions_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `question_revisions_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `readings`
--
ALTER TABLE `readings`
  ADD CONSTRAINT `readings_ibfk_1` FOREIGN KEY (`audio_id`) REFERENCES `audio_assets` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `readings_ibfk_2` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `refreshtokens`
--
ALTER TABLE `refreshtokens`
  ADD CONSTRAINT `refreshtokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `review_schedules`
--
ALTER TABLE `review_schedules`
  ADD CONSTRAINT `review_schedules_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `review_schedules_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `units`
--
ALTER TABLE `units`
  ADD CONSTRAINT `units_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_lesson_progress`
--
ALTER TABLE `user_lesson_progress`
  ADD CONSTRAINT `user_lesson_progress_ibfk_1` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_lesson_progress_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_masteries`
--
ALTER TABLE `user_masteries`
  ADD CONSTRAINT `user_masteries_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_mistakes`
--
ALTER TABLE `user_mistakes`
  ADD CONSTRAINT `user_mistakes_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_mistakes_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_simulation_attempts`
--
ALTER TABLE `user_simulation_attempts`
  ADD CONSTRAINT `user_simulation_attempts_ibfk_1` FOREIGN KEY (`simulation_id`) REFERENCES `jlpt_simulations` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_simulation_attempts_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_simulation_attempt_questions`
--
ALTER TABLE `user_simulation_attempt_questions`
  ADD CONSTRAINT `user_simulation_attempt_questions_ibfk_1` FOREIGN KEY (`attempt_id`) REFERENCES `user_simulation_attempts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_simulation_attempt_questions_ibfk_2` FOREIGN KEY (`attempt_section_id`) REFERENCES `user_simulation_attempt_sections` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_simulation_attempt_questions_ibfk_3` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_simulation_attempt_questions_ibfk_4` FOREIGN KEY (`question_revision_id`) REFERENCES `question_revisions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_simulation_attempt_sections`
--
ALTER TABLE `user_simulation_attempt_sections`
  ADD CONSTRAINT `user_simulation_attempt_sections_ibfk_1` FOREIGN KEY (`attempt_id`) REFERENCES `user_simulation_attempts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_simulation_attempt_sections_ibfk_2` FOREIGN KEY (`section_id`) REFERENCES `jlpt_simulation_sections` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `vocabularies`
--
ALTER TABLE `vocabularies`
  ADD CONSTRAINT `vocabularies_ibfk_1` FOREIGN KEY (`audio_id`) REFERENCES `audio_assets` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `xp_transactions`
--
ALTER TABLE `xp_transactions`
  ADD CONSTRAINT `xp_transactions_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `learning_sessions` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `xp_transactions_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
