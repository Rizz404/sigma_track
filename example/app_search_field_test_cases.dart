// Example Test Cases for AppSearchField

// Test Case 1: Display vs Value
// GIVEN: User opens edit asset form with existing category
// WHEN: Form loads
// THEN:
//   - TextField shows: "Electronics" (categoryName)
//   - Form value: "cat-123" (categoryId)

// Test Case 2: User mengetik manual
// GIVEN: Empty AppSearchField
// WHEN: User types "Elect"
// THEN:
//   - TextField shows: "Elect"
//   - Form value: "" (empty)
//   - Suggestions appear

// Test Case 3: User select dari list
// GIVEN: User has typed "Elect" and sees suggestions
// WHEN: User clicks "Electronics" item
// THEN:
//   - TextField shows: "Electronics"
//   - Form value: "cat-123"
//   - Suggestions hide
//   - Keyboard dismiss

// Test Case 4: User clear field
// GIVEN: Field has selected "Electronics"
// WHEN: User clicks clear button
// THEN:
//   - TextField shows: "" (empty)
//   - Form value: "" (empty)
//   - Suggestions hide

// Test Case 5: Submit validation
// GIVEN: User typed "Elect" but didn't select any item
// WHEN: User tries to submit form
// THEN:
//   - Form value is empty
//   - Validation error: "Category is required"
//   - Submit blocked

// Test Case 6: Edit mode initialization
// GIVEN: Editing asset with category "Electronics" (id: "cat-123")
// WHEN: Form loads with:
//   - initialValue: "cat-123"
//   - initialDisplayText: "Electronics"
// THEN:
//   - TextField shows: "Electronics"
//   - Form value: "cat-123"
//   - Can submit without re-selecting

// Test Case 7: Search debouncing
// GIVEN: User is typing
// WHEN: User types "E" then "l" then "e" quickly
// THEN:
//   - Search only triggered once after 300ms
//   - Not 3 separate searches

// Test Case 8: Custom itemBuilder
// GIVEN: AppSearchField with custom itemBuilder
// WHEN: Suggestions appear
// THEN:
//   - Use custom widget (not default design)
//   - Still maintain display vs value behavior

// Expected Backend Payload
// ✅ CORRECT:
// {
//   "categoryId": "cat-123",  // ID
//   "assetName": "Laptop"
// }

// ❌ WRONG (old behavior):
// {
//   "categoryId": "Electronics",  // Display text (WRONG!)
//   "assetName": "Laptop"
// }
