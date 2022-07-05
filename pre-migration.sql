-- PRE MIGRATION SCRIPT FOR V13 TO V14
ALTER TABLE public.res_company 
ADD account_journal_suspense_account_id integer,
ADD CONSTRAINT res_company_account_journal_suspense_account_id_fkey FOREIGN KEY (account_journal_suspense_account_id)
        REFERENCES public.account_account (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL;
COMMENT ON COLUMN public.res_company.account_journal_suspense_account_id IS 'Journal Suspense Account';

-- INSERT SUSPENSE ACC
INSERT INTO public.account_account(
	name, code, deprecated, user_type_id, internal_type, internal_group, reconcile, company_id, root_id, create_uid, create_date, create_asset)
	VALUES ('Bank Suspense Account', '111111', 0, 5, 'other', 'asset', 0, 1, 49049, 1, now()::timestamp, 'no');
INSERT INTO public.account_account(
	name, code, deprecated, user_type_id, internal_type, internal_group, reconcile, company_id, root_id, create_uid, create_date, create_asset)
	VALUES ('Bank Suspense Account', '111112', 0, 5, 'other', 'asset', 0, 2, 49049, 1, now()::timestamp, 'no');
INSERT INTO public.account_account(
	name, code, deprecated, user_type_id, internal_type, internal_group, reconcile, company_id, root_id, create_uid, create_date, create_asset)
	VALUES ('Bank Suspense Account', '111114', 0, 5, 'other', 'asset', 0, 4, 49049, 1, now()::timestamp, 'no');
INSERT INTO public.account_account(
	name, code, deprecated, user_type_id, internal_type, internal_group, reconcile, company_id, root_id, create_uid, create_date, create_asset)
	VALUES ('Bank Suspense Account', '111115', 0, 5, 'other', 'asset', 0, 5, 49049, 1, now()::timestamp, 'no');

-- Set Company Suspense Acc
UPDATE public.res_company t1
SET account_journal_suspense_account_id = t2.id
FROM public.account_account t2 
WHERE t1.id = t2.company_id
AND t2.name LIKE '%Suspense%' AND user_type_id=5;

DELETE FROM public.res_groups
WHERE name ='Allow to define fiscal years of more or less than a year';

DROP TABLE IF EXISTS public.project_allowed_internal_users_rel;
DROP TABLE IF EXISTS public.project_allowed_portal_users_rel;

ALTER TABLE public.project_project
DROP openupgrade_legacy_14_0_rating_status;

DELETE FROM public.ir_act_window_view
WHERE act_window_id=528 and view_mode='pivot';
