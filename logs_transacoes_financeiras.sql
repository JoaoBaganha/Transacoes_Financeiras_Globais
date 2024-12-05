CREATE TABLE transaction_log (
    log_id SERIAL PRIMARY KEY,
    transaction_id INT,
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action_type VARCHAR(50) CHECK (action_type IN ('INSERT', 'UPDATE', 'DELETE', 'ERROR')),
    previous_amount NUMERIC(10,2),
    new_amount NUMERIC(10,2),
    error_message VARCHAR(255),
    user_id INT,
    card_id INT,
    FOREIGN KEY (transaction_id) REFERENCES transacao(id),
    FOREIGN KEY (user_id) REFERENCES usuario(user_id),
    FOREIGN KEY (card_id) REFERENCES cartao(card_id)
);


CREATE TABLE user_log (
    log_id SERIAL PRIMARY KEY,
    user_id INT,
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action_type VARCHAR(50) CHECK (action_type IN ('INSERT', 'UPDATE', 'DELETE')),
    previous_data JSON,
    new_data JSON,
    performed_by VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES usuario(user_id)
);


CREATE TABLE card_log (
    log_id SERIAL PRIMARY KEY,
    card_id INT,
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action_type VARCHAR(50) CHECK (action_type IN ('INSERT', 'UPDATE', 'DELETE')),
    previous_data JSON,
    new_data JSON,
    performed_by VARCHAR(50),
    FOREIGN KEY (card_id) REFERENCES cartao(card_id)
);


CREATE TABLE error_log (
    log_id SERIAL PRIMARY KEY,
    error_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    table_affected VARCHAR(50),
    operation_attempted VARCHAR(50),
    error_message VARCHAR(255),
    user_id INT,
    card_id INT,
    FOREIGN KEY (user_id) REFERENCES usuario(user_id),
    FOREIGN KEY (card_id) REFERENCES cartao(card_id)
);

CREATE TABLE access_log (
    log_id SERIAL PRIMARY KEY,
    user_id INT,
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action_type VARCHAR(50) CHECK (action_type IN ('LOGIN', 'LOGOUT', 'FAILED_LOGIN', 'PASSWORD_CHANGE')),
    ip_address VARCHAR(50),
    status VARCHAR(50) CHECK (status IN ('SUCCESS', 'FAILED')),
    FOREIGN KEY (user_id) REFERENCES usuario(user_id)
);