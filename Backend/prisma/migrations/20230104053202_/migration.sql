-- DropForeignKey
ALTER TABLE `evidenciaactividad` DROP FOREIGN KEY `EvidenciaActividad_ActividadID_fkey`;

-- AlterTable
ALTER TABLE `evidenciaactividad` MODIFY `FechaSubida` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3);

-- AddForeignKey
ALTER TABLE `EvidenciaActividad` ADD CONSTRAINT `EvidenciaActividad_ActividadID_fkey` FOREIGN KEY (`ActividadID`) REFERENCES `Actividades`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
