DROP TABLE IF EXISTS #stepup_matrix;
CREATE TABLE #stepup_matrix (
    currency VARCHAR,
    lower_band FLOAT,
    higher_band FLOAT,
    new_price FLOAT,
    percent_discount VARCHAR,
    code INT,
    offer_id VARCHAR,
    subs_term VARCHAR,
    subs_product VARCHAR
);

INSERT INTO #stepup_matrix VALUES
('GBP', 0.01, 146.3, 154.0, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'annual', 'standard'),
('GBP', 146.31, 196.65, 207.0, '-33%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'annual', 'standard'),
('GBP', 196.66, 219.45, 231.0, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'annual', 'standard'),
('GBP', 219.46, 264.1, 278.0, '-10%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'annual', 'standard'),
('GBP', 264.11, 293.55, 309.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'annual', 'standard'),
('EUR', 0.01, 161.5, 170.0, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'annual', 'standard'),
('EUR', 161.51, 215.65, 227.0, '-33%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'annual', 'standard'),
('EUR', 215.66, 242.25, 255.0, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'annual', 'standard'),
('EUR', 242.26, 290.7, 306.0, '-10%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'annual', 'standard'),
('EUR', 290.71, 323.0, 340.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'annual', 'standard'),
('USD', 0.01, 176.7, 186.0, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'annual', 'standard'),
('USD', 176.71, 236.55, 249.0, '-33%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'annual', 'standard'),
('USD', 236.56, 265.05, 279.0, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'annual', 'standard'),
('USD', 265.06, 317.3, 334.0, '-10%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'annual', 'standard'),
('USD', 317.31, 353.4, 372.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'annual', 'standard'),
('AUD', 0.01, 176.7, 186.0, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'annual', 'standard'),
('AUD', 176.71, 236.55, 249.0, '-33%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'annual', 'standard'),
('AUD', 236.56, 265.05, 279.0, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'annual', 'standard'),
('AUD', 265.06, 317.3, 334.0, '-10%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'annual', 'standard'),
('AUD', 317.31, 353.4, 372.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'annual', 'standard'),
('HKD', 0.01, 1336.65, 1407.0, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'annual', 'standard'),
('HKD', 1336.66, 1790.75, 1885.0, '-33%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'annual', 'standard'),
('HKD', 1790.76, 2004.5, 2110.0, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'annual', 'standard'),
('HKD', 2004.51, 2405.4, 2532.0, '-10%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'annual', 'standard'),
('HKD', 2405.41, 2673.3, 2814.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'annual', 'standard'),
('SGD', 0.01, 225.15, 237.0, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'annual', 'standard'),
('SGD', 225.16, 301.15, 317.0, '-33%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'annual', 'standard'),
('SGD', 301.16, 337.25, 355.0, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'annual', 'standard'),
('SGD', 337.26, 404.7, 426.0, '-10%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'annual', 'standard'),
('SGD', 404.71, 450.3, 474.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'annual', 'standard'),
('JPY', 0.01, 23712.0, 24960.0, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'annual', 'standard'),
('JPY', 23712.01, 31773.7, 33446.0, '-33%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'annual', 'standard'),
('JPY', 31773.71, 35568.0, 37440.0, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'annual', 'standard'),
('JPY', 35568.01, 42681.6, 44928.0, '-10%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'annual', 'standard'),
('JPY', 42681.61, 47424.0, 49920.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'annual', 'standard'),
('CHF', 0.01, 177.65, 187.0, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'annual', 'standard'),
('CHF', 177.66, 238.45, 251.0, '-33%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'annual', 'standard'),
('CHF', 238.46, 266.95, 281.0, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'annual', 'standard'),
('CHF', 266.96, 320.15, 337.0, '-10%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'annual', 'standard'),
('CHF', 320.16, 356.25, 375.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'annual', 'standard'),
('GBP', 0.01, 15.675, 16.5, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'monthly', 'standard'),
('GBP', 15.69, 20.9, 22.0, '-33%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'monthly', 'standard'),
('GBP', 20.91, 23.275, 24.5, '-26%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'monthly', 'standard'),
('GBP', 23.29, 28.025, 29.5, '-11%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'monthly', 'standard'),
('GBP', 28.04, 31.35, 33.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'monthly', 'standard'),
('EUR', 0.01, 18.05, 19.0, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'monthly', 'standard'),
('EUR', 18.06, 23.75, 25.0, '-34%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'monthly', 'standard'),
('EUR', 23.76, 27.075, 28.5, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'monthly', 'standard'),
('EUR', 27.09, 32.3, 34.0, '-11%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'monthly', 'standard'),
('EUR', 32.31, 36.1, 38.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'monthly', 'standard'),
('USD', 0.01, 19.0, 20.0, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'monthly', 'standard'),
('USD', 19.01, 25.175, 26.5, '-34%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'monthly', 'standard'),
('USD', 25.19, 28.5, 30.0, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'monthly', 'standard'),
('USD', 28.51, 34.2, 36.0, '-10%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'monthly', 'standard'),
('USD', 34.21, 38.0, 40.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'monthly', 'standard'),
('AUD', 0.01, 19.0, 20.0, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'monthly', 'standard'),
('AUD', 19.01, 25.175, 26.5, '-34%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'monthly', 'standard'),
('AUD', 25.19, 28.5, 30.0, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'monthly', 'standard'),
('AUD', 28.51, 34.2, 36.0, '-10%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'monthly', 'standard'),
('AUD', 34.21, 38.0, 40.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'monthly', 'standard'),
('HKD', 0.01, 144.875, 152.5, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'monthly', 'standard'),
('HKD', 144.89, 193.8, 204.0, '-33%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'monthly', 'standard'),
('HKD', 193.81, 216.6, 228.0, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'monthly', 'standard'),
('HKD', 216.61, 260.3, 274.0, '-10%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'monthly', 'standard'),
('HKD', 260.31, 289.75, 305.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'monthly', 'standard'),
('SGD', 0.01, 24.7, 26.0, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'monthly', 'standard'),
('SGD', 24.71, 32.775, 34.5, '-34%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'monthly', 'standard'),
('SGD', 32.79, 37.05, 39.0, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'monthly', 'standard'),
('SGD', 37.06, 44.175, 46.5, '-11%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'monthly', 'standard'),
('SGD', 44.19, 49.4, 52.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'monthly', 'standard'),
('JPY', 0.01, 2569.75, 2705.0, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'monthly', 'standard'),
('JPY', 2569.76, 3442.8, 3624.0, '-33%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'monthly', 'standard'),
('JPY', 3442.81, 3854.15, 4057.0, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'monthly', 'standard'),
('JPY', 3854.16, 4625.55, 4869.0, '-10%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'monthly', 'standard'),
('JPY', 4625.56, 5139.5, 5410.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'monthly', 'standard'),
('CHF', 0.01, 19.475, 20.5, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'monthly', 'standard'),
('CHF', 19.49, 25.65, 27.0, '-34%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'monthly', 'standard'),
('CHF', 25.66, 28.975, 30.5, '-26%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'monthly', 'standard'),
('CHF', 28.99, 34.675, 36.5, '-11%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'monthly', 'standard'),
('CHF', 34.69, 38.95, 41.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'monthly', 'standard')
;
select * from #stepup_matrix