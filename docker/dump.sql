-- phpMyAdmin SQL Dump
-- version 4.9.7
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Sep 04, 2022 at 08:14 PM
-- Server version: 10.3.29-MariaDB
-- PHP Version: 7.4.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `Vorlesungen`
--

-- --------------------------------------------------------

--
-- Table structure for table `BELEGUNG`
--

CREATE TABLE `BELEGUNG` (
  `PNR` decimal(6,0) NOT NULL,
  `KNR` decimal(3,0) NOT NULL,
  `DNR` decimal(3,0) NOT NULL,
  `DATUM` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `BELEGUNG`
--

INSERT INTO `BELEGUNG` (`PNR`, `KNR`, `DNR`, `DATUM`) VALUES
('100001', '245', '4', '2000-01-01 00:00:00'),
('100001', '255', '1', '2000-01-01 00:00:00'),
('100001', '412', '2', '2000-01-01 00:00:00'),
('100001', '454', '7', '2000-01-01 00:00:00'),
('132442', '454', '7', '2000-01-01 00:00:00'),
('232452', '454', '7', '2000-01-01 00:00:00'),
('334643', '412', '2', '2000-01-01 00:00:00'),
('344556', '412', '2', '2000-01-01 00:00:00'),
('345678', '123', '4', '2000-01-01 00:00:00'),
('345678', '123', '6', '2000-01-01 00:00:00'),
('345678', '454', '7', '2000-01-01 00:00:00'),
('345678', '776', '3', '2000-01-01 00:00:00'),
('625342', '255', '1', '2000-01-01 00:00:00'),
('845622', '345', '8', '2000-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `DOZENT`
--

CREATE TABLE `DOZENT` (
  `DNR` decimal(3,0) NOT NULL,
  `STATUS` varchar(1) NOT NULL,
  `PNR` decimal(6,0) DEFAULT NULL,
  `NAME` varchar(20) NOT NULL,
  `VORNAME` varchar(15) NOT NULL,
  `FIRMA` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `DOZENT`
--

INSERT INTO `DOZENT` (`DNR`, `STATUS`, `PNR`, `NAME`, `VORNAME`, `FIRMA`) VALUES
('1', 'I', '345727', 'Meier', 'Thorsten', NULL),
('2', 'E', NULL, 'Vorher', 'Rudi', 'GigaSoft'),
('3', 'I', '232452', 'Merz', 'Tim', NULL),
('4', 'I', '233456', 'Karl', 'Kurt', NULL),
('5', 'E', NULL, 'Feier', 'Frank', 'Quasar'),
('6', 'I', '845622', 'Rolf', 'Otto', NULL),
('7', 'E', NULL, 'Star', 'Fred', 'Funkenflug'),
('8', 'E', NULL, 'Neulich', 'August', 'Harmonie');

-- --------------------------------------------------------

--
-- Table structure for table `KONTROLLE`
--

CREATE TABLE `KONTROLLE` (
  `KNR` decimal(3,0) NOT NULL,
  `RNR` decimal(2,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `KONTROLLE`
--

INSERT INTO `KONTROLLE` (`KNR`, `RNR`) VALUES
('123', '1'),
('123', '2'),
('123', '3'),
('123', '4'),
('234', '3'),
('234', '5'),
('245', '3'),
('245', '4'),
('245', '5'),
('255', '3'),
('283', '1'),
('283', '2'),
('283', '3'),
('341', '3'),
('345', '4'),
('412', '2'),
('412', '3'),
('454', '1'),
('454', '2'),
('454', '3'),
('454', '4'),
('455', '3'),
('455', '4'),
('562', '2'),
('562', '3'),
('562', '4'),
('776', '1'),
('776', '2');

-- --------------------------------------------------------

--
-- Table structure for table `KURS`
--

CREATE TABLE `KURS` (
  `KNR` decimal(3,0) NOT NULL,
  `KURSBEZEICHNUNG` varchar(40) NOT NULL,
  `KURSORT` varchar(10) NOT NULL,
  `TNR` decimal(2,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `KURS`
--

INSERT INTO `KURS` (`KNR`, `KURSBEZEICHNUNG`, `KURSORT`, `TNR`) VALUES
('123', 'Analysis 1', '2510.EG.25', '1'),
('234', 'Analysis 3', '1010.4.08', '4'),
('245', 'Lineare Algebra 1', '1010.2.05', '5'),
('255', 'Statistik', '2015.2.05', '3'),
('283', 'Planimetrie', '4001.EG.20', '1'),
('341', 'Analysis 4', '2015.1.10', '3'),
('345', 'Numerik part. DGL', '1010.2.05', '2'),
('412', 'Lineare Algebra 2', '2015.1.10', '3'),
('454', 'Wahrscheinlichkeitstheorie', '4001.EG.20', '1'),
('455', 'Numerik 1', '1010.4.08', '5'),
('562', 'Analysis 2', '1010.4.08', '2'),
('776', 'Algebraische Gleichungen', '1010.2.05', '4');

-- --------------------------------------------------------

--
-- Table structure for table `PERSON`
--

CREATE TABLE `PERSON` (
  `PNR` decimal(6,0) NOT NULL,
  `NAME` varchar(20) NOT NULL,
  `VORNAME` varchar(15) NOT NULL,
  `RNR` decimal(2,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `PERSON`
--

INSERT INTO `PERSON` (`PNR`, `NAME`, `VORNAME`, `RNR`) VALUES
('100001', 'Schneider', 'Peter', '3'),
('132442', 'Oswald', 'Kurt', '1'),
('232452', 'Horst', 'Petra', '1'),
('233456', 'Maler', 'Franz', '4'),
('334643', 'Meier', 'Hans', '2'),
('344556', 'Scherer', 'Daniel', '2'),
('345678', 'Metzger', 'Paul', '1'),
('345727', 'Steiner', 'Rene', '5'),
('567231', 'Schmid', 'Bea', '3'),
('625342', 'Gerber', 'Roland', '3'),
('845622', 'Hubert', 'Bauer', '4');

-- --------------------------------------------------------

--
-- Table structure for table `ROLLE`
--

CREATE TABLE `ROLLE` (
  `RNR` decimal(2,0) NOT NULL,
  `BEZEICHNUNG` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ROLLE`
--

INSERT INTO `ROLLE` (`RNR`, `BEZEICHNUNG`) VALUES
('4', 'Assistent'),
('5', 'Doktorand'),
('2', 'Lehrbeauftragter'),
('1', 'Professor'),
('3', 'Student');

-- --------------------------------------------------------

--
-- Table structure for table `THEMA`
--

CREATE TABLE `THEMA` (
  `TNR` decimal(2,0) NOT NULL,
  `THEMENGEBIET` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `THEMA`
--

INSERT INTO `THEMA` (`TNR`, `THEMENGEBIET`) VALUES
('1', 'Algebra'),
('4', 'Analysis'),
('2', 'Geometrie'),
('6', 'Numerik'),
('5', 'Stochastik'),
('3', 'Topologie');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `BELEGUNG`
--
ALTER TABLE `BELEGUNG`
  ADD PRIMARY KEY (`PNR`,`KNR`,`DNR`),
  ADD KEY `IX_BELEGUNG_KNR` (`KNR`),
  ADD KEY `IX_BELEGUNG_PNR` (`PNR`),
  ADD KEY `IX_BELEGUNG_DNR` (`DNR`);

--
-- Indexes for table `DOZENT`
--
ALTER TABLE `DOZENT`
  ADD PRIMARY KEY (`DNR`);

--
-- Indexes for table `KONTROLLE`
--
ALTER TABLE `KONTROLLE`
  ADD PRIMARY KEY (`KNR`,`RNR`),
  ADD KEY `IX_KONTROLLE_RNR` (`RNR`),
  ADD KEY `IX_KONTROLLE_KNR` (`KNR`);

--
-- Indexes for table `KURS`
--
ALTER TABLE `KURS`
  ADD PRIMARY KEY (`KNR`),
  ADD KEY `IX_KURS_TNR` (`TNR`);

--
-- Indexes for table `PERSON`
--
ALTER TABLE `PERSON`
  ADD PRIMARY KEY (`PNR`),
  ADD KEY `IX_PERSON_RNR` (`RNR`);

--
-- Indexes for table `ROLLE`
--
ALTER TABLE `ROLLE`
  ADD PRIMARY KEY (`RNR`),
  ADD UNIQUE KEY `IX_ROLLE_ROLLE` (`BEZEICHNUNG`);

--
-- Indexes for table `THEMA`
--
ALTER TABLE `THEMA`
  ADD PRIMARY KEY (`TNR`),
  ADD UNIQUE KEY `IX_THEMA_THEMENGEBIET` (`THEMENGEBIET`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `BELEGUNG`
--
ALTER TABLE `BELEGUNG`
  ADD CONSTRAINT `FK_BELEGUNG_DOZENT` FOREIGN KEY (`DNR`) REFERENCES `DOZENT` (`DNR`),
  ADD CONSTRAINT `FK_BELEGUNG_KURS` FOREIGN KEY (`KNR`) REFERENCES `KURS` (`KNR`),
  ADD CONSTRAINT `FK_BELEGUNG_PERSON` FOREIGN KEY (`PNR`) REFERENCES `PERSON` (`PNR`);

--
-- Constraints for table `KONTROLLE`
--
ALTER TABLE `KONTROLLE`
  ADD CONSTRAINT `FK_KONTROLLE_KURS` FOREIGN KEY (`KNR`) REFERENCES `KURS` (`KNR`),
  ADD CONSTRAINT `FK_KONTROLLE_ROLLE` FOREIGN KEY (`RNR`) REFERENCES `ROLLE` (`RNR`);

--
-- Constraints for table `KURS`
--
ALTER TABLE `KURS`
  ADD CONSTRAINT `FK_KURS_THEMA` FOREIGN KEY (`TNR`) REFERENCES `THEMA` (`TNR`);

--
-- Constraints for table `PERSON`
--
ALTER TABLE `PERSON`
  ADD CONSTRAINT `FK_PERSON_ROLLE` FOREIGN KEY (`RNR`) REFERENCES `ROLLE` (`RNR`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
