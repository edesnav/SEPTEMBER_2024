Get-ADGroupMember -Identity "GS_SEGURIDAD1" -Recursive | Where-Object { $_.objectClass -eq "user" } | select-object  DisplayName, EmailAddress
