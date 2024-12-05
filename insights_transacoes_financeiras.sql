--quantidade de user mulher e homen

CREATE VIEW quant_user AS
SELECT 
    gender,
    COUNT(*) AS total_users
FROM usuario
GROUP BY gender;


--longitude e lagitude das pesoas

CREATE VIEW latitude_longitude AS
SELECT 
    latitude,
    longitude
FROM endereco;

CREATE VIEW latitude_longitude_corrigida AS
SELECT 
    latitude / 100.0 AS latitude_decimal,
    longitude / 100.0 AS longitude_decimal
FROM endereco;

--bandeira de cartao mais ussada

CREATE VIEW bandeira_mais_usada AS
SELECT c.card_brand,
COUNT(t.id) AS transaction_count
FROM transacao t
JOIN cartao c ON t.card_id = c.card_id
GROUP BY c.card_brand
ORDER BY transaction_count DESC;


--quantdade de pessoaas com tal score
CREATE VIEW score_por_user AS
SELECT 
    CASE 
        WHEN credit_score > 900 THEN 'Maior que 900'
        WHEN credit_score BETWEEN 800 AND 899 THEN 'Entre 800-899'
        WHEN credit_score BETWEEN 700 AND 799 THEN 'Entre 700-799'
        WHEN credit_score BETWEEN 600 AND 699 THEN 'Entre 600-699'
        ELSE 'Menor 600'
    END AS score_range,
    COUNT(*) AS total_users
FROM usuario
GROUP BY 
    CASE 
        WHEN credit_score > 900 THEN 'Maior que 900'
        WHEN credit_score BETWEEN 800 AND 899 THEN 'Entre 800-899'
        WHEN credit_score BETWEEN 700 AND 799 THEN 'Entre 700-799'
        WHEN credit_score BETWEEN 600 AND 699 THEN 'Entre 600-699'
        ELSE 'Menor 600'
    END;

--quantidade por tipo de transacao
CREATE VIEW tipo_transacao AS
SELECT 
    use_chip AS transaction_type,
    COUNT(*) AS transaction_count
FROM transacao
GROUP BY use_chip;

--verifica cartao na dark web
CREATE VIEW cartao_vazado AS
SELECT 
    card_on_dark_web,
    COUNT(*) AS total_cards
FROM cartao
GROUP BY card_on_dark_web;

CREATE VIEW OR REPLACE cartoes_vazados AS
SELECT 
    CASE 
        WHEN card_on_dark_web = 'Yes' THEN 'Vazado'
        WHEN card_on_dark_web = 'No' THEN 'Não Vazado'
    END AS status_vazamento,
    COUNT(*) AS total_cards
FROM cartao
GROUP BY 
    CASE 
        WHEN card_on_dark_web = 'Yes' THEN 'Vazado'
        WHEN card_on_dark_web = 'No' THEN 'Não Vazado'
    END;



--cartoes espidados em mes

CREATE VIEW cartao_valid AS
SELECT 
    EXTRACT(MONTH FROM expires) AS expiration_month,
    COUNT(*) AS expired_card_count
FROM cartao
GROUP BY EXTRACT(MONTH FROM expires)
ORDER BY expiration_month;

CREATE VIEW cartao_valido AS
SELECT 
    TO_CHAR(expires, 'Month') AS expiration_month,
    COUNT(*) AS expired_card_count
FROM cartao
GROUP BY TO_CHAR(expires, 'Month')
ORDER BY TO_DATE(TO_CHAR(expires, 'Month'), 'Month');

--quantidade de transasao neg ou posi
CREATE VIEW transacao_posi_nega AS
SELECT 
    CASE 
        WHEN amount < 0 THEN 'Negativa'
        ELSE 'Positiva'
    END AS transaction_type,
    COUNT(*) AS transaction_count
FROM transacao
GROUP BY 
    CASE 
        WHEN amount < 0 THEN 'Negativa'
        ELSE 'Positiva'
    END;


--errors

CREATE VIEW erros AS
SELECT 
    CASE 
        WHEN errors IS NULL OR errors = '' THEN 'No Error'
        ELSE errors
    END AS error_type,
    COUNT(*) AS transaction_count
FROM transacao
GROUP BY 
    CASE 
        WHEN errors IS NULL OR errors = '' THEN 'No Error'
        ELSE errors
    END
ORDER BY transaction_count DESC;
