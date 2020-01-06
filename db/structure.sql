CREATE TABLE migration_versions (id integer PRIMARY KEY AUTOINCREMENT, version text NOT NULL);
CREATE TABLE accounts (id text NOT NULL PRIMARY KEY, url_token text NOT NULL, name text NOT NULL, email text NOT NULL, avatar text NOT NULL, api_token text NOT NULL, created_at text NOT NULL, updated_at text NOT NULL, enabled integer NOT NULL DEFAULT true);
CREATE UNIQUE INDEX accounts_url_token_idx ON accounts (url_token);
CREATE TABLE clubs (id text NOT NULL PRIMARY KEY, name text NOT NULL, description text NOT NULL, avatar text NOT NULL, background text NOT NULL, created_at text NOT NULL, updated_at text NOT NULL);
CREATE TABLE IF NOT EXISTS "histories"(id integer PRIMARY KEY, account_id text NOT NULL, club_id text NOT NULL, msg text NOT NULL, created_at text NOT NULL, updated_at text NOT NULL,FOREIGN KEY (account_id) REFERENCES accounts(id) ON UPDATE RESTRICT ON DELETE CASCADE,FOREIGN KEY (club_id) REFERENCES clubs(id) ON UPDATE RESTRICT ON DELETE CASCADE);
CREATE TABLE IF NOT EXISTS "accounts_clubs"(account_id text NOT NULL, club_id text NOT NULL,FOREIGN KEY (account_id) REFERENCES accounts(id) ON UPDATE RESTRICT ON DELETE CASCADE,FOREIGN KEY (club_id) REFERENCES clubs(id) ON UPDATE RESTRICT ON DELETE CASCADE);
CREATE UNIQUE INDEX accounts_clubs_account_id_club_id_idx ON accounts_clubs (account_id,club_id);
