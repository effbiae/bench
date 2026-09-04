#contributed by dzaima Sep 2026
inp ← {⟨⟩:•FBytes "/dev/stdin"; •file.MapBytes ⋈⁼𝕩}•args
lf ← @+10

inp ↩ {a‿b: (-1+≠b)↓a} (1+⊐⟜'>')⊸↓⍟3‿4 inp
! "THREE" ≡ 5↑inp # just making sure the above approach is correct
inp↓˜↩ inp⊐@+10
inp/˜↩ inp≠lf

z ← "GTAC" # A & T can't be 0 - sequence searching assumes last char isn't zero
inp ↩ (↕∘≠⌾((8|z-@)⊸⊏) 8⥊9) ⊏˜ 8|8‿8•bit._cast inp

J0 ← {a‿b: a↩⌊0.5+1e5×a ⋄ ∾⟨b," ",•Repr ⌊a÷1e3,".","000"«˜•Repr 1e3|a⟩}
J ← {•Out¨ ""∾⟜<˜ J0¨ ∨ 𝕩⋈¨𝕨}

igt ← inp≤1
iga ← inp⊏1‿0‿1‿0
ig←igt∧iga, it←igt>iga, ia←igt<iga, ic←¬igt∨iga

n ← ≠inp
z J n÷˜ +´¨ ig‿it‿ia‿ic
(⥊∾⌜˜z) J (n-1) ÷˜ 16↑/⁼ (1↓inp) + ¯1↓4×inp
# (⥊∾⌜˜z) J (n-1) ÷˜ 16↑/⁼ (1↓inp) 8•bit._add ¯1↓4 8•bit._mul inp

vs ← 3‿4‿6‿12‿18 ↑¨ <"GGTATTTTAATTTATAGT"

it1 ← «it
m0 ← ig ∧ « ig∧it1
m1 ← m0 ∧ «⍟3 ia
i2 ← /m1 ∧ «⍟4 it∧it1
r0 ← ⟨+´m0, +´m1, ≠i2⟩
rs ← r0 ∾ { 𝕊 p‿c: p ≠↩
  nn←≠n←z⊐p↓c
  inpp ← p↓inp
  i2 /˜↩ {n≡nn↑𝕩↓inpp}¨ i2
  ≠i2
}¨ <˘ 2↕2↓vs

vs {•Out ∾⟨•Repr 𝕩, @+9, 𝕨⟩}¨ rs
