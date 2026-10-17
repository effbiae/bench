L2 ← ⌊ ·•math.Log2 0.5+⊢
FFT ← { # takes real input; result is missing some monotonic transformations
  CMul ← -´∘× ⋈ +´∘×⟜⌽
  
  l0l←L2 l0←≠𝕩
  rs ← (⊢∾1»⌽) •math.Sin (π ÷ l0÷2) × ↕l0÷4
  
  al ← 1024⌊l0÷2
  rsx ← {⊏˘∘‿2⥊𝕩}⍟(↕1+L2 l0÷al) rs
  
  an ← L2 al
  ash ← an⥊2
  aSteps ← ⌽{i‿v: ⟨i-1, 0‿0⊸⊏⎉(an-i)¨v⟩}⍟(↕an) ⟨an-1, -∘⊏⊸«⊸⋈ (2⥊˜an-1) ⥊ ¯1⊑rsx⟩
  FFTa ← {
    ⥊¨ aSteps {i‿r𝕊𝕩: 𝕩 (i⍉+˝⊸≍)¨ r CMul -˝¨ 𝕩}´˜ ash⊸⥊¨ 𝕩
  }
  
  bSteps ← {(⌽ ∾¨ -⌾⊑) <˘ 2‿∘⥊𝕩}¨ ¯1↓rsx
  FFTb ← {
    al=≠⊑𝕩? FFTa 𝕩;
    e‿o ← <˘⍉> (<˘·⍉∘‿2⊸⥊)¨ 𝕩
    (FFTb e) (+∾-)¨ (FFTb o) CMul (l0l-L2 ≠⊑𝕩)⊑bSteps
  }
  
  FFTc ← {
    x‿y ← {𝕩 (<˘[0‿3,2‿1]⊏+∾-) (¯1⌽⌽)¨ 𝕩} FFTb ⌽ <˘ ⍉∘‿2⥊𝕩
    x {a‿b𝕊c‿d: ⟨a+d,b-c⟩} y CMul {[a,b]: ⟨b∾a-↩, a∾-b⟩} 2‿∘⥊rs
  }
  FFTc 𝕩
}

inpl ← L2 inp ← •ParseFloat ⊑•args

cm ← 1103515245
ca ← 12345
A32 ← 32•bit._add
M32 ← 32•bit._mul
init ← 11⌊L2 inp
adds ← ⊑ {l‿m‿a: ⟨l ∾ a A32 m M32 l, M32˜m, a A32 a M32 m⟩}⍟init ⟨⋈ca, ⋈cm, ⋈ca⟩
muls ← ⊑ {l‿m: ⟨l∾l M32 m, M32˜ m⟩}⍟init ⟨⋈cm, ⋈cm⟩
rand ← {adds A32 muls M32 ¯1⊑𝕩}⍟(1+↕inp÷2⋆init) ⋈inp
nums ← ∾((2⋆¯15)× (-2⋆15) 16•bit._xor 1⊏˘ ·32‿16•bit._cast ≍˘)¨ rand

a ← 0.25⊸×⌾⊑ +´ ×˜ FFT nums
top ← 10 {(𝕨↑·⍒⊏⟜𝕩)⊸⊏/𝕩≥(𝕨-1)⊑∨(⌈∘√𝕨⊸×)⊸•rand.Subset∘≠⊸⊏𝕩} a
{⌊0.5+ 1e9× inp÷˜√𝕩⊏a}⊸({
  •Out ∾ ⟨•Repr 𝕩, ".0", @+9, •Repr ⌊𝕨÷1e9, '.', «⟜"000000000" •Repr 1e9|𝕨⟩
}¨) top
