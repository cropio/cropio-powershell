# Windows PowerShell example and scripts to work with Cropio HTTP API

## Introduction

Cropio API is HTTP JSON API and could be used with any programming language or OS. You only have to be able send HTTP requests (and HTTPS support).

All workflows and full documentation available at http://docs.cropioapiv3.apiary.io/.

On http://docs.cropioapiv3.apiary.io you can generate code examples for all popular languages (Java, JS, Python, Ruby, C#, even for VisualBasic, etc.) But there missing PowerShell, so we created this docs to help our users who want to use Cropio API via PowerShell (OS Windows).

This docs contains only basic examples to help you start working with Cropio API via PowerShell (but our API is quite simple, so I believe this examples should be enough).

## Very basics of PowerShell

**PowerShell** (starting Windows PowerShell 3.0) support extremely useful `Invoke-RestMethod` command. This command is similar to well-known `curl` and `wget` commands from Linux/Unix world.

Full description of `Invoke-RestMethod` command available at official Microsoft MSDN site: https://msdn.microsoft.com/en-us/powershell/reference/5.1/microsoft.powershell.utility/invoke-restmethod (and I highly recommend to check this docs).

Short abstract from official Microsoft MSDN site:

```PowerShell
Invoke-RestMethod [-Method <WebRequestMethod>] [-UseBasicParsing] [-Uri] <Uri>
 [-WebSession <WebRequestSession>] [-SessionVariable <String>] [-Credential <PSCredential>]
 [-UseDefaultCredentials] [-CertificateThumbprint <String>] [-Certificate <X509Certificate>]
 [-UserAgent <String>] [-DisableKeepAlive] [-TimeoutSec <Int32>] [-Headers <IDictionary>]
 [-MaximumRedirection <Int32>] [-Proxy <Uri>] [-ProxyCredential <PSCredential>] [-ProxyUseDefaultCredentials]
 [-Body <Object>] [-ContentType <String>] [-TransferEncoding <String>] [-InFile <String>] [-OutFile <String>]
 [-PassThru] [<CommonParameters>]
```

> The Invoke-RestMethod cmdlet sends HTTP and HTTPS requests to Representational State Transfer (REST) web services that returns richly structured data.
>
> Windows PowerShell formats the response based to the data type. For an RSS or ATOM feed, Windows PowerShell returns the Item or Entry XML nodes. For JavaScript Object Notation (JSON) or XML, Windows PowerShell converts (or deserializes) the content into objects.

### Useful links about `Invoke-RestMethod` with how-to and examples

* https://www.jokecamp.com/blog/invoke-restmethod-powershell-examples/
* https://community.qualys.com/docs/DOC-5594
* https://www.lavinski.me/calling-a-rest-json-api-with-powershell/
* https://devops.profitbricks.com/tutorials/use-powershell-to-consume-a-profitbricks-rest-api/

## Examples of using PowerShell with Cropio API

### :warning: Important notice :warning:

1. You **must** add `Content-Type: application/json` HTTP header to **all** API requests.
2. You **must** use only `https://` requests.

### Obtaining API token with login and password

User must make Login action and obtain USER_API_TOKEN token that required for all next requests. USER_API_TOKEN is a string, that should be added for all request to Cropio API (http://docs.cropioapiv3.apiary.io/#reference/authentication/login-request).

PowerShell example:
```PowerShell
# !!! Replace USER_EMAIL and USER_PASSWORD with real credentials.

$uri="https://cropio.com/api/v3/sign_in"
$body='{"user_login": {"email": "USER_EMAIL", "password": "USER_PASSWORD"}}'

Invoke-RestMethod -Method Post -ContentType 'application/json' -Uri $uri -Body $body
```

Response should be something like this (if success):
```
success        : True
user_api_token : USER_API_TOKEN
user_id        : 111222333
email          : USER_EMAIL
username       : Name of user
company        : Name of company
time_zone      : London
language       : en
```

In case of error you will get Error with description.
```
Invoke-RestMethod : The remote server returned an error: (401) Unauthorized.
...
```

Now, we can use obtained USER_API_TOKEN to start work with Cropio API.

### Find User info by email

We can easily find User info by email:

```PowerShell
# !!! Replace USER_API_TOKEN and USER_EMAIL with real one.

$CropioHeader=@{"X-User-Api-Token"="USER_API_TOKEN"}
$userEmail="USER_EMAIL"
$uri="https://cropio.com/api/v3/users?email_eq=$userEmail"

(Invoke-RestMethod -Method Get -ContentType 'application/json' -Headers $CropioHeader -Uri $uri).data | Select-Object -First 1
```

Response should be something like this (if success):
```
id                 : 111222333
username           : Test user
email              : some_user_email@example.com
mobile_phone       : +111222333
status             : user
# ... and much more
```

### Find User ID by email

Same as find User info, but filter only ID field:

```PowerShell
# !!! Replace USER_API_TOKEN and USER_EMAIL with real one.

$CropioHeader=@{"X-User-Api-Token"="USER_API_TOKEN"}
$userEmail="USER_EMAIL"
$uri="https://cropio.com/api/v3/users?email_eq=$userEmail"

((Invoke-RestMethod -Method Get -ContentType 'application/json' -Headers $CropioHeader -Uri $uri).data | Select-Object -First 1).id
```

Response should be something like this (if success):
```
111222333
```

### Block User account by User ID

```PowerShell
# !!! Replace USER_API_TOKEN and USER_ID with real one.

$CropioHeader=@{"X-User-Api-Token"="USER_API_TOKEN"}
$userId="USER_ID"
$uri="https://cropio.com/api/v3/users/$userId"
$body='{"data": {"status": "no_access"}}'

Invoke-RestMethod -Method Put -ContentType 'application/json' -Headers $CropioHeader -Uri $uri -Body $body
```

Response should be something like this (if success):
```
data
----
@{id=11122233; username="Test user"; email=...
```

Check User info to be sure that `status` was changed:

```PowerShell
(Invoke-RestMethod -Method Get -ContentType 'application/json' -Headers $CropioHeader -Uri $uri).data
```

Response should be something like this:
```
id                 : 111222333
username           : Test user
email              : some_user_email@example.com
mobile_phone       : +111222333
status             : no_access
# ... and much more
```

### Block & unblock User account by email

Using described above commands to find User by email (to obtain User ID) and disable User account by ID.

```PowerShell
# !!! Replace USER_API_TOKEN and USER_EMAIL with real one.

$CropioHeader=@{"X-User-Api-Token"="USER_API_TOKEN"}
$userEmail="USER_EMAIL"
$uriUserSearch="https://cropio.com/api/v3/users?email_eq=$userEmail"

$userId=((Invoke-RestMethod -Method Get -ContentType 'application/json' -Headers $CropioHeader -Uri $uriUserSearch).data | Select-Object -First 1).id

$uriUser="https://cropio.com/api/v3/users/$userId"
$body='{"data": {"status": "no_access"}}'

(Invoke-RestMethod -Method Put -ContentType 'application/json' -Headers $CropioHeader -Uri $uriUser -Body $body).data.status
```

Response should be (if success):
```
no_access
```

To unblock User you can set `status` back to `user` value.

```PowerShell
$body='{"data": {"status": "user"}}'

(Invoke-RestMethod -Method Put -ContentType 'application/json' -Headers $CropioHeader -Uri $uriUser -Body $body).data.status
```

Response should be (if success):
```
user
```
