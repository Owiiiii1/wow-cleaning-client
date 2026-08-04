# WOW Cleaning

Flutter **client / customer** mobile app for WOW NOW CLEANING.

## Role

- Client login / registration against Laravel Mobile API
- View linked Bitrix client cache profile when available
- Demo bottom navigation / home bootstrap

## API

- Base URL: `https://app.wownowcleaning.com/api/mobile/v1`
- Register: `POST /client/auth/register`
- Login: `POST /client/auth/login`
- Logout: `POST /client/auth/logout` (Bearer token)
- Bootstrap: `GET /client/bootstrap` (Bearer token)
- Demo login (dev only): `POST /client/auth/demo-login`

Calls **Laravel only** — never Bitrix directly.  
No Bitrix webhook URLs or secrets in this app.

## Auth notes

- Email/password accounts live in Laravel `client_app_users`
- Password is never stored in Bitrix
- Token is kept **in memory only** for this phase (no secure storage yet)
- If Bitrix Contact is not linked: `account_status=pending_bitrix_link`

## Test data

Known Bitrix-linked contact (after registering locally):

- Email: `krasilnyk.kras@gmail.com`
- Phone: `+18135105613`
- Bitrix Contact ID: `9871`

Register once with a password (min 8 chars), then use Login.

## Run

```bash
flutter pub get
flutter run
```

## Current phase

Real client register/login foundation + home bootstrap display.
Staff auth and password reset are out of scope.
