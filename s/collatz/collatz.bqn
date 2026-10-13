B2W ← 1‿32•bit._cast
W2B ← 32‿1•bit._cast
WAdd ← 32•bit._add
WXor ← 32•bit._xor
W2Mul ← 64‿32•bit._mul
W2Add ← 64‿32•bit._add
Add0 ← {
  r0 ← 𝕨 WAdd 𝕩
  ov ← » (r0 WXor ¯2147483648) < 𝕨 WXor ¯2147483648
  {
    ∨´ ov ∧ r0=¯1? # multi-word overflow
      {vs←𝕩⊏r0 ⋄ r0 (1 WAdd vs)⌾(𝕩⊸⊏)↩ ⋄ 1+𝕩/˜¯1=vs}•_while_(×≠) /ov
    ;
      r0 WAdd↩ ov
  }
  r0
}
Hi ← {(32×⌈32÷˜≠𝕩)↑𝕩}

AddSmall ← { # scalar 𝕨 for 0≤𝕨<2⋆bigw-1
  2≤≠𝕩?
    x0b ← 𝕨‿0 W2Add 2↑𝕩
    0≠¯1⊑x0b? # too broad of a check, but that's fine
      x0b⌾(2⊸↑) 𝕩;
  ((≠t)↑𝕨) Add0 t←𝕩∾0
}

WZT ← {0≠¯1⊑𝕩? 𝕩; (-⊑0⊐˜⌽0=𝕩) ↓ 𝕩} # wide zero trim

Mul0 ← { # scalar 𝕩
  lo‿hi ← <˘⍉ 𝕩‿0 W2Mul 𝕨 ≍˘ 0
  (lo∾0) Add0 0∾hi
}
Mul2 ← { # 𝕨 should ideally be smaller than 𝕩
  ⟨w0⟩ 𝕊 𝕩: WZT 𝕩 Mul0 w0;
  𝕨 𝕊 x: WZT (x Mul0 ¯1⊑𝕨) {((≠t)↑x Mul0 𝕨) Add0 t←0∾𝕩}´ ¯1↓𝕨
}

Pow3 ← {
  0: ⋈1;
  l ← Pow3 ⌊𝕩÷2
  l Mul2 𝕩{2|𝕨? ((≠t)↑l) Add0 t←B2W Hi (0∾W2B𝕩)∾0; 𝕩} l
}

C0 ← {b‿m‿x: {2|x? ⟨b,m+1,1+3×x⟩; ⟨b-1,m,x÷2⟩}}•_while_(×⊑)
[muls, xs] ← ⍉1↓˘>C0¨ 8‿0⊸∾¨↕256 ⋄ muls3←3⋆muls
cacheR ← xs ⋈¨ muls3
mulByPows ← {∾⟨
  {WZT Mul0⟜𝕩}¨ 𝕩
  {𝕩⊸Mul2}˘(11↑𝕩≍˘0) W2Mul Pow3 21
⟩} -⟜(2⋆32)⌾(¯1⊸⊑) 3⋆↕21

·←{
  arg ← •ParseFloat⊑•args
  i ← 3 × h←⌊arg÷2
  x ← WZT 1 AddSmall B2W Hi (0⥊˜2|arg) ∾ W2B Pow3 h
  
  {𝕊:
    w0 ← 4294967296 | ⊑x
    w1‿p1 ← (k0←256|w0) ⊑ cacheR ⋄ w1+↩ p1 × ⌊w0÷256
    w2‿p2 ← (k1←256|w1) ⊑ cacheR ⋄ w2+↩ p2 × ⌊w1÷256
    w3‿p3 ← (k2←256|w2) ⊑ cacheR ⋄ w3+↩ p3 × ⌊w2÷256
    w4‿p4 ← (k3←256|w3) ⊑ cacheR ⋄ w4+↩ p4 × ⌊w3÷256
    i+↩ 32 + ms ← +´ k0‿k1‿k2‿k3 ⊏ muls
    
    mulByPow ← ms ⊑ mulByPows
    x ↩ MulByPow «x
    x ↩ {
      w4<2147483648? w4 AddSmall x;
      w4b ← 64‿1•bit._cast ⋈w4
      t ← x∾0
      t Add0 (≠t)↑ B2W «⍟(1086 - ⊑1‿32•bit._cast 32↑¯12↑w4b) 1« »⍟12 w4b # overcomplicated way of extracting the i32 limbs of integer w4 which is a f64
    }
    @
  
  }•_while_{𝕊: 3<≠x} @
  x W2B↩
  
  {𝕊:
    i+↩ 1
    x ↩ {⊑x? W2B WZT (x∾0‿0) Add0○B2W○Hi 1∾x∾0; 1↓x}
  }•_while_{𝕊: x≢(≠x)↑1}@
  •Show i
}
