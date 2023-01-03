/*
  Warnings:

  - Added the required column `Descripcion` to the `EvidenciaActividad` table without a default value. This is not possible if the table is not empty.
  - Added the required column `Nombre` to the `EvidenciaActividad` table without a default value. This is not possible if the table is not empty.
  - Added the required column `NombreArchivo` to the `EvidenciaActividad` table without a default value. This is not possible if the table is not empty.
  - Added the required column `RutaArchivo` to the `EvidenciaActividad` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `EvidenciaActividad` ADD COLUMN `Descripcion` VARCHAR(191) NOT NULL,
    ADD COLUMN `Estado` ENUM('SIN_ENTREGAR', 'A_TIEMPO', 'ASTRASO') NOT NULL DEFAULT 'SIN_ENTREGAR',
    ADD COLUMN `Nombre` VARCHAR(191) NOT NULL,
    ADD COLUMN `NombreArchivo` VARCHAR(191) NOT NULL,
    ADD COLUMN `RutaArchivo` VARCHAR(191) NOT NULL;
