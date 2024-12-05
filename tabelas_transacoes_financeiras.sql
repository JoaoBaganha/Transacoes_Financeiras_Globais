CREATE TABLE endereco (
    address_id SERIAL PRIMARY KEY,
	address_number INT,
	address_name VARCHAR(255),
    latitude INT,
    longitude INT 
);

CREATE TABLE usuario (
    user_id SERIAL PRIMARY KEY,
    current_age INT,
    retirement_age INT,
    birth_year INT,
    birth_month INT ,
    gender VARCHAR(10) CHECK (gender IN ('Female', 'Male')) ,
    address_id INT,
    per_capita_income INT,
    yearly_income INT,
    total_debt INT,
    credit_score INT ,
    num_credit_cards INT ,
    FOREIGN KEY (address_id) REFERENCES endereco(address_id)
);


CREATE TABLE cartao (
    card_id SERIAL PRIMARY KEY,
    user_id INT ,
    card_brand VARCHAR(50) CHECK (card_brand IN ('Amex', 'Discover', 'Mastercard', 'Visa' )) ,
    card_type VARCHAR(50) CHECK (card_type IN ('Credit', 'Debit', 'Debit (Prepaid)' )) ,
    card_number VARCHAR(16) ,
    expires DATE ,
    cvv INT ,
    has_chip VARCHAR(5) CHECK (has_chip IN ('YES', 'NO')) ,
    num_cards_issued INT ,
    credit_limit NUMERIC(10,2) ,
    acct_open_date DATE ,
    year_pin_last_changed INT ,
    card_on_dark_web VARCHAR(5) CHECK (card_on_dark_web IN ('Yes', 'No' )) ,
    FOREIGN KEY (user_id) REFERENCES usuario(user_id)
);

CREATE TABLE lista_mcc (
    code INT PRIMARY KEY,
    description VARCHAR(255) 
);

CREATE TABLE comerciante (
    merchant_id SERIAL PRIMARY KEY,
    merchant_city VARCHAR(100),
    merchant_state VARCHAR(100),
    zip NUMERIC(10,2) 
);


CREATE TABLE transacao (
    id SERIAL PRIMARY KEY,
    client_id INT ,
    card_id INT ,
    amount NUMERIC(10,2) ,
    use_chip VARCHAR(50) CHECK (use_chip IN ('Swipe Transaction', 'Online Transaction', 'Chip Transaction')) ,
    merchant_id INT ,
	mcc INT,
	errors VARCHAR(255),
	transaction_date date ,
	transaction_time time ,
	FOREIGN KEY (mcc) REFERENCES lista_mcc(code),
    FOREIGN KEY (client_id) REFERENCES usuario(user_id),
    FOREIGN KEY (card_id) REFERENCES cartao(card_id),
    FOREIGN KEY (merchant_id) REFERENCES comerciante(merchant_id)
);

