/* filter on table for :
- yesterday
- b2c customer = true
- is_active = true

*/
SELECT
	  dw_inserted_date
	, is_b2c
	, is_registered -- what is this?
	, is_print
	, ft_user_id
FROM
	dwabstraction.fact_userstatus fu
WHERE
	userstatus_date_dkey = 20210422 -- this is the distribution key, makes more sense to use this!
AND is_b2c = True
AND is_active = True

;