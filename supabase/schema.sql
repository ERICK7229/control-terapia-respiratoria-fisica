-- Control de Terapia Respiratoria y Fisica: tablas y reglas de acceso (Supabase)
-- Pegar completo en Supabase -> SQL Editor -> Run.

-- 1) Perfiles: rol de cada persona ('terapeuta' por defecto, 'jefe' para la jefe)
create table if not exists public.profiles (
  id     uuid primary key references auth.users(id) on delete cascade,
  nombre text,
  rol    text not null default 'terapeuta' check (rol in ('terapeuta','jefe'))
);

-- Crea el perfil automaticamente cuando se crea un usuario
create or replace function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, nombre)
  values (new.id, coalesce(new.raw_user_meta_data->>'nombre', split_part(new.email,'@',1)))
  on conflict (id) do nothing;
  return new;
end $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
  for each row execute function public.handle_new_user();

-- Perfiles de usuarios que ya existan antes de correr este script
insert into public.profiles (id, nombre)
select id, split_part(email,'@',1) from auth.users
on conflict (id) do nothing;

-- Funcion auxiliar: es jefe?
create or replace function public.is_jefe() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.profiles where id = auth.uid() and rol = 'jefe');
$$;

-- 2) Atenciones
create table if not exists public.atenciones (
  id        uuid primary key default gen_random_uuid(),
  creado    timestamptz not null default now(),
  user_id   uuid not null default auth.uid() references auth.users(id),
  fecha     date not null,
  servicio  text not null,
  paciente  text not null,
  hc        text not null,
  edad      integer,
  unidad    text,
  genero    text,
  terapeuta text,
  items     text[] not null default '{}',
  o2        text,
  obs       text
);
create index if not exists atenciones_fecha_idx on public.atenciones (fecha);
create index if not exists atenciones_servicio_idx on public.atenciones (servicio);

-- 3) Seguridad por filas (RLS)
alter table public.profiles   enable row level security;
alter table public.atenciones enable row level security;

drop policy if exists "perfil propio o jefe" on public.profiles;
create policy "perfil propio o jefe" on public.profiles
  for select to authenticated using (id = auth.uid() or public.is_jefe());

drop policy if exists "terapeutas guardan" on public.atenciones;
create policy "terapeutas guardan" on public.atenciones
  for insert to authenticated with check (user_id = auth.uid());

drop policy if exists "jefe lee" on public.atenciones;
create policy "jefe lee" on public.atenciones
  for select to authenticated using (public.is_jefe());

drop policy if exists "jefe borra" on public.atenciones;
create policy "jefe borra" on public.atenciones
  for delete to authenticated using (public.is_jefe());

-- 4) Tiempo real para el tablero
do $$ begin
  alter publication supabase_realtime add table public.atenciones;
exception when duplicate_object then null; end $$;

-- 5) Nombrar a la jefe (cambia el correo y ejecuta SOLO esta linea cuando ya exista su usuario)
-- update public.profiles set rol = 'jefe' where id = (select id from auth.users where email = 'CORREO_DE_LA_JEFE');
