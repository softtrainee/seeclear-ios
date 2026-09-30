# SeeClear — FPL Team Viewer

A native UIKit iOS application that allows users to browse Premier League
teams and view their players using data from the Fantasy Premier League API.

The implementation focuses on correctness, clean architecture, asynchronous
state handling, testability and native iOS APIs.

---

## Requirements

- Xcode 13.2.1
- Swift version supported by Xcode 13.2.1
- iOS 15.0+
- macOS compatible with Xcode 13.2.1

The application uses:

- Swift
- UIKit
- Foundation
- URLSession
- Codable
- Swift Concurrency
- XCTest

No third-party dependencies are required.

---

## Features

### Teams

The application displays Premier League teams returned by the FPL API.

Each team displays:

- Team name
- Short name
- Number of players

Selecting a team opens its squad.

### Squad

Players are grouped into:

- Goalkeepers
- Defenders
- Midfielders
- Forwards

Each player displays:

- Name
- Position
- Price
- Total FPL points

Players are sorted by total FPL points in descending order.

A player's name is used as a deterministic secondary sort when
two players have the same number of points.

### Search

The squad screen uses the native `UISearchController`.

Search:

- Updates as the user types
- Is case-insensitive
- Operates locally against the loaded squad
- Does not make additional network requests
- Preserves positional grouping
- Handles empty results

### Loading and Errors

The application handles:

- Initial loading
- Successful loading
- Initial request failure
- Pull-to-refresh
- Refresh failure
- Empty results
- Network errors
- HTTP errors
- Malformed API responses

If a refresh fails after data has already been displayed, the existing
data remains visible.

### Offline Support

The last successfully loaded FPL response is persisted locally as JSON.

When the application launches:

1. Cached data is loaded if available.
2. Cached data is displayed immediately.
3. A network refresh is attempted.
4. New successful data replaces the cached data and updates the cache.

If no cached data exists and the network request fails, the application
displays an error state with a Retry action.

---

## API

The application uses the Fantasy Premier League API.

Endpoint:

`https://fantasy.premierleague.com/api/bootstrap-static`

The application does not use a custom backend or proxy.

The bootstrap response contains the team and player information required
by this exercise.

---

## Architecture

The project uses a lightweight MVVM + Repository architecture.

```text
ViewController
      |
      v
  ViewModel
      |
      v
  Repository
     / \
    /   \
   v     v
 API    Cache
   |
   v
URLSession

## Screensort
<img width="487" height="910" alt="Screenshot 2026-09-30 at 6 24 28 PM" src="https://github.com/user-attachments/assets/4b2c48f3-ff1d-45ac-8b0f-1126fa7645fa" />
<img width="487" height="910" alt="Screenshot 2026-09-30 at 6 24 14 PM" src="https://github.com/user-attachments/assets/5fb574eb-6c12-44fd-8fb5-94bac372fc60" />
<img width="487" height="910" alt="Screenshot 2026-09-30 at 6 23 48 PM" src="https://github.com/user-attachments/assets/b9503a65-c803-4d08-849f-3cb0bc964e21" />


## Video Link
[Video](https://www.youtube.com/shorts/x_IjREiQavQ)

