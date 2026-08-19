-- =============================================================
-- Bibliothèque du Savoir - Schéma de la base de données
-- =============================================================

CREATE DATABASE IF NOT EXISTS bibliotheque
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE bibliotheque;

-- -------------------------------------------------------------
-- Réinitialisation (rend le script relançable à volonté)
-- -------------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS remember_tokens;
DROP TABLE IF EXISTS borrows;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS roles;
SET FOREIGN_KEY_CHECKS = 1;

-- -------------------------------------------------------------
-- Rôles
-- -------------------------------------------------------------
CREATE TABLE roles (
    id      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE
) ENGINE = InnoDB;

-- -------------------------------------------------------------
-- Utilisateurs
-- -------------------------------------------------------------
CREATE TABLE users (
    id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nom           VARCHAR(100) NOT NULL,
    prenom        VARCHAR(100) NOT NULL,
    email         VARCHAR(255) NOT NULL UNIQUE,
    password      VARCHAR(255) NOT NULL,
    telephone     VARCHAR(30)  NULL,
    role_id       INT UNSIGNED NOT NULL,
    date_creation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles (id)
) ENGINE = InnoDB;

-- -------------------------------------------------------------
-- Catégories
-- -------------------------------------------------------------
CREATE TABLE categories (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    libelle     VARCHAR(100) NOT NULL UNIQUE,
    description TEXT NULL
) ENGINE = InnoDB;

-- -------------------------------------------------------------
-- Livres
-- -------------------------------------------------------------
CREATE TABLE books (
    id               INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    isbn             VARCHAR(20) NOT NULL UNIQUE,
    titre            VARCHAR(255) NOT NULL,
    auteur           VARCHAR(255) NOT NULL,
    description      TEXT NULL,
    date_publication DATE NULL,
    quantite         INT NOT NULL DEFAULT 1,
    couverture       VARCHAR(255) NULL,
    categorie_id     INT UNSIGNED NULL,
    CONSTRAINT fk_books_categorie FOREIGN KEY (categorie_id) REFERENCES categories (id) ON DELETE SET NULL
) ENGINE = InnoDB;

-- -------------------------------------------------------------
-- Emprunts
-- -------------------------------------------------------------
CREATE TABLE borrows (
    id                  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id             INT UNSIGNED NOT NULL,
    book_id             INT UNSIGNED NOT NULL,
    date_emprunt        DATE NOT NULL,
    date_retour_prevue  DATE NOT NULL,
    date_retour         DATE NULL,
    statut              ENUM('en_cours', 'retourne') NOT NULL DEFAULT 'en_cours',
    CONSTRAINT fk_borrows_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT fk_borrows_book FOREIGN KEY (book_id) REFERENCES books (id) ON DELETE CASCADE
) ENGINE = InnoDB;

-- -------------------------------------------------------------
-- Tokens de connexion persistante (« se souvenir de moi »)
-- -------------------------------------------------------------
CREATE TABLE remember_tokens (
    id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id    INT UNSIGNED NOT NULL,
    token_hash CHAR(64) NOT NULL,
    expires_at DATETIME NOT NULL,
    CONSTRAINT fk_remember_tokens_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE = InnoDB;
