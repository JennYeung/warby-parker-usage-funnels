# warby-parker-usage-funnels
Warby Parker Usage funnels Analysis With SQL

For this project, I will be analyzing two of Warby Parker's marketing funnels - the Survey Funnel and the Home Try-on Purchase Funnel - in order to calculate their conversion rates. I will be utilizing my SQL skills and analytical abilities to work with the data provided by Codecademy and Warby Parker's data science team. 

I am given the following funnels and tables:

-> Survey Funnel:
    -> survey
        question      TEXT
        user_id       TEXT
        response      TEXT

-> Home Try-On Purchase Funnel:
    -> quiz
        user_id   TEXT
        style     TEXT
        fit       TEXT
        shape     TEXT
        color     TEXT
          
    -> home_try_on
        user_id             TEXT
        number_of_pairs     TEXT
        address             TEXT
        
    -> purchase
        user_id         TEXT
        product_id      INTEGER
        style           TEXT
        model_name      TEXT
        color           TEXT
        price           INTEGER
        
        
