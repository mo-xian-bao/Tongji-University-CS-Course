-- Active: 1742134147571@@127.0.0.1@3306@design
CREATE TABLE users(
    user_id         INTEGER         UNIQUE NOT NULL,
    user_name       VARCHAR(20)     UNIQUE NOT NULL,
    user_password   VARCHAR(30)     NOT NULL,
    email           VARCHAR(30)     NOT NULL,
    contact_info    VARCHAR(20)     NOT NULL,
    created_at      TIMESTAMP        NOT NULL,
    updated_at      TIMESTAMP        NOT NULL,
    PRIMARY KEY     (user_id)
);

CREATE TABLE venues(
    venue_id        INTEGER         UNIQUE NOT NULL,
    venue_name      VARCHAR(20)     NOT NULL,
    venue_type      VARCHAR(20)     NOT NULL,
    PRIMARY KEY     (venue_id)
);

CREATE TABLE user_OwnInfo(
    Own_id          INTEGER         UNIQUE NOT NULL,
    user_id         INTEGER         NOT NULL,
    venue_id        INTEGER         NOT NULL,
    start_time      DATETIME        NOT NULL,
    end_time        DATETIME        NOT NULL,
    posted_at       TIMESTAMP       NOT NULL,
    Own_status      SET('available','done','cancelled')
    PRIMARY KEY (Own_id),
    Foreign Key (user_id) REFERENCES users(user_id),
    Foreign Key (venue_id) REFERENCES venues(venue_id),
    CONSTRAINT chk_Oend_time CHECK (end_time > start_time)
);

CREATE TABLE user_Wantvenues (
    Want_id         INTEGER         UNIQUE NOT NULL,
    user_id         INTEGER         NOT NULL,
    venue_id        INTEGER         NOT NULL,
    start_time      DATETIME        NOT NULL,
    end_time        DATETIME        NOT NULL,
    posted_at       TIMESTAMP       NOT NULL,
    Want_status     SET('available','done','cancelled')      NOT NULL,
    PRIMARY KEY (Want_id),
    Foreign Key (user_id) REFERENCES users (user_id),
    Foreign Key (venue_id) REFERENCES venues (venue_id),
    CONSTRAINT chk_Wend_time CHECK (end_time > start_time)
);

CREATE TABLE ex_record(
    record_id       INTEGER         UNIQUE NOT NULL,
    Own_id          INTEGER         NOT NULL,
    Want_id         INTEGER         NOT NULL,
    initiator_user_id   INT         NOT NULL,
    created_at      TIMESTAMP       NOT NULL,
    ex_status       SET('pending','done','cancelled')   NOT NULL,
    PRIMARY KEY (record_id),
    Foreign Key (Own_id) REFERENCES user_OwnInfo (Own_id),
    Foreign Key (Want_id) REFERENCES user_Wantvenues (Want_id),
    Foreign Key (initiator_user_id) REFERENCES users (user_id)
);