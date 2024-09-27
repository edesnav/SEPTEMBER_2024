#Poner el password en un archivo de texto
$securePassword = ConvertTo-SecureString "ponerpaswword" -AsPlainText -Force
$securePassword | ConvertFrom-SecureString | Out-File "C:\export\user01pwd.txt"


# Ruta para el archivo de texto que contiene la contraseña encriptada
$encryptedPasswordPath = "C:\export\user01pwd.txt"
# Username
$userName = "ineco\eduardo.espartosa"

# LEER LA CONTRASEÑA EN UN ARCHIVO DE TEXTO ENCRIPTADO
$encryptedPassword = Get-Content $encryptedPasswordPath | ConvertTo-SecureString

# CREAR EL OBJETO PSCREDENTIAL
$credential = New-Object System.Management.Automation.PSCredential ($userName, $encryptedPassword)

# ARRANCAR EL SCRIPT CON CREDENCIALES
Start-Process -FilePath "powershell.exe" -ArgumentList "-File C:\test\test.ps1" -Credential $credential


#$securePassword = ConvertTo-SecureString "" -AsPlainText -Force
#$securePassword | ConvertFrom-SecureString | Out-File "C:\export\user01pwd.txt"
