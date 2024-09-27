$csvPath = "c:\export\desconocido.csv"

# Importa los datos del archivo CSV a la variable y asegúrate de que es tratada como un array
$datosExtraidos = @(Import-Csv -Path $csvPath)

# Ahora, $datosExtraidos contiene todos los datos del archivo CSV como un array de objetos.
# Cada objeto representa una fila del archivo CSV, con propiedades que corresponden a los encabezados de las columnas.

# Para verificar y ver los datos importados, puedes utilizar:
$datosExtraidos | Format-Table -AutoSize


