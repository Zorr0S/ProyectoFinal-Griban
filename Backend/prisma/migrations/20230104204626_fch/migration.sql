-- CreateTable
CREATE TABLE `Users` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `UserName` VARCHAR(191) NOT NULL,
    `Nombre` VARCHAR(191) NOT NULL,
    `Contrasena` VARCHAR(191) NOT NULL,
    `Rol` ENUM('PROFESOR', 'ALUMNO') NOT NULL DEFAULT 'ALUMNO',

    UNIQUE INDEX `Users_UserName_key`(`UserName`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Periodo` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `Nombre` VARCHAR(191) NOT NULL,
    `FechaInicio` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `FechaFinal` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Asistencias` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `Fecha` DATETIME(3) NOT NULL,
    `AlumnoID` INTEGER NOT NULL,
    `RegistroID` INTEGER NOT NULL,
    `PeriodoID` INTEGER NOT NULL,

    UNIQUE INDEX `Asistencias_id_AlumnoID_key`(`id`, `AlumnoID`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `RegistroAsistencia` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `Letra` VARCHAR(191) NOT NULL,
    `Descripcion` VARCHAR(191) NOT NULL,
    `Valor` DOUBLE NOT NULL,
    `PeriodoID` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Actividades` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `Tipo` ENUM('EXAMEN', 'PORTAFOLIO', 'ACTIVIDADCOMPLEMENTARIA') NULL,
    `Nombre` VARCHAR(191) NOT NULL,
    `Descripcion` VARCHAR(191) NOT NULL,
    `FechaSubida` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `FechaPara` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `EvidenciaActividad` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `ActividadID` INTEGER NOT NULL,
    `Nombre` VARCHAR(191) NULL,
    `Descripcion` VARCHAR(191) NULL,
    `FechaSubida` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),
    `AlumnoID` INTEGER NOT NULL,
    `NombreArchivo` VARCHAR(191) NULL,
    `EvidenciaURL` VARCHAR(191) NULL,
    `Estado` ENUM('SIN_ENTREGAR', 'A_TIEMPO', 'ASTRASO') NOT NULL DEFAULT 'SIN_ENTREGAR',
    `RutaArchivo` VARCHAR(191) NULL,
    `CalificacionID` INTEGER NOT NULL DEFAULT 1,

    UNIQUE INDEX `EvidenciaActividad_AlumnoID_ActividadID_key`(`AlumnoID`, `ActividadID`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Calificacion` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `letra` VARCHAR(191) NOT NULL,
    `valor` DECIMAL(65, 30) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Asistencias` ADD CONSTRAINT `Asistencias_RegistroID_fkey` FOREIGN KEY (`RegistroID`) REFERENCES `RegistroAsistencia`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Asistencias` ADD CONSTRAINT `Asistencias_AlumnoID_fkey` FOREIGN KEY (`AlumnoID`) REFERENCES `Users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Asistencias` ADD CONSTRAINT `Asistencias_PeriodoID_fkey` FOREIGN KEY (`PeriodoID`) REFERENCES `Periodo`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `RegistroAsistencia` ADD CONSTRAINT `RegistroAsistencia_PeriodoID_fkey` FOREIGN KEY (`PeriodoID`) REFERENCES `Periodo`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `EvidenciaActividad` ADD CONSTRAINT `EvidenciaActividad_ActividadID_fkey` FOREIGN KEY (`ActividadID`) REFERENCES `Actividades`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `EvidenciaActividad` ADD CONSTRAINT `EvidenciaActividad_AlumnoID_fkey` FOREIGN KEY (`AlumnoID`) REFERENCES `Users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `EvidenciaActividad` ADD CONSTRAINT `EvidenciaActividad_CalificacionID_fkey` FOREIGN KEY (`CalificacionID`) REFERENCES `Calificacion`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
