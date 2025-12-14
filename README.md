 

# MediaCoverageImageGrid

An iOS SwiftUI application that efficiently loads and displays media coverage images
in a responsive, scrollable grid. The project demonstrates manual image downloading,
caching (memory + disk), request cancellation, and smooth performance using native
Swift technologies only.

---

## Features

- Dynamic, responsive image grid using SwiftUI `LazyVGrid`
- Asynchronous image loading using `URLSession`
- Lazy image loading (images load only when visible)
- Manual request cancellation for fast scrolling
- Memory cache using `NSCache`
- Disk cache using file system
- Disk-to-memory cache promotion
- Smooth, lag-free scrolling
- Clean MVVM architecture
- No third-party libraries used

---

## API Used

