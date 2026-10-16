# from @dzaima Oct 2026
size ← •ParseFloat ⊑•args
•Out ∾⟨"P4", @+10, (⊢∾' '∾⊢) •Repr size⟩

xs0‿ys0 ← ¯1.5‿¯1 + (↕¨ ⟨size, ⌈0.5×size+1⟩) ÷ size÷2
iter ← 50

bsz ← 24
blx‿bly ← {𝕊n: {𝕩 ⋈¨ 𝕩-˜ n ⌊ bsz + 𝕩} bsz×↕⌈n÷bsz}¨ ≠¨ xs0‿ys0

res ← { 𝕊 yo‿yl:
  ys ← yl↑yo↓ys0
  yse ← ×˜0‿0‿¯1‿¯1⊏ys
  {
    𝕊 xs:
      xse ← 0‿¯1‿0‿¯1⊏xs
      ∨´ {r‿xo: ∧´ r > yse + ×˜ xo + xse}¨ ⟨0.25‿0.25, 0.0625‿1⟩? # fully inside main cardioids
        ys 1⌜ xs
  ;
    𝕊 xs:
      ysx ← ⥊ys ⊣⌜ xs
      xsx ← ⥊ys ⊢⌜ xs
      zr←zi←0
      check ← bsz
      checkAll ← ≠xsx
      {𝕊:
        zr2 ← xsx + (zr×zr) - zi×zi
        zi ↩ ysx + 2×zr×zi
        zr ↩ zr2
        # we're breaking the input into blocks, which should hopefully typically escape at similar times
        # first check if only a portion escapes, and then continue until all escape, without bothering with any partial filtering
        ∨´ 4> (×˜check↑zr) + ×˜check↑zi?  𝕩-1;
        check≢checkAll? check↩checkAll ⋄ (𝕩-1) × ∨´4> (×˜zr) + ×˜zi;
        0
      }•_while_× iter
      ⟨≠ys,≠xs⟩ ⥊ 4>(×˜zr)+×˜zi
  }∘{xo‿xl:xl↑xo↓xs0}¨ blx
}¨ bly

res ↩ ∾>res
res {𝕩 ∾ (¬2|size)↓⌽1↓𝕩}↩
•term.OutRaw 1‿8•bit._cast ⥊ ⌽⎉1 ↑‿8⊸⥊˘res
