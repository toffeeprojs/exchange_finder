CREATE TABLE database_update (
    database_name String,
    table_name String,
    data_key Map(String, String),
    updated_data Map(String, String),
    datatime DateTime,
    INDEX idx_table_name table_name TYPE minmax GRANULARITY 4
)
ENGINE = MergeTree()
PARTITION BY toDate(datatime)
ORDER BY (datatime)
TTL datatime + INTERVAL 90 DAY DELETE;


CREATE TABLE handler_calls (
    service_name String,
    handler_name String,
    handler_args Map(String, String),
    datatime DateTime,
    INDEX idx_handler_name handler_name TYPE minmax GRANULARITY 4
)
ENGINE = MergeTree()
PARTITION BY toDate(datatime)
ORDER BY datatime
TTL datatime + INTERVAL 90 DAY DELETE;
