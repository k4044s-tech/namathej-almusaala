-- =====================================================================
-- أوامر إدارية — تُشغَّل من Supabase > SQL Editor (مشروع namathej)
-- اسم المستخدم في التطبيق يُحفظ داخلياً بصيغة:  اسم_المستخدم@users.namathej.app
-- =====================================================================

-- ١) قائمة المدارس المسجّلة
select u.raw_user_meta_data->>'username' as username,
       s.name as school, u.created_at, u.last_sign_in_at
from auth.users u left join public.schools s on s.id = u.id
order by u.created_at desc;

-- ٢) إعادة تعيين كلمة مرور مدرسة (غيّر اسم المستخدم وكلمة المرور الجديدة)
-- update auth.users
--    set encrypted_password = extensions.crypt('NewPassword123', extensions.gen_salt('bf'))
--  where email = 'username@users.namathej.app';

-- ٣) حذف مدرسة وكل بياناتها نهائياً (لا يمكن التراجع)
-- delete from auth.users where email = 'username@users.namathej.app';

-- ٤) إيقاف تسجيل مدارس جديدة مؤقتاً:
--    Authentication > Sign In / Providers > Allow new users to sign up
