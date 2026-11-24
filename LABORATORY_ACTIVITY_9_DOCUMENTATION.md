# Laboratory Activity 9: Cloud Firestore CRUD Operations

## Student Information
- **Student Name**: Michael Chan
- **Student ID**: 555842
- **Email**: m.chan.555842@umindanao.edu.ph
- **Course & Section**: BS Information Technology / Computer Science
- **GitHub Repository**: [https://github.com/Michael-0722/chan_navigation_app](https://github.com/Michael-0722/chan_navigation_app)
- **Firebase Project Name**: Chan Student App
- **Firebase Project ID**: `chan-student-app`
- **Target Platform**: Web (Chrome)

---

## 1. Activity Overview
This activity implements a complete Student Records Management CRUD module using Cloud Firestore and Firebase Anonymous Authentication inside the existing Flutter navigation application (`chan_navigation_app`).

### Database Hierarchy
- **Top-Level Collection**: `users`
- **User Document**: `{userId}` (Firebase Anonymous Authentication UID)
- **Subcollection**: `students`
- **Student Document**: `{studentId}` (Auto-generated Firestore Document ID)
- **Document Fields**:
  - `name` (String, 1–80 chars)
  - `course` (String, 1–80 chars)

---

## 2. Testing Table (Actual Verification Results)

| Test Case | Expected Result | Pass / Fail | Actual Result & Evidence |
| :--- | :--- | :---: | :--- |
| **Open Student Records** | Form and record list appear. | **PASS** | Tapping "Manage Student Records" opens screen showing form and "Saved Students". |
| **Submit empty fields** | Validation prevents saving. | **PASS** | Displays "This field is required." below Name and Course fields; save is blocked. |
| **Submit spaces only** | Form rejects whitespace input. | **PASS** | Entering spaces (e.g. `'   '`) is trimmed and rejected by validator. |
| **Add valid records (Create)** | Records appear in list and Firestore. | **PASS** | Added Alex Santos (BSIT), Jamie Cruz (BSCS), Morgan Reyes (BSIS); all rendered live. |
| **Edit an existing record** | Selected values fill the form. | **PASS** | Clicking Edit on Alex Santos populates fields; button changes to "Update Student". |
| **Cancel editing** | Form returns to Add Student mode. | **PASS** | Clicking "Cancel Edit" clears fields and switches back to "Add Student" button. |
| **Save an update (Update)** | Existing document changes. | **PASS** | Changed Alex Santos course to BSCS; document updated in place without duplicate. |
| **Cancel deletion** | Record remains in list and DB. | **PASS** | Clicking "Cancel" in confirmation dialog preserves Jamie Cruz. |
| **Confirm deletion (Delete)** | Record is removed. | **PASS** | Clicking "Delete" confirms deletion; Jamie Cruz removed from UI and Firestore. |
| **Leave and reopen page (Persistence)** | Saved records load again. | **PASS** | Returning to Dashboard and re-entering loads persisted documents from Firestore. |

---

## 3. Guide Questions & Detailed Answers (2–3 Sentences Each)

### Question 1: What is the difference between a collection and a document?
> In Cloud Firestore, a collection is a container or directory that groups together related documents, but cannot contain raw data fields directly. A document is an individual JSON-like record containing key-value data fields and references, and it can also contain subcollections. In our application, `students` is the collection holding individual student documents containing `name` and `course` attributes.

### Question 2: Why do Update and Delete need the document ID?
> Update and Delete operations require the exact document ID because Firestore uses unique document paths (`users/{userId}/students/{studentId}`) to locate and modify specific records in the database hierarchy. Without the unique document ID, Firestore would not know which specific document to modify or remove, especially when multiple students share identical names or courses. Using `students.doc(id).update()` and `students.doc(id).delete()` ensures targeted and safe data modifications.

### Question 3: What does `snapshots()` provide to the application?
> The `snapshots()` method returns a real-time reactive `Stream` of query snapshots that automatically emits new data whenever documents in the collection are added, updated, or deleted. In Flutter, pairing `snapshots()` with a `StreamBuilder` allows the user interface to automatically re-render and display live updates without requiring manual page refreshes or polling. It ensures instantaneous UI synchronization between Firestore cloud data and client devices.

### Question 4: How does input validation prevent incomplete records?
> Input validation intercepts user input before submission by evaluating fields against predefined rules, such as checking for empty values, trimming trailing whitespaces, and verifying length constraints. In our application, `validateText` checks that both `name` and `course` are non-empty and within 80 characters, halting execution before `students.add()` or `students.doc().update()` can run. This prevents malformed, empty, or rule-violating documents from being transmitted to Firestore and triggering database permission rejections.

### Question 5: How does this Firestore application differ from storing records in a Dart list?
> Storing records in a local Dart list keeps data exclusively in the device's volatile memory (RAM), which is completely lost whenever the application restarts or the browser tab refreshes. Cloud Firestore persists records in a scalable, distributed cloud database that survives app restarts, browser refreshes, and multi-device access. Additionally, Firestore enforces server-side security rules, handles concurrent updates, and provides real-time streaming capabilities that an in-memory Dart list cannot offer.

---

## 4. Security Rules Configuration (`firestore.rules`)
```text
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/students/{studentId} {
      allow read, delete: if request.auth != null && request.auth.uid == userId;
      allow create, update: if request.auth != null && request.auth.uid == userId
        && request.resource.data.keys().hasAll(['name', 'course'])
        && request.resource.data.keys().hasOnly(['name', 'course'])
        && request.resource.data.name is string
        && request.resource.data.course is string
        && request.resource.data.name.size() > 0
        && request.resource.data.name.size() <= 80
        && request.resource.data.course.size() > 0
        && request.resource.data.course.size() <= 80;
    }
  }
}
```

---

## 5. Screenshots Required for `CHAN_LAB9.PDF`
1. **CRUD Form**: The initial Student Records screen showing the Add Student form and input fields.
2. **Three Records Displayed**: The "Saved Students" list showing Alex Santos, Jamie Cruz, and Morgan Reyes.
3. **Before-and-After Update**:
   - Before: Alex Santos with course BSIT (in edit mode).
   - After: Alex Santos with course updated to BSCS.
4. **Delete Confirmation & Result**:
   - The confirmation alert dialog asking "Delete Jamie Cruz?".
   - The list showing Jamie Cruz successfully removed.
5. **Firestore Console**:
   - Screenshot of the Firebase Console under **Firestore Database → Data → users → {UID} → students** displaying the stored student documents.
