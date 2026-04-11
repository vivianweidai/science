---
subject: Computing
section: Computing
topic: Data
table: Syntax
order: 5
---

# Syntax

| Label | Formula / Concept | Description |
|-------|-------------------|-------------|
| integer | int a = -3; 32 bit | $2^{31} \approx 10^{9}$ silent overflow |
| integer | unsigned int = 3; 32 bit | $2^{32}$ positive only larger than int |
| integer | long long a = 3; 64 bit | $2^{63} \approx 10^{18}$ no silent overflow |
| pairs | pair\<int, string\> p; | p = make_pair(10, \"ten\"); |
| pairs | auto \[a, b\] = p; retrieve | p.first p.second set and get |
| arrays | legacy from C | vectors have better protections |
| arrays | int a \[10\]; \[\] | int a\[3\] = {}; \[0, 0, 0\] |
| arrays | int grid\[10\]\[10\]; | two dimensional |
| vectors | dynamic array | with changeable size |
| vectors | vector\<int\> v; | vector\<int\> a(3); \[0, 0, 0\] |
| vectors | v.push_back(10); add to end | int i = pop_back(); get from end |
| vectors | vector\<vector\<int\>\> v; | two dimensional |
| vectors | sort(v.begin(), v.end()); | unique(v.begin(), v.end()); |
| graphs | edges of each node | array of dynamic arrays |
| graphs | matrix of all edges | a double array |
| graphs | all edges | dynamic array of pairs |
