import pandas as pd
import sys
import time


sys.path.insert(0, 'C:\\Users\\user\\Documents\\Creditup\\Python Scripts\\connections')
from PostgresConn import postgres_select

path = 'Documents\\Creditup\\Projects\\CreditupScoring\\'

#pathlib
pd.set_option('display.max_columns', None)


#with open(path + 'get_data\\sql_bki.sql', 'r', encoding='utf-8') as file:
with open(path + 'get_data\\sql_crdeal.sql', 'r', encoding='utf-8') as file:
    sql_query = file.read()
    file.close()


start_time = time.time()

df = postgres_select('creditup_scoring', sql_query)

print("--- %s seconds ---" % (time.time() - start_time))
print(df.shape)




#Extract Attributes
#------------------------------------------------------------------------------
ls_attr = []

for idx in df.index:
    
    ls = []
    deals = df.bki_crdeal[idx]
    bki_id_dict = {'bki_id': df.bki_id[idx]}
    
    if type(deals) == dict:
        ls.append({**deals['@attributes'], **bki_id_dict})
    elif type(deals) == list:
        ls += [{**i['@attributes'], **bki_id_dict} for i in deals]

    ls_attr += ls


cols = ['bki_id', 'inn', 'dlamt', 'dlref', 'dlcurr', 'dldonor', 'dlporpog', 
        'dlamtobes', 'dlcelcred', 'dlrolesub', 'dlvidobes']
attr = pd.DataFrame(ls_attr, columns=cols)


#Extract Deallife
#------------------------------------------------------------------------------
ls_deal = []

for idx in df.index:
    
    ls = []
    deals = df.bki_crdeal[idx]
    bki_id_dict = {'bki_id': df.bki_id[idx]}
    
    if type(deals) == dict:
        trans = deals['deallife']
        
        if type(trans) == dict:
            ls.append({**trans['@attributes'], **bki_id_dict})
        elif type(trans) == list:
            ls += [{**i['@attributes'], **bki_id_dict} for i in trans]
    
    elif type(deals) == list:
        
        for deal in deals:
            trans = deal['deallife']
            
            if type(trans) == dict:
                ls.append({**trans['@attributes'], **bki_id_dict})
            elif type(trans) == list:
                ls += [{**i['@attributes'], **bki_id_dict} for i in trans]

    ls_deal += ls


cols = ['bki_id', 'dlds', 'dldff', 'dldpf', 'dlref', 'dlyear', 'dlflbrk', 'dlflpay',
       'dlfluse', 'dlmonth', 'dlamtcur', 'dlamtexp', 'dlamtlim', 'dldayexp',
       'dlflstat', 'dlamtpaym', 'dldateclc']
deallife = pd.DataFrame(ls_deal, columns=cols)



print(attr.head())
print('\n')
print(attr.shape)

print(deallife.head())
print('\n')
print(deallife.shape)


#checking
#sum([int(i) for i in df.bki_urating_dinfo_all if i != 'null'])
#ls_attr = [i['@attributes'] for j in df.bki_crdeal for i in j]
#ls_deal = [x for i, x in enumerate(ls_deal) if x is not None]



deallife.to_csv(path + '..\\temp_files\\deallife.csv', 
          index=False)


attr.to_csv(path + '..\\temp_files\\attr.csv.gz', 
          compression='gzip',
          index=False)


sql_query = '''select bki_id from scoring_data.bki_response'''



#deallife

'''
'@attributes': {
   'dlds': '2018-06-30',                              #Дата начала сделки
   'dldff': '2018-07-20',                             #Фактическая дата окончания сделки (обязательное при статусе сделки закрыт) 
   'dldpf': '2018-07-20',                             #Дата окончания сделки по договору 
   'dlref': 'edb5c15b-fff1-4af6-bd0a-d62251e7cc82',   #Идентификатор сделки 
   'dlyear': '2018',                                  #Период данных (год)
   'dlflbrk': '1',                                    #Признак наличия просрочки в тек.периоде (Код из спр.13)
   'dlflpay': '1',                                    #Признак исполн. платежа в тек.периоде (Код из спр.13)
   'dlfluse': '0',                                    #Признак наличия кредитного транша в тек.периоде (Код из спр.13)
   'dlmonth': '7',                                    #Период данных (месяц) 
   'dlamtcur': '0.00',                                #Сумма тек. задолженности*
   'dlamtexp': '0.00',                                #Сумма тек. проср. задолженности*
   'dlamtlim': '0.00',                                #Текущий лимит сделки 
   'dldayexp': '0',                                   #Текущее кол-во дней просрочки 
   'dlflstat': '2',                                   #Статус сделки в тек.периоде (Код из спр.16)
   'dlamtpaym': '0.00',                               #Сумма планового обяз. платежа в тек.периоде (по графику) 
   'dldateclc': '2018-07-31',                         #Дата расчета
   'dlflbrkref': 'Да',                                #Значение из справочника признак наличия просрочки в тек.периоде (Значение из спр.13)
   'dlflpayref': 'Да',                                #Значение из справочника признак исполн. платежа в тек.периоде  (Значение из спр.13
   'dlfluseref': 'Нет',                               #Значение из справочника признака наличия кредитного транш в тек.периоде (Значение из спр.13)
   'dlflstatref': 'закрыта'                           #Значение из справочника cтатус сделки в тек.периоде  

#Сумма тек. задолженности* 
(сумму начисленных процентов + 
двойных (кратных) процентов + 
комиссии + 
тело кредита + 
просроченное тело +просроченные проценты)

#Сумма тек. проср. задолженности* 
(просроченные проценты + 
просроченные комиссии + 
просроченное тело кредита) 
'''


#@attributes
'''
{'inn': '3292211505',                                               #
 'lng': '1',                                                        #
 'bdate': '1990-02-19',                                             #
 'dlamt': '500.00',                                                 #Сумма (начальная) сделки
 'dlref': 'SAMDNWFC00046492238',                                    #Идентификатор сделки
 'fname': 'РУСЛАНА',                                                #
 'lname': 'МЕЛЬНИК',                                                #
 'mname': 'ВАЛЕРИЕВНА',                                             #
 'dlcurr': '980',                                                   #Валюта сделки (Код из спр.12)
 'lngref': 'Украинский',                                            #
 'dldonor': 'BNK',                                                  #Донор информации*
 'dlporpog': '7',                                                   #Порядок погашения (Код из спр.18)
 'dlamtobes': '',                                                   #Стоимость обеспечения в базовой валюте 
 'dlcelcred': '31',                                                 #Тип сделки (Код из спр.17)
 'dlcurrref': 'Украинская гривня',                                  #
 'dlrolesub': '1',                                                  #Роль субъекта (Код из спр.14)
 'dlvidobes': '',                                                   #Вид обеспечения (Код из спр.15)
 'dlporpogref': 'Кредит с индивидуальным графиком погашения',       #Значение из справочника порядок погашения (Значение из спр.18)
 'dlcelcredref': 'Кредитная карта',                                 #Значение из справочника тип сделки (Значение из спр.17)
 'dlrolesubref': 'Заемщик',                                         #Значение из справочника роль субъекта (Значение из спр.14)
 'dlvidobesref': ''                                                 #Значение из справочника вид обеспечения (Значение из спр.15)
 }

Донор информации (BNK - банк, NFN - нефинансовая, FIN - финансовая, 
OWN - своя, MFO - микрофинансовая, CRU - кредитный союз, 
CLC - коллекторская компания, INS - страховая компания, LSN - лизинговая компания) 
'''

