-- =====================================================================
-- نماذج المساءلة — بيانات منشئ الحساب في شاشة مدير النظام
-- يُشغَّل مرة واحدة بعد access.sql (آمن لإعادة التشغيل)
-- يضيف: اسم المنشئ، السجل المدني، الجوال (محفوظة مع الحساب عند التسجيل)
-- =====================================================================
drop function if exists public.admin_list();
create function public.admin_list()
returns table (user_id uuid, username text, email text, school text, created_at timestamptz, last_sign_in_at timestamptz,
               status text, plan text, expires_at date, employees bigint, logs bigint,
               creator text, civil text, mobile text)
language plpgsql stable security definer set search_path = '' as $$
begin
  if not public.is_admin() then raise exception 'غير مصرّح'; end if;
  return query
    select u.id, coalesce(u.raw_user_meta_data->>'username', split_part(u.email, '@', 1)), u.email::text,
           coalesce(s.name, u.raw_user_meta_data->>'school'), u.created_at, u.last_sign_in_at,
           a.status, a.plan, a.expires_at,
           (select count(*) from public.employees e where e.school_id = u.id),
           (select count(*) from public.log_entries l where l.school_id = u.id),
           u.raw_user_meta_data->>'creator', u.raw_user_meta_data->>'civil', u.raw_user_meta_data->>'mobile'
    from auth.users u
    join public.school_access a on a.user_id = u.id
    left join public.schools s on s.id = u.id
    order by u.created_at desc;
end $$;
revoke execute on function public.admin_list() from public, anon;
grant execute on function public.admin_list() to authenticated;
