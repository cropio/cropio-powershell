### Intro
**get_api_token.ps1** is simple PowerShell script that get UserApiToken for User.

Script take 2 arguments:
* `-userEmail` — Email of User (mail@example.org).
* `-userPassword` — Password of User.

### How-to run script
```PowerShell
powershell.exe -file get_api_token.ps1 -userEmail 'EMAIL' -userPassword 'PASSWORD'
```

### Example with full output

```PowerShell
PS C:\Users\alex\Desktop> powershell.exe -file cget_api_token.ps1 -userEmail 'EMAIL' -userPassword 'PASSWORD'
success        : True
user_api_token : USER_API_TOKEN
user_id        : 111222333
email          : USER_EMAIL
username       : Name of user
company        : Name of company
time_zone      : London
language       : en
PS C:\Users\alex\Desktop>
```
