---
subject: Computing
section: Computing
topic: Combinations
table: Recursion
order: 10
---

# Recursion

| Label | Formula / Concept | Description |
|-------|-------------------|-------------|
| recursion | iteratively use same function | to solve a problem |
| recursion | base case and recursive case | call stack with iterative work |
| recursion | can be used to make | subsets and permutations |
| recursion | vector\<int\> subset; int n = 3; void search (int k) { if (k == n+ 1) { // process subset } else { // recurse with k in subset subset.push_back(k); search(k+1); // recurse without k in subset subset.pop_back(k); search(k+1); } } search(1); |  |
| quicksort | divide and conquer | for a more efficient sort |
| quicksort | recursion can be used | for average $O(n\log n)$ |
