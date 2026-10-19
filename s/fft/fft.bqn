inp ← •ParseFloat ⊑•args
L2 ← ⌊ ·•math.Log2 0.5+⊢

cm ← 1103515245
ca ← 12345
A32 ← 32•bit._add
M32 ← 32•bit._mul
S1 ← {m‿a 𝕊 𝕩: a A32 m M32 𝕩}
Sq ← {m‿a: ⟨⊑M32˜ m, ⊑m‿a S1 a⟩} ⋈¨

Sl ← { m‿a 𝕊 l2: ⟨
  ⊑ {l‿m:  ⟨l ∾ l M32 m, M32˜m⟩}⍟l2 ⟨⋈1, ⋈m⟩
  ⊑ {l‿ma: ⟨l ∾ ma S1 l, Sq ma⟩}⍟l2 ⟨⋈0, m‿a⟩
⟩}

CMul ← -´∘× ⋈ +´∘×⟜⌽

il←L2 in←inp
al←L2 an ← 1024⌊in÷2
bl←L2 in÷an

rs ← (⊢∾1»⌽) •math.Sin (π ÷ in÷2) × ↕in÷4
rsx ← {⊏˘∘‿2⥊𝕩}⍟(↕1+bl) rs

ash ← al⥊2
aSteps ← ⌽{i‿v: ⟨i-1, 0‿0⊸⊏⎉(al-i)¨v⟩}⍟(↕al) ⟨al-1, -∘⊏⊸«⊸⋈ (2⥊˜al-1) ⥊ ¯1⊑rsx⟩
FFTa ← {
  ⥊¨ aSteps {i‿r𝕊𝕩: 𝕩 (i⍉+˝⊸≍)¨ r CMul -˝¨ 𝕩}´˜ ash⊸⥊¨ 𝕩
}

skipper ← (Sq⍟bl cm‿ca) Sl L2 an
rand ← ((Sq cm‿ca) Sl bl) S1 ⊑ cm‿ca S1 ⋈ inp
Num ← (2⋆¯15)× (-2⋆15) 16•bit._xor 1⊏˘ ·32‿16•bit._cast ≍˘

bSteps ← {(⌽ ∾¨ -⌾⊑) <˘ 2‿∘⥊𝕩}¨ ¯1↓rsx
FFTb ← {
  an=𝕨?
    i0 ← skipper S1 𝕩⊑rand
    FFTa ⟨Num cm‿ca S1 i0, Num i0⟩;
  ((𝕨÷2) FFTb 𝕩) (+∾-)¨ ((il-L2 𝕨)⊑bSteps) CMul (𝕨÷2) FFTb 𝕩+in÷𝕨×2
}

x‿y ← (⊢ (<˘[0‿3,2‿1]⊏+∾-) (¯1⌽⌽)¨) (2÷˜inp) FFTb 0

fft ← x {a‿b𝕊c‿d: ⟨a+d,b-c⟩} y CMul {[a,b]: ⟨b∾a-↩, a∾-b⟩} 2‿∘⥊rs

a ← 0.25⊸×⌾⊑ +´ ×˜ fft
top ← 10 {(𝕨↑·⍒⊏⟜𝕩)⊸⊏/𝕩≥(𝕨-1)⊑∨(⌈∘√𝕨⊸×)⊸•rand.Subset∘≠⊸⊏𝕩} a
{⌊0.5+ 1e9× inp÷˜√𝕩⊏a}⊸({
  •Out ∾ ⟨•Repr 𝕩, ".0", @+9, •Repr ⌊𝕨÷1e9, '.', «⟜"000000000" •Repr 1e9|𝕨⟩
}¨) top