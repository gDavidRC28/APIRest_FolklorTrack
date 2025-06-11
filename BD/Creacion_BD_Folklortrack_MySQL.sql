CREATE DATABASE folklortrack_db;

USE folklortrack_db;

-- Tabla usuarios
CREATE TABLE IF NOT EXISTS folklortrack_db.usuarios (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  email VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  nombre_completo VARCHAR(255) NULL DEFAULT NULL,
  rol ENUM('Admin', 'Alumno') NOT NULL DEFAULT 'Alumno',
  estatus ENUM('Activo', 'Inactivo') NOT NULL DEFAULT 'Activo',
  fecha_creado TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ultima_act TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE INDEX email_U (email ASC) VISIBLE
);

-- Tabla alumnos
CREATE TABLE IF NOT EXISTS folklortrack_db.alumnos (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  usuario_id INT UNSIGNED NOT NULL,
  talla ENUM('XS', 'S', 'M', 'L', 'XL', 'XXL', 'Unitalla') NOT NULL, 
  genero ENUM('Hombre', 'Mujer', 'Otro') NOT NULL,
  estatus ENUM('Activo', 'Inactivo') NOT NULL DEFAULT 'Activo', 
  fecha_inicio_agrupacion DATE NULL DEFAULT NULL,
  fecha_nacimiento DATE NULL DEFAULT NULL,
  foto_url TEXT NULL DEFAULT NULL,
  fecha_creado TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ultima_act TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE INDEX usuario_id_U (usuario_id ASC) VISIBLE,
  CONSTRAINT fk_alumnos_usuarios FOREIGN KEY (usuario_id)
    REFERENCES folklortrack_db.usuarios (id) ON DELETE RESTRICT ON UPDATE CASCADE
);
-- Tabla estados
CREATE TABLE IF NOT EXISTS folklortrack_db.estados (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre_estado VARCHAR(100) NOT NULL,
  img_estado_url TEXT NULL DEFAULT NULL,
  estatus ENUM('Activo', 'Inactivo') NOT NULL DEFAULT 'Activo',
  fecha_creado TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ultima_act TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE INDEX nombre_estado_U (nombre_estado ASC) VISIBLE
);

-- Tabla regiones
CREATE TABLE IF NOT EXISTS folklortrack_db.regiones (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre_region VARCHAR(100) NOT NULL,
  img_region_url TEXT NULL DEFAULT NULL,
  estado_id BIGINT UNSIGNED NULL DEFAULT NULL,
  estatus ENUM('Activo', 'Inactivo') NOT NULL DEFAULT 'Activo',
  fecha_creado TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ultima_act TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX fk_regiones_estados_id (estado_id ASC) VISIBLE,
  CONSTRAINT fk_regiones_estados FOREIGN KEY (estado_id)
    REFERENCES folklortrack_db.estados (id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Tabla vestuarios
CREATE TABLE IF NOT EXISTS folklortrack_db.vestuarios (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  folio VARCHAR(50) NOT NULL,
  nombre VARCHAR(255) NOT NULL,
  tipo VARCHAR(100) NOT NULL,
  talla ENUM('XS', 'S', 'M', 'L', 'XL', 'XXL', 'Unitalla') NOT NULL,
  genero ENUM('Hombre', 'Mujer', 'Unisex') NOT NULL,
  disponibilidad BOOLEAN NOT NULL DEFAULT TRUE,
  region_id BIGINT UNSIGNED NULL DEFAULT NULL,
  estatus ENUM('Activo', 'Inactivo') NOT NULL DEFAULT 'Activo',
  img_vestuario_url TEXT NULL DEFAULT NULL,
  fecha_creado TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ultima_act TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE INDEX folio_U (folio ASC) VISIBLE,
  INDEX fk_vestuarios_regiones_id (region_id ASC) VISIBLE,
  CONSTRAINT fk_vestuarios_regiones FOREIGN KEY (region_id)
    REFERENCES folklortrack_db.regiones (id) ON DELETE RESTRICT ON UPDATE CASCADE
);
-- Tabla eventos
CREATE TABLE IF NOT EXISTS folklortrack_db.eventos (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  titulo VARCHAR(255) NOT NULL,
  descripcion TEXT NULL DEFAULT NULL,
  fecha_inicio TIMESTAMP NOT NULL,
  fecha_fin TIMESTAMP NOT NULL,
  lugar_nombre VARCHAR(255) NOT NULL,
  lugar_url TEXT NULL DEFAULT NULL,
  estatus ENUM('Proximo', 'Concluido', 'Cancelado') NOT NULL DEFAULT 'Proximo',
  fecha_creado TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ultima_act TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  CONSTRAINT chk_eventos_fechas CHECK ((fecha_fin >= fecha_inicio))
);

-- Tabla evento_asignaciones
CREATE TABLE IF NOT EXISTS folklortrack_db.evento_asignaciones (
  evento_id BIGINT UNSIGNED NOT NULL,
  alumno_id BIGINT UNSIGNED NOT NULL,
  vestuario_id BIGINT UNSIGNED NOT NULL,
  estado_participacion ENUM('Invitado', 'Confirmado', 'Rechazado', 'Asistio') NOT NULL DEFAULT 'Invitado',
  fecha_creado TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (evento_id, alumno_id, vestuario_id), 
  INDEX fk_ea_alumnos_id (alumno_id ASC) VISIBLE,
  INDEX fk_ea_vestuarios_id (vestuario_id ASC) VISIBLE,
  CONSTRAINT fk_ea_eventos FOREIGN KEY (evento_id)
    REFERENCES folklortrack_db.eventos (id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_ea_alumnos FOREIGN KEY (alumno_id)
    REFERENCES folklortrack_db.alumnos (id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_ea_vestuarios FOREIGN KEY (vestuario_id)
    REFERENCES folklortrack_db.vestuarios (id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Tabla evento_regiones
CREATE TABLE IF NOT EXISTS folklortrack_db.evento_regiones (
  evento_id BIGINT UNSIGNED NOT NULL,
  region_id BIGINT UNSIGNED NOT NULL,
  fecha_creado TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (evento_id, region_id),
  INDEX fk_er_regiones_id (region_id ASC) VISIBLE,
  CONSTRAINT fk_er_eventos FOREIGN KEY (evento_id)
    REFERENCES folklortrack_db.eventos (id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_er_regiones FOREIGN KEY (region_id)
    REFERENCES folklortrack_db.regiones (id) ON DELETE RESTRICT ON UPDATE CASCADE
);