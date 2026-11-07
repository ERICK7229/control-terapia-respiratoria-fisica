# Control de Terapia Respiratoria y Física

Registro de atenciones de terapia respiratoria y física por servicio (UCI Cardiovascular, UCI Intermedios Cardiovascular, UCI Neurológica, UCI Intermedio Neurológica, UCI Pediátrica y Mezzanine, Hospitalización y Prioritaria), con tablero de indicadores.

## Archivos
- `index.html`: la aplicación (versión para GitHub Pages con base de datos Supabase).
- `config.js`: URL y clave pública (anon) del proyecto de Supabase.
- `supabase/schema.sql`: tablas y reglas de acceso.
- `terapia.html`: versión anterior, hecha para claude.ai (respaldo).

## Roles
- **Terapeuta**: inicia sesión y solo ve «Registrar atención». No puede leer ningún registro.
- **Jefe**: ve indicadores, todos los registros, borra y descarga CSV.
  Las reglas están en la base de datos (RLS), no solo en la pantalla.

## Puesta en marcha
1. Crear un proyecto en [supabase.com](https://supabase.com).
2. En **SQL Editor**, pegar y ejecutar `supabase/schema.sql`.
3. En **Authentication → Users**, crear los usuarios (jefe y terapeutas) con correo y contraseña.
4. Ejecutar en SQL Editor (con el correo de la jefe):
   `update public.profiles set rol = 'jefe' where id = (select id from auth.users where email = 'CORREO_DE_LA_JEFE');`
5. En **Project Settings → API** copiar la *Project URL* y la clave *anon public* en `config.js`.
   Nunca poner la clave `service_role`.
6. En GitHub: **Settings → Pages → Deploy from a branch → main / (root)**.

No incluye datos de pacientes. Los datos viven solo en Supabase.
