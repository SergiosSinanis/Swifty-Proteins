# Swifty Proteins

A mobile application built with Flutter and Dart that allows users to search for proteins and visualize their molecular structure in 3D. This project demonstrates mobile application development, REST API integration, protein data parsing, 3D molecular visualization, asynchronous programming, and responsive user interface design.

## Authors

Swifty Proteins is developed as a collaborative team project at 42 Paris École. The project showcases practical understanding of mobile application development with Flutter and Dart, API integration, structured data processing, 3D visualization, user interaction, and responsive interface design.

## Key Features

### Protein Search

- Protein Search: Search for proteins using their identifiers
- API Integration: Retrieve protein structure data from a remote API
- HTTP Communication: Perform asynchronous network requests
- JSON Data Processing: Parse structured API responses
- Search Validation: Handle invalid or empty protein identifiers
- Network Error Handling: Handle connection failures and unavailable services
- User Feedback: Display appropriate messages when a protein cannot be found

### Protein Data Processing

- Protein Structure Retrieval: Retrieve molecular structure information from the remote data source
- Molecular Data Parsing: Process protein structure data
- Atom Information: Extract individual atoms and their properties
- Atomic Coordinates: Process three-dimensional X, Y, and Z coordinates
- Chemical Elements: Identify the different elements composing the protein
- Bond Information: Process relationships between atoms
- Structured Data Models: Convert raw API data into application data structures

### 3D Molecular Visualization

- 3D Rendering: Display protein structures in an interactive three-dimensional environment
- Atom Visualization: Represent atoms as visual elements
- Bond Visualization: Display connections between atoms
- Molecular Structure: Reconstruct the spatial structure of proteins
- Camera Control: Navigate around the molecular structure
- Rotation: Rotate the molecular model
- Zoom: Adjust the visualization scale
- Interactive Visualization: Explore protein structures through user interaction

### Flutter Application

- Dart Programming Language: Application logic implemented in Dart
- Flutter SDK: Cross-platform mobile application framework
- Widget-Based UI: Build the interface using Flutter widgets
- Stateful Components: Manage dynamic application state
- Asynchronous Programming: Handle network operations without blocking the interface
- Navigation: Move between search and visualization screens
- Responsive Layout: Adapt the interface to different screen sizes and orientations

### Error Handling

- Empty Input Handling: Prevent searches with empty identifiers
- Invalid Input: Handle invalid protein identifiers
- Protein Not Found: Handle unavailable protein structures
- Network Errors: Handle connection failures
- Request Timeouts: Handle requests that exceed the allowed response time
- API Errors: Handle unsuccessful server responses
- Invalid Data: Handle malformed or unexpected responses
- Parsing Errors: Handle invalid molecular structure data
- User Feedback: Display appropriate error messages without crashing the application

## Application Architecture

### Flutter Application

- Dart Programming Language: Application logic implemented in Dart
- Flutter SDK: Cross-platform mobile application framework
- Widget-Based Architecture: Interface built using reusable Flutter widgets
- State Management: Manage search results and molecular visualization state
- Navigation: Switch between application screens
- Gesture Handling: Handle user interaction with the molecular model
- Responsive Layouts: Adapt the interface to different screen sizes

### API Client

- HTTP Client: Communicate with the remote protein data source
- REST API: Retrieve protein structure information through HTTP requests
- Asynchronous Requests: Perform network operations without blocking the UI
- HTTP Response Handling: Validate server responses
- JSON Parsing: Process structured API responses
- Error Handling: Process HTTP and network errors

### Molecular Data Processing

The application follows the following data flow:

```text
Protein Identifier
        ↓
API Request
        ↓
Protein Structure Data
        ↓
Data Parsing
        ↓
Atom & Bond Extraction
        ↓
3D Molecular Model
        ↓
Interactive Visualization
```
