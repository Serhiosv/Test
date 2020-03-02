select bki_id,
--TECH
	json_extract_path(response::json, 'tech','trace', 'step', '@attributes', 'ftm') bki_tech_trace_step_ftm,
	json_extract_path(response::json, 'tech','trace', 'step', '@attributes', 'stm') bki_tech_trace_step_stm,
	json_extract_path(response::json, 'tech','billing', 'balance', '@attributes', 'date') bki_tech_bill_bal_date,	
	json_extract_path(response::json, 'tech','billing', 'balance', '@attributes', 'value') bki_tech_bill_bal_val,

--CKI
	json_extract_path(response::json->'comp'->0, 'cki', '@attributes', 'bdate') bki_cki_bdate,	
	--["inn", "bdate", "fname", "lname", "mname", "reqlng", "reqlngref"]

--CKI indent
	response::json->'comp'->0->'cki'->'ident'->0->'@attributes'->'vdate' bki_cki_indend_0_vdate, --verification date
	response::json->'comp'->0->'cki'->'ident'->0->'@attributes'->'bdate' bki_cki_indend_0_bdate, --bdate
	response::json->'comp'->0->'cki'->'ident'->0->'@attributes'->'csex' bki_cki_indend_0_csex, --sex
	response::json->'comp'->0->'cki'->'ident'->0->'@attributes'->'family' bki_cki_indend_0_family, --family status	
	response::json->'comp'->0->'cki'->'ident'->0->'@attributes'->'ceduc' bki_cki_indend_0_ceduc,	--education
	response::json->'comp'->0->'cki'->'ident'->0->'@attributes'->'spd' bki_cki_indend_0_spd,	--Наличие регистрации СПД
	response::json->'comp'->0->'cki'->'ident'->0->'@attributes'->'sstate' bki_cki_indend_0_sstate,	--social status
	response::json->'comp'->0->'cki'->'ident'->0->'@attributes'->'cchild' bki_cki_indend_0_cchild,	--count of child

--CKI addr
	response::json->'comp'->0->'cki'->'addr'->0->'@attributes'->'vdate' bki_cki_addr_0_vdate,
	response::json->'comp'->0->'cki'->'addr'->0->'@attributes'->'adstate' bki_cki_addr_0_adstate,
	response::json->'comp'->0->'cki'->'addr'->0->'@attributes'->'adcity' bki_cki_addr_0_adcity,

	--CRDEAL
	response::json->'comp'->1->'crdeal' bki_crdeal,
/*
	response::json->'comp'->1->'crdeal'->0->'@attributes'->'dlref' crdeal_0_attr_dlref, --Идентификатор сделки
	response::json->'comp'->1->'crdeal'->0->'@attributes'->'dlcelcred' crdeal_0_attr_dlcelcred,	--Тип сделки 
	response::json->'comp'->1->'crdeal'->0->'@attributes'->'dlvidobes' crdeal_0_attr_dlvidobes, --Вид обеспечения 
	response::json->'comp'->1->'crdeal'->0->'@attributes'->'dlporpog' crdeal_0_attr_dlporpog, --Порядок погашения
	response::json->'comp'->1->'crdeal'->0->'@attributes'->'dlamt' crdeal_0_attr_dlamt, --Сумма (начальная) сделки
	response::json->'comp'->1->'crdeal'->0->'@attributes'->'dldonor' crdeal_0_attr_dldonor, --Донор информации
	response::json->'comp'->1->'crdeal'->0->'@attributes'->'dlrolesub' crdeal_0_attr_dlrolesub, --Роль субъекта
	response::json->'comp'->1->'crdeal'->0->'@attributes'->'dlamtobes' crdeal_0_attr_dlamtobes, --Стоимость обеспечения в базовой валюте 
*/
--REESTRTIME
	response::json->'comp'->3->'credres' credres,
	response::json->'comp'->3->'reestrtime'->'@attributes'->'hr' bki_reestrtime_hr, --Количество запросов за час 
	response::json->'comp'->3->'reestrtime'->'@attributes'->'da' bki_reestrtime_da, --Количество запросов за день 
	response::json->'comp'->3->'reestrtime'->'@attributes'->'wk' bki_reestrtime_wk, --Количество запросов за неделю 
	response::json->'comp'->3->'reestrtime'->'@attributes'->'mn' bki_reestrtime_mn, --Количество запросов за месяц 
	response::json->'comp'->3->'reestrtime'->'@attributes'->'qw' bki_reestrtime_qw, --Количество запросов за квартал 
	response::json->'comp'->3->'reestrtime'->'@attributes'->'ye' bki_reestrtime_ye, --Количество запросов за год 
	response::json->'comp'->3->'reestrtime'->'@attributes'->'yu' bki_reestrtime_yu, --Количество запросов свыше года 

--CONTACTS
	response::json->'comp'->5->'cont' bki_contacts,
	JSON_ARRAY_LENGTH(response::json->'comp'->5->'cont') bki_contacts_len,

--URATING score
	response::json->'comp'->8->'urating'->'@attributes'->'score' bki_urating_score,
	response::json->'comp'->8->'urating'->'@attributes'->'scoredate' bki_urating_scoredate,
	response::json->'comp'->8->'urating'->'@attributes'->'score3' bki_urating_score3,
	response::json->'comp'->8->'urating'->'@attributes'->'scorelast' bki_urating_scorelast,
	response::json->'comp'->8->'urating'->'@attributes'->'scoredatelast' bki_urating_scoredatelast,
	response::json->'comp'->8->'urating'->'@attributes'->'scorelevel' bki_urating_scorelevel,

--URATING dinfo
	response::json->'comp'->8->'urating'->'dinfo'->'@attributes'->'all' bki_urating_dinfo_all,
	response::json->'comp'->8->'urating'->'dinfo'->'@attributes'->'open' bki_urating_dinfo_open,
	response::json->'comp'->8->'urating'->'dinfo'->'@attributes'->'close' bki_urating_dinfo_close,
	response::json->'comp'->8->'urating'->'dinfo'->'@attributes'->'expyear' bki_urating_dinfo_expyear,
	response::json->'comp'->8->'urating'->'dinfo'->'@attributes'->'maxnowexp' bki_urating_dinfo_maxnowexp,
	response::json->'comp'->8->'urating'->'dinfo'->'@attributes'->'datelastupdate' bki_urating_dinfo_datelastupdate,

--URATIN p and n factors
	response::json->'comp'->8->'urating'->'nfactors'->'@attributes'->'count' bki_urating_nfactors_count,
	response::json->'comp'->8->'urating'->'pfactors'->'@attributes'->'count' bki_urating_pfactors_count

from scoring_data.bki_response
where bki_id in (307952, 439913, 362007, 295442, 329621, 282403, 345846, 365448, 295060,
       435673, 292856, 350231, 371623, 309926, 361684, 293842, 295739,
       384488, 340576, 432906, 487686, 447670, 420078, 380431, 311631,
       278753, 309447, 342270, 305473, 287917, 430511, 309106, 450007,
       391836, 381932, 432936, 296330, 450117, 356756, 306705, 391909,
       386208, 369726, 307667, 324485, 430680, 445025, 307083, 358427,
       391911, 450712, 381338, 379160, 449426, 272776, 281521, 330944,
	   
       456299, 331192, 335297, 354650, 338101, 368548, 454895, 366322,
       332372, 336387, 312760, 456161, 316801, 379940, 306802, 321042,
       280886, 273522, 331305, 345056, 374379, 423572, 452645, 305150,
       433232, 376306, 442001, 363136, 287144, 433611, 329667, 348202,
       287317, 384697, 334947, 445217, 380656, 290946, 420004, 444213,
       284970, 332296, 399993, 428699, 324554, 483446, 436295, 447135,
       298723, 293395, 335078, 289547, 466280, 434088, 321709, 368469,
       385863, 323158, 296596, 284009, 426029, 423119, 322010, 446284,
       452736, 389179, 385266, 326932, 313807, 324649, 327641, 384336,
       352687, 342156, 366026, 289363, 305537, 341878, 429291, 300726,
       276461, 464905, 437910, 305049, 450247, 332845, 439766, 390625,
       391670, 370543, 369189, 382042, 450876, 364685, 434073, 460720,
       381421, 469278, 402528, 316874, 448601, 423664, 354849, 353194,
       470440, 323168, 381628, 304227, 351656, 332949, 334563, 290018,
       334401, 329283, 475089, 295060, 363674, 385355, 389025, 480602,
       336342, 428820, 356335, 469205, 436920, 315625, 346436, 380749,
       306508, 436089, 441980, 451945, 433322, 349899, 363706, 438092,
       421000, 293209, 368910, 355110, 333002, 389481, 423681, 414427,
       300982, 287455, 468366, 310260, 420897, 500808, 411620, 441021,
       407932, 373104, 326170, 438115, 381108, 391914, 375427, 333993,
       462974, 336748, 287375, 353022, 426920, 431703, 420385, 389958,
       302205, 298685, 377086, 277918, 390374, 368372, 479381, 368817,
       278203, 313584, 479330, 299301, 335101, 306307, 332023, 448732,
       468331, 400742, 332641, 278582, 467623, 332187, 379885, 456361,
       430198, 441280, 327497, 386944, 291950, 295816, 386680, 291379,
       348383, 302290, 287210, 372224, 424290, 316090, 322336, 336297,
       312317, 358410, 332449, 413617, 357519, 386896, 376970, 372297,
       463761, 392281, 335296, 383876, 486950, 381804, 293466, 313410,
       386554, 437173, 297571, 284758, 374481, 426356, 457511, 286972,
       420388, 455347, 388367, 309826, 430767, 394400, 458208, 314026,
       371505, 476473, 390618, 476539, 421905, 450586, 331406, 445564,
       351349, 430768, 373093, 391691, 289692, 358409, 420977, 424549,
       332135, 389071, 368110, 368650, 389940, 321949, 482616, 462959,
       370538, 360137, 462757, 442594, 352832, 337275, 289704, 361703,
       293100, 387077, 364822, 417758, 291313, 325072, 350218, 332862,
       315467, 378235, 304426, 453309, 461478, 303473, 310354, 331033,
       298983, 410152, 335433, 322597, 343560, 474204, 475200, 365314,
       310127, 319795, 375725, 439451, 287347, 491479, 434853, 360921,
       431183, 317743, 321216, 313182, 482108, 370142, 322607, 418665,
       471727, 480808, 439376, 486892, 340938, 376113, 411179, 295668,
       435211, 381232, 380946, 381295, 343447, 331688, 460488, 429363,
       486525, 347365, 347658, 437289, 296732, 275194, 331771, 426991,
       320011, 383186, 477950, 352978, 407094, 385575, 308835, 387868,
       390926, 446174, 321171, 420834, 429122, 460678, 461869, 355363,
       346316, 302239, 444899, 464019, 366475, 356278, 376873, 321364,
       362544, 402536, 342305, 444959, 370305, 350544, 360505, 391419,
       341731, 444410, 470828, 344142, 355454, 318061, 420948, 420036,
       327797, 480453, 316814, 357085, 338694, 439880, 459281, 324867,
       377061, 343538, 442015, 359982, 391371, 364170, 364620, 306912,
       487544, 367311, 288768, 293536, 420181, 319057, 388611, 380934,
       334899, 387846, 287611, 273038, 378026, 343004, 341703, 382462,
       430137, 297189, 320341, 382033, 298728, 378711, 410272, 313966,
       308509, 289733, 390200, 448647, 353028, 308458, 323719, 437840,
       301558, 335950, 437268, 363244, 326391, 379824, 440853, 335808,
       384237, 272584, 356924, 379802, 472921, 311791, 443994, 374859,
       420159, 296649, 425149, 284875)
	   
/*
where bki_id in (476998, 303481, 302395, 277296, 319159, 304321, 283973, 420080, 423332, 352906, 313539, 402792,
				 401553, 501493, 493503, 301432, 301444, 270422, 363991, 384085, 290365, 378096, 311833, 427215, 291052, 290194)
*/
;




