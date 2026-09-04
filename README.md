This publishes the Array Language Benchmark to https://effbiae.github.io/bench/

Includes [run]() which runs the benchmark and [plot]() which generates the site.
(these two will be combined into one file as they share `imp` and logic)

TODO:
 - change goal.k to .goal
 - marshall's simpler knuc: https://dzaima.github.io/paste/#0RVLBattAEL3vVwybgyUk21LjBKWEErVQgy@F4ntZNzIVBNVYiqGqDSkUYysOcSjBOSjYBAIyPfQSSA8lBenov5gv6Cd0dm23gl1237yZ2XlPftABHE4Bz@5ev/wUeSHw6rHXq4bRsR9wdtJW0SPDthjzFXcJnwWe/W49B61sGzhetHQcfhMD0OiWTHGell6UdEx@EooX813i1oBSZTpBq1SWkOdketKWYPU/NF4QxBqWarptIyiKk8Sq7Bm2t1fMBOD5V8DRE86zlsmBm/T4t16nC8QSxaPt7Zq8wk1uWRbPv1P1TZgCfYHz5YA11g0o8OY0yjPgXJVLD1cpNCwCcJTBn9vrJZ6P8owO2YCxWCXxpvuqzv9pQWAylW8HAzQ1wn1JlPRiVs4fuCs429kyNRxe4@iGZsTJk6Y5/bh8pGRKLnVw8D450KnWJb3A6Ts0Oa27lh9V3r0XYaQ6wA606ex1IfogAuh0vZ7/8TRkwdrB8UKqHEMDguKRytRweFXFL78kqlF9OeIkXaWxThQtKNs6KJ69vyGSg2QQ0XUaJv8hL7ViJtNZL1Q9lJm09mnZz@TmEH5Fgh3yer3pNulz5e423XqTs43CG7O2Phj5g1TqgprHpJ7U2aRf7MBcS04GUcFeyP4C#BQN
  -dzaimas faster advance: 
diags ← ∾3⥊<⥊=⌜˜↕≠system
Advance ← { 𝕊 dt:
  d ← -⌜˜˘ pxyz
  mag ← dt ÷ ×˜⊸× √ +˝ ×˜ d
  t ← d ×⎉2 masses ×⎉1 mag
  vxyz -↩ +˝⎉2 0¨⌾(diags/⥊) t
  pxyz +↩ dt×vxyz
} 
