
SELECT
    CASE
    WHEN leadsource::text = 'Build Batch'::character varying::text THEN 'Build Batch'::character varying
    WHEN leadsource::text = 'Build Final'::character varying::text THEN 'Build Final'::character varying
    WHEN leadsource::text = 'Client Source Batch'::character varying::text THEN 'Client Source Batch'::character varying
    WHEN leadsource::text = 'Client Source Final'::character varying::text THEN 'Client Source Final'::character varying
    WHEN leadsource::text = 'B2C-Individual Digital'::character varying::text THEN 'B2C-Individual Digital'::character varying
    WHEN leadsource::text = 'Corporate'::character varying::text THEN 'Corporate'::character varying
    WHEN leadsource::text = 'Registered'::character varying::text THEN 'Registered'::character varying
    WHEN leadsource::text = 'Sales Inside'::character varying::text THEN 'Sales Inside'::character varying
    WHEN leadsource::text = '2-9ers'::character varying::text THEN '2-9ers'::character varying
    WHEN leadsource::text = 'Agency'::character varying::text THEN 'Agency'::character varying
    WHEN leadsource::text = 'API Form'::character varying::text THEN 'API Form'::character varying
    WHEN leadsource::text = 'Bloomberg Leads'::character varying::text THEN 'Bloomberg'::character varying
    WHEN leadsource::text = 'Bloomberg Terminal'::character varying::text THEN 'Bloomberg'::character varying
    WHEN leadsource::text = 'Channel Partner'::character varying::text THEN 'Channel Partner'::character varying
    WHEN leadsource::text = 'Channel Referral'::character varying::text THEN 'Channel Referral'::character varying
    WHEN leadsource::text = 'Contact sales form'::character varying::text THEN 'Contact sales form'::character varying
    WHEN leadsource::text = 'Contact support form'::character varying::text THEN 'Contact support form'::character varying
    WHEN leadsource::text = 'Contact Us Form'::character varying::text THEN 'Contact Us Form'::character varying
    WHEN leadsource::text = 'Concurrency'::character varying::text THEN 'Copyright'::character varying
    WHEN leadsource::text = 'Copyright'::character varying::text THEN 'Copyright'::character varying
    WHEN leadsource::text = 'Email Forwarding'::character varying::text THEN 'Copyright'::character varying
    WHEN leadsource::text = 'Generic Email Address'::character varying::text THEN 'Copyright'::character varying
    WHEN leadsource::text = 'Overcopying'::character varying::text THEN 'Copyright'::character varying
    WHEN leadsource::text = 'Corporate Blog Subscriber'::character varying::text THEN 'Corporate Blog Subscriber'::character varying
    WHEN leadsource::text = 'Current Client'::character varying::text THEN 'Current Client'::character varying
    WHEN leadsource::text = 'Customer Referral'::character varying::text THEN 'Customer Referral'::character varying
    WHEN leadsource::text = 'Existing Client'::character varying::text THEN 'Customer Referral'::character varying
    WHEN leadsource::text = 'Existing Customer'::character varying::text THEN 'Customer Referral'::character varying
    WHEN leadsource::text = 'Case Study Download'::character varying::text THEN 'Document Download'::character varying
    WHEN leadsource::text = 'Document Download'::character varying::text THEN 'Document Download'::character varying
    WHEN leadsource::text = 'FTCorporate asset download'::character varying::text THEN 'Document Download'::character varying
    WHEN leadsource::text = 'Email Enquiry'::character varying::text THEN 'Email Enquiry'::character varying
    WHEN leadsource::text = 'Event'::character varying::text THEN 'Event'::character varying
    WHEN leadsource::text = 'FT Event'::character varying::text THEN 'Event'::character varying
    WHEN leadsource::text = 'Free Trial Form'::character varying::text THEN 'Free Trial Form'::character varying
    WHEN leadsource::text = 'FT Confidential Research'::character varying::text THEN 'FT Confidential Research'::character varying
    WHEN leadsource::text = 'FT Content'::character varying::text THEN 'FT Content'::character varying
    WHEN leadsource::text = 'FT Dept Referral'::character varying::text THEN 'FT Dept Referral'::character varying
    WHEN leadsource::text = 'FT Referral'::character varying::text THEN 'FT Referral'::character varying
    WHEN leadsource::text = 'FT.com'::character varying::text THEN 'FT.com'::character varying
    WHEN leadsource::text = 'Google Research'::character varying::text THEN 'Google Research'::character varying
    WHEN leadsource::text = 'Telephone Research'::character varying::text THEN 'Google Research'::character varying
    WHEN leadsource::text = 'Industry Contacts'::character varying::text THEN 'Industry Contacts'::character varying
    WHEN leadsource::text = 'Lighthouse'::character varying::text THEN 'Lighthouse'::character varying
    WHEN leadsource::text = 'Salesforce'::character varying::text THEN 'Lighthouse'::character varying
    WHEN leadsource::text = 'Linkedin Ads'::character varying::text THEN 'LinkedIn Ads'::character varying
    WHEN leadsource::text = 'LinkedIn Research'::character varying::text THEN 'LinkedIn Research'::character varying
    WHEN leadsource::text = 'Linkedin Search'::character varying::text THEN 'LinkedIn Research'::character varying
    WHEN leadsource::text = 'Manila'::character varying::text THEN 'Manila Research'::character varying
    WHEN leadsource::text = 'Manila Reseach'::character varying::text THEN 'Manila Research'::character varying
    WHEN leadsource::text = 'Manila Reseacrh'::character varying::text THEN 'Manila Research'::character varying
    WHEN leadsource::text = 'Manila Research'::character varying::text THEN 'Manila Research'::character varying
    WHEN leadsource::text = 'Phone Enquiry'::character varying::text THEN 'Phone Enquiry'::character varying
    WHEN leadsource::text = 'Print Customer'::character varying::text THEN 'Print Customer'::character varying
    WHEN leadsource::text = 'Secondary Schools'::character varying::text THEN 'Secondary Schools'::character varying
    WHEN leadsource::text = 'Syndication Sales Plan'::character varying::text THEN 'Syndication'::character varying
    WHEN leadsource::text = 'Telephone Prospecting'::character varying::text THEN 'Telephone Prospecting'::character varying
    WHEN leadsource::text = 'List Research (Company)'::character varying::text THEN 'Third Party'::character varying
    WHEN leadsource::text = 'Marketing/Third Party List'::character varying::text THEN 'Third Party'::character varying
    WHEN leadsource::text = 'Merit Data'::character varying::text THEN 'Third Party'::character varying
    WHEN leadsource::text = 'Merit Research'::character varying::text THEN 'Third Party'::character varying
    WHEN leadsource::text = 'Scout'::character varying::text THEN 'Third Party'::character varying
    WHEN leadsource::text = 'Third Party Data'::character varying::text THEN 'Third Party'::character varying
    WHEN leadsource::text = 'Third Party List'::character varying::text THEN 'Third Party'::character varying
    WHEN leadsource::text = 'Third Party Research'::character varying::text THEN 'Third Party'::character varying
    WHEN leadsource::text = 'Default - Please update'::character varying::text THEN 'Unknown'::character varying
    WHEN leadsource::text = 'Government Intelligence Digest'::character varying::text THEN 'Unknown'::character varying
    WHEN leadsource::text = 'http://thefinlab.com/'::character varying::text THEN 'Unknown'::character varying
    WHEN leadsource::text = 'Other'::character varying::text THEN 'Unknown'::character varying
    WHEN leadsource::text = 'Republishing Africa'::character varying::text THEN 'Unknown'::character varying
    WHEN leadsource::text = 'Restoring Client Trust Report'::character varying::text THEN 'Unknown'::character varying
    WHEN leadsource::text = 'SFDC-IN|Financial Times News Feed'::character varying::text THEN 'Unknown'::character varying
    WHEN leadsource::text = 'Unknown'::character varying::text THEN 'Unknown'::character varying
    WHEN leadsource::text = 'Web chat'::character varying::text THEN 'Web Chat'::character varying
    WHEN leadsource::text = 'Free Trial Request Form'::character varying::text THEN 'Free Trial Request Form'::character varying
    WHEN leadsource::text = 'Internet Research'::character varying::text THEN 'Internet Research'::character varying
    WHEN leadsource::text = 'Online Order Form'::character varying::text THEN 'Online Order Form'::character varying
    WHEN leadsource::text = 'Sales Navigator'::character varying::text THEN 'Sales Navigator'::character varying 
        ELSE 'Unknown'
        END AS adjusted_leadsource 
    , COUNT(leadsource) AS count_
FROM ftsfdb.view_sfdc_leads sf_leads
GROUP BY 1
ORDER BY 1