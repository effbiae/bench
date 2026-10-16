# from @Marshall Oct 2026
FFT ← {
  s ← 2 ⥊˜ n ← 2 ⋆⁼ l ← ≠⊑𝕩
  r ← -∘⊏⊸«⊸⋈ (1↓s) ⥊ •math.Sin (↕ × π⊸÷) l÷2    # Roots of unity (get Cos from Sin)
  M ← -´∘× ⋈ +´∘×⟜⌽                              # Complex multiplication
  F ← { (r 0‿0⊸⊏⎉(n-𝕨)¨↩) ⊢ (+˝¨(𝕨⍉≍)¨r M-˝¨)𝕩 } # FFT loop
  ⥊¨ (↕n) F´˜ s⊸⥊¨ 𝕩
}

n ← •ParseFloat ⊑•args
log2 ← ⌊2⋆⁼0.5+n

cm ← 1103515245
ca ← 12345
A32 ← 32•bit._add
M32 ← 32•bit._mul
z1 ← {l‿·‿a:l∾a} {l‿m‿a: ⟨l ∾ a A32 m M32 l, M32˜m, a A32 a M32 m⟩}⍟log2 ⟨⋈0, ⋈cm, ⋈ca⟩
m1 ← ∾ {l‿m: ⟨l∾l M32 m, M32˜ m⟩}⍟log2 ⟨⋈1, ⋈cm⟩
nums ← ¯1+ (2⋆¯15)× ⌊(2⋆16)÷˜ (2⋆32) | 1↓z1 A32 n M32 m1

a ← 0.25⊸×⌾⊑ +´ {×˜ (n÷2)↑𝕩}¨ FFT nums‿0

top ← 10 {(𝕨↑·⍒⊏⟜𝕩)⊸⊏/𝕩≥(𝕨-1)⊑∨(⌈∘√𝕨⊸×)⊸•rand.Subset∘≠⊸⊏𝕩} a
{⌊0.5+ 1e9× (n÷2)÷˜ √ 𝕩⊏a}⊸({
  •Out ∾ ⟨•Repr 𝕩, ".0", @+9, •Repr ⌊𝕨÷1e9, '.', «⟜"000000000" •Repr 1e9|𝕨⟩
}¨) top
