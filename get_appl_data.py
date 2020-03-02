import pandas as pd
import sys
import time


sys.path.insert(0, 'C:\\Users\\user\\Documents\\Creditup\\Python Scripts\\connections')
from MysqlConn import DatabaseConnect


path = 'C:\\Users\\user\\Documents\\Creditup\\Projects\\Models\\CreditupScoring\\'

pd.set_option('display.max_columns', None)


with open(path + 'get_data\\sql_applications.sql') as file:
    sql_appl_query = file.read()
    file.close()


decis_con = DatabaseConnect('decision')
df = pd.DataFrame(decis_con.query(sql_appl_query), columns=decis_con.getcolnames())
decis_con.conn.close()


int_cols = ['id', 'backend_application_id', 'user_id', 'status_id', 'loan_closed', 'loan_overdue', 'overdue_days', 'first_loan_flag', 'loan_days', 
'purpose_id', 'gender_id', 'marital_status_id', 'children_count_id', 
'education_id', 'addr_region_id', 'addr_owner_type_id', 'fact_addr_same', 'fact_addr_region_id', 
'has_immovables', 'has_movables', 'employment_type_id', 'position_id', 'organization_type_id', 
'empoyees_count_id', 'seniority_years', 'monthly_income', 'monthly_expenses', 'income_source_id', 
'other_loans_has_closed', 'other_loans_active',	'product_id', 'bki_id']

for i in int_cols:
    if df[i].dtype != 'int64':
        df[i] = df[i].fillna('0').astype('int64')


date_cols = ['applied_at', 'initial_payment_date', 'birth_date', 
             'passport_date', 'addr_registration_date', 
             'fact_addr_start_date', 'employment_date']

for i in date_cols:
    if df[i].dtype != '<M8[ns]':
        df[i] = pd.to_datetime(df[i], errors='coerce')


float_cols = ['loan_amount', 'other_loans_about_current', 
              'other_loans_about_monthly', 'product_dpr', 
              'product_amount_from', 'product_amount_to',
              'product_base_amount_limit', 'amount_limit']

for i in float_cols:
    if df[i].dtype != 'float64':
        df[i] = df[i].astype('float64')


df.replace({pd.np.nan: None}, inplace=True)

df.to_csv('Documents\\temp\\data.csv', index=False)
















from PostgresConn import postgres_insert, postgres_truncate, postgres_select


data_to_insert = [tuple(row) for row in df[:200].itertuples(index=False)]


start_time = time.time()

#insert
insert_to_appl = """ insert into scoring_data.applications values ({})""".format(
    '%s,' * 60 + '%s')
postgres_insert('creditup_scoring', insert_to_appl, data_to_insert)

end_time = time.time()
print(end_time - start_time)




#for checking
postgres_select('creditup_scoring', 'select * from scoring_data.applications')


#truncate table before inserting
sql_truncate_campaigns = '''truncate table scoring_data.applications'''
postgres_truncate('creditup_scoring', sql_truncate_campaigns)
