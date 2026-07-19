# ZodiacPlus Expert

Flutter expert application for ZodiacPlus consultations.

## Consultation demo backend

The app uses the same HTTP, SSE, and Agora flow as the web expert demo:

1. It creates or restores a temporary expert session and keeps its access token
   in platform secure storage.
2. Every app launch starts the expert offline. The home toggle calls
   `PATCH /api/v1/experts/me/availability` to move online or offline.
3. The app listens to `GET /api/v1/events/stream` and reloads
   `GET /api/v1/experts/me/consultations/active` whenever the SSE connection is
   established again. It also polls the active-consultations endpoint every two
   seconds as a recovery path when an SSE event is delayed or unavailable.
4. A `consultation.requested` event shows the persistent **Join room** action.
   The expert can join (accept) or decline the consultation.
5. Joining accepts the consultation, requests short-lived Agora credentials,
   and publishes camera/microphone media with the Agora RTC SDK.
6. Call lifecycle evidence is sent for joined, left, reconnecting, and
   reconnected states. Manual hang-up calls the consultation end endpoint.
   A backend `consultation.ended` event immediately closes local media.

The API and worker must both be running. Confirm PostgreSQL and Redis readiness
through the backend's `/health/ready` endpoint before testing a call.
The worker is required for immediate SSE delivery, ring/balance timeouts, and
automatic consultation recovery; REST polling in the app only provides a
client-side fallback for discovering active rooms.

## API URL

The app connects to the deployed Render API by default:

```text
https://zp-backend-3fxe.onrender.com
```

Override it only when testing a different backend. For an Android emulator
connected to a backend on the development machine, use:

```bash
flutter run --dart-define=ZP_API_BASE_URL=http://10.0.2.2:3000
```

For a physical device, use an HTTPS deployment or the development machine's LAN
address. Do not put `DATABASE_URL`, Redis credentials, the Agora App Certificate,
or other backend secrets in this app.

## Device permissions

Camera and microphone permissions are requested only when an expert joins a
consultation. Android and iOS permission descriptions are registered in their
platform project files. Remote-device camera and microphone testing requires
HTTPS except for supported localhost development environments.
