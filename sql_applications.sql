
SELECT 
	apl.id, apl.backend_application_id, apl.user_id, apl.social_number, apl.phone_mobile, 
	apl.status_id, apl.loan_closed, apl.loan_overdue, apl.overdue_days, apl.ip,
	if(apl.applied_at = frs.first_loan_date, 1, 0) first_loan_flag,
	apl.applied_at, DATE_ADD(apl.applied_at, INTERVAL apl.loan_days DAY) initial_payment_date, 
	apl.loan_amount, apl.loan_days, apl.user_agent, apl.detections,
	
	#application data
	apl.purpose_id, apl.purpose_other, apl.gender_id, apl.birth_date, apl.marital_status_id, apl.children_count_id, apl.education_id, apl.passport_date,
	apl.social_accounts, apl.email, 
	apl.addr_region_id, apl.addr_city, apl.addr_owner_type_id, apl.addr_registration_date, apl.fact_addr_same, 
	apl.fact_addr_region_id, apl.fact_addr_city, apl.fact_addr_start_date, 
	apl.has_immovables, apl.has_movables, apl.employment_type_id, apl.position_id, apl.position_other,
	apl.organization, apl.organization_type_id, apl.organization_type_other, 
	apl.empoyees_count_id, apl.employment_date, apl.seniority_years, apl.work_phone, 
	apl.monthly_income, apl.monthly_expenses, apl.income_source_id, apl.income_source_other,
	apl.other_loans_has_closed, apl.other_loans_active, apl.other_loans_about_current, apl.other_loans_about_monthly,
	
	#product info
	apl.product_id, apl.product_dpr, apl.product_amount_from, apl.product_amount_to, 
	apl.product_base_amount_limit, apl.amount_limit,
	
	IFNULL(bki.bki_id,
		(SELECT MIN(id) FROM creditup_dmaker.finplugs_pdl_bki_calls bki
		WHERE apl.social_number = bki.social_number AND DATEDIFF(apl.created_at, bki.created_at) BETWEEN -1 AND 30
		AND bki_type_id = 1 AND remote_error_code IS NULL AND curl_error = 0)
		) bki_id	

FROM 
	creditup_dmaker.finplugs_pdl_applications apl

		#bki id
		LEFT JOIN 
		(SELECT application_id id, MIN(id) bki_id FROM creditup_dmaker.finplugs_pdl_bki_calls
		WHERE bki_type_id = 1 AND remote_error_code IS NULL AND curl_error = 0 GROUP BY application_id) bki
		ON apl.id = bki.id	
	
		#первый кредит
		INNER JOIN 
		(SELECT user_id, MIN(applied_at) first_loan_date
		FROM creditup_dmaker.finplugs_pdl_applications
		WHERE status_id IN (4,5,6) GROUP BY user_id) frs
		ON apl.user_id = frs.user_id	

WHERE
	apl.status_id IN (5,6) 
	AND apl.applied_at >= '2019-01-01' AND apl.applied_at < CURDATE()
	AND apl.user_id NOT IN (SELECT user_id FROM creditup_dmaker.finplugs_pdl_applications WHERE status_id = 4)
;




