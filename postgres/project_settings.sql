CREATE TYPE user_role AS ENUM('MEMBER', 'MODERATOR', 'ADMINISTRATOR');
CREATE TABLE users (
    id BIGINT PRIMARY KEY,
    location GEOGRAPHY(Point, 4326) NOT NULL,
    is_pined  BOOLEAN NOT NULL DEFAULT FALSE,
    first_name VARCHAR(64) NOT NULL,
    last_name VARCHAR(64) NULL DEFAULT NULL,
    username VARCHAR(32) NULL DEFAULT NULL,
    display_name VARCHAR(64) NULL DEFAULT NULL,
    role user_role NOT NULL DEFAULT 'MEMBER',
    is_disabled BOOLEAN NOT NULL DEFAULT FALSE,
    disable_comment VARCHAR(256) NULL DEFAULT NULL,
    CHECK (
        (is_disabled IS FALSE AND disable_comment IS NULL)
        OR
        (is_disabled IS TRUE AND disable_comment IS NOT NULL)
    )
);
CREATE INDEX users_location_idx ON users USING GIST (location);


CREATE TABLE currencies (
    code VARCHAR(5) PRIMARY KEY CHECK (name ~ '^[A-Z0-9]{3,5}$'),
    rate NUMERIC(15, 6) NOT NULL CHECK (rate > 0),
    comment VARCHAR(128) NULL DEFAULT NULL,
    is_disabled BOOLEAN NOT NULL DEFAULT FALSE
);


CREATE TYPE exchange_type AS ENUM('FIXED', 'BASIC_MARGIN', 'PERCENT_MARGIN');
CREATE TABLE exchanges (
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    currency_give VARCHAR(5) NOT NULL REFERENCES currencies(name) ON DELETE RESTRICT,
    currency_get VARCHAR(5) NOT NULL REFERENCES currencies(name) ON DELETE RESTRICT,
    is_pined  BOOLEAN NOT NULL DEFAULT FALSE,
    comment VARCHAR(512) NULL DEFAULT NULL,
    exch_type exchange_type NOT NULL,
    rate NUMERIC(15, 6) NOT NULL,
    is_disabled BOOLEAN NOT NULL DEFAULT FALSE,
    disable_comment VARCHAR(256) NULL DEFAULT NULL,
    CHECK (currency_name_give <> currency_name_get),
    CHECK (
        (is_disabled IS FALSE AND disable_comment IS NULL)
        OR
        (is_disabled IS TRUE AND disable_comment IS NOT NULL)
    ),
    PRIMARY KEY (user_id, currency_give, currency_get)
);
CREATE INDEX exchanges_currency_pair_idx ON exchanges(currency_give, currency_get);
