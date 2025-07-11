CREATE TYPE user_role AS ENUM (
    'MEM',
    'MOD',
    'ADM'
);

CREATE TABLE users (
    telegram_id BIGINT PRIMARY KEY,
    location GEOGRAPHY(Point, 4326) NOT NULL,

    telegram_first_name VARCHAR(64) NOT NULL,
    display_name VARCHAR(64) NULL
        DEFAULT NULL,
    telegram_username VARCHAR(32) NULL
        DEFAULT NULL,
    telegram_last_name VARCHAR(64) NULL
        DEFAULT NULL,

    role user_role NOT NULL
        DEFAULT 'MEM',

    is_disabled BOOLEAN NOT NULL
        DEFAULT FALSE,
    disable_comment VARCHAR(256) NULL
        DEFAULT NULL,

    CHECK ((disable_comment IS NULL) OR (is_disabled IS TRUE))
);

CREATE INDEX users_location_idx
    ON users USING GIST (location);

CREATE TABLE currencies (
    name VARCHAR(5) PRIMARY KEY
        CHECK (name ~ '^[A-Z]{3,5}$'),
    relative_rate NUMERIC(15, 6) NOT NULL
        CHECK (relative_rate > 0),

    is_disabled BOOLEAN NOT NULL
        DEFAULT FALSE
);

CREATE TABLE exchanges (
    user_telegram_id BIGINT NOT NULL
        REFERENCES users(telegram_id)
        ON DELETE RESTRICT,

    currency_name_give VARCHAR(5) NOT NULL
        REFERENCES currencies(name)
        ON DELETE RESTRICT,
    currency_name_get VARCHAR(5) NOT NULL
        REFERENCES currencies(name)
        ON DELETE RESTRICT,

    CHECK (currency_name_give <> currency_name_get),
    PRIMARY KEY (
        user_telegram_id,
        currency_name_give,
        currency_name_get
    ),

    is_dynamic BOOLEAN NOT NULL,
    rate_or_margin NUMERIC(15, 6) NOT NULL,

    comment VARCHAR(512) NULL
        DEFAULT NULL,

    is_disabled BOOLEAN NOT NULL
        DEFAULT FALSE,
    disable_comment VARCHAR(256) NULL
        DEFAULT NULL,

    CHECK ((disable_comment IS NULL) OR (is_disabled = TRUE))
);

CREATE INDEX exchanges_currency_pair_idx
    ON exchanges(
        currency_name_give,
        currency_name_get
    );
