# Control de Terapia Respiratoria y Física

Registro de atenciones de terapia respiratoria y terapia física por servicio (UCI Cardiovascular, UCI Intermedios Cardiovascular, UCI Neurológica, UCI Intermedio Neurológica, UCI Pediátrica y Mezzanine, Hospitalización y Prioritaria), con tablero de indicadores.

## Contenido
- `terapia.html`: página completa (formulario de registro, indicadores, registros y descarga a CSV).

## Cómo funciona
- **Terapeutas** (nivel Colaborador): solo ven «Registrar atención».
- **Jefe** (nivel Editor o Propietario): ve indicadores, registros de todas las terapeutas, borrado y CSV.

## Importante
La página usa funciones de la plataforma Artifacts de claude.ai (base de datos compartida, roles de usuario y descargas). La versión en uso está publicada en claude.ai. Este repositorio es el respaldo del código y su control de versiones.
Si se abre `terapia.html` fuera de claude.ai, el formulario y el tablero se ven, pero no guardan ni sincronizan datos.

No incluye datos de pacientes.
