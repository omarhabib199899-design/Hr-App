# Live location — what the app needs to send

Written for: the Flutter developer on the DigitalHR app.

Al Nasr's management wants one screen showing where everyone is while they are at
work, with the office staff and the field reps as two separate groups. The screen
and the storage are already built and live on the server. The only part missing is
the app sending its position.

**This is one new call and one existing call.** There is no new screen in the app.

Every endpoint follows the conventions already used by the rest of the API:
- `Authorization: Bearer <token>` (from `/api/login`)
- `Accept: application/json`
- Responses wrapped as `{ "status": bool, "message": string, "status_code": int, "data": … }`

---

## The rule

A position is recorded **only** while the employee is:

1. checked in (an attendance with no check-out), **and**
2. inside their shift's hours.

Outside either, the server records nothing. **The app does not have to work this out** —
ask the server, and it will say.

This matters for the app in one practical way: there is no point draining the
battery sending positions that will be refused.

---

## 1. Ask whether to track — `GET /api/alnasr/location/policy`

Call this when the app starts, after every check-in and check-out, and whenever
`recheck_after_seconds` has elapsed.

```json
{
  "status": true,
  "message": "Data found",
  "status_code": 200,
  "data": {
    "tracking": true,
    "reason": null,
    "interval_seconds": 300,
    "recheck_after_seconds": 300,
    "attendance_id": 412
  }
}
```

| Field | Meaning |
|---|---|
| `tracking` | `true` → send positions. `false` → send nothing. |
| `reason` | Why not: `not_checked_in` or `outside_working_hours`. `null` when tracking. |
| `interval_seconds` | How often to send a position while `tracking` is true. Currently **300 (5 minutes)**. |
| `recheck_after_seconds` | When to call this endpoint again. 900 while not tracking, so the app is not polling hard for nothing. |
| `attendance_id` | The check-in the positions will be filed under. Informational. |

**Read the interval from here; do not hard-code it.** Management may want it
changed, and if it lives on the server that is a settings change rather than a new
app release for every handset.

---

## 2. Send the position — `POST /api/users/location`

**This endpoint already exists in the app's API.** It now accepts four more
optional fields and tells you whether the position was kept.

```
POST /api/users/location

latitude       required   number
longitude      required   number
accuracy       optional   number   metres, from the OS
battery_level  optional   integer  0-100
is_mock        optional   boolean  true if the OS reports a mock-location provider
recorded_at    optional   string   when the FIX was taken (Y-m-d H:i:s)
```

```json
{
  "status": true,
  "message": "Location successfully sent",
  "status_code": 200,
  "data": {
    "stored": true,
    "reason": null,
    "next_ping_after_seconds": 300,
    "tracking": true
  }
}
```

**`stored: false` is not an error.** It means the employee is off shift and the
server kept nothing. The call still returns 200. When you see it, stop sending and
go back to the policy endpoint.

### Please do send `recorded_at`

If the phone has no signal, queue the positions and send them when it reconnects,
each with the `recorded_at` of when it was actually taken. The server orders the
map and the route by that time, not by arrival. Without it, a queue arriving at
once draws the day's route in the wrong order and shows an old point as where the
person is now.

Send it as the device's local time in `Y-m-d H:i:s`. A timestamp in the future, or
more than 24 hours old, is ignored and replaced with the arrival time — so a
handset with a wrong clock cannot bury the day's route in 1970.

### Please do send `accuracy` and `is_mock`

A phone's position is a claim, not a fact. Without `accuracy` a 2 km city-block
guess is drawn on the manager's map with the same confidence as a real GPS fix.
`is_mock` is what the OS already tells you about faked-location apps; the server
flags it rather than refusing it, so the manager can see it for what it is.

---

## What to build

```
on app start, on check-in, on check-out:
    GET /api/alnasr/location/policy

while policy.tracking:
    every policy.interval_seconds:
        read position
        POST /api/users/location  (+ accuracy, battery_level, is_mock, recorded_at)
        if response.data.stored == false:
            stop; GET the policy again

while not policy.tracking:
    wait policy.recheck_after_seconds, then GET the policy again
```

Background location needs the usual permissions and the usual store declarations
(`ACCESS_BACKGROUND_LOCATION` on Android, `UIBackgroundModes: location` on iOS).
Both stores require that the user is told what the tracking is for; the app should
say plainly that location is recorded during working hours while checked in, and
stops at check-out. That is also what the server actually does, so the wording is
not a promise the backend fails to keep.

---

## Questions worth settling before you build

1. **A missed interval.** If the app is killed, does it restart tracking on its
   own, or only when the employee next opens it? The server will accept either; the
   manager's screen will show a gap for the time it was off.
2. **Battery floor.** Should the app stop sending below some battery level — 10%,
   say — so the employee is not left with a dead phone? The server does not impose
   one.
3. **Movement threshold.** Sending only when the position has moved more than,
   say, 50 metres saves battery and keeps the route readable, but it also means a
   stationary person looks like a stale one. Ask management which they would rather
   have; the server handles both.

Send questions to Omar.

---

## What is already done on the server

Nothing below needs work from the app side; it is listed so you know what to
expect to see once the app starts sending.

- `employee_locations` carries `attendance_id`, `accuracy_m`, `battery_level`,
  `is_mock`, `recorded_at` and `source`.
- Positions are refused unless the employee is checked in and on shift.
- `0,0` is refused — it is the middle of the Atlantic, not a location.
- Admin → Field tracking → **Live map**: everyone checked in, split into
  In office / Out of office, refreshing on a timer, with each person's route for
  the day drawn when their name is clicked. Someone who is checked in but has sent
  no position is shown at their check-in point, labelled as such, so the map never
  passes a clock-in location off as a live one.
