import MCore.YangMills.A1.CanonicalIdentitySpectralBindingV11

namespace MCore.YangMills.A1

/--
V12 semantic firewall.

The existing K14GapScale interface leaves gapBound abstract.  Therefore a
spectral exclusion theorem alone cannot imply gapBound for every possible
K14 realization.  The following explicit countermodel makes that logical
separation kernel-visible.
-/
def spectralFirewallD : MCore.K14PhysicalHilbertData where
  State := Unit
  Scale := Unit
  vacuum := ()
  zeroState := ()
  physical := fun _ => True
  orthogonalToVacuum := fun _ => True
  norm := fun _ => ()
  unitNorm := ()
  vacuum_normalized := rfl

def spectralFirewallH :
    MCore.K14HamiltonianOperator spectralFirewallD where
  domain := fun _ => True
  act := fun _ _ => ()
  denselyDefined := True
  symmetric := True
  selfAdjoint := True

def spectralFirewallG :
    MCore.K14GapScale spectralFirewallD where
  positive := fun _ => True
  gapBound := fun _ _ _ => False

def spectralFirewallLaplace : MCore.PositiveSpectralLaplaceData where
  laplace := fun _ => 0
  massBelow := fun _ => 0
  lowerBound := by
    intro t r ht hr
    simp

def spectralFirewallDecay :
    MCore.ExponentialDecayData spectralFirewallLaplace.laplace where
  C := 0
  m := 1
  C_nonneg := by norm_num
  m_pos := by norm_num
  upperBound := by
    intro t ht
    simp

def spectralFirewallRealization : MCore.SpectralExclusionRealization where
  spectral := spectralFirewallLaplace
  decay := spectralFirewallDecay

theorem spectralFirewall_mass_nonneg :
    ∀ r : ℝ, 0 ≤ r →
      0 ≤ spectralFirewallRealization.spectral.massBelow r := by
  intro r hr
  simp [spectralFirewallRealization, spectralFirewallLaplace]

theorem spectralFirewall_lowSpectrumExcluded :
    ∀ r : ℝ, 0 ≤ r →
      r < spectralFirewallRealization.decay.m →
      spectralFirewallRealization.spectral.massBelow r = 0 := by
  intro r hr0 hrm
  exact MCore.realized_exclusion
    spectralFirewallRealization spectralFirewall_mass_nonneg r hr0 hrm

/-- A hypothetical universal rule deriving arbitrary K14 gapBound directly
from low-spectrum exclusion is false. -/
def UniversalExclusionToGapBound : Prop :=
  ∀ (D : MCore.K14PhysicalHilbertData)
    (H : MCore.K14HamiltonianOperator D)
    (G : MCore.K14GapScale D)
    (S : MCore.SpectralExclusionRealization)
    (rate : D.Scale),
    (∀ r : ℝ, 0 ≤ r → r < S.decay.m →
      S.spectral.massBelow r = 0) →
    ∀ (psi : D.State) (hpsi : H.domain psi),
      D.physical psi →
      D.orthogonalToVacuum psi →
      G.gapBound rate psi (H.act psi hpsi)

theorem no_universal_exclusion_to_arbitrary_gapBound :
    ¬ UniversalExclusionToGapBound := by
  intro h
  have bad :=
    h spectralFirewallD spectralFirewallH spectralFirewallG
      spectralFirewallRealization () spectralFirewall_lowSpectrumExcluded
      () True.intro True.intro True.intro
  exact bad

#print axioms MCore.YangMills.A1.spectralFirewall_lowSpectrumExcluded
#print axioms MCore.YangMills.A1.no_universal_exclusion_to_arbitrary_gapBound

end MCore.YangMills.A1
