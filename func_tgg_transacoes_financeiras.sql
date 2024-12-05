-- LOG CARTAO
CREATE OR REPLACE FUNCTION log_card_update() 
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO card_log (card_id, action_type, previous_data, new_data, performed_by)
        VALUES (NEW.card_id, 'INSERT', NULL, row_to_json(NEW), CURRENT_USER);

ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO card_log (card_id, action_type, previous_data, new_data, performed_by)
        VALUES (NEW.card_id, 'UPDATE', row_to_json(OLD), row_to_json(NEW), CURRENT_USER);

ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO card_log (card_id, action_type, previous_data, new_data, performed_by)
        VALUES (OLD.card_id, 'DELETE', row_to_json(OLD), NULL, CURRENT_USER);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER card_log_trigger
AFTER INSERT OR UPDATE OR DELETE ON cartao
FOR EACH ROW
EXECUTE FUNCTION log_card_update();

UPDATE cartao
SET credit_limit = 7000.00
WHERE card_id = 1;


-- LOG USUARIO 
CREATE OR REPLACE FUNCTION log_user_update() 
RETURNS TRIGGER AS $$
BEGIN
    -- Se a idade ou renda do usuário mudar, registra o log
    IF OLD.current_age <> NEW.current_age OR OLD.yearly_income <> NEW.yearly_income THEN
        INSERT INTO user_log (user_id, action_type, previous_data, new_data, performed_by)
        VALUES (NEW.user_id, 'UPDATE', 
                json_build_object('current_age', OLD.current_age, 'yearly_income', OLD.yearly_income),
                json_build_object('current_age', NEW.current_age, 'yearly_income', NEW.yearly_income),
                CURRENT_USER);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_user_update
AFTER UPDATE ON usuario
FOR EACH ROW
EXECUTE FUNCTION log_user_update();

UPDATE usuario 
SET current_age = 56, yearly_income = 60000 
WHERE user_id = 3;


-- LOG TRANSACAO
CREATE OR REPLACE FUNCTION log_transaction_update() 
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO transaction_log (transaction_id, action_type, previous_amount, new_amount, user_id, card_id)
        VALUES (NEW.id, 'INSERT', NULL, NEW.amount, NEW.client_id, NEW.card_id);
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO transaction_log (transaction_id, action_type, previous_amount, new_amount, user_id, card_id)
        VALUES (NEW.id, 'UPDATE', OLD.amount, NEW.amount, NEW.client_id, NEW.card_id);
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO transaction_log (transaction_id, action_type, previous_amount, new_amount, user_id, card_id)
        VALUES (OLD.id, 'DELETE', OLD.amount, NULL, OLD.client_id, OLD.card_id);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER transaction_log_trigger
AFTER INSERT OR UPDATE OR DELETE ON transacao
FOR EACH ROW
EXECUTE FUNCTION log_transaction_update();

INSERT INTO transacao (id, client_id, card_id, amount)
VALUES (1, 1001, 2001, 500.00);
SELECT * FROM transaction_log;

-- LOG ACESSO
CREATE OR REPLACE FUNCTION log_access() 
RETURNS TRIGGER AS $$
BEGIN
    -- Log de login
    IF TG_OP = 'INSERT' THEN
        INSERT INTO access_log (user_id, log_date, action_type, ip_address, status)
        VALUES (NEW.user_id, CURRENT_TIMESTAMP, 'LOGIN', NEW.ip_address, 'SUCCESS');
    -- Log de falha de login
    ELSIF TG_OP = 'UPDATE' AND NEW.status = 'FAILED' THEN
        INSERT INTO access_log (user_id, log_date, action_type, ip_address, status)
        VALUES (NEW.user_id, CURRENT_TIMESTAMP, 'FAILED_LOGIN', NEW.ip_address, 'FAILED');
    -- Log de logout
    ELSIF TG_OP = 'UPDATE' AND NEW.status = 'LOGOUT' THEN
        INSERT INTO access_log (user_id, log_date, action_type, ip_address, status)
        VALUES (NEW.user_id, CURRENT_TIMESTAMP, 'LOGOUT', NEW.ip_address, 'SUCCESS');
    -- Log de mudança de senha
    ELSIF TG_OP = 'UPDATE' AND NEW.status = 'PASSWORD_CHANGE' THEN
        INSERT INTO access_log (user_id, log_date, action_type, ip_address, status)
        VALUES (NEW.user_id, CURRENT_TIMESTAMP, 'PASSWORD_CHANGE', NEW.ip_address, 'SUCCESS');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER access_log_trigger
AFTER INSERT OR UPDATE ON access_log
FOR EACH ROW
EXECUTE FUNCTION log_access();

