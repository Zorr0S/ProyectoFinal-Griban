/*
  Warnings:

  - Added the required column `Descripcion` to the `RegistroAsistencia` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `RegistroAsistencia` ADD COLUMN `Descripcion` VARCHAR(191) NOT NULL;
