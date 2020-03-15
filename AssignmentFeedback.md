## Assignment Feedback

### Pros:

- UI is perfect — add currency screen, selected cell state, swipe gesture actions, all is good;
- Proper MVVM — clean and well-structured code, bindings via delegates + coordinator, service locator, mocks;
- Each service has its own error enumeration;
- Cell registration via `CellType` protocol;
- Use of `UIStackView`.

### Cons:

- Application is crashing without network connection while executing Unit tests;
- Default switch case is table view data source;
- Using optional casting instead of `Codable` protocol for API parsing;
- No `NumberFormatter`.
