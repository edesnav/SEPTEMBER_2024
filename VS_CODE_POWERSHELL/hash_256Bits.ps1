# Paso 1: Generar una Clave de Encriptación de 256 bits
# Generar una clave de encriptación de 256 bits (32 bytes)
$key = New-Object Byte[] 32
# Llenar la clave con valores aleatorios
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($key)


# Paso 2: Cifrar la Contraseña Usando la Clave
$securePassword = ConvertTo-SecureString "Passw0rd" -AsPlainText -Force
# Cifrar la contraseña usando la clave y guardar en un archivo
$securePassword | ConvertFrom-SecureString -Key $key | Out-File "C:\export\user01pwd.txt"

#Paso 3: Guardar la Clave de Encriptación de Forma Segura
# Convertir la clave a Base64 para guardarla en un archivo de texto
$keyBase64 = [Convert]::ToBase64String($key)
$keyBase64 | Out-File "C:\export\encryptionkey.txt"

#Paso 4: Leer la Contraseña Cifrada y Descifrarla
# Leer y convertir la clave de encriptación desde Base64
$keyBase64 = Get-Content "C:\export\encryptionkey.txt" -Raw
$key = [Convert]::FromBase64String($keyBase64)

# Leer la contraseña cifrada desde el archivo y descifrarla
$encryptedPasswordPath = "C:\export\user01pwd.txt"
$encryptedPassword = Get-Content $encryptedPasswordPath | ConvertTo-SecureString -Key $key

# Crear el objeto de credencial
$userName = "nombredominio\administrator"
$credential = New-Object System.Management.Automation.PSCredential ($userName, $encryptedPassword)


# Paso 5: Ejecutar un Script con las Credenciales
# Iniciar el script como el usuario especificado
Start-Process -FilePath "powershell.exe" -ArgumentList "-File C:\export\test.ps1" -Credential $credential

