CREATE TABLE currencies (
    name VARCHAR(10) PRIMARY KEY,
    rate_to_usd NUMERIC(15, 6) NOT NULL CHECK (rate_to_usd > 0)
);

CREATE TABLE users (
    telegram_id BIGINT PRIMARY KEY,
    location GEOGRAPHY(Point, 4326) NOT NULL
);

CREATE INDEX users_location_idx ON users USING GIST (location);

CREATE TABLE exchanges (
    user_telegram_id BIGINT NOT NULL REFERENCES users(telegram_id) ON DELETE CASCADE,
    currency_give VARCHAR(10) NOT NULL REFERENCES currencies(name) ON DELETE RESTRICT,
    currency_get VARCHAR(10) NOT NULL REFERENCES currencies(name) ON DELETE RESTRICT,
    is_dynamic BOOLEAN NOT NULL,
    rate NUMERIC(20, 6),
    comment VARCHAR(400),

    PRIMARY KEY (user_telegram_id, currency_give, currency_get),
);

CREATE INDEX exchanges_currency_pair_idx ON exchanges (currency_give, currency_get);
